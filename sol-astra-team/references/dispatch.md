# 有界派遣與回件

先讀本技能入口及 setup。只在使用者明確叫用本次具體任務後派遣；檢查實際 Main、父任務資格、載入角色、容量、模型與所需授權。Worker／explorer／researcher 預設 Terra medium，唯讀 Reviewer 使用 gpt-6.1-sol medium；保留當次明確模型選擇。缺少相容角色或主機要求的 gate，就只停止該派遣，不安裝例外或以 model override 假裝角色已變更。

本次叫用涵蓋下列有界角色的實際任務，不代表新增外部權限。每個 assignment 綁定原始叫用、唯一 planned ID、精確模型／effort、範圍、時間及實際收據。依主機正式契約跑必要的 model/parent/task gates；不得以合成測試或其他任務紀錄冒充授權。本公開版不依賴作者的私有檢查腳本。

每次只派有價值的切片，不湊滿角色樹。可寫資源只有一位 writer，Main 不與 Worker 重疊；其他角色 write_scope=none。封包含 outcome、問題／動作、必要原始輸入、read/write scope、acceptance、stop condition、task_id／role／scope／permissions／rules_ref／rules_hash／state_version／next_action。沿用已有 state_version，普通任務不為此建立另一套狀態。

讀取並要求接收者遵守適用的 AGENTS.md 與驗收契約；主機有 Outcome-first verification 時明確引用。核對 native 派遣收據與真正 child ID；所有 child 不再派遣、不建立 chat、不改 canonical state、不接管 Main 權限。

Reviewer 只在入口定義的 plan／repeated-error／completion 三個時點，回答一個會影響決策的具體問題。沿用同一 Reviewer；相同證據不重複審查。回傳可定位發現、影響、建議、反例與未知。Main 查核並整合，只有相關改動才重驗；模型意見、檔案存在或工具成功都不等於整體驗收。

native child 從其正式 parent channel 回傳。中斷、停止或替換時，先對帳實際 child、writer、修改與 owned process，再沿主機正常 lifecycle 回收；不強殺未知程序、不宣稱沒有工具證據的關閉結果。角色中的 sandbox/read-only 是預設與指令界線，不是所有外部工具的攔截證明。
