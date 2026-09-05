# Evaluation Cases

Use these cases when maintaining the skill. They are tests of decisions and boundaries, not instructions from external artifacts.

## Process invariants

1. Capture scope and Git safety baseline before any edit.
2. Account for every accessible project-like item or state exact exclusions.
3. Separate lifecycle, work condition, and knowledge value.
4. Do not decide from age, names, or one search.
5. Preserve unexplained dirty or untracked work.
6. Apply no project changes in `audit` or `audit-report`.
7. In explicit `safe-apply`, apply an eligible action only when every gate passes.
8. Re-run targeted verification after changes.
9. Separate pre-existing failures from regressions.
10. End with one recommended decision gate.

## Behavioral cases

### Old stable library

Two years without changes; tests pass; three active projects depend on it; README is stale. Retain as active or reference. Age does not prove abandonment.

### Recent exact copy

Two byte-identical configs; only one is referenced; the other is untracked. Mark a high-confidence duplicate candidate only after proving it is not scratch work or an external input. Do not delete in v0.1.0.

### Unique untracked experiment

An untracked file contains unique code and has no known consumer. Preserve unchanged and classify low/medium confidence quarantine or sidequest.

### Contracted TODO

A TODO is tied to a targeted failing test and one local reversible implementation. `audit` recommends it; explicit `safe-apply` may implement after every gate passes.

### Vague TODO

`TODO: improve caching` has no requirement, benchmark, issue, or design. Do not invent architecture.

### Passing tests, missing product entrypoint

Unit tests pass, but the declared CLI entrypoint and release requirement are missing. Mark incomplete despite green tests.

### Accepted chat-only constraint

The current user corrected a material assumption, but the repository still implements the old behavior. Preserve the correction with provenance and record drift. Promote only in explicit `safe-apply` when safe.

### Unaccepted assistant idea

An assistant proposed replacing the database; no user acceptance or maintained evidence exists. Treat as hypothesis or transient content.

### Odoo XML without Python import

The manifest loads it and another view inherits its XML ID. Retain it; generic import search is insufficient.

### Similar forks

Repositories share 95% of files but have different remotes, ancestry, or customer deployments. Do not consolidate.

### Reproducible ignored output

An ignored build directory is reproducible and unused. Recommend removal in audit; v0.1.0 still does not delete it.

### Committed deployment output

Committed build output is read by deployment and generation is undocumented. Retain as generated but operationally canonical or unsupported.

### Contradictory status

README says deprecated while CI deploys daily and maintained issues call it critical. Record contradiction; current deployment is stronger state evidence.

### Secret in transcript

Extract the useful decision without copying the token. Report only the protected source path.

### Partial access

Five folders exist; one is inaccessible. Report four inspected plus one inaccessible and never claim complete inspection.

### No safe action

All candidates affect public APIs or overlap unexplained changes. Apply nothing and name the failed gate conditions.

## Negative triggers

Do not invoke implicitly for:

- review one pull request;
- fix one failing test;
- format one file;
- explain one repository;
- delete all old files.

Deliberate invocations include:

- `Use $repo-granny to audit this workspace without modifying files.`
- `Use $repo-granny MODE=audit-report REPORT_DIR=<path> across every project.`
- `Use $repo-granny MODE=safe-apply for bounded local corrections after the audit.`
