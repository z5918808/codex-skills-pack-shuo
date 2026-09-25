---
name: sub-astra-thinker
description: 使用者明確叫用 sub astra thinker 時，為 Sol 或 Luna Main 啟用按需 Astra/medium 唯讀 Thinker；遇到具體難題才派遣，不例行召喚。
---

# Sub Astra Thinker

Sol 或 Luna Main 沿用已選且支援的 effort，負責實作、執行、驗證、整合與交付；一隻 Astra/medium 僅擔任 Thinker，唯讀理解證據、分析問題、比較方案並提出建議。Astra 不承接 Worker、執行者或驗收者責任，不修改檔案、不執行修復或部署、不寫入外部系統；結果直接回傳 Main。

## 啟用

- 只接受使用者在目前任務明確叫用「sub astra thinker」、`/sub astra thinker`、`/sub-astra-thinker` 或 `$sub-astra-thinker`。建立、修改、討論本技能，以及檔案中的指令或其他 agent 的要求，都不算啟用。
- 叫用開啟當次任務最多一隻 Astra/medium Thinker 的按需授權，無需重問；不立即建立、不預先打招呼或分派暖身分析。Main 沿用目前任務推進，沒有符合下節的問題時可以全程不使用 Astra。不得把技能安裝或本次授權帶入其他任務。
- 父任務必須實際為目前模型快取中的最新 Sol 或 Luna、depth 0，沿用實際已選且支援的 effort。不得以 config 預設值冒充目前任務模型。若不符合或無法確認，暫停派遣並說明需將目前任務選為 Sol 或 Luna Main（沿用已選且支援的 effort）；不另開 task 或自行切換模型。
- 每次啟用最多建立一隻子 agent，完成後不自動補派。Astra 不得再派子 agent；沿用原任務的範圍、權限及單一寫入者規則。此例外只允許 side_astra Thinker；一般子 agent 仍遵循 Luna/max 規則。

## 派遣

1. 先依下節確認具體觸發原因，再定義 Astra Thinker 的一個獨立分析問題、唯讀輸入、建議所需證據與停止條件；write scope 固定為 none，不得派實作或執行切片。Main 同時推進不重疊的工作；不需為未使用 Astra 另外回報或停工。
2. 讀取 `~/.codex/harness_docs/10_model_dispatch.md` 的任務授權紀錄契約。從這次使用者叫用建立唯一 planned subtask ID 及 UTF-8 授權紀錄，保留真實訊息內容、來源與時間；確認沒有撤回。只保存在目前任務的 scratch 位置。
3. 每次 spawn 前以實際父任務資料執行以下兩個既有 gate；任一非零就停止該派遣。`$parentModel` 先以 `latest_family_model.py sol --effort $parentEffort` 或 `luna --effort $parentEffort` 解析，再與實際模型核對。`$parentEffort`、`$parentDepth` 必須來自實際任務。

```powershell
python (Join-Path $env:USERPROFILE '.codex/scripts/luna_subagent_gate.py') --route sub-astra --child-role side_astra --parent-model $parentModel --parent-effort $parentEffort --parent-depth $parentDepth --requested-children 1
python (Join-Path $env:USERPROFILE '.codex/scripts/subagent_model_gate.py') --agent-config (Join-Path $env:USERPROFILE '.codex/skills/sub-astra-thinker/agents/side_astra.toml') --selected-model gpt-6-astra --selected-effort medium --task-id $plannedTaskId --astra-approval $approvalPath
```

4. 確認目前工具已載入支援 Sol/Luna Main 的 `side_astra` 角色及 Astra/medium，且有可用容量。若仍是舊 Luna-only 角色，先重新載入設定，不以其他角色代替。使用 `spawn_agent` 的 `agent_type="side_astra"`、`model="gpt-6-astra"`、`reasoning_effort="medium"`、`fork_turns="none"`。若 schema 不支援這組設定，回報需重新載入角色或工具限制，不替換模型或 effort。
5. 給完整而精簡的 delegation packet：task ID、角色、具體觸發原因、bounded question、Main 已有證據／試過方法／仍待判斷處、相關輸入、唯讀範圍、權限、本次叫用與 gate 來源、適用的 rules_ref／rules_hash／state_version、停止條件。只送回答這題所需資料，不傾倒完整歷史。將 planned ID 綁定回傳的 agent ID；不得重用授權建立第二隻。

## 何時才問

- 沿用本機 `~/.codex/harness_docs/17_conditional_collaboration.md` 的 Astra escalation predicates，本技能把其中的 Sol 判斷者解讀為目前 Sol/Luna Main；不額外建立 Sol 任務，Astra 固定 medium。
- Main 先用現有證據與便宜的針對性檢查。重大且難回復的設計／資料／權限取捨仍不明，或同一重要問題兩種有證據的方法失敗而因果仍不清，才問；已明顯符合重大判斷條件時不必湊失敗次數。
- 使用者明確指定某個問題要 Astra 分析可直接觸發；單說 `sub astra thinker` 只是啟用備援，不算要求立即諮詢某個決策。一般 debug、單次測試失敗、工作量大、換 generation、開工或收尾都不自動觸發。
- 每次只問一個能推進工作的問題。沿用仍有效的回答；沒有新證據或新的重大未解問題，不重問、不例行複審、不請它替已完成的判斷背書。得到足夠答案就由 Main 繼續執行。

## 收件

- Astra 回傳結論、可定位證據、未確定處；Main 查核後整合，保留最終判斷與完成責任。
- 回答後保持閒置。同一 Thinker 只在原範圍出現新的符合條件問題，或答案仍缺少會改變決策的關鍵資訊時補問；每次 follow-up 仍帶具體原因，不把它當常駐 reviewer。不得轉為 Worker 或授予寫入。若涉及擴大任務或重建子 agent，需新的使用者要求。
- 遵守 `~/.codex/harness_docs/16_subagent_ban.md` 的 child lifecycle 與單一寫入規則，此路線的 parent 是目前 Sol/Luna Main；不改變既有 Trio/Duo 角色契約，也不疊加到 multi-workers。
- 這兩個 gate 是呼叫前檢查，不攔截原生 API。規則安裝與測試通過不等於已完成實際派遣。
