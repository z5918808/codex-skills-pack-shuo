---
name: prompt-for-goal
description: Compile, audit, or revise /prompt for goal, /goal, terminal-ready goals, and LFD readiness packages.
---

# Goal Compiler

把意圖編成下一位 agent 可直接執行的目標契約。這個 skill 不執行目標；只定義 outcome、存在證據、路線、gate 與停止條件。

## 先選模式

- **design**：從需求編目標稿。
- **audit**：找既有 goal 的測量、權限、作弊或停止缺口。
- **revise**：依 run evidence 更新 target、gate 或策略，不重寫施工史。
- **terminal-ready**：使用者明確要求時，只輸出一個 `/goal` block。

模式不要混在同一份輸出。

## 選正確視野

把使用者的 `next` 當第一個未驗證階段，不自動當總目標：

- **single**：單一明確修正。
- **lane**：同類 defect 或一條流程。
- **factory**：重複 defect、batch、verifier、repair 與 feedback。
- **long-run**：需外部 supervisor、checkpoint 或可跨 session 執行。

選最高有證據支持的一層。重複 defect 應升到共同 contract／verifier／producer，但不能因一句「自動化」發明整套平台。

## 必備契約

每份 goal 至少定義：

- **Outcome / Existence**：完成後世界多出什麼可觀察結果。
- **Current truth**：接手者先讀哪個 live file、command、UI、log 或 artifact。
- **Roadmap**：從第一個未驗證階段到完成，每段一個 exit evidence。
- **State owner**：誰寫 authoritative state；誰只讀或 render。
- **Safety / permission**：live、DB、金錢、secret、bulk、destructive 的授權與 rollback。
- **Stop / strategy change**：何時完成、blocked、或因無新資訊換方法。

Proof 必須可重跑。Dry-run green、scorer green、confirmation-ready 都不是 live permission。

## Readiness 是執行 Gate，不是編譯 Gate

缺 eval、baseline、budget instrument 或 evaluator isolation 時，仍可產生 scaffolding goal；把補 gate 放在 Roadmap 第 1 階段，並明寫：gate 通過前不得進 repair、batch write、optimization 或 canary。

只有連「怎樣算存在」或安全 scope 都無法合理定義時，才停止並輸出：

```text
GOAL_READINESS: BLOCKED
missing_proof_or_gate:
- <會改變目標或安全性的缺口>
minimal_safe_next:
- <取得該決策的最小動作>
```

Optimization／benchmark／distill 類 goal 另需：target、baseline、measurement command、budget counter、abort test、editable/frozen scope、獨立 evaluator 或 blind fixture、anti-gaming 與 strategy-change rule。

## 預設中文目標稿

```markdown
目標：
<一句 outcome>

現況：
<latest verified checkpoint + truth source>

完成標準：
- <observable existence>
- <integrated proof>
- <state / safety / recovery condition>

路線圖：
1. <first unverified phase> -> evidence: <signal>
2. <core lane / factory> -> evidence: <signal>
3. <integration / bounded canary> -> evidence: <signal>

規則：
- 先查 live truth；claim != truth。
- Gate 未綠前不得進下一個有副作用階段。
- 同類錯第二次，改共同 contract / verifier / producer，不補單點。
- 無新資訊就換假設或停止。
- 回報 delta：verified / changed / blocker / next。
```

刪除不適用的行，不留下 placeholder。

## Terminal-ready `/goal`

只輸出一個 block：

```text
/goal <outcome>.
Existence: <observable result>.
Current: <known state and first live truth source>.
Roadmap:
1. <first unverified phase> -> evidence: <signal>
2. <core lane or factory> -> evidence: <signal>
3. <integrated proof or bounded canary> -> evidence: <signal>
Rules: <state owner; readiness gate; permission boundary; rollback; strategy-change; stop; delta report>.
```

若 readiness 缺口已知，第一階段就建立 harness／baseline／instrument；Rules 明寫 gate 綠前禁止後續副作用。

## 篇幅

- 一般 goal 預設 20–60 行；factory／long-run 60–100 行。
- 路線圖通常 3–6 階段；不另附重複待辦。
- 刪完成史、舊 blocker、schema 空欄與 repo 已可讀的規則全文。
- 不為縮短刪 truth source、permission、rollback、exit evidence 或 stop condition。
- 只有 long-run 才加 checkpoint、progress 與 durable handoff。

完成於：接手者能在 30 秒找到 outcome、current truth、第一步、每段證據、安全 gate 與停止條件。
