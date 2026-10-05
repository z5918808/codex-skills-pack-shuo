## Facts To Promote Later

`/save` 可以記 1-3 條候選事實，但不負責升級。

可列入：

- 已驗證、未來同 thread 會重用的技術事實。
- 可能跨 thread 成立，但還需要 close-out 判斷的穩定規則。
- 新發現的驗證指令、入口、failure mode。

不可列入：

- 只是本輪流水帳。
- token、secret、cookie、customer data。
- 未驗證推測。
- 長篇架構說明。

升級去處：

- 同 thread 共用事實：由 `/close-out` 放到 thread facts / `_ctx/workstreams/<name>/FACTS.md`。
- 跨 thread 事實：由 `/close-out` 放到 repo spine。
