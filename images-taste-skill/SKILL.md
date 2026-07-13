---
name: image-taste-frontend
description: Use when frontend work needs image-led art direction, visual concepts, or a premium design reference before coding.
---

# Image Taste Frontend

## Outcome

Create an art-directed, image-led frontend reference that is distinctive, readable, and practical to implement. The reference image is a design specification, not mood art.

## Trigger Boundary

Use when visual taste, composition, or art direction is the main uncertainty: landing pages, heroes, marketing sites, portfolios, editorial pages, or premium redesigns.

Do not force this workflow for bug fixes, technical-only work, structural changes, or tasks with an exact supplied design system. When generation is unavailable, state that limitation and use the strongest available visual reference route.

## Workflow

1. Infer the site type, audience, primary CTA, section count, and hard constraints.
2. Choose one coherent art direction. Do not blend every attractive idea.
3. Use the `imagegen` skill to generate the reference image or image set before implementation when generation is available.
4. Inspect every generated image closely. Extract the visible design contract below.
5. Implement only after the contract is explicit. Treat the images as the primary visual source of truth.
6. Capture the implementation and compare it against the reference. Repair visible drift before polishing details.

Do not ask follow-up questions when a strong, safe interpretation is available.

## Image Count

- One section: one image.
- Two to four sections: one tall image.
- Five to eight sections: two tall images.
- Nine to twelve sections: three tall images.
- More sections: add one image per roughly four sections.

For multiple images, keep one palette, type logic, spacing system, CTA style, media treatment, and component language. Each image must continue the same site.

## Choose the Direction

Pick one option from each row, then commit:

| Axis | Options |
|---|---|
| Theme | pristine light, deep dark, bold solid, quiet neutral |
| Hero | cinematic minimal, asymmetric split, image-first, editorial offset, oversized type |
| Page rhythm | modular grid, editorial alternation, gallery cadence, poster stack, Swiss grid |
| Type | refined grotesk, expressive display, compressed statement, serif/sans editorial, rational Swiss |
| Material | solid field, ambient depth, full-bleed media, tactile paper, restrained glass or metal |

Choose at most four signature components and two motion cues. A signature element must support hierarchy or storytelling, not decorate empty space.

## Visible Design Contract

Extract and record:

- page and section order;
- hero focal point, H1 line count, CTA priority, and media role;
- grid, alignment, section spacing, and density;
- type scale, font character, line length, and reading order;
- palette, contrast, surfaces, borders, radius, and shadows;
- image crops, aspect ratios, frames, and repeated media modules;
- component families and interaction cues;
- mobile adaptation and any ambiguity the image leaves unresolved.

If this contract cannot be read from the image, regenerate or refine the reference before coding.

## Art-Direction Rules

- Give the hero one dominant focal point. Keep the H1 to one to three lines and supporting copy brief.
- Use imagery as structure: hero media, editorial crops, product visuals, galleries, or section transitions.
- Keep similar media in repeatable aspect-ratio frames with consistent crop and radius logic.
- Vary section rhythm through scale, alignment, density, and image-to-text ratio without breaking coherence.
- Use generous, controlled whitespace. Separate dense sections with calm ones.
- Keep one controlled palette with one or two accents.
- Make at least three deliberate, memorable choices in composition, typography, framing, or rhythm.
- Preserve accessibility, legibility, responsive behavior, and implementation clarity.

## Reject AI Slop

Reject the draft if it relies on:

- default purple/blue glow, blobs, or meaningless futuristic decoration;
- repeated card rows or cloned text-left/image-right sections;
- fake dashboard spam, excessive glass, pills, badges, or micro-details;
- long wrapped hero copy, weak hierarchy, or gradient text as a shortcut;
- stock-photo clichés, random thumbnails, or one hero image followed by a text-only page;
- dense walls of content or spacing that changes without a reason;
- generic claims such as “unleash,” “revolutionize,” “next-gen,” or “seamless.”

Creativity must increase clarity and identity. If it creates noise, remove it.

## Implementation Fidelity

Do not reinterpret a strong reference into a generic coded template. Preserve its layout tension, whitespace, type hierarchy, media balance, and section rhythm.

Resolve missing details in this order:

1. visible design language;
2. hierarchy and spacing;
3. component and media system;
4. responsive practicality;
5. the simplest choice that stays visually faithful.

## Verification

Before completion, verify:

- the hierarchy and primary CTA are obvious;
- the hero is clean and the H1 is not over-wrapped;
- imagery is structural, coherent, and sufficient across the page;
- the site has a memorable thesis without template-like repetition;
- spacing, palette, type, frames, and components remain consistent across images;
- a developer can infer the implementation from the reference;
- the coded result still belongs to the same design world;
- desktop and mobile screenshots preserve the reference’s core composition.
