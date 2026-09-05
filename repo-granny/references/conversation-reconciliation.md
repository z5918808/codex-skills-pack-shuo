# Conversation Reconciliation

Use only sources actually available in the current context, explicitly supplied by the user, injected by the host, stored inside the scoped workspace, or exposed through an authorized tool.

## Authority

Rank intent evidence in this order unless a maintained repository contract defines a stricter local order:

1. current user instruction;
2. explicit accepted decision with clear project ownership;
3. maintained canonical project document;
4. current implementation and runtime evidence for as-is behavior;
5. accepted issue, release, or operational record;
6. older conversation or working note;
7. unaccepted assistant proposal.

Implementation proves current state, not necessarily intended state. When sources disagree, record `as_is`, `intended`, `drift`, provenance, and the authority needed to resolve it.

## Extraction

For each material item record:

- source identifier and date when available;
- exact project association;
- type: `decision`, `constraint`, `acceptance_criterion`, `action`, `blocker`, `question`, `idea`, or `context`;
- current status: `implemented`, `documented`, `conflicting`, `stale`, `orphaned`, or `unresolved`;
- knowledge value from the classification reference;
- confidence;
- recommended destination or next proof.

## Promotion gate

Promote an item into an existing canonical document only in explicit `safe-apply` mode and only when it is clearly associated, current, explicit, non-sensitive, not contradicted, and safe to add without creating a second source of truth.

Otherwise retain it as a proposed update or decision-gate item. Do not create a new governance system merely because no obvious destination exists.

## Boundaries

- A user correction overrides the earlier assistant claim it corrected.
- An assistant proposal remains a hypothesis until accepted or implemented by maintained evidence.
- Do not crawl unrelated personal history.
- Narrow searches using repository names, remotes, paths, issue IDs, or identifiers.
- Do not quote or reproduce secrets; record only the protected source path.
- Do not claim all-history coverage unless every relevant source was actually accessible.
- Separate raw provenance from distilled durable knowledge.

## Report

State coverage as explicit sets, for example: current conversation, supplied transcripts, workspace records, connected issue tracker, and unavailable sources. For every promoted or proposed item, preserve enough provenance for a future reader to verify it.
