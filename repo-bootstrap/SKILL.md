---
name: repo-bootstrap
description: Use when initializing, bootstrapping, or setting up a new or existing repository for Codex, especially when the user says "initialize this repo", "bootstrap this repo", "create AGENTS.md", or asks for repo-local Codex defaults.
---

# Repo Bootstrap

## Overview

Create a repo-local `AGENTS.md` from a default Codex repo template. This turns "initialize this repo" into a small, repeatable bootstrap step instead of relying on global instructions to carry repo-specific operating contracts.

## Workflow

1. Resolve the repo root.
   - Prefer `git rev-parse --show-toplevel` when inside a Git repo.
   - Otherwise use the current working directory or the path the user named.
2. Check whether `AGENTS.md` already exists at the repo root.
   - If it exists, read it first and do not overwrite it silently.
   - Patch missing sections only when the user asked to upgrade or refresh repo defaults.
3. If `AGENTS.md` is missing, run the bundled script:

```powershell
powershell -ExecutionPolicy Bypass -File "<skill-dir>\scripts\bootstrap_repo.ps1" -RepoPath "<repo-root>"
```

4. Re-read the created `AGENTS.md` and report the evidence path.

## Template Selection

The script prefers the user-editable template:

```text
~/.codex/templates/repo/AGENTS.md
```

If that file is missing, it falls back to the bundled asset:

```text
<skill-dir>/assets/default-repo-AGENTS.md
```

Keep detailed SOPs out of Global AGENTS. The repo template should provide compact contracts and TODO slots that each real repo can fill with live commands, boundaries, and verification routes.

## What To Bootstrap

Create repo-local defaults for:

- Completion Gate
- Debug Workflow
- Factory Output
- Durable Memory
- Long-Run / Goals
- Connectors
- Risk Boundary

Do not create `_ctx/`, automation files, connector configs, or test scripts unless the user explicitly asks or the repo workflow requires them.

## Existing Repos

If a repo has no `AGENTS.md` and the user asks to initialize or bootstrap it, create one.

If a repo already has `AGENTS.md`, treat it as live repo truth. Do not replace it. Instead:

- identify missing sections
- propose a small patch
- preserve repo-specific commands and constraints
- verify by re-reading the file after edits

## Completion

Before claiming bootstrap is done, provide:

- target repo path
- template source path
- created or updated file path
- verification result from re-reading the file

If the script could not run, create the file with the same template content using normal file editing tools and state that script verification was not used.
