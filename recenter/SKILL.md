---
name: recenter
description: Use when a long or heavily compacted thread may be drifting and the user wants to pause, recover the original goal, review the current main line, inspect blind spots, separate verified truth from assumptions, and choose the next concrete step. Trigger on requests like "recenter", "停下來回想", "review 主線", "怕你忘記 goal", "ctx 被壓縮", "對話太長", "重新抓一下現在在幹嘛", "檢查盲點", or "不要繼續做，先想清楚".
---

# Recenter

`recenter` 是長對話的主線回正器。

它不是 `/save`、不是 handoff、也不是自動 compact。目標是在繼續動手前，把原始目標、現場真相、盲點、噪音與下一步重新對齊。

## 核心原則

1. 先停下來，不要立刻繼續實作。
2. 以可驗證現況為準，不靠對話記憶猜。
3. 區分 `已驗證`、`高信心推論`、`待確認`。
4. 找出主線與噪音，必要時砍掉支線。
5. 最後必須給出一個最小但有意義的下一步。
6. 若發現資訊會在 compact 後消失，先建議寫入專案狀態檔或使用 `/save`。

## 工作流

### 1. 抓原始目標

先用一句話重建使用者真正要達成的 goal。

如果 goal 已經變形，明確指出：

- 原本目標是什麼
- 目前實際在做什麼
- 兩者是否偏離

### 2. 讀現場真相

依任務類型讀最小必要現況：

- 專案狀態檔、handoff、`PROJECT_STATUS`、`AGENT_STARTUP_SOP`
- terminal / log / process / test output
- git diff / 最近改動
- 使用者最新明確指令

不要把未重查的舊對話當成現況。

### 3. 主線盤點

整理目前狀態：

- 主線是什麼
- 主線進度百分比
- 已完成什麼
- 還缺什麼才算真的完成
- 哪些支線應暫停或丟掉

### 4. 盲點掃描

至少檢查這些問題：

- 有沒有把工具成功當成任務成功
- 有沒有把 fallback 當長期完成態
- 有沒有漏驗證
- 有沒有只做文件、沒有推進主線
- 有沒有過度優化單點，傷到整體目標
- 有沒有使用者新指令被舊脈絡蓋掉
- 有沒有 compact 後會遺失的關鍵資訊

### 5. 重新決策

在以下選項中拍板一個：

- 繼續原主線
- 收斂成最小完成
- 先補驗證
- 暫停實作，重寫計畫
- 先寫入狀態檔或 `/save`，再 compact
- 放棄目前支線，切回真正目標

## 回覆格式

預設用這個格式，保持短：

```md
目前判斷：
- 原始目標：...
- 現在真相：...
- 主線進度：...%

盲點 / 風險：
- ...

下一步：
- ...
```

如果情況很簡單，可以壓成三句：

1. 現在在做什麼
2. 最大偏差或風險是什麼
3. 下一步做什麼

## 何時建議轉用其他 skill

- 需要把狀態寫進專案：用 `/save`
- 要交接給新 session：用 `hand-off`
- 到了適合清 context 的里程碑：用 `strategic-compact`
- 已經有明確可並行任務：再考慮 `lilbots-deploy` 或 `bigbots-deploy`

## 完成標準

只有以下都完成，才算 recenter 完成：

1. 原始目標已重新表述
2. 當前真相與推測已分開
3. 主線進度已用百分比表示
4. 至少列出一個可能盲點或明確說沒有明顯盲點
5. 下一步已具體到可以立刻執行
