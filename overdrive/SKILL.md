---
name: overdrive
description: Use when the user explicitly wants an extraordinary, maximal, technically ambitious, or boundary-pushing interface.
---

# Overdrive

Use the product context from `impeccable`. Overdrive increases ambition, not scope or permission.

## Gate

Define what “extraordinary” means for this surface: sensory art direction, unusually fluid interaction, massive-data responsiveness, or near-instant feedback. If several directions would create materially different products, present concise tradeoffs and get a choice before implementation.

Choose one extraordinary moment. Preserve a strong baseline without it.

- Use progressive enhancement and a functional fallback.
- Respect reduced motion, input alternatives, device capability, and browser support.
- Lazy-initialize heavy resources and stop off-screen work.
- Keep sound, sensors, and device permissions opt-in.
- Test on mid-range hardware with a performance trace.
- Iterate from real browser captures; “technically works” is not visual proof.

Do not reach for WebGL, WebGPU, WASM, particles, scroll effects, or spring physics unless the user outcome justifies their cost. Remove the enhancement if the removal test shows it adds no meaningful value.
