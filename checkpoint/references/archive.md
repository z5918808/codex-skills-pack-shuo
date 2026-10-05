## 封存原則

封存不是刪除。

可封存候選：

- 過期 scratch / temp / debug output
- 被新版 artifact 取代的舊 HTML / report / screenshot
- 舊 run 的大型中間產物
- 已驗證可重建的生成物
- 重複、失敗、已不再服務主線的 pilot output

不可封存，除非使用者明確確認：

- active run / state / manifest / log
- source input、不可重建資料
- 使用者手動檔案
- 目前腳本按固定路徑依賴的檔案
- credentials、token、customer data
- 不確定用途的檔案

封存執行規則：

1. 先產生 archive plan：root、keep、candidates、reason、risk、restore path。
2. 執行前確認每個 target 的 resolved absolute path 位於專案 root 或使用者指定 root 之下。
3. 預設搬到 `archive/<YYYYMMDD-HHMM>-<slug>/` 或專案既有 archive / quarantine 位置。
4. 保留相對路徑與 manifest，讓檔案可還原。
5. 驗證 archive 可列、大小合理、manifest 存在後，才回報完成。
6. 不做不可逆刪除，除非使用者二次明確確認。
