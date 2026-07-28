---
name: animate
description: Use when UI motion can clarify state, continuity, feedback, spatial relationships, or one intentional delight moment.
---

# Animate

Use the project design context from `impeccable`; this skill adds motion judgment only.

## Core Rule

Every animation must explain a state change, preserve spatial continuity, confirm input, or support a deliberate brand moment. Decoration alone is not a reason.

1. Name the user event, meaning, and non-animated fallback.
2. Prefer one motion system and one signature moment over scattered effects.
3. Keep feedback immediate; let distance and complexity determine duration rather than fixed tables.
4. Avoid layout work when transform or opacity expresses the same change, but use the simplest correct technique.
5. Cancel obsolete animations and never block urgent input.
6. Respect `prefers-reduced-motion`; the reduced experience must remain complete and understandable.

Verify on target hardware with performance tracing, keyboard flow, interrupted transitions, repeated use, and reduced motion. Remove motion that adds latency, ambiguity, or fatigue.
