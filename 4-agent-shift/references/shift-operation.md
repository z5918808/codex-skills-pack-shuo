# 班次操作

真正派遣或設定有期限班次時讀取。維護技能不產生派遣授權紀錄、不 spawn、不建立排程。

## 角色安裝

完整安裝 `4-agent-shift` 目錄到所在環境的 skills 根目錄。隨包的 [角色設定](../agents/four_agent_shift_sol.toml) 只定義模型與角色邊界，還要在支援自訂代理的主機設定中登記。

使用預設 skills 安裝位置時，在 Codex 使用者設定加入以下單一區段；既有區段先核對，不重複追加，不覆寫其他設定：

```toml
[agents.four_agent_shift_sol]
description = "Sol 6.1/medium child for Nox census, Tally planning, Rivet scoped execution, or Tock read-only acceptance. No child delegation."
config_file = "skills/4-agent-shift/agents/four_agent_shift_sol.toml"
```

非預設安裝位置須調整 profile 路徑。重新載入主機設定後，從實際派遣 schema 確認角色、模型、effort 與容量。只複製目錄不等於已啟用子代理；主機若禁止 Sol root／四角色分批派遣，按該主機的正式授權入口處理，不能從其他技能借例外。此技能不依賴作者私人腳本，也不提供雲端執行服務；主機規定的 gates 仍需由主機提供。

## 派遣前置

1. 確認是 root，使用者已明確要求本團隊處理具體任務且未撤回。Main 不換模型。從主機模型清單與派遣工具核對 `gpt-6.1-sol` / `medium`。主機若要求最新家族模型而與此設定衝突，停止派遣並列出衝突，不能自行升版或繞過 gate。
2. 在**當前工具 schema** 確認已載入 `four_agent_shift_sol`，固定模型 `gpt-6.1-sol`、effort `medium`。磁碟 config 不證明 session 已載入。缺角色時請使用者在載入新設定的聊天叫用；不發探測 child、不借用其他限定角色或 model override 掩蓋不相容。
3. 核對容量與既有 child，最多兩位執行中。idle、timeout 或缺回覆不等於 writer 終止；確認終止及 side effects 後再換 writer。只清理本班擁有且已確認過期的 process。
4. 四位各有唯一 planned child task ID。依主機已有的模型與派遣授權契約，綁定實際**執行叫用**的訊息；需要紀錄時存 repo 外受控工作目錄。建立技能的訊息不算執行授權。

紀錄格式沿主機契約，至少能追到唯一 task ID、原始叫用來源、所選模型、effort、範圍及時間。只從真實訊息填寫，不複製範例或捏造同意，每次派遣前核對未撤回。

每次 spawn **之前**跑主機要求的模型、父任務與授權 gates。必要 gate 缺少、非零或授權路由不允許這個 root 使用四位 Sol child 時，停止該派遣，回報具體規則與缺口，繼續獨立授權工作。不修改父任務規則或關閉安全控制；安裝設定不會自行建立派遣例外。gate PASS 只驗傳入事實，不證明訊息真實性、runtime 攔截或 child 已使用模型。

通過後使用 `collaboration.spawn_agent`：`agent_type="four_agent_shift_sol"`、`model="gpt-6.1-sol"`、`reasoning_effort="medium"`、`fork_turns="none"`。回傳後綁定 planned ID 與 actual child ID，查核 role/model/effort 收據；工具未揭露欄位標 `unverified`，不填預期值。設定不符停止該 child 的依賴工作。

## 任務包與進度

每包含 `task_id / role / scope / permissions / rules_ref / rules_hash / state_version / next_action`，加原始需求、必要 inputs、read/write resources、驗收證據、依賴與停止條件。rules 釘同一 immutable SHA，指向適用 AGENTS.md 的驗收規則與本技能；主機有 Outcome-first verification 時一併引用。沿用已有 version，簡單任務可用 `state_version=not_applicable`，不新造 canonical state。

Nox、Tally、Tock 明列 `write_scope=none`。Rivet 只取已核對 exact write scope。四者不得派遣或建立聊天；向 Main 回報。少傳必要原始證據，不複製帳密、私人資料或長篇聊天；Tock 從原始需求及產物判斷，不以其他角色結論自證。

Main 維護一份精簡工作清單：owner、狀態、證據、blocker／下一步。依實際結果轉為 `planned → running → ready_for_review → verified`，或 `blocked / decision_required / human_only`；deadline 到標 `unfinished`。需要可恢復班次或 repo 指定時才保存 durable ledger，沿既有位置與單一 writer。

等待使用 mailbox 與有界 wait，不忙輪詢、不做無關清查。Main 持續工作時至少每 60 秒提供一次有意義進度。失聯先對帳 child 與 writer，不盲重派可能已提交的動作。

## 夜班與排程

有期限班次記 `start_at / stop_at / timezone / owner / objective / stop_condition`，用 client 時區。開始時間到且執行環境可持續運作才執行；開始已過但尚未停止時，只處理剩餘時間，不冒充完整八小時。

到期、目標達成或使用者叫停時停止新工作，對帳已提交動作與 writer，完成必要 teardown。gate 或容量不足阻擋其依賴工作，不影響獨立授權工作。工作已完成就收班，不為填滿八小時掃無關系統。

定時、週期或稍後續跑沿主機已提供的排程工具與其契約；Codex 有 `automation_update` 時使用它。只在使用者要求時建立，不另搭 scheduler、不假稱 native child 是 cloud agent。沒有可持續執行的主機或必要工具時，明示依賴。無人值守仍受主機模型與角色限制；若規則只允許 Sol Main/Reviewer，不能將 Nox/Tally/Rivet 改名假扮合格角色。缺相容授權契約就阻擋排程派遣，保留可審查設定，不宣稱夜班可自動運作。手動有界班次仍可依原授權執行。

外送通知須有授權；heartbeat 狀態未變或無可處理事項保持安靜，完成、失敗、重要改變或必要人工動作才通知。

## 完成查核

Main 查核四個 actual child、scope、rules hash、讀回與相關驗收，確認已無未記錄的本班背景 process。保留 dirty worktree；不自動 branch、worktree、stage、commit、push、merge、發布或清理他人檔案。依既有授權執行已要求操作，不另加批准關卡。

晨間報告計數只取 verified 唯一工作項，附必要證據與具體待決動作。估計工時或金額揭露基準，無基準省略。列未派、未完成、未驗證角色與原因；Main 親自完成不能算已派出的 child。
