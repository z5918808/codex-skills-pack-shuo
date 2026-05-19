---
name: babysitting
description: Use when the user wants Codex to babysit a live project, service, agent, bot, daemon, or workflow by checking current truth, the latest conversation, and the most meaningful surfaces to inspect; then immediately debug, stabilize, or reconnect the system if something is wrong. Trigger on requests like "顧一下", "babysit", "看一下 Jarvis 好不好", "接回去", "盯著它", "系統怪怪的", or similar.
---

# Babysitting

## 目的

不是做一般 code review，也不是只做分析。

`babysitting` 的任務是：

1. 看專案現況
2. 看最新對話在擔心什麼
3. 抓出現在最值得檢查的表面
4. 若有問題，立刻 babysit 到回穩

一句話：像保母一樣把系統顧住，不讓它在使用者沒盯著時悄悄爛掉。

## 何時使用

當使用者意思接近：

- 幫我看一下這東西現在好不好
- 顧著這個 Jarvis / bot / daemon
- 看看有沒有怪事
- 如果壞了就接回去
- 不知道哪裡有問題，但感覺不對
- 不想自己一層一層翻，叫你先去抓最值得看的地方

## 核心原則

1. 先看公開症狀，再回頭找根因。
2. 先抓最有意義的檢查表面，不做無限巡田水。
3. 若系統健康，明確講健康，不要硬修東西。
4. 若系統不健康，先止血，再追根因，再驗證。
5. 不要只列風險；能接回去就直接接回去。
6. 不要把歷史 log 噪音當成新故障。

## 預設檢查順序

按價值排序，不是全部都看：

1. 最新對話指向的公開症狀
   - 例如 Telechat 回錯、mail 沒發、daemon 停住、畫面怪、輸出怪

2. 最可能影響該症狀的 runtime truth
   - process / PID
   - state 檔
   - lock 檔
   - 最新 log
   - 入口腳本

3. 真正對外的 public path
   - 誰在送訊息
   - 誰在 long-poll
   - 誰在寫 state
   - 誰在決定 fallback

4. 若以上正常，再看次要風險
   - 舊程序殘留
   - 歷史 log 混淆
   - config 漏接
   - memory / checkpoint 沒進主線

## Babysitting 流程

1. 先鎖定「現在要顧的是誰」
   - 專案、bot、daemon、mail 線、browser sidecar、某條 capability

2. 從最新對話抽出當前疑點
   - 使用者實際擔心什麼
   - 最後看到的壞症狀在哪裡出現

3. 挑 1 到 3 個最有意義的檢查面
   - 不要全掃
   - 先看最靠近公開症狀的面

4. 判斷是否真的有問題
   - 若沒有，就回報健康狀態與最該留意的點
   - 若有，就直接進 debug / recover

5. Babysit 回穩
   - 清 stale lock
   - 收斂 duplicate owner
   - restart 正確 daemon
   - 修 log 分代
   - 接回正確主線
   - 補最小必要 patch

6. 驗證
   - 至少一個 runtime 驗證
   - 至少一個 public-path 驗證或 public artifact 驗證

7. 留下真相
   - 若這次 babysitting 有實質修復或釐清真相，寫回 continuity / memory

## 怎麼挑「最值得檢查」的地方

優先檢查這些高訊號表面：

- 正在跑的 process / parent chain
- 最新 active log，而不是整包舊 log
- state / pid / lock / manifest
- 真正對外 sender / router / formatter
- 使用者剛剛提到的那條能力邊界

避免一開始就浪費時間在：

- 全 repo 無差別掃描
- 舊 screenshot
- 已知歷史問題但和當前症狀無關的 branch
- 只做靜態閱讀，不碰 runtime

## 何時直接 debug

只要符合其一，就不要停在分析：

1. 已看到公開症狀
2. 已找到明確 stale process / duplicate owner / broken runtime
3. 已確認 public path 沒接到預期主線
4. 已確認只差最小修補就能回穩

## 何時不要亂修

若發現以下情況，先停下來講 blocker：

- 缺權限
- 缺帳密
- 缺外部系統登入態
- 有兩條以上主線都可能是真 owner，且證據不足
- 需要使用者補一句話才能安全拍板

## 搭配技能

- 若症狀一直陰魂不散，先用 `catch-bugs` 的心法。
- 若要釐清根因，不要跳過 `systematic-debugging`。
- 若修完要宣稱成功，先走 `verification-before-completion`。
- 若 babysitting 產出新的 project truth，順手寫回 `close-out`。

## 回報格式

預設用這個節奏：

1. 目前判斷
2. 我現在先檢查哪裡
3. 結果或 blocker

如果系統健康，也要講清楚：

- 現在誰在活著
- 哪條是主線
- 最值得留意但目前未爆的點

## 禁止事項

1. 不要把 babysitting 做成純分析。
2. 不要把整份舊 log 當成現況。
3. 不要因為看到一個錯字就忘了真正公開症狀。
4. 不要為了顯得勤奮而亂重啟所有東西。
5. 不要把 fallback 說成完成態。
