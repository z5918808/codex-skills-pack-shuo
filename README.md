# Codex Skills Pack：通用技能包

一套以「能直接完成工作」為標準整理的 Codex skills 精選集。

目前收錄 **84 個通用 skills**，涵蓋工程、除錯、研究、安全、長任務協作、前端設計與內容工作。每個 skill 都是獨立目錄，可單獨安裝，不必一次載入整包。

> 適合：想快速建立可重複工作流的新手，以及重視證據、風險檢查、工作交接與長任務協作的進階使用者。

## 快速開始

```powershell
git clone https://github.com/z5918808/codex-skills-pack-shuo.git
Set-Location .\codex-skills-pack-shuo

$skillsRoot = Join-Path $env:USERPROFILE ".codex\skills"
New-Item -ItemType Directory -Force -Path $skillsRoot | Out-Null
Copy-Item -LiteralPath ".\diagnose" -Destination $skillsRoot -Recurse -Force
```

重新開啟 Codex task，直接在 prompt 點名：

```text
請使用 $diagnose，找出這個測試失敗的 root cause；先重現，再提出最小修復。
```

macOS、Linux、整包安裝、更新與移除方式請看 [新手使用指南](./docs/GETTING_STARTED.md)。

## 為什麼選這一包

- **結果優先**：skill 必須導向可觀察成果，不只提供抽象建議。
- **證據導向**：完成、進度與根因都需要可重跑的證據。
- **安全邊界**：production、database、secret、批次處理與破壞性操作都有明確限制。
- **方便移植**：不綁私人帳號、客戶資料、固定使用者路徑或私有執行環境。
- **按需載入**：需要哪個才讀哪個，避免一次載入整包內容。

## 新手推薦的 10 個

| Skill | 何時使用 |
|---|---|
| [`check`](./check/) | 判斷目前真的完成了什麼，以及下一個最小驗證步驟 |
| [`diagnose`](./diagnose/) | Bug、測試失敗或不穩定行為，需要找出根因 |
| [`explain`](./explain/) | 想把複雜狀態整理成短而清楚的說明 |
| [`step-back-and-think`](./step-back-and-think/) | 一直補洞、方向混亂或需要重新找主戰場 |
| [`repo-bootstrap`](./repo-bootstrap/) | 新 repo 要建立最小可用的 Codex 工作約定 |
| [`security-review`](./security-review/) | 以證據建立威脅模型並進行安全審查 |
| [`risk-preflight`](./risk-preflight/) | Production、secret、bulk、delete 或不可逆操作前 |
| [`handoff`](./handoff/) | 把可接續的狀態交給下一個 agent 或 task |
| [`duo-long-running`](./duo-long-running/) | Runner 執行長任務、Reviewer 只處理事件與技術救援 |
| [`question-eli10`](./question-eli10/) | 想用先結論、白話方式理解複雜問題 |

## Skill 目錄

### 執行、狀態與長任務

[`check`](./check/) ·
[`checkpoint`](./checkpoint/) ·
[`duo-long-running`](./duo-long-running/) ·
[`durable-authority-resume`](./durable-authority-resume/) ·
[`explain`](./explain/) ·
[`handoff`](./handoff/) ·
[`history-matters`](./history-matters/) ·
[`long-running-agent`](./long-running-agent/) ·
[`pause-and-reflect`](./pause-and-reflect/) ·
[`project-context-compactor`](./project-context-compactor/) ·
[`project-memory-gate`](./project-memory-gate/) ·
[`prompt-for-goal`](./prompt-for-goal/) ·
[`question-eli10`](./question-eli10/) ·
[`recenter`](./recenter/) ·
[`reconcile-project-state`](./reconcile-project-state/) ·
[`resume`](./resume/) ·
[`save`](./save/) ·
[`step-back-and-think`](./step-back-and-think/)

### 工程、架構與品質

[`agents.md-compact`](./agents.md-compact/) ·
[`api-design`](./api-design/) ·
[`backend-patterns`](./backend-patterns/) ·
[`codebase-design`](./codebase-design/) ·
[`complexity-optimizer`](./complexity-optimizer/) ·
[`diagnose`](./diagnose/) ·
[`domain-modeling`](./domain-modeling/) ·
[`e2e-testing`](./e2e-testing/) ·
[`eval-harness`](./eval-harness/) ·
[`factory-output`](./factory-output/) ·
[`frontend-patterns`](./frontend-patterns/) ·
[`improve-codebase-architecture`](./improve-codebase-architecture/) ·
[`repo-bootstrap`](./repo-bootstrap/) ·
[`repo-cleanup-judge`](./repo-cleanup-judge/) ·
[`serious-project-cleanup`](./serious-project-cleanup/) ·
[`skill-cleaner`](./skill-cleaner/) ·
[`system-instruction-craft`](./system-instruction-craft/) ·
[`tdd`](./tdd/) ·
[`trim-repo-agents-md`](./trim-repo-agents-md/) ·
[`windows-encoding-safety`](./windows-encoding-safety/)

### 研究、審查、協作與安全

[`agent-db-safety`](./agent-db-safety/) ·
[`ask-like-human-user-prompt`](./ask-like-human-user-prompt/) ·
[`audit`](./audit/) ·
[`autoresearch`](./autoresearch/) ·
[`bigbots-deploy`](./bigbots-deploy/) ·
[`find-some-shit-to-do`](./find-some-shit-to-do/) ·
[`grilling`](./grilling/) ·
[`market-research`](./market-research/) ·
[`report-for-outsourcing`](./report-for-outsourcing/) ·
[`research`](./research/) ·
[`risk-preflight`](./risk-preflight/) ·
[`security-review`](./security-review/) ·
[`self-reflect`](./self-reflect/) ·
[`streaming-dag-execution`](./streaming-dag-execution/) ·
[`super-report`](./super-report/)

### 前端、UX 與視覺設計

[`adapt`](./adapt/) ·
[`animate`](./animate/) ·
[`bolder`](./bolder/) ·
[`clarify`](./clarify/) ·
[`colorize`](./colorize/) ·
[`critique`](./critique/) ·
[`delight`](./delight/) ·
[`design-audit`](./design-audit/) ·
[`design3steps`](./design3steps/) ·
[`distill`](./distill/) ·
[`frontend-art-direction`](./frontend-art-direction/) ·
[`frontend-design`](./frontend-design/) ·
[`image-taste-frontend`](./image-taste-frontend/) ·
[`impeccable`](./impeccable/) ·
[`layout`](./layout/) ·
[`optimize`](./optimize/) ·
[`overdrive`](./overdrive/) ·
[`playwright`](./playwright/) ·
[`polish`](./polish/) ·
[`prototype`](./prototype/) ·
[`quieter`](./quieter/) ·
[`shape`](./shape/) ·
[`typeset`](./typeset/)

### 寫作、簡報與商業內容

[`ai-layer-first`](./ai-layer-first/) ·
[`article-writing`](./article-writing/) ·
[`content-engine`](./content-engine/) ·
[`frontend-slides`](./frontend-slides/) ·
[`investor-materials`](./investor-materials/) ·
[`investor-outreach`](./investor-outreach/) ·
[`step-by-step-report`](./step-by-step-report/) ·
[`writing-great-skills`](./writing-great-skills/)

## 收錄原則

本 repo 僅收錄可公開、方便移植、可獨立理解的通用工作流程。每個 skill 都必須能獨立使用，並通過結構、連結與敏感資訊掃描。

## 安全與權限

Skill 是工作規則，不是額外權限。它不會替你取得 production、database、GitHub 或其他外部系統的授權。

在執行寫入、上傳、刪除、批次處理或 production 操作前，仍應確認：

1. 目標與影響範圍。
2. 預覽或 dry-run。
3. 回復方法。
4. 當次明確授權。

## 驗證

從 repo root 執行：

```powershell
node --experimental-strip-types .\skill-cleaner\scripts\validate-skill-index.ts --root .
node --experimental-strip-types --test .\skill-cleaner\scripts\validate-skill-index.test.ts
```

公開版的基本完成條件：

- 每個 skill 目錄都有可解析的 `SKILL.md`。
- Frontmatter 含單一 `name` 與 `description`。
- README 列出的 skill 與實際目錄一致。
- 沒有疑似憑證字串、私人絕對路徑或失效的相對引用。
- UTF-8 中文內容可正確讀取。

## Repository 結構

```text
.
├── <skill-name>/
│   ├── SKILL.md
│   ├── agents/          # 選用
│   ├── references/      # 選用
│   └── scripts/         # 選用
├── docs/
│   └── GETTING_STARTED.md
├── AGENTS.md            # 選用的起始規則
└── README.md
```

`AGENTS.md` 是給新 repo 參考的最小預設，不會因安裝 skills 自動生效。請先審閱，再放到合適的專案範圍；不要直接覆蓋既有規則。

## 更新策略

這個 repository 是經過公開化審查的版本快照，不是使用者本機 skills 目錄的無條件鏡像。更新時會先同步候選版本，再依公開性、可攜性、通用性與重複性審查，最後才通過驗證。

各 skill 內原有的 `LICENSE` 或來源標示會隨目錄保留。整個 repository 的授權方式，請以根目錄實際提供的授權檔為準。
