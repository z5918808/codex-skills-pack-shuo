---
name: how-to-use-impeccable-for-design
description: "Use when the user wants the current agent to propose how to use Impeccable for a UI task, recommend a direction, and present 3 distinct frontend design concepts before coding. Trigger on requests for design direction, visual options, concept exploration, layout/style alternatives, or deciding which Impeccable flow should be used for a landing page, app shell, component, or visual refresh."
---

# How To Use Impeccable For Design

## Overview

Use this skill when the user wants direction first and code second.

This skill turns a vague or partial UI brief into:

1. one recommended Impeccable path
2. three clearly different frontend design options
3. one concrete recommendation for what to build next

It is a pre-build design skill. Its main job is to help the current agent think with intent instead of blurting out a generic card grid.

## Hard Rules

1. Check the project `DESIGN.md` first. If missing, fall back to the global design template.
2. Inspect the current product, page, or code context before proposing directions.
3. Give exactly 3 options unless the user explicitly asks for a different number.
4. Make the options materially different in structure, tone, and visual system. Do not give 3 near-clones.
5. Name one recommended option and explain why it fits best.
6. If context is incomplete, make reasonable assumptions and label them briefly instead of stopping the flow.
7. Do not spawn subagents unless the user explicitly asks for parallel agents or delegation.
8. Do not jump into implementation unless the user asks for code or clearly wants the chosen option built immediately.

## Workflow

### 1. Read the situation

Collect only the minimum truth needed:

- what the screen or feature is for
- who it is for
- what action matters most
- whether there is an existing UI or brand to respect
- whether the user wants exploration only, or exploration plus build

If the repo already contains enough context, infer the rest and move.

### 2. Choose the Impeccable path

Pick the most appropriate path and say it plainly.

Use:

- `impeccable teach` when design context is missing
- `shape` when the feature is new and the brief is still fuzzy
- `impeccable craft` when the direction is already clear and the user wants to build
- `critique` when the UI exists but feels wrong
- `audit` when the user needs structured issue-finding before changes
- `design3steps` when the safest anti-slop baseline is enough
- `impeccable-design-workflow` when command choice itself is the problem

If more than one applies, recommend a short sequence, not a kitchen sink pile.

### 3. Produce 3 design options

For each option, provide:

- a short name
- a one-line visual thesis
- the layout idea
- the type direction
- the color/material direction
- the motion direction
- why this option fits the brief
- one risk or tradeoff

The 3 options should feel like different bets. Good axes of variation:

- editorial vs product-like
- dense vs spacious
- restrained vs expressive
- image-led vs typography-led
- architectural grid vs asymmetric composition

### 4. Recommend one option

After the 3 options, choose one.

Explain:

- why it is the best fit for the brief
- what it avoids that the weaker options do not
- which Impeccable command should be used next if the user wants to build it

### 5. End with the next move

Close with one concrete next move for the current agent.

Examples:

- "Pick option 2 and I will build it with `impeccable craft`."
- "We should run `shape` first because the product goal is still mush."
- "The page already exists, so `critique` first, then build from the winning direction."

## Output Shape

Keep the answer compact and decision-friendly.

Default structure:

1. Current direction
2. Recommended Impeccable path
3. Three design options
4. Recommended option
5. Next move

## Good Option Patterns

Use patterns like these when forming the 3 options:

- **Editorial premium**: strong typography, clear pacing, fewer boxes, more negative space
- **Product clarity**: explicit hierarchy, modular layout, tighter interaction affordances
- **Atmospheric brand**: color, texture, and motion carry more emotional weight without killing usability
- **Utility minimal**: quiet, fast, stripped down, strong information density
- **Expressive launch**: more dramatic hero, higher contrast, stronger motion, sharper personality

## Failure Modes

- giving 3 options that are basically the same page in different colors
- recommending `/polish` before the structure exists
- ignoring existing brand or product constraints
- asking too many clarifying questions when the repo already tells the story
- confusing "direction" with implementation details

## Example Prompts

```text
Use $how-to-use-impeccable-for-design.
Give me a direction and 3 frontend design options for this landing page before we write code.
```

```text
Use $how-to-use-impeccable-for-design.
Look at this existing dashboard and tell me which Impeccable path we should use, then show 3 redesign directions.
```

```text
Use $how-to-use-impeccable-for-design.
I want one recommended design route plus a few distinct visual concepts for this feature.
```
