---
name: serious-project-cleanup
description: Use when the user wants serious project整理 before execution, project slimming, stale artifact cleanup, old file distillation, rewriting outdated docs, archiving superseded outputs, or aligning a workspace with the current operating philosophy before continuing work.
---

# Serious Project Cleanup

This is not casual cleanup. It is a pre-execution reset for a project that accumulated too many agent-made artifacts, stale reports, old philosophy, duplicated notes, or obsolete outputs.

Goal: turn a noisy workspace into a smaller, truthful, executable project state.

## Core Rule

Do serious整理 before major execution when the project state itself has become drag.

This is whole-repo整理, but it must be conversation / thread aware. Clean the whole repo surface without flattening separate conversations into one pile.

Do not just delete. First decide what each artifact is doing now:

- keep active truth
- distill / rewrite into current truth
- archive as provenance
- quarantine as risky or uncertain
- mark as delete candidate

Permanent deletion requires explicit confirmation. Reversible archive, rewrite, and quarantine are preferred.

## Non-Destructive Default

This skill reduces project drag without treating old context as disposable.

Default posture:

- preserve first
- copy before remove
- archive before replace
- quarantine uncertainty
- list delete candidates without deleting
- keep unrelated thread context recoverable even when it looks irrelevant to the current task

Do not optimize for the smallest repo. Optimize for the smallest safe active surface with recoverable provenance.

## Conversation / Thread Safety

Do not cut across other conversations' context.

Rules:

1. Assume one repo can contain many separate conversations, threads, workstreams, campaigns, and agent runs.
2. Before moving, rewriting, archiving, or quarantining a context-like file, identify which thread it belongs to.
3. Never merge unrelated thread context into one canonical file.
4. Never delete, overwrite, or rewrite another thread's active context just because it is not relevant to the current task.
5. Unknown thread ownership means `unknown_preserve` or `quarantine`, not delete.
6. Old conversation context can be archived only if it remains recoverable by thread, original path, timestamp, and manifest entry.
7. If a file contains multiple threads, extract/distill per thread and preserve the original once.
8. Active thread cleanup may be aggressive; inactive or unrelated thread cleanup must be conservative.
9. Unrelated thread memory is not junk. It is out of scope unless the user explicitly asks to clean that thread too.
10. Do not flatten repo-wide memory into one generic summary. Preserve thread boundaries in filenames, folders, headings, and manifest entries.

Thread signals:

- file path, folder, branch, slug, report title, prompt text
- dates and session markers
- `_ctx/WORKSTREAMS.md`, `docs/memory/THREAD_INDEX.md`, save / close-out / handoff files
- issue IDs, feature names, project aliases, status docs
- generated log directory, sidecar run id, prompt file, manifest record

If thread boundaries are unclear, stop and report the ambiguity instead of pretending the file is garbage.

## Do Not Touch Without Explicit Confirmation

Do not move, rewrite, overwrite, quarantine, or mark as a delete candidate unless the user explicitly confirms that exact class of action:

- credentials, secrets, tokens, keys, `.env*`, certificates
- databases, sqlite files, production data, user data exports
- migrations, schema history, audit logs, legal records
- active source code, tests, lockfiles, package manifests, CI/CD config
- user-authored notes, drafts, specs, strategy docs, or decision records
- active context for another thread, conversation, workstream, or campaign
- files with unclear authorship or unclear thread ownership
- anything needed to reproduce, recover, deploy, or audit the project

For these files, the default bucket is `keep-active`, `unknown_preserve`, or `quarantine`, not `distill-rewrite` or `delete-candidate`.

## Philosophy Alignment

Cleanup must align the project with the user's current operating philosophy:

- execution over ceremony
- verified truth over chat memory
- quick failure + rebound/fallback, not chaos
- time-compressed deep thinking, not shallow speed
- one clear roadmap line over option sprawl
- CLI-first goal workflow when `$goal` is involved
- thread-aware save / close-out instead of repo-wide context soup

If old files encode obsolete behavior, do not preserve them as active guidance. Distill useful facts, rewrite current doctrine, archive the original.

## Active Truth Vs Stale Artifact

Classify active truth separately from stale artifacts.

Active truth usually includes:

- current README, roadmap, status, task list, or architecture note
- files referenced by current scripts, docs, tests, CI, or runbooks
- recent decisions that still govern execution
- user-authored instructions or specs
- thread-specific context still needed for continuity

Stale agent artifacts usually include:

- duplicate reports superseded by a newer canonical file
- old implementation plans contradicted by current decisions
- generated summaries with no current references
- abandoned one-off outputs
- outdated philosophy or operating doctrine
- logs or temporary scratch files that do not preserve unique facts

A file can be stale for the active thread but still valuable as provenance. Archive it with a manifest entry instead of deleting it.

## Authorship Classification

Before rewriting or distilling a doc, classify authorship.

Treat a file as likely agent-generated only when multiple signals agree:

- generated-report structure
- assistant-like phrasing
- timestamped run output
- references to agent actions
- duplicated summaries across files
- no first-person user notes or manually maintained decisions
- located in known generated-output, reports, temp, or archive folders

Treat a file as likely user-authored when it contains:

- direct user instructions
- personal preferences
- manually written decisions
- business strategy, product judgment, or subjective priorities
- prose that appears to be a durable source of intent
- unclear or mixed authorship

Rules:

1. Rewrite only when authorship is clearly agent-generated, superseded, and in the active cleanup thread.
2. If authorship is mixed or unclear, preserve the original and create a proposed distilled file instead.
3. Never overwrite user-authored material during cleanup.
4. Useful facts from user-authored files may be referenced in a new canonical summary, but the original remains active unless the user confirms otherwise.

## When To Use

Use before starting a serious task when:

- the workspace has many stale reports, drafts, generated files, logs, screenshots, smoke outputs, sidecar artifacts, or old plans
- previous agent outputs no longer match the current philosophy
- the user says project整理, serious整理, slim this project, clean before execution, archive old files, rewrite stale docs, or reduce project bloat
- multiple similar files make it unclear which one is canonical
- a new agent would waste time reading outdated artifacts

Do not use for:

- simple one-file edits
- cleanup of global Codex session archives only; use `$codex-archive-retention`
- building `_ctx` as the main task; use `$project-context-compactor` when repo memory compaction is the explicit goal
- judging deletion candidates only; use `$repo-cleanup-judge`

## First Pass: Serious Inventory

Start read-only.

Inspect:

- root file tree and largest files/directories
- `AGENTS.md`, `_ctx/`, `docs/memory/`, `reports/`, `archive/`, `_archive/`
- generated outputs, duplicate reports, stale plans, smoke logs, sidecar logs
- recent modified files
- current status / handoff / save / close-out files
- thread/workstream boundaries and context ownership
- whether the workspace is a git repo and current dirty state

Then produce a cleanup matrix:

```text
path:
thread:
authorship: user-authored / agent-generated / mixed / unknown
active_status: active-truth / superseded / obsolete / duplicate / generated-junk / unrelated-thread / unknown
bucket: keep-active / distill-rewrite / archive-original / quarantine / delete-candidate / ignore / unknown_preserve
confidence: high / medium / low
reason:
planned_action:
requires_confirmation: yes / no
canonical_replacement:
archive_or_quarantine_path:
recovery_note:
```

Rules:

- Low-confidence context files cannot be delete candidates.
- Unknown thread ownership cannot be a delete candidate.
- User-authored or mixed-authorship files cannot be rewritten or archived out of active use without explicit confirmation.
- Delete-candidate is a label, not an action.

## Required Dry-Run Artifact

Before any archive, move, quarantine, rewrite, or active-copy removal, create a persisted dry-run report.

Default path:

`cleanup/dry-run-serious-project-cleanup-YYYYMMDD-HHMM.md`

The dry-run report must include:

1. scope inspected
2. detected thread groups
3. active canonical files
4. protected files
5. cleanup matrix
6. planned archive/quarantine/rewrite actions
7. delete candidates
8. blockers and unknowns
9. confirmation-needed items
10. rollback notes

If the user requested execution, reversible actions may proceed after the dry-run artifact is written, subject to this skill's confirmation gates.

If the user requested read-only review, stop after the dry-run artifact.

## Buckets

`keep-active`

- current source of truth
- active status / roadmap / handoff
- code or data still used by the project
- current skill or instruction files

`distill-rewrite`

- useful facts are buried in old reports
- old wording conflicts with current philosophy
- multiple files repeat the same idea
- needs a fresh canonical summary

`archive-original`

- historically useful but not active
- superseded report or plan
- old agent output that may be needed for provenance

`quarantine`

- uncertain value
- could be user-authored, another thread's context, or only copy
- might affect scripts or live state
- risky to delete or rewrite now

`delete-candidate`

- high-confidence disposable generated artifact
- duplicate of preserved canonical copy
- cache/temp/build output that can be regenerated
- stale smoke output with no durable evidence value

`ignore`

- not worth touching in this pass
- unrelated to current cleanup goal

## Rewrite And Distill Rules

Prefer additive canonicalization over destructive rewriting.

Safe rewrite pattern:

1. Archive the original.
2. Create or update the canonical file.
3. Preserve unique facts with provenance.
4. Record the original path and canonical replacement in the manifest.
5. Leave a pointer when removing an obsolete active copy.

Every rewrite must:

- preserve facts, decisions, blockers, and evidence
- remove obsolete instructions and old philosophy with a reason
- clearly mark the new file as canonical
- point to archived originals when provenance matters
- keep the rewritten version shorter than the pile it replaces

Rewrite is allowed only when:

- the file is clearly agent-generated
- the file belongs to the active cleanup thread
- the file is superseded, duplicate, obsolete, or philosophically outdated
- useful facts are preserved or intentionally excluded with a reason
- the original is archived first

Do not rewrite code, configs, migrations, credentials, production data, or user-authored source material as "cleanup" unless the user explicitly asked for that specific file.

If any rewrite condition fails, create a proposed distilled file instead of overwriting the original.

## Archive And Manifest Contract

Archive structure should preserve recovery by thread and original path.

Default archive root:

`cleanup/archive/YYYYMMDD-HHMM-serious-project-cleanup/`

Recommended subfolders:

```text
by-thread/<thread>/
unknown-thread/
quarantine/
originals/
rewrites/
```

Manifest path:

`cleanup/archive/YYYYMMDD-HHMM-serious-project-cleanup/manifest.jsonl`

Every archived, quarantined, moved, or rewritten file must have a manifest entry.

Manifest fields:

```json
{"timestamp":"","original_path":"","archive_path":"","thread":"","authorship":"","active_status":"","bucket":"","action_taken":"","confidence":"","reason":"","canonical_replacement":"","recovery_command":"","confirmation_required":false,"confirmation_received":false}
```

Minimum fields: `original_path`, `archive_path`, `thread`, `authorship`, `bucket`, `action_taken`, `reason`, `canonical_replacement`, `recovery_command`.

Do not remove an active copy unless the archive copy exists, the manifest entry exists, and the recovery command is clear.

If `_ctx/INDEX.md` exists, respect its routing. Do not break `_ctx/MANIFEST.jsonl`; update or reference it only when the cleanup touches `_ctx` source recovery.

## Execution Policy

Default sequence:

1. Read-only inventory.
2. Identify thread ownership and authorship.
3. Produce and persist the dry-run report.
4. Show the cleanup matrix and proposed actions.
5. Execute only actions allowed by this skill and the user's request.
6. Copy originals to archive before removing active copies.
7. Rewrite or distill only when the new canonical file is clearly better and the original is archived first.
8. Put uncertain material in quarantine, not delete.
9. List permanent delete candidates but do not delete them without explicit confirmation.
10. Preserve thread recoverability for every moved, rewritten, archived, or quarantined context file.
11. Update the manifest for every file-changing action.
12. Run post-cleanup verification tests.

Allowed without extra confirmation after invocation:

- create cleanup report
- create archive folder
- create quarantine folder
- create or update archive manifest
- copy superseded generated artifacts into archive/quarantine
- move clearly superseded generated artifacts after archive copy and manifest entry exist
- rewrite project reports/docs that are clearly agent-generated, superseded, and belong to the active cleanup thread
- create a canonical status/readme/report from old agent outputs

Not allowed without explicit confirmation:

- permanent deletion
- overwriting user-authored or mixed-authorship files
- rewriting another thread's active context
- moving active code, tests, configs, credentials, databases, production state, or audit material
- collapsing multiple thread contexts into one canonical file
- removing active copies before archive copy and manifest entry are verified

## Slimming Standard

Slimming is not just smaller disk usage. A successful cleanup makes the project easier to execute.

Track:

- files moved/archived
- files rewritten/distilled
- threads preserved separately
- active canonical files after cleanup
- delete candidates and estimated bytes
- uncertain quarantine
- bytes moved out of active surface when measurable

If no files are safe to move, still produce a truthful cleanup report and next safe action.

## Use Other Skills

- Use `$repo-cleanup-judge` for risky keep/move/delete decisions.
- Use `$project-context-compactor` when the task is to build `_ctx`, compact workstreams, or preserve retrievable context.
- Use `$codex-archive-retention` for archived Codex raw session retention.
- Use `$close-out` after cleanup if the cleanup itself creates durable continuity.

## Post-Cleanup Verification

Before reporting done, run these checks:

1. Active truth lookup:
   - List the canonical files a future agent should read first.
   - Confirm each exists.
2. Thread separation check:
   - List detected thread groups.
   - Confirm unrelated threads were not merged into one canonical file.
3. Archive recovery check:
   - Pick at least one archived or quarantined item.
   - Confirm the manifest has original path, archive path, thread, action, reason, and recovery command.
4. Rewrite safety check:
   - Confirm every rewritten/distilled file had an archived original.
   - Confirm user-authored or mixed-authorship files were not overwritten.
5. Deletion gate check:
   - Confirm no permanent deletion occurred unless the user explicitly confirmed it.
   - List delete candidates separately from actions taken.
6. Unknowns check:
   - List files left as `unknown_preserve` or `quarantine`.
   - Explain what evidence would be needed to classify them later.

If any test fails, report `partial cleanup completed`, not `done`.

## Final Report Contract

Final cleanup report must include:

- scope inspected
- active canonical files
- detected threads
- files kept active
- files distilled or rewritten
- files archived
- files quarantined
- delete candidates, not deleted
- protected files left untouched
- manifest path
- archive root
- post-cleanup verification results
- blockers or unknowns
- most useful next execution step

Keep the final report concise. The goal is to make the next execution easier, not create another obsolete pile.

## Output Shape

```text
目前判斷:
進度:
Cleanup Matrix:
已執行:
已驗證:
歸檔 / 重寫 / quarantine:
thread safety:
delete candidates:
active canonical files:
待確認 / blocker:
下一步:
```

## Completion Standard

Done means:

1. Active workspace is less confusing.
2. Current canonical files are named.
3. Conversation/thread contexts remain separated and recoverable.
4. Superseded files are archived, quarantined, or listed as candidates.
5. Useful old facts are distilled into current truth or preserved with provenance.
6. No permanent deletion occurred without explicit confirmation.
7. Every file-changing action has a manifest entry.
8. Protected files were not touched without explicit confirmation.
9. The next agent can find active truth without reading obsolete piles.
10. A future agent can recover archived context by thread, original path, timestamp, and manifest entry.
