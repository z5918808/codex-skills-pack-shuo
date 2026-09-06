# Bounded Reviewer Repair

Reviewer: read when pre-run evidence exposes a shared defect or on a delivered technical handoff. The packet is defined in [Worker execution](worker.md); authority and permission interpretation stay in the entrypoint.

Establish the cause from current evidence, make the smallest authorized correction, and provide evidence that the affected contract behavior is restored. Choose diagnosis depth and tools for the uncertainty; no fixed reflection template or number of hypotheses is required.

- Use delivered artifacts and authoritative state. If needed, take the one event-triggered Worker snapshot allowed by the entrypoint. Confirm an apparently hung action has not already completed before killing or retrying it.
- A low-risk cause already verified by deterministic evidence needs no elaborate diagnosis. Worker confidence is insufficient. For uncertainty, repeated failures, high risk, contradictory evidence, or a failed short repair, investigate the unresolved cause before another patch. Repeated symptoms belong at their earliest common owner, not product- or generation-specific branches.
- A shared-code change still needs a bounded RED→GREEN regression at the real call seam and the narrowest relevant suite. Prefer an existing fixture; keep verification proportional to the affected contract. For non-code corrections, use decisive before/after state evidence. Reuse sufficient current proof rather than rerunning identical checks.
- Leave the full production traversal, batch, migration, and full acceptance command to the Worker. Update canonical authority only when its contract requires it.

Once repair is verified, use [lifecycle](lifecycle.md) for a prior goal when one exists, then [dispatch](dispatch.md) for exactly one fresh goal. Recheck the affected readiness evidence and acceptance discriminator; a patch-local green result does not establish that the dispatch route works. End the turn after dispatch. If the old action already completed, the new goal consumes its evidence and forbids duplicate execution.

Final acceptance uses [acceptance](acceptance.md), including independent contract evidence for Reviewer-authored repairs. An unresolved permission or external gate stops only the affected action while authorized safe work remains.

## Required handback after shared repair

Reviewer repair ends at verified code/configuration plus bounded fixture/read-only evidence. It excludes every live rollback or recovery write, even a one-item smoke test. Before each repair verification command, check the actual target and side effects; no live apply hidden behind a test/preview flag. If its behavior is unknown, inspect or exercise an isolated fixture first.

1. Establish whether the old Worker action completed, stopped, or has unresolved side effects using available current evidence and the existing bounded lifecycle rules. Never rerun an action merely because the repair succeeded.
2. Prepare the changed code/diff identity, affected behavior, regression results, no-write preview where applicable, actual permission reference, remaining assumptions, and explicit next executor=Worker in the existing handoff/dispatch artifact.
3. If material uncertainty remains about the repaired route or safe execution, send that bounded question to the same Astra Thinker with the evidence, then yield. Routine decisive repairs need no extra mid-run consultation; mandatory closing remains required. Astra ready does not grant user permission.
4. Once readiness and actual authorization are satisfied, use lifecycle-approved redispatch to the existing Worker with the pinned repaired references and action scope. Missing or stale authorization blocks only the affected live action. Do not run the live operation while preparing its dispatch.
5. Worker executes and returns actual evidence through reporting.md. Reviewer routes the complete result to the same Astra chat for closing verification; corrections follow the same ownership split.

Example: Reviewer fixes the rollback tool and validates an isolated fixture; Worker applies the authorized category rollback and performs the assigned full inventory; Astra checks the resulting evidence. Reviewer must not apply even the first live rollback to demonstrate that its repair works.
