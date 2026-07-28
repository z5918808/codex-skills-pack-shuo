---
name: layout
description: Use for /layout when hierarchy, grouping, alignment, density, rhythm, or responsive composition feels structurally weak.
---

# Layout

Use the spatial context from `impeccable`; this skill changes composition, not information ownership.

## Core Rule

Layout should reveal what belongs together, what matters first, and how the page adapts.

- Start with content priority and real ranges, not a preferred grid.
- Use proximity, alignment, scale, and whitespace before adding containers.
- Reuse the project spacing and layout tokens; add a token only for a repeated need.
- Choose Flexbox, Grid, container queries, or normal flow from the relationship being expressed.
- Match density to the task: dashboards, forms, reading, and marketing have different needs.
- Break symmetry only when it improves hierarchy and survives responsive reflow.
- Define overlay and sticky behavior with a small semantic layer model.

Do not ban cards, center alignment, margins, or arbitrary values without context; reject them only when they obscure grouping or create drift.

Verify squint hierarchy, long content, zoom, mobile reflow, keyboard order, touch, overflow, and representative data density.
