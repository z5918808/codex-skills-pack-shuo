import json
import os
import platform
import socket
import tempfile
import time
import urllib.request
from pathlib import Path


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
BU_API = "https://api.browser-use.com/api/v3"
IS_WINDOWS = platform.system() == "Windows"
TMPDIR = Path(tempfile.gettempdir())


def _paths(name):
    n = name or NAME
    return (
        str(TMPDIR / f"bu-{n}.sock"),
        str(TMPDIR / f"bu-{n}.pid"),
        str(TMPDIR / f"bu-{n}.port"),
        str(TMPDIR / f"bu-{n}.log"),
    )


def _log_tail(name):
    try:
        return Path(_paths(name)[3]).read_text().strip().splitlines()[-1]
    except (FileNotFoundError, IndexError):
        return None


def _port(name=None):
    return int(Path(_paths(name)[2]).read_text().strip())


def daemon_alive(name=None):
    try:
        if IS_WINDOWS:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect(("127.0.0.1", _port(name)))
        else:
            s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            s.connect(_paths(name)[0])
        s.settimeout(1)
        s.close()
        return True
    except (FileNotFoundError, ConnectionRefusedError, socket.timeout, ValueError, OSError):
        return False


def ensure_daemon(wait=60.0, name=None, env=None):
    """Idempotent. `env` is merged into the child process env."""
    if daemon_alive(name):
        return
    import subprocess

    e = {**os.environ, **({"BU_NAME": name} if name else {}), **(env or {})}
    p = subprocess.Popen(
        ["uv", "run", "daemon.py"],
        cwd=os.path.dirname(os.path.abspath(__file__)),
        env=e,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        start_new_session=True,
    )
    deadline = time.time() + wait
    while time.time() < deadline:
        if daemon_alive(name):
            return
        if p.poll() is not None:
            break
        time.sleep(0.2)
    msg = _log_tail(name)
    raise RuntimeError(msg or f"daemon {name or NAME} didn't come up -- check {_paths(name)[3]}")


def restart_daemon(name=None):
    """Best-effort daemon restart for setup/debug flows."""
    import signal

    sock, pid_path, port_path, _ = _paths(name)
    try:
        if IS_WINDOWS:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect(("127.0.0.1", _port(name)))
        else:
            s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
            s.connect(sock)
        s.settimeout(5)
        s.sendall(b'{"meta":"shutdown"}\n')
        s.recv(1024)
        s.close()
    except Exception:
        pass
    try:
        pid = int(open(pid_path).read())
    except (FileNotFoundError, ValueError):
        pid = None
    if pid:
        for _ in range(75):
            try:
                os.kill(pid, 0)
                time.sleep(0.2)
            except ProcessLookupError:
                break
        else:
            try:
                os.kill(pid, signal.SIGTERM)
            except ProcessLookupError:
                pass
    for f in (sock, pid_path, port_path):
        try:
            os.unlink(f)
        except FileNotFoundError:
            pass


def _browser_use(path, method, body=None):
    key = os.environ.get("BROWSER_USE_API_KEY")
    if not key:
        raise RuntimeError("BROWSER_USE_API_KEY missing -- see .env.example")
    req = urllib.request.Request(
        f"{BU_API}{path}",
        method=method,
        data=(json.dumps(body).encode() if body is not None else None),
        headers={"X-Browser-Use-API-Key": key, "Content-Type": "application/json"},
    )
    return json.loads(urllib.request.urlopen(req, timeout=60).read() or b"{}")


def _cdp_ws_from_url(cdp_url):
    return json.loads(urllib.request.urlopen(f"{cdp_url}/json/version", timeout=15).read())["webSocketDebuggerUrl"]


def start_remote_daemon(name="remote", **create_kwargs):
    if daemon_alive(name):
        raise RuntimeError(f"daemon {name!r} already alive -- restart_daemon({name!r}) first")
    browser = _browser_use("/browsers", "POST", create_kwargs)
    ensure_daemon(
        name=name,
        env={"BU_CDP_WS": _cdp_ws_from_url(browser["cdpUrl"]), "BU_BROWSER_ID": browser["id"]},
    )
    return browser
