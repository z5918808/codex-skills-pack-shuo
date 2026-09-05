# Classification and Evidence

Use three independent dimensions. Never force lifecycle, work condition, and knowledge value into one label.

## Project lifecycle

- `ACTIVE_MAINLINE`: directly serves the current primary outcome and has a current consumer, release path, or accepted roadmap role.
- `ACTIVE_SIDEQUEST`: intentionally active and useful, but not required by the mainline.
- `PARKED`: intentionally paused with a reason, restart condition, and recoverable last-known state.
- `COMPLETED`: the intended outcome is delivered and verified; passing tests alone are insufficient.
- `REFERENCE`: retained for examples, research, comparison, history, or reusable knowledge; not an active delivery path.
- `RAW_ARCHIVE`: authoritative raw evidence kept for provenance, recovery, audit, or later distillation.
- `DEAD_CANDIDATE`: strong evidence shows no active consumer, no accepted restart condition, and no irreplaceable retained value. This is never deletion permission.
- `QUARANTINE`: ownership, provenance, purpose, safety, or consumers remain unclear. It is a decision state, not a physical folder.

`DEAD_CANDIDATE` requires at least two independent strong signals, no stronger current-use signal, separate assessment of unique knowledge/assets, and a recovery path.

## Work condition

- `HEALTHY`: matches its declared purpose, current contracts, and verification path.
- `INCOMPLETE`: an explicit accepted contract lacks a required part.
- `BLOCKED`: the next meaningful step depends on a named unavailable decision, dependency, access, upstream fix, or unresolved contradiction.
- `DUPLICATE_CANDIDATE`: may duplicate another item, but equivalence, ownership, consumers, lineage, and canonical destination still require proof.
- `ORPHANED`: no confirmed owner or consumer, while value or safety is not yet known.
- `UNSUPPORTED`: still has a purpose or consumer but lacks maintained verification, ownership, dependencies, or an operating path.
- `GENERATED`: reproducible output from a canonical source; confirm generation, deployment role, and reproducibility before demotion.
- `CONTRADICTORY`: authoritative-looking sources disagree about behavior, ownership, status, or intent.

A TODO, draft filename, stale branch, or unrelated failing test does not establish `INCOMPLETE`.

## Knowledge value

- `MEMORY_KERNEL`: durable definitions, constraints, accepted decisions, rationale, invariants, source-of-truth routing, or recovery procedures.
- `BREAKTHROUGH_CLUE`: non-final evidence, anomaly, or partial result that could unlock future work.
- `REJECTED_PATH`: a considered approach rejected for a recorded reason.
- `CONTRADICTION`: conflicting claims whose resolution matters; retain both sides and provenance.
- `REFERENCE_KNOWLEDGE`: useful background that need not remain in active context.
- `TRANSIENT`: repeated, superseded, speculative, social, or low-impact material with no durable decision value.

## Evidence strength

- `DIRECT`: observed in current files, executable behavior, command output, runtime evidence, explicit current instruction, or a canonical ledger.
- `STRONG`: corroborated by multiple maintained sources, tests, Git history, dependency metadata, issues, releases, or active consumers.
- `WEAK`: based mainly on age, names, absence from one search, informal comments, old conversation, or assumptions.

## Confidence

- `HIGH`: direct or multiply corroborated evidence; material contradictions resolved.
- `MEDIUM`: plausible but ownership, consumer, equivalence, or intent questions remain.
- `LOW`: purpose, provenance, or impact is unclear.

Confidence never grants write authority. A physical change also needs the Safe Action Gate in `SKILL.md`.

## Priority

- `P0`: immediate risk to unique work, secrets, data, production, money, security, or canonical control.
- `P1`: blocks active work or risks losing important decisions, history, or ownership.
- `P2`: maintenance cost, stale routing, duplication, unsupported work, or dormant clutter.
- `P3`: cosmetic or optional optimization.

## Common claims

### Abandoned

Strong signals include an explicit cancellation, a verified replacement in use plus no remaining consumer, an intentionally retired required platform, or maintained roadmap/code/release evidence agreeing that work ended.

Age, old commits, stale branches, missing README, names such as `old` or `v2`, one missing reference, and failing tests are weak signals only.

### Duplicate

Distinguish exact accidental copies from generated derivatives, forks, experiments, compatibility implementations, versioned documentation, deployment copies, and recovery backups. Only accidental duplicates with the same purpose, ownership, lifecycle, consumers, and lineage are ordinary consolidation candidates.

### Incomplete

Require an accepted expected outcome: a maintained requirement, targeted failing test, declared entrypoint, or release gate. Do not invent work from vague TODOs.

### Important but undocumented

High-value examples include user corrections affecting future behavior, code relying on an undocumented constraint, a failure cause that prevents repeated work, or a release/recovery procedure existing only in a conversation.

## Recommended action vocabulary

- `KEEP`
- `PROMOTE`
- `COMPLETE`
- `CONSOLIDATE`
- `DEMOTE`
- `PARK`
- `ARCHIVE_PLAN`
- `QUARANTINE`
- `DELETE_CANDIDATE`

The last three are recommendations or decision states only. Version 0.1.0 does not physically archive, quarantine, or delete.
