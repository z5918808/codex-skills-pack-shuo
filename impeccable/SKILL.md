---
name: impeccable
description: Use for /impeccable when crafting, teaching, or extracting a distinctive frontend design system or premium UI.
---

# Impeccable

## Outcome

Create a functional interface with a clear visual thesis, strong product fit, and verified responsive detail. “Premium” means intentional and context-specific, not a fixed dark, glass, serif, or minimalist style.

## Modes

- Default or `craft`: design or improve an interface. Read `reference/craft.md` when the task needs its detailed flow.
- `teach`: establish durable project design context.
- `extract`: turn repeated local patterns into reusable tokens or components. Read `reference/extract.md`.

Do not load every reference. Use only the one needed for the current decision:

| Need | Reference |
|---|---|
| typography or font loading | `reference/typography.md` |
| palette or contrast | `reference/color-and-contrast.md` |
| layout, grid, or spacing | `reference/spatial-design.md` |
| motion | `reference/motion-design.md` |
| forms, focus, or feedback | `reference/interaction-design.md` |
| responsive adaptation | `reference/responsive-design.md` |
| labels, errors, empty states | `reference/ux-writing.md` |

## Context Gate

Before design work, establish:

- primary users and the decision or job they must complete;
- product and brand character;
- content, states, and information density;
- technical, accessibility, and existing design-system constraints;
- one visual thesis and one memorable device.

Read existing instructions, product docs, tokens, components, and brand assets first. Ask only for unknowns that materially change the design. When safe, state a reasonable assumption and continue instead of forcing a setup interview.

## Craft Workflow

1. Inspect the existing product and identify what must remain consistent.
2. State the user, job, tone, constraints, visual thesis, and anti-goals in a few lines.
3. Choose one coherent direction; do not average several styles into a safe result.
4. Define the visible system: type, color, spacing, layout, surfaces, media, states, and motion.
5. Implement the thinnest complete slice that proves the direction.
6. Render it in the real browser at representative desktop and mobile sizes.
7. Compare intent with the screenshot, repair hierarchy and interaction defects, then polish.

Use image-led art direction only when imagery is central; route that work through `image-taste-frontend` rather than duplicating its workflow.

## Design Judgment

### Typography

- Choose type from brand voice, content, language support, and loading constraints.
- Use few sizes with clear contrast and readable line length.
- Reject reflex choices only when they make the result generic; do not ban a font regardless of context.

### Color and Surfaces

- Derive light, dark, or mixed theme from use context.
- Use a controlled palette, accessible contrast, and scarce accents.
- Tint neutrals when it improves cohesion; pure black or white is not inherently wrong.
- Avoid gradient text, glow, glass, or shadow when they substitute for hierarchy.

### Layout and Density

- Build rhythm through grouping, alignment, scale, and varied spacing.
- Preserve the information density the user’s job requires.
- Use cards only for real grouped objects or actions; do not wrap every section.
- Break the grid only when the result remains readable and responsive.

### Interaction and Motion

- Use native semantics or tested accessible primitives.
- Motion should explain state, continuity, or hierarchy and respect reduced motion.
- Optimistic UI needs rollback and conflict behavior; it is not a visual default.
- Empty, loading, error, disabled, and success states are part of the design.

## Reject AI Defaults

Reject a design when it depends on repeated card rows, random pills, decorative charts, generic purple-blue glow, stock copy, excessive rounded containers, or one trendy font/color formula across unrelated projects.

The cure is not another universal ban. Return to the user, job, content, and visual thesis.

## Teach Mode

When explicitly invoked with `teach`:

1. inspect existing product, tokens, components, and brand material;
2. ask only the unanswered product and brand questions;
3. write or update `.impeccable.md` with users, jobs, brand character, aesthetic direction, constraints, anti-goals, and three to five design principles;
4. show the proposed context before treating it as durable truth when judgment is subjective.

Do not edit unrelated instruction files unless the user asks.

## Verification

Before completion, verify:

- the interface serves a named user and job;
- the visual thesis is visible without explanation;
- hierarchy, density, and states match the product context;
- existing tokens and components were reused or intentionally changed;
- keyboard, focus, contrast, reduced motion, zoom, and mobile reading order work;
- screenshots at real sizes match the intended direction;
- decoration does not outrank content or action.
