---
name: streaming-dag-execution
description: Run independent work as a streaming DAG when batch barriers, feeder starvation, or final sections cause delay.
---

# Streaming DAG Execution

## Overview

讓每個 item 在前置條件滿足後立即前進：許多備料台並行，一個共享結帳口串行。最佳化總完成時間，不是 worker 數量。

## 適用判斷

僅在以下條件同時成立時使用：

- 至少兩個 item 可獨立準備。
- 每個 stage 有明確輸入、輸出、owner 與依賴。
- worker 可產 immutable artifact，由 central merger 單寫狀態。
- 並行收益高於協調成本。

單一 item、不可分割的共享 mutable state，或無法定義交接證據時保持串行。

## 執行契約

1. 為每個 item 定義 `item_id`、stage、prerequisites、artifact、owner、失敗回流與 release condition。
2. 啟動 bounded workers；`dispatch created` 只算 planned，必須有實際 worker output 才算 running。
3. 單筆 prerequisites 一滿足就前進，不等整批：`ready → work → validated → packet_ready → critical_queue → done`。
4. worker 只寫自己的 immutable output；central merger 單寫 registry、ledger、queue 與完成狀態。
5. shared writer、deploy、live mutation、migration 或 final merge 必須是 `single writer` 並維持 WIP=1；prep 可以並行。
6. feeder 意外輸出零筆、worker 未啟動或 queue 斷料時，明確列為 throughput blocker。修 feeder／runner，不准 Main 默默退回逐筆手工。
7. 單一 item 失敗只進具名 repair lane，不得阻塞其他無依賴 item，也不得從總目標消失。

## 真實 DAG Proof

每次狀態回報必須列：

- `eligible_items`、`requested_workers`、`actual_workers`
- stage distribution，含各 stage 的 item IDs
- actual worker output refs
- `critical_queue`、`active_critical_wip`
- repair items、missing proof、release condition
- feeder idle／critical-lane idle 原因

至少兩個 eligible items 必須已有真實 worker outputs，或同時位於不同 stage；若 eligible item 少於兩個，明確降級為簡單串行。

## Fail-Close

以下都不是 DAG proof：只有 dispatch plan、同批空 artifact、process 存在但無 output、全部 item 停在同一 barrier、Main 手工逐筆代做。遇到這些情況，狀態固定為 `planned_not_streaming`，不得宣稱多線運作。

## 快速例子

商品 A 已進 validator、商品 B 正在 source、商品 C 正在 image prep；三者產出獨立 artifact，最後只有 A 進單一 live writer。這是 streaming DAG。三份 SUB dispatch 都存在但沒有 worker output，則不是。
