---
name: strategic-compact
description: Suggests manual context compaction at logical milestones so long sessions stay usable instead of drifting into random auto-compaction.
origin: ECC
---

# Strategic Compact

這個 skill 的用途很單純：在長 session 裡，提醒你在對的邊界自己做一次手動 compact，而不是等系統在奇怪的時點硬切。

它是**判斷型 skill**，不是自動 hook。  
也就是說，它提供「什麼時候該 compact」的規則，不負責替你在 Codex 裡自動綁設定或偷跑腳本。

## 何時啟用

- 同一個 session 已經跑很久，脈絡明顯變肥
- 任務正在跨 phase：探索 -> 規劃 -> 實作 -> 驗證
- 準備從一條主線切到另一條主線
- 剛完成一個 milestone，接下來要做不同性質的工作
- 你開始感覺回應變慢、失焦，或上下文裡已經塞了太多死路

## 為什麼要 strategic compact

亂數時間點被壓縮，通常很煩，因為：

- 可能切在半套 debug 或半套實作中間
- 剛好把還有用的局部脈絡一起洗掉
- 留下的不是主線，而是雜訊

在對的邊界 compact，通常比較對：

- 探索做完、準備執行時
- 某個 milestone 結束、要進下一段時
- 一條失敗路線已經確認死掉、準備換解法時

## 在 Codex 裡怎麼用

這份 skill 在 Codex 裡的正確用法是：

1. 先把當前主線的可重用結果寫進專案
2. 確認下一步已經清楚，不會因 compact 消失
3. 再手動做 compact，讓下一段工作從乾淨脈絡重新開始

可留下來的東西包含：

- 寫回 repo 的計畫、狀態、TODO、handoff
- 真正改過的檔案
- 已驗證的命令、輸出與結論

不要指望 compact 後還保留：

- 中間推理細節
- 剛剛看過但沒記下來的檔案內容
- 臨時在對話裡講過但沒寫回專案的偏好或判斷

## 什麼時候該 compact

| 階段切換 | 要不要 compact | 理由 |
|---|---|---|
| 探索 -> 規劃 | 要 | 探索通常最肥，規劃是蒸餾後的結果 |
| 規劃 -> 實作 | 通常要 | 只要計畫已寫進檔案或現場已穩，就該清場 |
| 實作 -> 測試 | 看情況 | 若測試強依賴剛改的細節，先別切 |
| Debug -> 下一個功能 | 要 | debug 噪音很容易污染下一段判斷 |
| 半套實作中 | 不要 | 這時切掉最容易把自己坑死 |
| 一條方法已證實失敗 | 要 | 把死路清掉，別讓它繼續佔上下文 |

## 壓縮前檢查

在你真的 compact 前，至少先確認：

- 主線下一步已經能用一句話講清楚
- 關鍵結論已經寫回專案，不只留在聊天裡
- 若有 blocker，已經明確寫出來
- 沒有正在進行中、切掉就會斷氣的操作

## 實務原則

1. 規劃完成後 compact，通常最划算
2. 大型 debug 收斂後 compact，避免把錯誤脈絡一路帶下去
3. 不要在半套實作正熱的時候 compact
4. compact 前先寫，再切；不要賭自己等等記得
5. compact 的目的不是省 token 而已，是保住主線判斷力

## 結論

這個 skill 真正要做的事不是「自動幫你壓縮」，而是提醒你：

**在對的邊界主動清場，讓下一段工作繼續準、繼續快。**
