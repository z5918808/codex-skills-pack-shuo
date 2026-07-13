# Codex Skills Pack：新手實用版

這是一套精選的通用 Codex skills。重點是讓新手能直接完成工作，不必先理解複雜 agent 架構。

繁中一句話清單：`使用說明.txt`

本 repo 只保留：

- 常見 coding、debug、review、research、writing 與 frontend 工作。
- 可重跑驗證、風險預檢、handoff 與狀態判斷。
- 不依賴私人帳號、特定公司、ERP、commerce 平台或本機固定路徑的流程。

不包含 Odoo、Shopify、私人 bridge、客戶流程、舊相容 alias、重複微技能與敏感 browser domain recipes。

## 新手先裝這 10 個

| Skill | 用途 |
|---|---|
| `go` | 從目前狀態繼續做下一個可驗證步驟 |
| `check` | 判斷什麼已完成、什麼只是 claim |
| `diagnose` | 用 evidence 找 bug root cause |
| `find-some-shit-to-do` | 不知道做什麼時，找出最值得做的一件事 |
| `step-back-and-think` | 避免一直補洞，重新找真正瓶頸 |
| `coding-standards` | 改善命名、邊界、錯誤處理與測試品質 |
| `security-review` | 做 evidence-based security review |
| `risk-preflight` | production、secret、bulk、destructive 前先預檢 |
| `handoff` | 把目前狀態交給下一個 agent |
| `skill-cleaner` | 檢查 skill descriptions、重複與索引成本 |

## 完整分類

### 執行與狀態

`go`、`smart-go`、`check`、`explain`、`resume`、`handoff`、`long-running-agent`、`prompt-for-goal`、`project-context-compactor`

### 找問題與做決策

`find-some-shit-to-do`、`step-back-and-think`、`diagnose`、`autoresearch`、`grill-me`、`repeat-review`、`ask-like-human-user-prompt`、`report-for-outsourcing`、`step-by-step-report`

### Coding 與 repo

`coding-standards`、`api-design`、`backend-patterns`、`frontend-patterns`、`complexity-optimizer`、`improve-codebase-architecture`、`e2e-testing`、`playwright`、`repo-bootstrap`、`repo-cleanup-judge`、`trim-repo-agents-md`

### Safety

`risk-preflight`、`agent-db-safety`、`security-review`、`windows-encoding-safety`

### Frontend 與設計

`frontend-design`、`design3steps`、`impeccable`、`shape`、`critique`、`audit`、`adapt`、`polish`、`images-taste-skill`

### 協作、研究與寫作

`bigbots-deploy`、`duo`、`article-writing`、`market-research`

## 安裝

建議先挑需要的 skill：

```powershell
Copy-Item -Recurse -Force .\diagnose "$env:USERPROFILE\.codex\skills\diagnose"
```

也可以整包同步：

```powershell
robocopy . "$env:USERPROFILE\.codex\skills" /E /XD .git /XF AGENTS.md README.md
```

`AGENTS.md` 是可選的新手預設，不會因複製 skills 自動安裝。需要時請自行審閱後放到合適 scope。

## 驗證

```powershell
node --experimental-strip-types .\skill-cleaner\scripts\validate-skill-index.ts --root .
node --experimental-strip-types --test .\skill-cleaner\scripts\validate-skill-index.test.ts
```

公開版完成條件：

- 每個 `SKILL.md` 有一個 `name` 與一個短 `description`。
- protected slash triggers 可見。
- 沒有私人絕對路徑、credential-like literals 或斷掉的相對引用。
- platform-specific workflow 不混進通用包。
