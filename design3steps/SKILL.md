---
name: design3steps
description: "Use when UI, landing page, section, or visual refresh work needs a conservative anti-slop baseline before getting fancy. Use for the simple 3-step design workflow: define one visual thesis first, lock the page or section skeleton second, and refine typography, color, material, and motion third. Prefer this when the user wants a safe default design process rather than the full Impeccable command system."
---

# Design3steps

## Overview

Use this as the basic house style workflow when you want a clean, dependable design path without invoking the whole Impeccable command family.

This skill is deliberately conservative:

1. decide the point of view
2. lock the structure
3. refine the finish

If the work needs deeper diagnosis or command-level routing, switch to `impeccable-design-workflow`.

## Hard Rules

1. Start with a one-line visual thesis before writing or revising UI code.
2. Sample at least 3 relevant reference systems before locking direction.
3. Treat `impeccable.style` as an anti-pattern reference, not as the target aesthetic.
4. Give each section one job only.
5. Do not jump to detailed polish before the layout skeleton is stable.
6. Use this skill as the default baseline. Escalate to `impeccable-design-workflow` only when the command choice is non-obvious or the problem is already diagnostic.

## The 3 Steps

### Step 1: Visual Thesis

Write one sentence that answers:

- what this should feel like
- what it should not feel like
- what the first-screen impression should be

Good example:

```text
像一本冷靜但昂貴的產品型錄，不像 SaaS dashboard，也不要卡片牆。
```

Output for this step:

- one-line visual thesis
- 2-3 reference systems
- 1 anti-reference

### Step 2: Skeleton

Turn the thesis into a simple structure before styling.

For landing or marketing work, default to:

1. hero
2. support
3. detail
4. final CTA

For product or app work, default to:

1. primary workspace
2. navigation
3. secondary context
4. clear action/state layer

Rules:

- each section gets one job
- avoid card walls by default
- remove repeated promises
- make the first screen readable in one glance

Output for this step:

- section list
- one job per section
- dominant visual idea per section

### Step 3: Finish

Only after the skeleton is right, refine:

- typography
- color
- material / texture
- motion

Ask:

- does the type hierarchy read fast
- does the palette have intent
- do the materials add atmosphere instead of clutter
- does motion help hierarchy instead of showing off

Output for this step:

- type direction
- color direction
- material direction
- motion direction

## Escalate to Impeccable Workflow When

Switch to `impeccable-design-workflow` if any of these are true:

- you are not sure whether to use `/shape`, `/critique`, `/audit`, or a surgical Impeccable command
- the UI already exists and the failure mode is unclear
- the user wants the full Impeccable command family
- the user explicitly asks for `impeccable`

## Quick Use Cases

### New page

```text
Use design3steps.
先幫我定一句 visual thesis，再排骨架，最後才補字體跟色彩。
```

### Safe de-slop pass

```text
Use design3steps.
我想先用保守基本招式把這頁從 AI 味拉回來。
```

## Failure Modes

- starting from colors or motion before the thesis exists
- trying to rescue a weak skeleton with polish
- using too many references and losing the point of view
- copying `impeccable.style` like a style preset
