---
name: duo-run-light
description: Terra Main 執行與驗收，只有主線遇到具體瓶頸才請 Sol 6.1 medium Thinker 提供唯讀建議。
---

# Duo Run Light

`/duo-run-light` 或 `$duo-run-light` 搭配具體目標啟用。Main 預設 Terra medium，自己實作、驗證、驗收與交付；保留實際選定模型與 effort，不切換正在執行的 Main。若目前不是 Terra，先明示配對尚未成立，繼續獨立已授權工作，不建立替代 Main。維護或討論本技能不啟動角色。

這是獨立的輕量工作流，不啟動一般 Duo 的 Worker、原生 goal、排程、監控或強制目標檔案。已有目標及專案規則沿用原 owner。所在環境的模型、父任務、資料與外部操作 gates 仍須通過；安裝技能不新增權限或放寬 Terra 的 native delegation 資格。本公開版不依賴作者的私人 scripts 或 harness_docs。

## 只有瓶頸才求援

先做最小相關查證。只有同一路線兩次失敗仍無可用原因、證據推翻原假設且無法選下一步、驗收分不出合理的錯誤結果，或主線反覆繞圈時，才請一位 `gpt-6.1-sol` / `medium` Thinker 回答一個具體問題。資料量、階段完成、閒置與收尾本身不觸發。相同問題沒有新證據就不重問。

Thinker 唯讀分析，回傳建議、原始證據、反例／未知與下一個可驗證動作；不寫程式、不改目標、不操作 live 系統、不再派遣、不接管執行或接受整體成果。Main 自行核對、採納或否決並繼續工作。專案明確要求的獨立 review 仍須依其契約完成，不能用建議替代。

## 派遣與回件

明確叫用本技能執行具體工作，涵蓋符合瓶頸條件時建立或沿用一條獨立 Sol Thinker chat，及該問題的直接回報。先確認本次授權、精確模型／effort、專案、實際 Main ID／host、可用傳訊工具與主機 gates。優先沿用同目標、前次結果已交接且 effects 已對帳的 Thinker；不複製 pending 問題。使用持續可讀取及傳訊的 chat，不以 native child 或新 worktree 代替。

派工附目標、單一問題、已試方法與原始證據、只讀範圍、停止條件、Main 回傳地址，以及專案適用的規則／版本／hash。主機有 Outcome-first verification 時引用並要求讀取。核對實際選用 `gpt-6.1-sol/medium`；模型、角色或必要 gates 缺少就只停止該諮詢，繼續獨立已授權工作，不用其他模型冒充。

訊息明寫「請回傳結果給main」，要求 Thinker 用 `send_message_to_thread` 傳實際結論或 blocker，確認成功收據後才在自己的 chat 結束。一般回報不帶 `model`／`thinking`，避免變更 Main。Main 派工也須核對收據；模糊傳送先對帳，不盲重送或重做分析。傳送失敗保存建議與精確錯誤供有界恢復，不宣稱 Main 已收到。

Main 派遣後讓出回合，不 polling、wait_threads、sleep/read loop 或定時催問。送達不保證喚醒；Main 收到後核對問題、版本與證據，完成下一個已授權動作、指出精確 blocker 或驗收結果。模型意見與傳訊成功都不是產品成功證據。

## 安裝與完成

本包只提供流程；主機需提供 Terra／Sol 模型、可核對的 chat 身分、指定模型／effort 的建立或沿用能力、直接回報通道及適用授權檢查。模型描述檔是檢查輸入，不是已載入角色或 runtime 隔離。工具不能選指定模型時，由使用者在同專案建立相符 chat；必要回報能力缺少時，明示缺口，不派出無法交接的工作。

完成以使用者可觀察結果、正式入口的適當驗證、受影響契約與未驗證範圍判定。停止時對帳本次已確認自有的資源與未完成 effects，不變更其他執行中任務。
