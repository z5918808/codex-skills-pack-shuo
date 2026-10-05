## Harness Checklist

### Local Harness

- 檢查 repo 結構，找出實際入口、package、workspace、apps、packages、scripts。
- 檢查 package manager 與 lockfile，例如 npm / pnpm / yarn / bun 與對應 lockfile。
- 讀取相關 config，例如 `package.json`、`turbo.json`、`next.config.*`、Dockerfile、CI config、Vercel config、TS config。
- 檢查 env var 來源與差異；只讀必要資訊，避免輸出 secret。
- 找出 build / test / lint / typecheck / dev / deploy 相關指令。
- 找出 dry-run 或 inspect 指令，例如 `turbo run build --dry-run`、framework-specific inspect、CI dry-run。
- 檢查 `git status` 與 `git diff`，避免覆蓋無關變更。
- 檢查 log / cache / artifact / trace / coverage / bundle output。
- 建立最小重現步驟，讓每輪測試可重跑、可比較。

### Cloud Harness

- 取得 deployment logs。
- 取得 build logs。
- 使用 env pull / env inspect 比對遠端環境設定。
- 建立或讀取 preview deployment。
- 取得 cache hit / miss、build cache key、artifact restore/save 資訊。
- 使用 platform-specific inspect command，例如 Vercel / GitHub Actions / Docker / cloud provider CLI。
- 檢查 remote config / secret / runtime / region / framework inference / build image 設定。
- 檢查 error monitoring、metrics、trace、latency、resource usage。

### Observability

- Agent 必須能看到真實輸出，而不是靠猜。
- 每個 Hypothesis 都要對應一個可驗證指令或觀測來源。
- 每次 Test 都要留下 Result 摘要，包含關鍵輸出與判讀。
- 不允許把「看起來應該是」當成結論。
- 若輸出彼此矛盾，先處理矛盾，再繼續修正。
- 若觀測成本太高，先設計更小的替代觀測，不要跳到大範圍修改。
