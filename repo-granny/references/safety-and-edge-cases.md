# Safety and Edge Cases

Read this file before any write or when a classification could lead to removal, consolidation, demotion, or archival.

## Preservation rule

Unknown does not mean disposable. Preserve first, establish provenance and consumers, then decide.

## User work and Git

- Capture branch, HEAD, upstream, worktrees, submodules, staged, unstaged, conflicted, untracked, and unpushed state before editing.
- Treat unexplained dirty or untracked files as protected user work.
- Do not stash, reset, clean, normalize, stage, overwrite, or absorb them.
- A tracked file may still contain unique local history not present on a remote.
- Similar checkouts may be worktrees, deployment copies, mirrors, vendor forks, migration experiments, or recovery snapshots.

Version 0.1.0 never performs deletion, moves, renames, archival, commits, pushes, merges, releases, deployments, branch/tag operations, or history rewrites.

## Scope and links

- Resolve the exact scope and never traverse above it.
- Do not follow symlinks, junctions, or mounts outside the scope.
- Treat multiple paths resolving to one target as one identity signal, not proof of duplicate projects.
- Record inaccessible paths and permission failures without claiming full inspection.
- On Windows, account for junctions, case-insensitive paths, reserved names, path length, and line-ending differences.

## Static “unused” evidence is weak

Text search alone cannot rule out:

- dynamic imports, reflection, plugin registries, entry points, or dependency injection;
- configuration-driven loading, templates, translations, and naming conventions;
- CI, scheduled jobs, hooks, deployment scripts, or external consumers;
- XML, JSON, YAML, database, metadata, domain, context, or report references;
- feature flags, migrations, rollback scripts, fixtures, snapshots, and incident evidence.

## Odoo

Before calling an Odoo asset unused, inspect module manifests and data order, XML IDs, inherited views, QWeb, actions, menus, security records, scheduled actions, domains, contexts, reports, Studio exports, server actions, multi-company rules, access rules, and version-upgrade behavior. Lack of a Python import is not sufficient.

## Generated and ignored material

A generated or ignored path may be the only build, a deployment input, expensive to reproduce, a forensic artifact, or a cache containing unsaved state. Confirm generator, sources, reproducibility, downstream use, ownership, and running processes before recommending removal.

Names such as `dist`, `build`, `out`, `target`, `.cache`, `tmp`, `coverage`, and `node_modules` are clues, not proof.

## Dependencies and configuration

Do not remove a dependency solely because a search finds no import. Check scripts, plugins, optional features, peer dependencies, code generation, tests, build tooling, and runtime loading. Lockfiles and apparently unused configuration may be canonical reproducibility or external integration inputs.

## Production, databases, and remote state

Do not apply or remove migrations, schemas, production records, cloud resources, DNS, credentials, access policies, subscriptions, release configuration, or remote state. Old migrations and inactive feature flags may be required for reconstruction or rollback.

## Secrets

- Do not read secret contents merely to classify files.
- Do not copy secrets into reports, archives, issues, commits, or chat.
- Record only that sensitive material exists, its protected path, and the handling gate.
- Do not validate, rotate, revoke, upload, or use credentials.

## Binary, dataset, legal, and audit material

Filenames and text similarity are unreliable for binaries, media, datasets, and models. Check exact hashes, metadata, provenance, licensing, versions, encoding, and consumers. Never remove notices, licenses, attribution, compliance evidence, audit trails, customer records, or retention-controlled material based only on engineering relevance.

## Conversations and documentation

- Versioned documents may intentionally differ.
- One repeated explanation may contain a critical correction or rejected path.
- Assistant prose is not authoritative because it is detailed or recent.
- Preserve raw provenance when necessary while routing it out of active context.
- Never claim access to conversations or memories that were not actually available.

## Verification

- Capture a baseline before changes.
- Passing tests may coexist with an unfinished product or broken deployment.
- Failing tests may be pre-existing, obsolete, flaky, platform-specific, or unrelated.
- Use targeted checks first and broader checks only when justified.
- Attribute regressions precisely.
- Do not install broad tooling solely to manufacture a green check.

## Concurrency

Check for active builds, migrations, synchronization, package management, development servers, or other agents before touching outputs they may own. Use one writer for shared state. A report or handoff is evidence, not write authority.

## Decision-gate triggers

Route these to the final decision gate:

- unique or ambiguously owned material;
- public or cross-project contracts;
- unknown external consumers;
- production, data, money, security, billing, authentication, infrastructure, or credential effects;
- schema or migration changes;
- legal, licensing, audit, or retention uncertainty;
- medium/low-confidence consolidation;
- conflict between current intent and maintained repository rules;
- unexplained user work blocking an otherwise safe action.

Continue unaffected read-only work and consolidate unresolved choices into one recommended gate.
