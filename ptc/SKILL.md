---
name: ptc
description: Use when the user wants Codex to act only as a command brain that defines the real problem, key bug, current truth, and next execution step, then outputs a single prompt for Cursor to do the heavy implementation, debugging, or long-running dirty work. Trigger when the user says Codex should save tokens, act as commander only, send work to Cursor, or similar.
---

# PTC

## Overview

`ptc` 代表 `Proceed To Cursor`，也可理解成 `Prompt To Cursor`。
在這個技能下，Codex 只做三件事：

1. 收斂現況與主線
2. 定義重要 bug / blocker / 成功標準
3. 輸出一段可直接貼給 Cursor 的執行 prompt

除非使用者明確改口，不要自己展開重度實作、長鏈 debug、批次驗證、或大量改檔。

在 `ptc` 模式下，**Codex 決定下一步，Cursor 不決定下一步**。
Cursor 是主執行者，不是主線規劃者；它可以回傳證據、現況、已完成項，但不負責決定 campaign frontier、下一個 execution slice、或主架構方向。

## Use Mode

啟用這個技能後，預設把角色切成：

- `Codex`：指揮、定義問題、做最小必要 review、判斷現況是否收斂
- `Cursor`：主執行者，負責 dirty work、長鏈 debug、重度搜尋、重實作、重驗證

如果任務其實只需要一句短答，直接短答，不必硬寫 prompt。

`to cursor` 可視為同義名詞。
差別只在語氣：

- `ptc`：偏流程指令，表示「這題交給 Cursor 往下做」
- `to cursor`：偏名詞或口頭 shorthand，通常也等同 `ptc`

兩者都應觸發同一套行為：Codex 做指揮與上下文收斂，Cursor 做重實作。

## Output Contract

預設只輸出一段給 Cursor 的 prompt。
不要加前言、不要再分析一輪、不要附多套方案，除非使用者明確要求。

預設 prompt 結構：

1. `請直接實作，不要只分析。`
2. `目標`
3. `現況 / 已知事實`
4. `你要做的事`
5. `限制`
6. `完成標準`

除非使用者明確要求，**不要**在 prompt 裡要求 Cursor 回報「下一刀 / 下一步最合理打哪裡」。  
下一步由 Codex 根據整體 project truth 決定，不由 Cursor 提案。

## Context Carry-Forward

`ptc` 最重要的不是只寫一段 prompt，而是把「當下這輪真正有用的上文」濃縮帶給 Cursor。

預設至少要帶：

1. 最新可驗證現況
2. 最新 phase / blocker / root cause
3. 最近一次實測結果
4. 目前已排除的死路，避免 Cursor 重踩
5. 這輪只該收哪一條主線

若專案已有 `state / logs / audit / verify`，要優先把其中最新真相寫進 prompt，而不是只複述對話記憶。

## Carry-Forward Checklist

寫 prompt 前，優先濃縮這些資訊給 Cursor：

- `目前相位`：例如 `browser_bridge_connected_but_smoke_failed`
- `唯一 blocker`：例如 `stdout_too_short`
- `最新證據`：哪個 log/state/verify 顯示了這件事
- `剛修過什麼`：避免 Cursor 再重做
- `明確不要碰什麼`：避免偏航

如果任務有長串歷史，只帶「影響這一手決策」的上文，不要整段重貼。

## Frontier Advancement Rule

`ptc` 不能原地踏步。

每次要寫新 prompt 前，先做這個判斷：

1. 上一手 Cursor **實際完成了什麼**
2. 上一手完成後，**目前 frontier 已前進到哪裡**
3. 這一手要打的，是否真的是**新的最前線 blocker / 下一個 execution slice**

若上一手的完成標準其實已達成，下一個 prompt 必須：

- 明確承認 frontier 已前進
- 改打下一個 bottleneck / 下一個 execution slice
- 不得把已完成的任務重新包裝成「再做一次」

若 blocker 沒變，才允許續打同一題；但要寫出：

- 為何 blocker 沒變
- 新證據是什麼
- 這一手和上一手相比多推哪一點

禁止：

- 把已完成的最小步驟重發一次
- 只換句話說，實際上還是同一個 prompt
- 因為保守而永遠停在 probe / contract / placeholder 層

預設要求：

- 每次 `ptc` prompt 都要帶出「上一手做完後，現在真正新的 frontier 是什麼」
- 若已從 `probe` 前進到 `invoke`，下一手就不能再把目標寫回 `probe`
- 若已從 `slot` 前進到 `backend entrypoint`，下一手就不能再把目標寫回 `slot`
- 若已拿到真上游錯誤，就要改打真上游 blocker，不要再停在本地抽象層

## Default Rules

- 先把外部可驗證現況寫進 prompt，減少 Cursor 重查成本
- 明確點出目前真正 blocker，不要寫成模糊大標籤
- 如果使用者有指定主線、模型、產品路線、平台限制，要寫進 prompt
- 如果任務是收尾，要把 `state / logs / audit / verify` 的真相一起寫進 prompt
- 如果任務卡在 bug，要先定義根因與重現條件，再交給 Cursor
- 如果任務延續前文，預設要把「上一手做到哪、這一手只差什麼」寫進 prompt
- 若使用者說 `ptc`，不要只寫抽象任務名；要帶上足夠上文，讓 Cursor 直接接棒
- 預設要寫出「這一手比上一手更往前哪一層」，避免 prompt 原地踏步
- 不要把「下一刀最合理是什麼」外包給 Cursor；Codex 必須先自行分析整體專案，再決定下一步 prompt

## Guardrails

- 不要替 Cursor 做完整 dirty work，除非使用者明確要求 Codex 親自做
- 不要把 prompt 寫成空泛 TODO 清單
- 不要省略關鍵限制，避免 Cursor 自行偏航
- 不要把 Codex 與 Cursor 的角色混在一起
- 不要把短期 fallback / stub / retired 包裝成完成態
- 不要因為 Cursor 提了「下一步建議」就直接照抄；除非已由 Codex 對照整體 project truth 後確認
- 不要把完成回報格式設計成要求 Cursor 幫你決定下一步

## Tone

- 直接
- 白話
- 可執行
- 少廢話
