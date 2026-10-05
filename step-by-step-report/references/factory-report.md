## Required Content For Factory Reports

When explaining a product/content/data factory, cover the whole line:

1 → Raw input

- raw source, product id, crawl data, manager state, front state, existing artifacts

2 → Evidence packaging

- source refs, hashes, screenshots, binary proof, structured tables, current live state

3 → Deterministic hard gate

- schema, row width, source identity, stale generation, protected fields, live side effects

4 → AI semantic review

- title, description, common spec, model table, image identity, commercial language

5 → Target normalization

- AI output becomes structured target; AI never writes live and never marks done

6 → Replay / preview

- no-live preview, field diff, writer route, stable-field expectation

7 → Page pack compiler

- merge components into one product page pack

8 → Shadow owner

- same-generation quality check before live permission

9 → Live-ready queue

- only complete page packs enter; candidates and proposals do not count

10 → Live canary / batch

- explicit product ids, single writer, rollback, manager reload, front QA

11 → Final owner

- only final owner can mark production_ready

12 → Closeout

- counts, links, retractions, blockers, next queue

## Quality Gate Checklist

Mention these gates when relevant:

- source identity proof exists
- image proof uses actual binary / hash / dimensions
- image is not blurry, wrong product, wrong brand, or watermark polluted
- title is commercial Traditional Chinese, not literal bad translation
- brand display matches authority
- vendorChildId is safe or absent when not needed
- common spec is rendered HTML or empty, not JSON / dict / debug text
- model table headers and visible cell values are commercial Traditional Chinese
- table layout is not broken
- catalog is correct, cleared, or not applicable
- category is unchanged
- product is not counted done by HTTP 200 alone
- rollback exists
- same-generation owner passes
