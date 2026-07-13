---
name: security-review
description: Security review with threat modeling, evidence-based severity, and bounded remediation.
---

# Security Review

找出可被利用、會造成實際影響的安全問題。預設只讀；除非使用者明確要求，不直接修檔或執行 live action。

## 核心原則

1. 先定義資產、攻擊者、信任邊界、資料流與濫用情境，再找控制缺口。
2. `verified vulnerability`、`credible risk`、`missing evidence` 分開寫；不要把猜測升格為漏洞。
3. 嚴重度由可利用性、影響、暴露範圍與現有控制決定，不由關鍵字決定。
4. 找最便宜且決定性的證據：程式路徑、設定、負向測試、隔離 fixture、實際回應。
5. 建議要帶 scope、取捨與解除條件；避免把情境式選擇寫成普遍禁令。
6. 高風險或 live 修復先走 `$risk-preflight`；review 結論不是執行授權。

## Review Flow

### 1. 定界

確認：

- 系統、環境、入口與資料類型。
- 身分、租戶、權限角色與敏感資產。
- Internet、使用者、第三方、背景工作與管理面的信任邊界。
- 本次是程式碼 review、架構 review、設定 review，還是可重跑測試。

資訊不足時，先標記缺口；只有缺口會改變結論或安全操作時才停下問人。

### 2. 依攻擊面檢查

- **身分與授權**：登入、session、token、物件級與租戶級權限、管理面、權限撤銷。
- **輸入與注入**：SQL、command、template、path、反序列化、輸出編碼與內容渲染。
- **請求邊界**：CSRF、CORS、SSRF、redirect、webhook 驗證、egress 與 DNS/redirect 轉向。
- **秘密與密碼學**：來源、scope、輪替、撤銷、傳輸、靜態保護；不用自製 crypto。
- **業務邏輯**：重放、重複提交、競態、額度、價格、狀態轉移、idempotency。
- **資源濫用**：大小、數量、並發、timeout、quota、昂貴解析；限流依身分與成本設計。
- **供應鏈**：實際可達依賴、鎖檔、來源、更新風險、建置與發布權限；掃描結果只是證據之一。
- **紀錄與可觀測性**：錯誤證據足夠，但 Cookie、Authorization、token、個資須遮罩並限制保存與存取。

### 3. 檔案上傳專項

Client MIME、副檔名與檔名都不可信。依格式與威脅模型評估：

- magic bytes／實際解析、格式 allowlist、必要時 decode/re-encode。
- 大小、數量、壓縮炸彈、metadata、解析 timeout 與使用者 quota。
- 隨機 server-side 名稱、路徑 canonicalization、避免覆寫與 race。
- 暫存隔離；高風險格式再評估掃毒或 sandbox，不能把掃毒當完整解法。
- 儲存在 public root 之外或隔離 origin；提供檔案時確認 `Content-Type`、`Content-Disposition`、`nosniff`、CSP 與 cache。
- 預覽、下載、分享與刪除各自有授權，不假設「知道 URL」就是權限。

### 4. 避免普遍處方

以下都必須依威脅模型與產品需求判斷：

- Cookie 或 browser storage；`SameSite`、CSRF token 與跨站登入流程。
- Secret manager、環境注入或平台原生秘密機制。
- CSP directive、inline content、第三方 script 與 rollout 方式。
- 限流 key、門檻、burst、fail-open／fail-close。
- 上傳格式、重編碼、掃毒、`inline` 或 `attachment`。

不要因單點失敗封整個技術家族；禁令要有 scope、fixture 與解除條件。

## 驗證

優先做可重跑的負向測試：

- 未登入、低權限、跨租戶、已撤銷身分。
- 邊界值、惡意輸入、重放、並發、timeout 與第三方失敗。
- 上傳偽造 MIME、雙副檔名、polyglot、超大檔與危險 metadata。
- 實際回應標頭、檔案 origin、log 遮罩與 secret scan。
- 修復前後 fixture 必須可區分；只有工具 green 不等於漏洞已關閉。

若只能 self-check，明標 `weak verification`。涉及 production、資料、憑證或 destructive 驗證時停在安全邊界。

## 輸出格式

先列 findings，再給摘要。每項 finding 包含：

1. **嚴重度與狀態**：verified / risk / missing evidence。
2. **座標**：檔案:行、路由、設定、測試或實際回應。
3. **攻擊路徑與影響**：需要哪些前提、可跨到哪個邊界。
4. **證據**：觀察到什麼；哪些仍未知。
5. **最小修復**：控制點、scope、相容性與 rollout 風險。
6. **驗證方式**：可重跑 fixture、預期 before/after、rollback 或解除條件。

沒有可利用問題時也要說明檢查範圍、證據強度與未覆蓋面，不寫「完全安全」。
