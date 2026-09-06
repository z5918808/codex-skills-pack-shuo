# Bounded Reviewer Repair

Reviewer: read when pre-run evidence exposes a shared defect or on a delivered technical handoff. The packet is defined in [Worker execution](worker.md); authority and permission interpretation stay in the entrypoint.

Establish the cause from current evidence, make the smallest authorized correction, and provide evidence that the affected contract behavior is restored. Choose diagnosis depth and tools for the uncertainty; no fixed reflection template or number of hypotheses is required.

- Use delivered artifacts and authoritative state. If needed, take the one event-triggered Worker snapshot allowed by the entrypoint. Confirm an apparently hung action has not already completed before killing or retrying it.
- A low-risk cause already verified by deterministic evidence needs no elaborate diagnosis. Worker confidence is insufficient. For uncertainty, repeated failures, high risk, contradictory evidence, or a failed short repair, investigate the unresolved cause before another patch. Repeated symptoms belong at their earliest common owner, not product- or generation-specific branches.
- A shared-code change still needs a bounded RED→GREEN regression at the real call seam and the narrowest relevant suite. Prefer an existing fixture; keep verification proportional to the affected contract. For non-code corrections, use decisive before/after state evidence. Reuse sufficient current proof rather than rerunning identical checks.
- Leave the full production traversal, batch, migration, and full acceptance command to the Worker. Update canonical authority only when its contract requires it.

Once repair is verified, use [lifecycle](lifecycle.md) for a prior goal when one exists, then [dispatch](dispatch.md) for exactly one fresh goal. Recheck the affected readiness evidence and acceptance discriminator; a patch-local green result does not establish that the dispatch route works. End the turn after dispatch. If the old action already completed, the new goal consumes its evidence and forbids duplicate execution.

Final acceptance uses [acceptance](acceptance.md), including independent contract evidence for Reviewer-authored repairs. An unresolved permission or external gate stops only the affected action while authorized safe work remains.
