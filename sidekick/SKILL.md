---
name: sidekick
description: 為長跑的 Luna 或 Sol Main 配同專案 Astra Thinker chat；Thinker 按需給輕量引導並直接回報 Main，可沿用現有 Goal mode。
---

# Sidekick

`/sidekick` 或 `$sidekick` 用於長跑中的 Luna 或 Sol Main。Main 同時負責實作、檢查、驗收與交付，保留原模型、effort、任務與寫入權；若已有 Goal mode 就沿用，沒有也不為 sidekick 強制建立 goal。獨立 Astra Thinker 只提供唯讀判斷，不是第二個 Main、實作 Worker 或完整 code reviewer。建立或修改本 skill 不啟動角色。

## 啟用

先核對 Main 的 Codex projectId／host，找同專案已有的 Thinker chat；確認模型與前次結果已交接後優先沿用。沒有適用 chat 時，由使用者在 Main 所在 Codex 專案建立 Astra chat；若任務工具能選指定 Astra，且本次建立獲授權、符合所在環境模型規則，也可用工具建立。工具不能選 Astra 時，不改用 Sol 或 ChatGPT 暫時 side chat。Thinker 使用 Astra/high、一般速度而非 Fast；若工具沒有速度參數，就在可見的 chat 設定確認，不宣稱工具已強制設定。

啟用前用可用的 chat 工具核對 Thinker 是可持續讀取與傳訊的 Codex chat，projectId／host 與 Main 相符，並取得雙方 ID。使用者直接在 Thinker chat 叫用時，也先定位 Main；無法唯一識別才問 Main 連結或 ID。若目前是 ChatGPT 暫時 side chat，告知它不符合 repo Thinker 條件，轉至同專案 Codex chat 後再啟用。此 skill 的分析與回報採用 [thinker](../thinker/SKILL.md)；安裝時一併安裝兩者。

Main 遇到卡住、反覆失敗、證據衝突、下一步不清楚或 goal prompt 不足時，送一個能改變下一步的具體問題，附現有目標的權威來源、最近結果、已試方法與邊界。發給 Thinker 的實際訊息須明寫「請回傳結果給main」，附 Main threadId／host，要求 Thinker 完成後用 `send_message_to_thread` 回傳結論並確認 receipt，不能只在 Thinker chat 作答；Main 也核對派工送達。單純開好 chat 不代表已取得建議。

## 輕量支援

Thinker 只讀與問題有關的資料。若使用者在 Thinker 直接叫用，就從已確認的 Main 最新進展選最值得提醒的一個盲點。回覆保持輕：判斷、依據、可能盲點、下一個可驗證動作及可推翻條件。不要展開全庫審查、逐檔 code review、大量資料消化、持續監控或例行 milestone 檢查。Thinker 不寫程式或 goal、不部署、不派代理、不接管程序與外部操作。

若 goal 或任務提示不足，Thinker 提出精簡修訂建議：哪個目標、範圍、驗收證據或首步不夠，建議如何改，以及依據。Main 是唯一修改者，遵守所在專案的 goal 與交接規則；沒有 goal 檔就不為 sidekick 強制建立。若原生 `update_goal` 只改狀態，不宣稱 objective 已更新。建議不得擴大使用者授權。

Thinker 完成後將精簡結論直接送 Main 並核對傳送結果，在自己的 chat 也留同一結論。若傳送工具不可用或實際失敗，明確標示 Main 未收到，保留可轉交的訊息，不重做分析。Main 核對建議後決定、執行與驗收；顧問意見不是授權或成功證明，Main 也不因顧問閒置而停工。
