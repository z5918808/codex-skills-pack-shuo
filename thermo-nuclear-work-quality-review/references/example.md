## Example

輸入：一個長跑 agent 專案有 5 個 status docs、3 個 handoff、2 個 dashboard、1 個 AGENTS 規則、1 個 worker closeout，但每次接手仍要讀整條聊天才知道能不能繼續。

審查結果：

- P1: source of truth 洩漏。status docs 與 dashboard 都宣稱 current state，但沒有單一 checkpoint command。建議保留一個 `current_state` report，其他改成 archive/provenance。
- P1: closeout claim 被當 truth。worker closeout 沒有 independent verifier。建議完成定義改成 closeout + verifier + artifact evidence。
- P2: handoff 過大。handoff 包含歷史敘事、下一步、規則、debug route。建議拆成 `INDEX`、`CURRENT`、`MANIFEST`，並刪除重複段落。
- P2: wrapper 過多。dashboard 只是重包裝 status docs，沒有降低決策成本。建議停止更新 dashboard，直到有明確 decision gate。

不是新增第 6 個狀態檔，而是刪到只剩一個可刷新狀態入口、一個 provenance index、一個 verifier。
