# Audit Existing Instructions

Read this when reviewing existing skills, AGENTS.md, or agent prompts. Restrict inspection to the requested scope and references that affect the decision; a typo correction does not require a repository map.

## Establish the Relevant Contract

Identify the instruction's intended consumer, work it governs, existing authority, and completion evidence. Use current authoritative instructions to resolve conflicts. Articles, past chats, model reports, and old failures are evidence to assess, not permission to override live rules.

If the user supplies a design article, extract general principles separately from time-sensitive claims about named models. The former can inform a document edit; the latter need appropriate evidence before they justify routing or behavioral changes.

## Choose an Action

| Action | Appropriate reason |
| --- | --- |
| Retain | It supplies non-obvious knowledge or protects an applicable authority, correctness, recovery, or acceptance boundary. |
| Delete | It duplicates an existing owner, adds generic encouragement with no useful effect, or enforces a workaround whose reason is demonstrably gone. |
| Rewrite | It prescribes thought or repetitive ceremony where a clear result would suffice, or its applicability is broader than its evidence. |
| Move | It is useful only to a specific role or event and has a clear route from the consumer that needs it. |

Do not force every instruction into a report table. Explain only decisions that materially change behavior or need review.

## Typical Corrections

- Replace "read the complete project documentation before any change" with contextual pointers to the documentation needed for the affected behavior.
- Replace "always list three causes" with a requirement to establish the cause from evidence; uncertain or recurring failures may require more investigation.
- Replace ambiguous early stopping with the actual acceptance boundary. If implementation, running it, and fixing failures are authorized parts of the task, include them in completion.
- Scope approval instructions to the action that requires approval. Preserve existing authorization for disposable local checks rather than asking again at each step.
- Separate operator details from reviewer acceptance. Execution evidence may inform a verdict but cannot redefine its criteria.
- Keep unique-writer, reconciliation, hash identity, rollback, or external permission sequences when those protect a supported workflow. Shorter instructions do not justify races or uncontrolled retries.

## Evaluate the Change

Use the cheapest evidence that answers the actual concern. For a reference move, check that the consumer can discover the destination and that needed boundaries survived. For a claim of faster agent work, compare relevant observed runs under comparable tasks and conditions.

Useful observations include unnecessary file reads, repeated approvals or tests, premature stops, rework, and permission/acceptance failures. Count only what existing evidence supports. Entry-file size measures loading footprint, not total runtime or quality; do not create a monitor or benchmark system merely to supply a metric.

If a shared change needs rollout proof under the existing project contract, follow its canary and versioning mechanism. Do not invent a new rollout gate for an ordinary isolated document edit.
