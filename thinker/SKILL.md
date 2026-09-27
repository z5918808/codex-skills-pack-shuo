---
name: thinker
description: 為獨立分析任務選擇 Thinker，在另一條 Codex chat 完成唯讀判斷並直接回報 Main。
---

# Thinker

用於使用者明確要求獨立 Thinker 分析時；討論或修改本 skill 不啟動任務。Main 保留執行、驗收與授權責任。先遵守所在環境的模型派遣、任務建立與授權規則，再選擇可用模型：大量資料消化可用 Luna/max；一般架構、比較與診斷可用 Sol/medium；具體高難度決策或使用者明確指定時可用 Astra/high。這些是建議，不覆蓋使用者指定的模型或 effort，也不保證主機提供該模型。

獨立分析使用一條可持續讀取、傳訊的 Codex chat；repo 任務須與 Main 在同一專案。優先核對可沿用且前次結果已交接的 Thinker。建立新 chat 前確認本次授權、實際模型／effort、專案、Main threadId／host 與工具能力；若工具不能選指定模型，請使用者在對應專案建立，不能用其他模型或 ChatGPT 暫時對話冒充。不要以原生 subagent 或新 worktree 代替這條 chat。

Main 給 Thinker 的訊息包含具體問題、必要來源與最近結果、唯讀範圍、停止條件、實際 Main threadId／host，以及專案有釘選規則時的版本或 hash。訊息必須明寫「請回傳結果給main」，並要求 Thinker 用 `send_message_to_thread` 傳給該 Main、確認送達後才在自己的 chat 結束。派工送達也須核對；只有 chat 已建立或 Main 已送出，不等於分析完成。

Thinker 只讀取回答該問題所需證據，回傳判斷、來源、主要盲點、下一個最便宜的驗證動作與可推翻條件。大量資料分析另交代覆蓋範圍與例外。不要重複 Main 已完成的調查，不實作、不寫入專案、不執行 live 操作、不再派任務。缺關鍵證據時回報最小查證，不把猜測當成結論。

完成後先用 `send_message_to_thread` 將實際結論或 blocker 傳給 Main，核對工具 receipt；自己的 chat 也留下精簡結論。傳送失敗時保留結果與錯誤供最小重送或使用者轉交，不重做分析、不宣稱 Main 已收到。成功送達不等於 Main 已採納；Main 自行核對、執行與驗收。
