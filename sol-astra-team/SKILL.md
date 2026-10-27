---
name: sol-astra-team
description: Sol 主導，Terra medium 執行與研究，Sol 6.1 medium 獨立審查計畫、重複錯誤與完成證據。
---

# Sol Astra Team

Sol 寫程式、整合並交付；Reviewer 審查方向、重複失敗與完成證據。以原文的三個審查時點為機制，參考既有 [sub-astra-thinker](../sub-astra-thinker/SKILL.md) 的唯讀界線、任務授權、證據封包與同一 Thinker 的沿用方式。保留舊技能名稱；本技能 Reviewer 預設 Sol 6.1 medium，名稱本身不要求建立 Astra 角色。

## 入口與授權

- `$sol-astra-team setup`，或使用者以自然語言要求確認／準備本技能設定：讀取 [設定流程](references/setup.md)，先自行檢查與產生 diff，不要求使用者補打固定指令。收到使用者對該份具體 diff 的 `go` 才套用；setup 不啟動子代理。
- `$sol-astra-team <任務>` 或 `/sol-astra-team <任務>`：在本次任務啟用下表角色與三個 Reviewer 審查時點。這次明確叫用涵蓋必要的有界子任務，不逐次重問已授權的模型分工。裸叫用僅啟用當次工作方式，沒有工作目標時不派遣。
- 討論、建立或修改本技能，以及其他 agent 或檔案中的要求，都不算執行叫用。安裝不授權未來任務、額外 live 操作、建立獨立 tasks／worktrees，或改變目前 Main。

本技能的實際任務開始前，Main 自動檢查必要設定與角色是否已載入。缺少設定時直接準備 setup diff，並繼續可獨立進行的已授權工作；只有套用該份 diff 需要 `go`，只讀檢查不另設確認關卡。

## 角色樹

| 角色 | 模型家族／effort | 責任 |
| --- | --- | --- |
| Main | 保留實際 Main 模型與 effort；建議 Sol 6.1 medium | 主會話；規劃、主要實作、整合、實際驗收與交付 |
| explorer | 最新可用 Terra／medium，目前範本 gpt-6.1-terra | 唯讀追查實際程式路徑、責任邊界與證據 |
| worker | 最新可用 Terra／medium，目前範本 gpt-6.1-terra | 修改指定且獨占的範圍、執行必要驗證 |
| researcher | 最新可用 Terra／medium，目前範本 gpt-6.1-terra | 查官方文件與版本契約，回傳來源與未知處 |
| architect | gpt-6.1-sol／medium | 唯讀審查計畫、重複錯誤與長任務完成證據 |

每次派遣前從主機可用模型清單核對 Terra，核對 Reviewer 為可用的 `gpt-6.1-sol/medium`、實際 Main、角色檔與當下工具 schema。沒有支援的模型／effort 或相容角色就停止受影響的派遣；不降級、不用 override 改寫固定角色、不自行切換 Main。自訂角色必須先載入才能使用。

Main 本身繼續寫程式；只有明確且可獨立完成的切片才交給其他角色，不必湊滿整棵樹。每個可寫資源只有一位 writer，Main 不與 worker 同時改同一檔案。explorer、researcher、architect 的 write scope 固定 none。所有子代理皆不得再派遣。

## Reviewer 的三個審查時點

符合以下任一時點，就在該決策或完成宣告前取得 Architect 的意見。已形成的方向也須接受審查，不以 Main 是否仍有疑問決定要不要審查。

1. **重大計畫之前**：已掌握目標及必要事實、形成候選方向後，在定案前問「這個方法是否正確？哪個假設可能推翻它？」重大指跨元件契約、架構／持久化／權限改變，或昂貴且難回復的選擇；普通小修不觸發。
2. **同一錯誤再現時**：同一可辨識問題在一次有根據的修正後再次出現，問「是不是追錯責任層或因果？下一個最有辨識力的檢查是什麼？」附兩次失敗與中間變更。不要先湊兩種修法，也不要把同一次失敗重印的 log 算成再現。第三次同策略失敗時停止該策略，保留最小證據。
3. **長任務宣告完成之前**：Main 已完成實作並取得實際結果證據後，問「哪些需求、整合路徑或失敗情境仍有遺漏？」長任務指包含多個實作／整合階段或跨元件結果的工作；只因等待外部服務很久不算。Reviewer 意見不能替代實際驗收。

同一任務最多建立一位 Architect，三個時點沿用它。每次 review 限一個具體問題；同一時點、相同證據已有有效回答就沿用。計畫階段的答覆不能當完成階段的審查。一般回合、每次改碼、單次錯誤與例行進度不自動召喚。

Reviewer 收件後回傳具體發現、可定位證據、影響、建議與未知處。Main 查核並決定採納方式；重大問題修正後只補必要的結果驗證或針對性追問，不啟動無限審查循環。

## 派遣與交付

實際派遣及 follow-up 前讀 [派遣流程](references/dispatch.md)。沿用主機既有 parent/model gates、任務綁定紀錄與實際工具容量；本技能不建立另一個排程器或政策引擎。缺少所需 review 或驗收時，繼續可獨立進行的已授權工作，清楚回報缺口，不把未審查／未驗證當完成。

每份封包與 review 必須引用並要求接收者讀取適用專案的驗收規則；主機有 **Outcome-first verification** 時一併引用，帶適用的 `rules_ref`／`rules_hash`。Main 先說明可觀察的驗收結果、主要失敗風險與最小可靠驗證路徑；重用現有驗證，測試依增量價值選擇。完成以使用者結果、受影響契約與未驗證邊界判斷。

角色 Reviewer 與平台的 approval reviewer 是不同機制；本技能不變更 approval_policy 或 approvals_reviewer，不宣稱角色設定可攔截全部工具。
