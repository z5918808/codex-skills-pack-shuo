---
name: brave
description: Use when the user invokes /brave or $brave, explicitly asks to use Brave, Brave browser, Brave tabs, Brave profile, or the Codex Chrome Web Store extension installed in Brave. Handles browser automation that needs the user's Brave cookies, logged-in sessions, existing tabs, extensions, or remote authenticated sites, while keeping Chrome and Brave routing separate.
---

# Brave

## Overview

Use Brave as the user's extension-backed Chromium browser. This skill exists so `@chrome` can stay Google Chrome-oriented while `/brave` cleanly means "use the user's Brave browser/session/profile."

## Routing Rules

- Prefer Brave when the user invokes `/brave`, `$brave`, says "use Brave", or says the extension/login/session is in Brave.
- Do not reinterpret `@chrome` as Brave. If the user asks for Chrome, use the Chrome skill; if the user asks for Brave, use this skill.
- Treat the Codex Chrome Web Store extension as a Chromium extension that may be installed in Brave.
- Reuse the existing Brave session or tabs when possible. Do not open fresh browser windows unless needed for the task or the user asked for it.
- Do not inspect cookies, password stores, local storage, browser databases, or raw profile files.
- If a helper or plugin is named Chrome, treat that name as implementation detail only after verifying it can actually reach Brave.

## Preferred Workflow

1. Identify whether the task needs Brave specifically:
   - logged-in Brave account/session
   - existing Brave tab
   - Brave-installed extension
   - user explicitly requested Brave

2. First try an extension-backed browser connection if the Browser/Chrome plugin extension backend is available.
   - If `agent.browsers.get("extension")` works and tab/user APIs work, use that connected browser.
   - Confirm it is the intended live context by checking visible tabs, page titles, or user-visible browser state; do not read private stores.
   - If the connected browser is not Brave and Brave matters, stop and report the mismatch.

3. If extension-backed control cannot reach Brave, try `browser-harness` when the task needs an existing Brave session, existing tabs, complex real-site interaction, or authenticated state.
   - Attach to an already-running Brave session when available.
   - On Windows, Brave commonly runs as `brave.exe` and stores profile data under `%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data`; use these only for detection/routing, not for reading private data.
   - If there is no attachable Brave debugging endpoint, explain that Brave is running but not controllable through the current route.

4. If Brave is blocked, classify the blocker before falling back:
   - extension backend unavailable
   - native host communication failure
   - Brave not running
   - Brave running but not attachable
   - selected tool only supports Google Chrome
   - site-level automation problem

5. Fall back only with a reason:
   - Use Google Chrome only if the user accepts the mismatch, the task does not require Brave state, or the tool is explicitly limited to Chrome.
   - Use Playwright only when a fully replayable script is more important than using the user's Brave session.

## Extension Checks

- A successful lightweight tab-list or selected-tab call is enough to prove the extension-backed route works.
- A Chrome-profile helper failure does not prove Brave lacks the extension.
- If the extension route fails, ask the user to confirm the Codex extension is enabled in Brave before asking them to reinstall anything.
- Do not install or repair native host files yourself.
- Do not ask the user to change Chrome settings when the target browser is Brave. Use Brave's extension manager path conceptually: `brave://extensions`.

## Task Handling

- For existing tabs, list visible tabs first, choose by URL/title/recency, then claim or attach to that tab. Do not guess tab ids.
- For file uploads, use the browser tool's file chooser flow with absolute paths. If file URL access is required, tell the user to enable file access for the Codex extension in Brave.
- For risky actions inside authenticated sites, confirm right before the action when it could submit data, spend money, publish content, modify accounts, or expose sensitive information.
- Before ending browser work, close or release extra tabs unless the tab is a deliverable or handoff state the user needs.

## Reporting

- State whether Brave was actually reached, inferred, or blocked.
- If fallback was used, say why Brave failed, what route was used instead, and whether the result still satisfies the user's original Brave requirement.
- Keep the report short unless the user asks for detailed browser diagnostics.
