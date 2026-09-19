---
name: frontend-art-direction
description: Set visual direction for new UI or substantial redesigns when product identity, composition, or interaction needs decisions.
---

# Frontend Art Direction

## Mission

Elevate frontend UI and interaction quality with art-direction thinking, high-quality references, visual hierarchy, motion taste, component craft, and real implementation. Think like an art director, then build like a product engineer.

This skill is not a document generator and not a generic component cookbook. Its purpose is to make the visible product more beautiful, premium, coherent, and interaction-polished. If the user gives only product requirements and asks to build a frontend from scratch, treat art direction as part of product definition instead of waiting for a separate "make it beautiful" request. If the user asks for development, deliver working UI, not only a brief or DESIGN.md.

## Operating Modes

- **Direct development mode**: Use by default when the user asks to build, redesign, beautify, polish, or improve UI. This includes building a new frontend from plain requirements. Do the art-direction thinking explicitly enough to guide the work, edit the product, run it when possible, and verify the visible result.
- **Direction-only mode**: Use when the user asks to discuss, plan, compare styles, or not edit code yet. Produce an art direction brief, reference analysis, or design options.
- **Direction checkpoint mode**: Use when agent judgment, the user's request, and available evidence show the visual direction is uncertain and expensive to undo. Present a compact direction lock or v0 preview and wait for user confirmation before full implementation.
- **Visual memory mode**: Use when the project will continue, the user asks for a design system, or the UI direction should persist. Create or update `DESIGN.md`, then continue implementation if development was requested.

## Scope Calibration

Use the full workflow for new screens, redesigns, direction changes, visually weak demos, or work that affects several components. Use direction checkpoints only when ambiguity plus cost-of-wrong-direction justify stopping; if the user gave a clear direction or asked the agent to decide, proceed with a short recorded assumption. Use a fast path for small polish tasks such as one control, one dialog, a local spacing/type/color issue, or a minor state fix.

Fast path:

1. Inspect the affected surface and existing component or token pattern.
2. Name the visible problem and the intended correction in one or two sentences.
3. Skip external reference search unless the local pattern is weak or the user asks for broader direction.
4. Make the smallest visible improvement that preserves the product's current visual language.
5. Verify the changed state on the real surface when possible.

## Core Workflow

1. Identify the user goal, primary workflow, audience, device, input method, content, and cost of choosing the wrong direction.
2. Inspect the affected surface and local visual system: existing components, tokens, themes, states, assets, and relevant project guidance. For a new surface, inspect enough of the app shell and stack to make an implementable decision.
3. Choose a clear direction from the available evidence. Use `references/requirement-evidence-workflow.md` or `references/design-read-and-dials.md` only when requirements or visual tradeoffs remain unclear.
4. Pause for a direction checkpoint only when uncertainty and rework cost are both high. If the user supplied a direction or asked Codex to decide, record the assumption briefly and continue. Use `references/direction-advisor-checkpoints.md` for an expensive or hard-to-reverse choice.
5. Search externally only when a specific gap cannot be resolved from local evidence. Inspect as many references as needed to answer that gap; there is no fixed count. Use `references/reference-ingestion.md` for substantial comparison work.

When the user provides detailed UI build prompts or asks whether prompt examples have reference value, use `references/high-fidelity-prompt-patterns.md` to extract implementation-grade prompt structure. When those prompts are media-led, cinematic, object/character-led, portfolio-editorial, or experiential landing pages, use `references/media-led-experiential-patterns.md`. Treat these as style-specific references, not default aesthetics.

6. Choose the visual medium, hierarchy, type, composition, states, motion, and responsive behavior that best serve the workflow. Use the focused reference for a decision only when needed, such as `references/visual-language.md`, `references/motion-spatial-language.md`, or `references/type-and-component-identity.md`.
7. Implement the working surface with existing project patterns and mature components where they fit. Improve shared primitives first only when they materially limit the requested result.
8. Verify the affected real surface and critical states with available browser, screenshot, emulator, device, or canvas tools. Fix visible defects before completion. Use `references/visual-quality-gates.md` only for a substantial final quality pass.

## Art-Direction Priorities

Prioritize these quality dimensions:

- **Product character**: The UI should have a clear identity: calm, precise, immersive, premium, warm, editorial, utilitarian, playful, cinematic, or another intentional character.
- **Requirement fit**: Layout, density, component choice, motion, visual medium, and typography should come from the user's workflow, surface type, device, content, and risk. Do not choose expressive styling before the requirement is understood.
- **Checkpoint discipline**: Pause for direction confirmation only when ambiguity or visual risk is high. Do not ask ritual questions for small, clear, local UI work.
- **Style anchor discipline**: For vague or new visual directions, use a concrete anchor with signature move, borrow, avoid, applicable scene, and misuse risk. Do not proceed from style labels like "clean modern premium."
- **Local evidence first**: Existing components, tokens, themes, routes, assets, and shipped screens are the first design system. Preserve, extend, or repair them before importing a new visual language.
- **Taste stance**: Choose a visible stance. Do not average references into "clean modern premium." The result should be clearly restrained, clearly expressive, kinetic, object-led, editorial, instrument-like, or consumer-characterful.
- **Design read and dials**: Read the scene before choosing a look. Let design variance, motion intensity, information density, and component distinctiveness come from the user's requirement, product workflow, references, and local evidence.
- **Type identity**: Font family, pairing, numeric treatment, and CJK/multilingual behavior should come from the scene and style anchor. Do not use one default font across every product category unless it is an intentional token-backed decision.
- **Component morphology**: Define a context-driven shape language for every major component family: navigation, controls, forms, tables, lists, panels, dialogs, media, charts, models, state feedback, and cards. Do not default every region to the same square or rounded rectangle.
- **Content/media readiness**: Before expressive styling, classify whether the project has placeholder content, real data/workflow, a strong product/data/media object, or high-quality editorial/model/animation media. Let readiness set the surface mode and expression budget.
- **Medium fit**: Choose static UI, photography, illustration, motion, 3D/model, or a hybrid because it best serves the scene. Do not default to screenshots, stock imagery, component animation, or 3D decoration when another medium communicates the product better. If high-quality material is unavailable, use restrained interface craft instead of pretending the surface is a cinematic hero.
- **Reference taste**: Use references to raise judgment. Borrow principles, not screenshots. A resource catalog entry is not enough by itself; translate it through the product's character and workflow.
- **Reference/component execution**: Substantial UI work must inspect actual reference pages or demos and use mature local or external components for common primitives. Do not hand-roll a component-less screen unless the task is tiny or the product requires custom primitives.
- **Proportion and composition**: Tune scale, density, spacing, rhythm, balance, focal areas, and one product-specific visual anchor before decorative styling.
- **Visual hierarchy**: Make the first read, primary action, secondary information, and detail layer obvious.
- **Color and material**: Use color roles, contrast, background/foreground depth, borders, shadow, imagery, material, motif, and texture as one visual system.
- **Typography**: Set readable type scale, weight, line height, numeric treatment, labels, and content tone from foundation references or project tokens. Use typographic contrast and rhythm to create character. Avoid oversized type as a substitute for design. In product tools, prefer dense, role-based type over hero-scale headings. Strong content or media can support a rare display moment, but it does not create the need for one; the surface must still require that scale.
- **Component craft**: Use mature components for consistency and behavior, then customize composition and styling to fit the art direction.
- **Interaction feel**: Make interactions fast, legible, restrained, and responsive to the device and input method. Motion, animation, and 3D should express state, continuity, product meaning, or spatial understanding.
- **Real content**: Design with realistic copy, data, media, states, and edge cases. Avoid placeholder-only beauty.

## Component Craft

Use existing project components, design tokens, and theme conventions first. Do not introduce a new component language unless the current one is clearly blocking quality. For substantial new UI, create a Component Adoption Plan before implementation; common primitives should come from the local system or mature components, not ad hoc divs and one-off styles.

For web surfaces, prefer appropriate mature primitives such as shadcn/ui, Radix, Tailwind, lucide icons, Motion, TanStack Table, Recharts, or the project's existing equivalents. Add dependencies only when they fit the stack and task. Use `references/frontend-resource-catalog.md` to choose concrete motion, component, and icon resources when the existing stack needs support. Never let a copy-paste component library determine the product's visual identity.

For mobile, Android, embedded, or car/head-unit UI, prefer platform components, existing app components, Material/Compose/XML theme tokens, and device-appropriate control sizing.

Good component use should produce complete states, accessible controls, coherent spacing, consistent icons, predictable behavior, and a recognizable component silhouette. Do not let a library's default look replace the product's art direction. For every major component family, ask what job it does, what input model it serves, what density it needs, what state cycle it has, and what motion or feedback makes it legible. Avoid a page where every section, feature, stat, form, and media area is the same component shape; choose panels, rows, rails, docks, canvases, media frames, tables, strips, drawers, sheets, timelines, charts, product objects, or cards only when those fit the workflow better.

## Interaction Quality

High-end interaction is not spectacle. It is clear, immediate, and well-paced state change.

In direct development mode, a polished UI should not be static. Implement at least one meaningful motion or transition layer unless the user, platform, or accessibility context rules it out. Minimum acceptable motion is stateful and visible: press/focus feedback, panel reveal, route or tab continuity, loading/empty transition, list filtering continuity, drag/selection feedback, media/voice state feedback, or success/error response. A color-only hover change is not enough for substantial UI work.

Check:

- Does every click, hover, focus, touch, drag, submit, and navigation have appropriate feedback?
- Are loading, empty, error, disabled, success, and partial-data states designed rather than incidental?
- Are transitions short and purposeful, generally using opacity, transform, or layout continuity rather than heavy effects?
- Are mobile, touch, remote, rotary, or car-display flows free from hover-only affordances?
- Does motion remain performant on the target device?
- Do microcopy and state labels sound like a real product rather than template filler?

When using component/motion resources such as transitions.dev, React Bits, Aceternity UI, HeroUI, or Spectrum UI, borrow both component structure and state behavior. Do not strip the motion away and leave a static clone.

## Cross-Device Translation

Keep the same art direction across devices, but translate layout, density, control size, interaction feedback, and motion according to:

- viewing distance
- input method
- attention level
- screen size and aspect ratio
- performance constraints
- task frequency and information density

Do not treat responsive design as shrinking. Reorganize hierarchy, navigation, and density for the canvas.

## DESIGN.md

Use `DESIGN.md` as project visual memory when it helps ongoing work. It is not the primary deliverable unless the user asks specifically for it.

Create or update it when:

- the project will keep evolving
- a new visual direction has been established
- styles are inconsistent across screens
- the user asks for a design system, visual language, or persistent UI guidance
- future agents or teammates need a stable art-direction source

If `DESIGN.md` conflicts with visible product quality, improve the UI and update the document afterward. Do not obey stale design notes blindly. See `references/design-md.md`.

## Verification

Before finishing UI development, verify the visible result where possible:

- Run the app or open the page.
- Check desktop and relevant mobile/device viewports.
- Inspect screenshots for hierarchy, spacing, overflow, contrast, alignment, visual coherence, and template-like or generic AI aesthetics.
- Verify the content/media readiness decision: the final expression should match the readiness level, surface mode, and expression budget.
- Inspect type scale specifically: no hero-sized heading, giant number, or marketing headline should dominate a compact product surface. For any display-size text, verify display need first, then locked typography reference, product context, and supporting content/media.
- Exercise interaction states, not only the default screen.
- Confirm at least one meaningful state transition or motion moment is implemented and visible, with reduced-motion behavior when appropriate.
- Check console/build errors and performance red flags.
- For existing UI, capture or inspect the before state and compare against the after state.
- For new UI, compare the implemented surface against the Art Direction Brief and the selected references.
- Do one self-iteration before final delivery when the first visible result has obvious composition, density, hierarchy, or taste problems.

If full verification is blocked, state the blocker and provide the closest completed evidence.

## Minimum Done Criteria

For UI development, do not finish with design intent only. A complete pass should usually include:

- a Requirement Frame, Local Evidence Scan, and Design Read for substantial work: surface type, workflow, density, local components/tokens/assets, weak primitives, context dials, and gaps to fill
- a brief reference or direction decision appropriate to the task size, backed by inspected evidence
- external references chosen to fill named gaps, not generic "beautiful UI" inspiration
- a Reference Website Pass for substantial work: inspected URL/demo/screenshot/file evidence and the exact decisions borrowed
- a Component Adoption Plan for substantial work: local/external components, states, motion source, icon source, and what was not hand-rolled
- a content/media readiness level, surface mode, and expression budget for substantial UI work
- an explicit medium decision for substantial UI: static, image/photo, illustration, motion/animation, 3D/model, or hybrid, with a reason tied to the product
- real code edits to the visible surface
- a desktop and target-device or target-viewport check when runnable
- at least one interaction or state check beyond the default screen
- at least one implemented stateful motion or transition layer for substantial UI work, unless explicitly inappropriate
- a typography scale check against foundation references or project tokens, especially for oversized headings and numbers
- a display-need and display-support check when large type is used: explain why the surface truly needs that scale, then name the content, image, animation, model, data object, or editorial material that makes it feel earned
- an evidence pack when the work is substantial: requirement frame, design read/context dials, local evidence used, references used, components/resources used, type identity, component context decisions, largest text role/size, viewport or screenshot check, motion trigger, and reduced-motion or fallback note
- one self-iteration when the first visible result has obvious hierarchy, spacing, text-fit, motion, generic-template, component-less, or reference-disconnected problems

When feedback says the result has no beauty, no coordination, poor interaction, poor visuals, no components, samey components, wrong font, no reference-site influence, or a one-font/square-block look, treat it as an execution failure, not a subjective disagreement. Re-run the Design Read, Reference Website Pass, Component Context Decisions, and Component Adoption Plan before continuing, replace weak freehand primitives with mature components or stronger local primitives, and verify where references/components/motion are visible in the rendered result.

## Feedback Loop

When the user says the result is ugly, generic, bland, lifeless, static, gimmicky, "食之无味", or the direction is wrong, treat it as art-direction calibration. Do not defend the previous aesthetic. Quickly identify whether the problem is taste stance, product character, reference choice, proportion, expressive composition, visual language, motion/spatial language, color/material, density, type scale, component language, or interaction feel, then revise or roll back the affected surface with a clear scope.
