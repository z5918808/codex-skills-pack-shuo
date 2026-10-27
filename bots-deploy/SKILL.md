---
name: bots-deploy
description: "依本次指定的模型、effort 與任務範圍派遣相容子代理；派遣須通過角色及授權 gate。"
---

# Bots Deploy

這是有界派遣入口：Worker 預設 Terra medium，Reviewer 預設 Sol 6.1 medium；當次明確選擇模型或 effort 時沿用該選擇，不繼承前次任務的授權。只有目前任務的使用者明確叫用才啟動；討論或維護本技能不算叫用。Main 負責目標、權限、派遣、整合與驗證。先讀 [共用派遣規則](../_shared/bot-dispatch.md)。

## 選擇與派遣

1. Worker 未指定模型時預設最新 listed Terra / medium；Reviewer 預設 gpt-6.1-sol / medium。保留當次明確指定的模型與 effort；若只指定家族，從主機目前可用模型清單解析。模型、effort 或相容角色不可用就停止該派遣，不沿用舊版。
2. 將目標切為必要且可獨立驗收的分析或執行切片。分析切片唯讀；執行切片只給明確授權的資源與唯一 writer。當次使用者指令沒有授權的外部或 live 操作，不因派遣而新增權限。
3. 每片在**當下 tool schema** 中找已載入、固定模型與 effort 完全相符且能力相容的角色。預設 Terra medium 使用已載入且相容的 `worker`／`explorer`；`bots_sol` 與 `bots_luna` 保留為當次明確選用的相容角色。其他組合也須有相符載入角色。`bigbots_sol` 僅供 Bigbots 的三方唯讀分析；`side_astra` 僅供 sub-astra-thinker，均不可借用。固定角色不靠 override 改模型；沒有相容角色時只報告該切片阻礙及需載入的設定，不建立探測子代理。
4. 從本次真實叫用綁定唯一 planned task ID、模型、effort、範圍與時間。依主機的正式模型及父任務授權契約執行必要 gates；Sol/Astra 需要的明確任務授權不能從 Main 的模型推定。任何必要 gate 缺少、非零、角色不符或容量不足，就只停止受影響的派遣。這份技能不依賴作者私有腳本，也不擴張父模型資格。
5. 顯式指定相容 `agent_type`、`model`、`reasoning_effort`、`fork_turns="none"`，給每片完整且精簡的任務包。子代理不得再派遣。每片收件後由 Main 核對證據與實際變更；只有所需切片和整合驗收完成才報告完成。未派出的切片不可算完成。
