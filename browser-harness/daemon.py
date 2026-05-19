"""CDP WS holder + Unix socket relay. One daemon per BU_NAME."""
import asyncio, json, os, socket, subprocess, sys, time, urllib.request
from collections import deque
from pathlib import Path
import platform
import tempfile

from cdp_use.client import CDPClient


def _load_env():
    p = Path(__file__).parent / ".env"
    if not p.exists():
        return
    for line in p.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        k, v = line.split("=", 1)
        os.environ.setdefault(k.strip(), v.strip().strip('"').strip("'"))


_load_env()

NAME = os.environ.get("BU_NAME", "default")
IS_WINDOWS = platform.system() == "Windows"
TMPDIR = Path(tempfile.gettempdir())
SOCK = str(TMPDIR / f"bu-{NAME}.sock")
LOG = str(TMPDIR / f"bu-{NAME}.log")
PID = str(TMPDIR / f"bu-{NAME}.pid")
PORT = str(TMPDIR / f"bu-{NAME}.port")
BUF = 500
PROFILES = [
    Path.home() / "Library/Application Support/Google/Chrome",
    Path.home() / "Library/Application Support/Microsoft Edge",
    Path.home() / "Library/Application Support/Microsoft Edge Beta",
    Path.home() / "Library/Application Support/Microsoft Edge Dev",
    Path.home() / "Library/Application Support/Microsoft Edge Canary",
    Path.home() / ".config/google-chrome",
    Path.home() / ".config/microsoft-edge",
    Path.home() / ".config/microsoft-edge-beta",
    Path.home() / ".config/microsoft-edge-dev",
    Path.home() / "AppData/Local/Google/Chrome/User Data",
    Path.home() / "AppData/Local/Microsoft/Edge/User Data",
    Path.home() / "AppData/Local/Microsoft/Edge Beta/User Data",
    Path.home() / "AppData/Local/Microsoft/Edge Dev/User Data",
    Path.home() / "AppData/Local/Microsoft/Edge SxS/User Data",
]
INTERNAL = ("chrome://", "chrome-untrusted://", "devtools://", "chrome-extension://", "about:")
BU_API = "https://api.browser-use.com/api/v3"
REMOTE_ID = os.environ.get("BU_BROWSER_ID")
API_KEY = os.environ.get("BROWSER_USE_API_KEY")
WINDOWS_BROWSER = os.environ.get("BU_WINDOWS_BROWSER", "chrome").strip().lower()
WINDOWS_PROFILE = Path(
    os.environ.get(
        "BU_WINDOWS_PROFILE",
        str(Path.home() / "AppData/Local/BrowserHarness/ChromeProfile"),
    )
)


def log(msg):
    open(LOG, "a").write(f"{msg}\n")


def _wait_for_debug_port(port_file, timeout=30):
    deadline = time.time() + timeout
    while time.time() < deadline:
        if not port_file.exists():
            time.sleep(1)
            continue
        try:
            port, path = port_file.read_text().strip().split("\n", 1)
        except (NotADirectoryError, ValueError):
            time.sleep(1)
            continue
        while True:
            probe = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            probe.settimeout(1)
            try:
                probe.connect(("127.0.0.1", int(port.strip())))
                return f"ws://127.0.0.1:{port.strip()}{path.strip()}"
            except OSError:
                if time.time() >= deadline:
                    raise RuntimeError(
                        f"Chrome remote debugging exists at {port_file}, but DevTools is not live yet on 127.0.0.1:{port.strip()}"
                    )
                time.sleep(1)
            finally:
                probe.close()
    return None


def _probe_profiles():
    for base in PROFILES:
        port_file = base / "DevToolsActivePort"
        if not port_file.exists():
            continue
        ws = _wait_for_debug_port(port_file, timeout=2)
        if ws:
            return ws
    return None


def _windows_browser_candidates():
    local = Path.home() / "AppData/Local"
    program_files = [Path(os.environ.get("ProgramFiles", "")), Path(os.environ.get("ProgramFiles(x86)", ""))]
    mapping = {
        "chrome": [
            local / "Google/Chrome/Application/chrome.exe",
            *(p / "Google/Chrome/Application/chrome.exe" for p in program_files if str(p)),
        ],
        "edge": [
            local / "Microsoft/Edge/Application/msedge.exe",
            *(p / "Microsoft/Edge/Application/msedge.exe" for p in program_files if str(p)),
        ],
        "brave": [
            local / "BraveSoftware/Brave-Browser/Application/brave.exe",
            *(p / "BraveSoftware/Brave-Browser/Application/brave.exe" for p in program_files if str(p)),
        ],
    }
    if WINDOWS_BROWSER in mapping:
        return [(WINDOWS_BROWSER, p) for p in mapping[WINDOWS_BROWSER]]
    p = Path(WINDOWS_BROWSER)
    if p.is_absolute():
        return [(p.stem.lower(), p)]
    out = []
    for name in ("chrome", "edge", "brave"):
        out.extend((name, p) for p in mapping[name])
    return out


def _ensure_windows_browser():
    profile = WINDOWS_PROFILE
    profile.mkdir(parents=True, exist_ok=True)
    port_file = profile / "DevToolsActivePort"
    try:
        ws = _wait_for_debug_port(port_file, timeout=2)
        if ws:
            return ws
    except RuntimeError:
        log(f"stale DevToolsActivePort at {port_file}, relaunching isolated browser")
        try:
            port_file.unlink()
        except FileNotFoundError:
            pass
    for name, exe in _windows_browser_candidates():
        if not exe.exists():
            continue
        log(f"launching {name} with isolated profile {profile}")
        subprocess.Popen(
            [
                str(exe),
                "--remote-debugging-port=0",
                f"--user-data-dir={profile}",
                "about:blank",
            ],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True,
        )
        ws = _wait_for_debug_port(port_file, timeout=30)
        if ws:
            return ws
    raise RuntimeError(
        "Windows browser bootstrap failed — no usable Chrome/Edge/Brave binary found, or DevToolsActivePort never appeared"
    )


def get_ws_url():
    if url := os.environ.get("BU_CDP_WS"):
        return url
    if ws := _probe_profiles():
        return ws
    if IS_WINDOWS:
        return _ensure_windows_browser()
    raise RuntimeError(f"DevToolsActivePort not found in {[str(p) for p in PROFILES]} — enable chrome://inspect/#remote-debugging, or set BU_CDP_WS for a remote browser")


def stop_remote():
    if not REMOTE_ID or not API_KEY: return
    try:
        req = urllib.request.Request(
            f"{BU_API}/browsers/{REMOTE_ID}",
            data=json.dumps({"action": "stop"}).encode(),
            method="PATCH",
            headers={"X-Browser-Use-API-Key": API_KEY, "Content-Type": "application/json"},
        )
        urllib.request.urlopen(req, timeout=15).read()
        log(f"stopped remote browser {REMOTE_ID}")
    except Exception as e:
        log(f"stop_remote failed ({REMOTE_ID}): {e}")


def is_real_page(t):
    return t["type"] == "page" and not t.get("url", "").startswith(INTERNAL)


class Daemon:
    def __init__(self):
        self.cdp = None
        self.session = None
        self.events = deque(maxlen=BUF)
        self.dialog = None
        self.stop = None  # asyncio.Event, set inside start()

    async def attach_first_page(self):
        """Attach to a real page (or any page). Sets self.session. Returns attached target or None."""
        targets = (await self.cdp.send_raw("Target.getTargets"))["targetInfos"]
        pages = [t for t in targets if is_real_page(t)]
        if not pages:
            # No real pages — create one instead of attaching to omnibox popup
            tid = (await self.cdp.send_raw("Target.createTarget", {"url": "about:blank"}))["targetId"]
            log(f"no real pages found, created about:blank ({tid})")
            pages = [{"targetId": tid, "url": "about:blank", "type": "page"}]
        self.session = (await self.cdp.send_raw(
            "Target.attachToTarget", {"targetId": pages[0]["targetId"], "flatten": True}
        ))["sessionId"]
        log(f"attached {pages[0]['targetId']} ({pages[0].get('url','')[:80]}) session={self.session}")
        for d in ("Page", "DOM", "Runtime", "Network"):
            try:
                await asyncio.wait_for(
                    self.cdp.send_raw(f"{d}.enable", session_id=self.session),
                    timeout=5
                )
            except Exception as e:
                log(f"enable {d}: {e}")
        return pages[0]

    async def start(self):
        self.stop = asyncio.Event()
        url = get_ws_url()
        log(f"connecting to {url}")
        self.cdp = CDPClient(url)
        try:
            await self.cdp.start()
        except Exception as e:
            raise RuntimeError(f"CDP WS handshake failed: {e} -- click Allow in Chrome if prompted, then retry")
        await self.attach_first_page()
        orig = self.cdp._event_registry.handle_event
        mark_js = "if(!document.title.startsWith('\U0001F7E2'))document.title='\U0001F7E2 '+document.title"
        async def tap(method, params, session_id=None):
            self.events.append({"method": method, "params": params, "session_id": session_id})
            if method == "Page.javascriptDialogOpening":
                self.dialog = params
            elif method == "Page.javascriptDialogClosed":
                self.dialog = None
            elif method in ("Page.loadEventFired", "Page.domContentEventFired"):
                try: await asyncio.wait_for(self.cdp.send_raw("Runtime.evaluate", {"expression": mark_js}, session_id=self.session), timeout=2)
                except Exception: pass
            return await orig(method, params, session_id)
        self.cdp._event_registry.handle_event = tap

    async def handle(self, req):
        meta = req.get("meta")
        if meta == "drain_events":
            out = list(self.events); self.events.clear()
            return {"events": out}
        if meta == "session":     return {"session_id": self.session}
        if meta == "set_session":
            self.session = req.get("session_id")
            try:
                await asyncio.wait_for(self.cdp.send_raw("Page.enable", session_id=self.session), timeout=3)
                await asyncio.wait_for(self.cdp.send_raw("Runtime.evaluate", {"expression": "if(!document.title.startsWith('\U0001F7E2'))document.title='\U0001F7E2 '+document.title"}, session_id=self.session), timeout=2)
            except Exception: pass
            return {"session_id": self.session}
        if meta == "pending_dialog": return {"dialog": self.dialog}
        if meta == "shutdown":    self.stop.set(); return {"ok": True}

        method = req["method"]
        params = req.get("params") or {}
        # Browser-level Target.* calls must not use a session (stale or otherwise).
        # For everything else, explicit session in req wins; else default.
        sid = None if method.startswith("Target.") else (req.get("session_id") or self.session)
        try:
            return {"result": await self.cdp.send_raw(method, params, session_id=sid)}
        except Exception as e:
            msg = str(e)
            if "Session with given id not found" in msg and sid == self.session and sid:
                log(f"stale session {sid}, re-attaching")
                if await self.attach_first_page():
                    return {"result": await self.cdp.send_raw(method, params, session_id=self.session)}
            return {"error": msg}


async def serve(d):
    if not IS_WINDOWS and os.path.exists(SOCK):
        os.unlink(SOCK)

    async def handler(reader, writer):
        try:
            line = await reader.readline()
            if not line: return
            resp = await d.handle(json.loads(line))
            writer.write((json.dumps(resp, default=str) + "\n").encode())
            await writer.drain()
        except Exception as e:
            log(f"conn: {e}")
            try:
                writer.write((json.dumps({"error": str(e)}) + "\n").encode())
                await writer.drain()
            except Exception:
                pass
        finally:
            writer.close()

    if IS_WINDOWS:
        server = await asyncio.start_server(handler, host="127.0.0.1", port=0)
        port = server.sockets[0].getsockname()[1]
        Path(PORT).write_text(str(port))
        listen_target = f"127.0.0.1:{port}"
    else:
        server = await asyncio.start_unix_server(handler, path=SOCK)
        os.chmod(SOCK, 0o600)
        listen_target = SOCK
    log(f"listening on {listen_target} (name={NAME}, remote={REMOTE_ID or 'local'})")
    async with server:
        await d.stop.wait()


async def main():
    d = Daemon()
    await d.start()
    await serve(d)


def already_running():
    try:
        if IS_WINDOWS:
            port = int(Path(PORT).read_text().strip())
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect(("127.0.0.1", port))
        else:
            s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            s.connect(SOCK)
        s.settimeout(1)
        s.close()
        return True
    except (FileNotFoundError, ConnectionRefusedError, socket.timeout, ValueError, OSError):
        return False


if __name__ == "__main__":
    if already_running():
        print(f"daemon already running on {SOCK}", file=sys.stderr)
        sys.exit(0)
    open(LOG, "w").close()
    open(PID, "w").write(str(os.getpid()))
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
    except Exception as e:
        log(f"fatal: {e}")
        sys.exit(1)
    finally:
        stop_remote()
        try: os.unlink(PID)
        except FileNotFoundError: pass
        try: os.unlink(PORT)
        except FileNotFoundError: pass
        if not IS_WINDOWS:
            try: os.unlink(SOCK)
            except FileNotFoundError: pass
