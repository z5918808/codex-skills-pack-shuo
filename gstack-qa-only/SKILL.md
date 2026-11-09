---
name: gstack-qa-only
description: 使用 gstack 的 report-only QA 方法檢查瀏覽器、API、CLI、背景工作或 webhook，交付可重現證據與缺陷報告；不修產品程式或測試。支援 Full、Quick 與 Regression。
metadata:
  upstream: garrytan/gstack
  upstream_ref: 74418edabc0ed566de97a7283e09543604de883c
---

# gstack QA Only（Codex 入口）

本技能安裝自 [garrytan/gstack qa-only](https://github.com/garrytan/gstack/blob/74418edabc0ed566de97a7283e09543604de883c/qa-only/SKILL.md)。原版文件與來源模板保留於 `upstream/`；此檔只處理名稱、路徑與 Codex 主機相容性，不代表已安裝完整 gstack 執行環境。

## 載入與路徑

先讀 [原版 qa-only 工作流程](upstream/qa-only/WORKFLOW.md)，依它的情境依序讀取所需章節，不啟動 `/qa` 修復流程。

上游路徑對應到本技能目錄：

- `qa-only`／`gstack-qa-only` 章節：`upstream/qa-only/sections/`。
- 共用 `qa`／`gstack-qa` 章節、參考、範本：`upstream/qa/sections/`、`upstream/qa/references/`、`upstream/qa/templates/`。
- `~/.claude/skills/gstack/qa-only/sections/preamble.md`：`upstream/qa-only/sections/preamble.md`。
- gstack `ETHOS.md`：`upstream/ETHOS.md`。

原版 `SKILL.md` 改以 `WORKFLOW.md` 儲存，內容不變，避免額外註冊 `/qa` 或 `/qa-only`。功能檢查不載入瀏覽器章節；報告章節仍在停止探測後才讀。

## 主機與執行條件

沿用使用者與專案的工具、授權、瀏覽器及 Outcome-first verification 契約。Windows 使用 PowerShell；上游 Bash 範例、Claude 工具名稱及 Aside 優先順序不覆蓋主機契約。使用實際可用的原生讀寫、提問與瀏覽器工具，不虛構同名工具已存在。

本安裝只包含技能與共用 QA 文件，未安裝 gstack 的 `bin/`、browse daemon、Bun、hooks 或遙測。使用時先核對所需 runtime 是否已實際可用；上游絕對 `bin/` 路徑不是存在證明。缺少必要 deadline／evidence／browser 工具時，依原版規則將受影響探測列為 blocked，繼續獨立且安全的檢查；不得用自行轉錄結果冒充原版證據工具已驗證。

缺少 `gstack-skill-start` 時沿原版 degraded mode：視為互動工作，不執行 onboarding／telemetry，也不推定使用者同意任何安裝。安裝本技能或引用上游文件均不授權啟動 setup、註冊 hooks、改全域設定、匯入 cookies、對外同步或發送遙測。

## 交付範圍

僅寫使用者允許的報告、證據及自有隔離 fixture。保留原版的 charter、成功與失敗重播、Full／Quick／Regression、證據連結、未驗證範圍及自有資源回收要求。產品程式、測試、依賴與部署維持不變；修復建議留在報告，不實作、不提交。
