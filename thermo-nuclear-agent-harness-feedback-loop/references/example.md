## Example

問題：部署從 34 秒變成 3 分 22 秒。

Loop：

| Round | Hypothesis | Test | Result | Decision | Next Action |
| --- | --- | --- | --- | --- | --- |
| 1 | env var 污染 cache hash | 檢查 `turbo run build --dry-run` 與 `globalEnv` | 發現 `NEXT_PUBLIC_VERCEL_URL` 進入 `globalEnv` | 部分成立 | 移除或隔離該 env var 後重測 |
| 2 | 移除 env var 可恢復 cache hit | 重跑 dry-run 與 preview deployment | local hash 改善，但 cloud build 仍 miss cache | 部分成立 | 檢查 platform framework inference |
| 3 | Next.js framework inference 重新注入 env var | 檢查 Vercel build logs、env inspect、framework 設定 | build logs 顯示 deployment URL 仍影響 build input | 成立 | 調整設定並限制 build-time env |
| 4 | 修正後部署時間回復 | 重跑 preview deployment 並比較 cache hit / duration | cache hit 回復，部署回到 34 秒 | Fix 已驗證 | 記錄 Root Cause、Fix、Verification |

重點不是 Agent 一開始就知道答案，而是 Harness 讓它能查、能測、能比較、能排除錯誤 Hypothesis，最後收斂到被 evidence 支持的 Root Cause。

主線邊界：

- 這個結果可以支持「建議調整 deployment/cache 診斷主線」。
- 但除非使用者或 repo workflow 明確確認，不自動把專案主線改成 cache rewrite、platform migration 或大規模 refactor。
