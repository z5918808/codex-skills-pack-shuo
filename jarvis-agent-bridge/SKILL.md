---
name: jarvis-agent-bridge
description: Let non-JARVIS repos borrow safe JARVIS stack capabilities from D:\JARVIS\openclaw-kit without rebuilding browser, health, evidence, or reporting surfaces.
---

# JARVIS Agent Bridge

## Use this when

- current repo wants to leverage JARVIS status, doctor, evidence, or capability surfaces
- you want to avoid rebuilding OpenClaw / Telechat glue
- you need a bridge-safe path instead of touching bootstrap or `.openclaw`

## Default Rule

- provider root = `D:\JARVIS\openclaw-kit`
- default profile = `readonly`
- escalation profile = `doctor`
- source label = `JARVIS-live-readonly`

## Allowed v0 paths

- `npm --prefix D:\JARVIS\openclaw-kit run bridge:status`
- `npm --prefix D:\JARVIS\openclaw-kit run bridge:doctor`
- `createJarvisAgentBridge({ providerRoot: "D:/JARVIS/openclaw-kit", profileName: "readonly" })`

## Forbidden v0 paths

- bootstrap
- daemon start / stop / restart
- `.openclaw` writes
- `sessions.json` writes
- `gateway.cmd` writes
- `mail.*`
- `procue.quote`
- `odoo` / sidecars
- `system.self_update`

## Working rule

- Prefer borrowing read-only status/report first.
- If status is insufficient, escalate to doctor/evidence export.
- If bridge-safe surface is insufficient, stop and report the missing surface.
- Do not silently widen scope into live runtime control.
