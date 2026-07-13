---
name: polish
description: Use for /polish after core behavior is verified and the user wants a bounded final pass for consistency and edge states.
---

# Polish

Use the project design context from `impeccable`. Polish is finish work; do not use it to avoid incomplete structure or failing behavior.

## Gate

Confirm the target flow works, the quality bar is known, and the polish budget is bounded. Fix systemic token or component drift before isolated pixels.

Check only relevant areas:

- alignment, spacing, typography, contrast, and visual hierarchy;
- hover, focus, active, disabled, loading, empty, error, and success states;
- responsive reflow, long content, localization, zoom, and touch;
- icons, images, layout shift, reduced motion, and keyboard flow;
- copy terminology and shared component consistency;
- browser console and the most relevant tests.

Do not introduce a new design direction, refactor unrelated code, remove user work, or chase pixel perfection while P0/P1 defects remain.

Verify by using the feature and comparing real screenshots at representative sizes. Stop when the bounded quality bar is met; polish is not an endless loop.
