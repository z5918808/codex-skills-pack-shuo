---
name: optimize
description: Use for /optimize when measured loading, interaction, rendering, network, memory, or runtime performance is inadequate.
---

# Optimize

## Core Rule

Measure the user-visible bottleneck on a fixed fixture, change the largest proven cause, then repeat the same measurement.

1. Define target users, devices, networks, flow, and success threshold.
2. Capture a baseline trace or metric and preserve raw evidence.
3. Classify the bottleneck: server, network, assets, JavaScript, rendering, layout, memory, or third party.
4. Make one bounded change with an expected mechanism.
5. Re-measure on the same basis and check correctness, accessibility, and visual regressions.

Prefer removing work over scheduling it better. Use framework-native image, code-splitting, caching, and server-data paths before custom machinery.

Do not blanket-add memoization, lazy loading, `will-change`, virtualization, prefetch, service workers, or concurrency. Each can make the wrong workload worse.

Report the baseline, change, result, variance, tradeoff, and whether the change is kept. A synthetic score alone is weak proof; use field data when the decision depends on real users.
