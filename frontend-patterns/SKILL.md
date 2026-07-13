---
name: frontend-patterns
description: Use when frontend work needs component boundaries, state ownership, data flow, accessibility, or performance decisions.
---

# Frontend Patterns

## Core Rule

Choose the owner of each state before choosing a library or pattern. Most frontend complexity comes from storing the same truth in multiple places.

## Classify State

| State kind | Default owner |
|---|---|
| Shareable navigation state | URL and router |
| Remote data and mutation status | Server-state cache |
| Unsaved form input | Form boundary |
| Ephemeral interaction | Nearest component |
| Cross-tree app policy | Narrow context or store |
| Value computable from other state | Derive during render |

Do not copy props, URL values, or query results into local state without a synchronization reason and a conflict policy.

## Component Boundaries

Split a component when a part has its own behavior, accessibility contract, data boundary, or independent reason to change. Keep it together when splitting would only create prop plumbing and names.

- Prefer composition and explicit props over configurable “god components.”
- Keep page composition separate from reusable interaction primitives.
- Put data access behind a small query or mutation function, not behind a ceremonial layer per component.
- Use stable domain identifiers as keys. Never use array position when items can reorder.
- Preserve the project’s established framework and component patterns unless evidence shows they fail.

## Server Data

- Use the framework’s server-data path or an established query cache before inventing a custom fetch hook.
- Build query keys from normalized URL or domain inputs.
- Cancel or ignore stale requests so late responses cannot overwrite newer intent.
- Define loading, empty, error, partial, stale, and success states explicitly.
- For optimistic mutations, specify rollback, duplicate-click behavior, and every cache view that must reconcile.
- Treat pagination, filtering, and sorting as one contract; changing filters usually resets the page.
- Prefetch only likely next actions and verify the bandwidth and memory cost.

## Forms and Mutations

- Keep draft input local to the form until submission unless live sharing is required.
- Validate for usability on the client and for authority on the server.
- Disable or deduplicate repeated submission when the operation is not naturally idempotent.
- Preserve entered data on recoverable failure and attach errors to the relevant control.
- Decide how navigation, refresh, and retry affect the draft before implementation.

## Accessibility

- Start with native elements and platform semantics.
- Prefer tested accessible primitives for dialogs, menus, comboboxes, tabs, and popovers; short ARIA snippets rarely implement the full interaction model.
- Every interactive path must work by keyboard with visible focus.
- A dialog needs a name, focus containment, Escape behavior, background isolation, and focus restoration.
- Announce meaningful async changes without making every update noisy.
- Respect reduced motion, contrast, zoom, touch targets, and responsive reading order.

## Performance

Measure before optimizing. Identify whether the cost is network, JavaScript, rendering, layout, images, or interaction latency.

- Avoid effects for values that can be derived during render.
- Add memoization only when profiling identifies repeated expensive work or referential churn.
- Do not mutate props or cached data while sorting or transforming.
- Virtualize only large measured lists; preserve keyboard navigation and screen-reader usability.
- Lazy-load genuinely heavy, non-critical code and provide a stable fallback.
- Keep urgent input responsive; defer or transition expensive result updates when the framework supports it.

## Reject These Defaults

- one global store for server, URL, form, and modal state;
- custom data-fetch hooks that recreate caching, cancellation, retry, and race handling poorly;
- `useEffect` synchronization between duplicate sources of truth;
- blanket `useMemo`, `useCallback`, or `React.memo` without profiling;
- hand-rolled dialogs or comboboxes with incomplete focus and ARIA behavior;
- index keys, mutable sorting, or optimistic updates without rollback;
- accessibility and mobile checks postponed until final polish.

## Verification

Cover the state and interaction graph:

- deep link, refresh, back, forward, and invalid URL input;
- rapid typing, filter changes, request races, and offline or error states;
- optimistic success, rollback, repeated clicks, and cross-view cache consistency;
- keyboard-only flow, focus restoration, screen-reader naming, zoom, and reduced motion;
- mobile layout and reading order;
- profiler or performance trace before and after any optimization.

Finish only when each state has one owner, each async path has a stale-result policy, and each interactive primitive has a verified accessibility contract.
