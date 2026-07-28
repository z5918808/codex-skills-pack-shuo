---
name: super-report
description: Diagnose one engineering topic through contract, routing, and state ownership, then synthesize a decision.
---

# Super Report

對一個非瑣碎工程問題做三鏡頭診斷：承諾、路由、狀態 owner。預設只讀；報告不產生修檔、部署或 live permission。

## 使用邊界

適合三種問題互相糾纏、單一 code review 不足時。若一個決定性 probe 就能回答，直接做 probe，不展開 super report。

開始前定義：

- topic 與要支持的決策；
- in scope / out of scope；
- 可重跑 evidence；
- 缺證據時報告是 `analysis-only`。

只有使用者要求檔案時才建立 `SUPERREPORT.md` 或子報告；chat-only 不製造 artifact。需要獨立 review 且使用者明確允許平行 agents 時，可分派三鏡頭，主 agent 仍負責綜合。

## 三個鏡頭

### 1. Contract Surface

核心問題：承諾是否錯、缺失、模糊或被過度解讀？

檢查使用者指令、API／CLI／UI、schema、文件、status、handoff 與隱含 operator expectation。找出：

- 哪個 promise 沒有 owner 或可驗證條件；
- docs、runtime、artifact 與 agent claim 是否矛盾；
- readiness 是否被誤當 completion 或 permission；
- 最危險的過度解讀與 blast radius。

### 2. Routing Architecture

核心問題：request、artifact、skill、agent、gate 或 permission 是否走錯路？

畫出 canonical route，只標會改變決策的節點。分開：

- progress proof；
- readiness proof；
- permission proof；
- post-execute proof。

`green`、dry-run green、no-send green、confirmation-ready、舊 artifact 都不是 live permission。

### 3. State Ownership

核心問題：authoritative state owner 是否不清、重複、過時或被繞過？

確認：

- 誰是 writer；誰只是 reader、cache、render 或報告；
- 是否有 double writer、shadow truth、mtime-latest 或 chat summary 被當真相；
- artifact 的 run id、path、hash、freshness 與 recovery route；
- permission state 與業務 state 是否被混成同一個欄位。

## 每鏡頭最小契約

每個鏡頭只需回答：

```text
Verdict: yes / no / unknown
Strongest finding:
Evidence:
Impact:
Missing proof:
Minimal safe next:
```

沒有差異時不要重複同一段 failure mode、blocking rule 與 proof contract。三鏡頭一致就寫一致；不要製造假衝突。

## 綜合輸出

預設五段：

1. **判斷**：一句決策與最高風險。
2. **三鏡頭診斷**：每個鏡頭最強 finding 與證據。
3. **交叉判斷**：真正衝突、共同 root cause；無衝突就明說。
4. **缺少證據**：只列會改變決策的缺口。
5. **最小安全下一步**：一個 owner、一個 proof、一個停止邊界。

只有與 topic 有關時才加 merge、ship、rollback、human confirmation 等 decision table 欄位；不輸出固定十節空模板。

## 證據與安全

- Claim、HTTP 200、AI report、status doc 都只是輸入。
- 重要結論附檔案:行、指令、run id 或實際回應。
- 只能 self-check 時標 `weak verification`。
- 證據矛盾先處理，不用摘要蓋過。
- 遮罩 secret、cookie、customer data、internal URL 與 production identifier。
- 沒有 fresh explicit authorization + bounded scope + proof gate，不建議 live action。

完成於：三個核心問題都有 verdict、關鍵 claim 可追溯、衝突已裁決或明列 unknown、下一步能取得決定性證據。不是完成於報告頁數。
