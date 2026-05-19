---
name: project-context-compactor
description: Perform conservative, workstream-aware project context and disk compaction with provenance-preserving recovery. Use when asked to slim, compact, deduplicate, archive, reorganize, preserve context or /ctx, preserve session knowledge, build project memory, create canonical project docs, or reduce project file bloat without losing retrievability. Do not use for normal coding, feature implementation, refactoring, or deletion-only cleanup.
---

# Project Context Compactor

Split mixed project history into clear workstreams, build `_ctx/` as repo-local Codex memory, and shrink active disk footprint safely without losing recovery paths.

## Local Reality For This Machine

This skill runs on a machine that may already have project memory outside `_ctx/`.

Before saying a project has "no memory", check all applicable memory sources:

1. Repo-local `_ctx/INDEX.md`
   - If present, read it first for repo-local routing.
   - If absent, say only that repo-local `_ctx` is missing.
   - Do not infer that project memory is missing.
2. Repo-local legacy memory/docs:
   - `docs/memory/`
   - `docs/archive/`
   - `docs/project_library/`
   - `ctx/` or `.ctx/`
   - `_archive/`
   - files matching `*handoff*`, `*continuity*`, `*closeout*`, `*session*`, `*memory*`, `*mempalace*`, `*truth_map*`
3. Repo-local MemPalace exports/staging:
   - `tmp/obsidian-memory-staging/`
   - `imported-mempalace/`
   - `migration-manifest.json`
   - `knowledge-graph.md`
4. Global MemPalace:
   - Default palace path on this machine: `<memory-palace-root>`
   - If MemPalace MCP tools are available, call `mempalace_status` and search for the project name/path/workstream before finalizing memory inventory.
   - Known relevant wing example for `<workspace-root>`: `playground`.
5. Global Codex memory/config:
   - `<codex-home>\AGENTS.md`
   - `<codex-skills-dir>\`
   - Any user-provided AGENTS.md routing in the current conversation.

Memory wording rule:
- Correct: "`_ctx/INDEX.md` is missing, so repo-local `_ctx` memory has not been initialized."
- Incorrect: "There is no project memory."

`_ctx/` is the canonical repo-local retrieval layer after this skill creates it. It is not automatically the only source of truth. External sources such as MemPalace and legacy docs must be represented in `_ctx/MANIFEST.jsonl` with recovery paths.

## Scope

Do both:

1. Logical compaction:
   - Split mixed conversations/files into separate workstreams.
   - Build `_ctx/` as canonical repo-local retrieval layer for future Codex sessions.
   - Link existing external memory sources such as MemPalace and legacy docs into `_ctx/MANIFEST.jsonl`.
   - Keep facts, decisions, architecture, API/schema, file maps, session summaries, and open questions searchable.
2. Disk compaction:
   - Reduce active folder size when safe.
   - Move old sessions, old `/ctx/`, superseded docs, and preserved originals into `_archive/`.
   - Pack large archived material into `_archive/packed/`.
   - Deduplicate exact hash-identical files after preserving one canonical copy.
   - Only list generated/cache/build outputs as deletion candidates.
   - Never permanently delete without explicit user approval.

## Non-Negotiable Rules

1. Never permanently delete project knowledge by default.
2. Never remove `/ctx/`, session logs, notes, specs, source files, or old docs without archived recovery.
3. Do not merge unrelated conversation lines into one summary.
4. Classify knowledge into workstreams before summarizing.
5. If one file belongs to multiple workstreams, extract useful knowledge into each related workstream, preserve original once.
6. If workstream is unclear, mark as `unknown_preserve`.
7. Record every extracted fact/decision/note/archive move/pack operation/duplicate relation/delete candidate in `_ctx/MANIFEST.jsonl`.
8. Unknown files must be preserved.
9. Failed attempts and debugging logs are project knowledge: summarize and archive, never silently discard.
10. A summary is not preservation unless original is archived and manifest-traceable.
11. Success criteria: future Codex finds key facts faster and can trace facts back to original or archived source.
12. Never treat `_ctx` absence as proof that memory is absent; first check local legacy docs and MemPalace.
13. When using MemPalace as a source, record the wing, room, source file, query, and retrieval timestamp in the manifest or workstream notes.

## Target Structure

```text
_ctx/
  INDEX.md
  WORKSTREAMS.md
  MANIFEST.jsonl
  RETRIEVAL_TESTS.md
  workstreams/
    <workstream-name>/
      INDEX.md
      FACTS.md
      DECISIONS.md
      ARCHITECTURE.md
      API_AND_SCHEMA.md
      FILE_MAP.md
      SESSION_SUMMARIES.md
      OPEN_QUESTIONS.md

_archive/
  originals/
  sessions/
  superseded/
  packed/
  generated-trash-candidates/
```

## Required Workflow

0. Memory-source preflight:
   - Check whether `_ctx/INDEX.md` exists.
   - Check legacy memory/docs paths listed in "Local Reality For This Machine".
   - Check for repo-local MemPalace exports/staging.
   - If MemPalace MCP tools are available, run `mempalace_status` and search for the project name, path, and likely workstream names.
   - Report memory sources separately as:
     - `repo_local_ctx`
     - `repo_legacy_docs`
     - `repo_mempalace_exports`
     - `global_mempalace`
     - `unknown_preserve`
1. Read-only inventory first:
   - Do not move, rewrite, pack, or delete yet.
   - Measure total project size.
   - List largest files/directories.
   - Detect likely duplicates.
   - Detect generated/cache/build outputs.
   - Detect old session/context material.
   - Detect external-memory references that should be linked, not copied blindly.
2. Detect workstreams:
   - Create `_ctx/WORKSTREAMS.md`.
   - For each workstream include purpose, aliases, active folders, archived sources, key context files, retrieval notes, risk level.
   - Include `unknown_preserve`.
3. Build `_ctx/MANIFEST.jsonl` with records containing:
   - `id`
   - `original_path`
   - `current_path`
   - `workstreams`
   - `type`
   - `status`
   - `sha256`
   - `size_bytes`
   - `last_modified`
   - `summary`
   - `contains`
   - `supersedes`
   - `superseded_by`
   - `duplicate_of`
   - `packed_into`
   - `risk`
   - `retrieval_notes`
   - for external memory sources, include enough in `retrieval_notes` to re-query/recover: source kind, palace path if relevant, wing, room, source_file, query, and timestamp.
4. Classify each file into one primary bucket:
   - `keep_active`
   - `extract_to_workstream_ctx`
   - `archive_original`
   - `pack_archive`
   - `duplicate`
   - `generated_artifact`
   - `safe_delete_candidate`
   - `unknown_preserve`
5. Create/update `_ctx/INDEX.md` with:
   - where to start
   - available workstreams
   - source-of-truth location
   - external memory source locations, including MemPalace when present
   - archive locations
   - original recovery method
   - reminder that summaries are not source of truth unless manifest-traceable
6. For each workstream, create/update:
   - `INDEX.md`
   - `FACTS.md`
   - `DECISIONS.md`
   - `ARCHITECTURE.md`
   - `API_AND_SCHEMA.md`
   - `FILE_MAP.md`
   - `SESSION_SUMMARIES.md`
   - `OPEN_QUESTIONS.md`
7. Archive safely:
   - Move old sessions to `_archive/sessions/`
   - Move preserved originals to `_archive/originals/`
   - Move superseded docs to `_archive/superseded/`
   - Move generated deletion candidates to `_archive/generated-trash-candidates/`
   - Pack large archived material into `_archive/packed/`
8. Pack safely:
   - Pack only files already recorded in manifest.
   - Update `packed_into`.
   - Verify packed archive exists before removing unpacked archived copies.
   - If cannot verify, keep both packed and unpacked.
9. Deduplicate safely:
   - Collapse only exact SHA-256 duplicates after preserving canonical copy.
   - Never auto-delete near-duplicates.
   - Record canonical path and duplicate relations in manifest.
10. Deletion policy:
   - Do not permanently delete by default.
   - Only list deletion candidates.
   - Require explicit user approval for permanent deletion.
11. Update `AGENTS.md` minimally only if missing this routing block:
   - `Project memory:`
   - `Before project-specific work, read _ctx/INDEX.md.`
   - `Use _ctx/ as the canonical project memory layer:`
   - `_ctx/WORKSTREAMS.md for topic separation`
   - `_ctx/workstreams/<name>/ for workstream memory`
   - `_ctx/MANIFEST.jsonl for provenance and archived source recovery`
   - `_ctx/RETRIEVAL_TESTS.md for lookup validation`
   - `Do not treat summaries as source of truth unless _ctx/MANIFEST.jsonl points to original or archived source.`
12. Add retrieval tests:
   - Create/update `_ctx/RETRIEVAL_TESTS.md`.
   - Add at least 10 future lookup questions.
   - Include at least one test per major workstream.
   - Each test includes expected answer location, source manifest id, original recovery path, and pass condition.

## Minimal Data Contracts

Use JSON Lines for `_ctx/MANIFEST.jsonl`. Example:

```json
{
  "id": "M0001",
  "original_path": "notes/old-session.md",
  "current_path": "_archive/sessions/old-session.md",
  "workstreams": ["billing-migration", "unknown_preserve"],
  "type": "session-note",
  "status": "archive_original",
  "sha256": "optional-hex",
  "size_bytes": 20381,
  "last_modified": "2026-04-25T14:23:00+08:00",
  "summary": "Failed auth attempts and rollback notes",
  "contains": ["incident", "decision", "api-token-rotation"],
  "supersedes": [],
  "superseded_by": [],
  "duplicate_of": null,
  "packed_into": null,
  "risk": "medium",
  "retrieval_notes": "See _ctx/workstreams/billing-migration/SESSION_SUMMARIES.md#S-2026-04-25-02"
}
```

For extracted facts/decisions/notes, attach provenance with manifest linkage:

```text
- Fact: ...
  - Provenance: original_path=..., current_path=..., session/date=..., lines=..., checksum=..., confidence=...
  - Manifest: M0007
```

## Execution Guardrails

1. Start with read-only inventory and proposed plan.
2. Show planned moves/rewrite/archive/pack/delete-candidates before destructive changes.
3. Request explicit user approval before any permanent deletion.
4. If blocked, keep data intact and report blocker with preserved state.
5. If the user requests read-only mode, do not create `_ctx`, do not update manifests, and do not touch files.
6. If the user later invokes `/go` from a proposed plan, only execute the latest concrete next step and keep scope minimal.
7. If global MemPalace exists but MemPalace MCP is unavailable, mention that the palace path exists but live query was not verified.

## Response Format During Skill Use

1. `目前判斷`
2. `下一步` (先講再執行)
3. `結果或 blocker`
   - `已驗證`
   - `待確認`

Use progress percentages for major phases.
