---
name: codex-archive-retention
description: Use when auditing, reviewing, pruning, deleting, compressing, or deciding retention policy for archived Codex sessions under E:\CodexArchive or .codex archived_sessions, especially before removing old thread history.
---

# Codex Archive Retention

## Overview

Use this skill to produce a dry-run retention report for archived Codex session files. The default posture is evidence first: classify candidates, write reports, and do not delete or move anything.

## Quick Start

Run the bundled report script:

```powershell
pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\codex-archive-retention\scripts\codex-archive-retention.ps1"
```

Default input:

- Archive root: `E:\CodexArchive\archived_sessions`
- Report root: `E:\CodexArchive\reports`

Outputs:

- Markdown report for human review.
- JSON report for follow-up filtering.

## Report Policy

The report must remain dry-run only. It should include:

- Monthly file counts and MB.
- Largest archived session files.
- `likely-low-value` candidates such as smoke tests, wrapper checks, one-line OK checks, and short diagnostic sidecar threads.
- `keep-review` candidates when content mentions production, database, orders, payments, tokens, migrations, handoffs, incidents, or other high-value traces.

Do not delete from this skill unless the user explicitly asks for deletion after reviewing a report.

## Deletion Gate

Before any deletion or compression proposal, require:

- The specific report path being used.
- The classes or file list targeted.
- A manifest of exact files.
- Confirmation that high-risk keep signals are excluded.

For actual deletion, prefer moving to a dated quarantine folder first, not permanent deletion.

## Common Commands

Custom archive root:

```powershell
pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\codex-archive-retention\scripts\codex-archive-retention.ps1" -ArchiveRoot "E:\CodexArchive\archived_sessions"
```

Show more largest files:

```powershell
pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\codex-archive-retention\scripts\codex-archive-retention.ps1" -LargestLimit 100
```

Use slower head+tail sampling only when the quick report is not enough:

```powershell
pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\codex-archive-retention\scripts\codex-archive-retention.ps1" -DeepScan
```

`-DeepScan` defaults to the largest 20 session JSONL files and reads only a fixed-size tail sample with FileStream. Increase carefully:

```powershell
pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\codex-archive-retention\scripts\codex-archive-retention.ps1" -DeepScan -DeepScanLimit 50
```

## Weekly Automation

Installed automation:

- ID: `codex-archive-retention-weekly-report`
- Schedule: weekly Sunday 09:00
- Mode: read-only report
- Workspace: `C:\Users\user\Documents\Codex\2026-05-03\codex-app-cleanup-c-users-user`

The automation must not delete, move, compress, quarantine, or mutate files. It runs the quick report script and summarizes PASS/WARN/FAIL, archive size, monthly distribution, report paths, and next safe action.

## Resources

- `scripts/codex-archive-retention.ps1`: read-only report generator.
