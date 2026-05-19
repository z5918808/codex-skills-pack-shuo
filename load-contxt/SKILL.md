---
name: load-contxt
description: Use when starting a new conversation and the user wants to resume project work from previously saved continuity, handoff, or status notes such as /load_contxt, 接上上一個對話, 讀 continuity 後繼續, or similar.
---

# LOAD-CONTXT

`/load_contxt` 的目的不是回顧聊天，而是把新對話快速拉回「現在真的該做什麼」。

它現在主要對接 `close-out`：前一個對話負責寫回 project truth，新的對話負責把那份 truth 讀回來並接棒。

從現在開始，**優先讀 thread continuity，不要把 repo 內所有 continuity 混成同一團再整理。**

## 何時使用

當使用者要你：

- 在新對話接上上一輪進度
- 讀 continuity / handoff / status 後直接繼續
- 避免因換 thread 而丟主線
- 用 `/load_contxt` 作為新 session 的起手式

## 核心原則

1. 以專案內可驗證檔案為準，不靠對話記憶猜。
2. 先找最接近主線的 continuity，再看 handoff、status、state、logs。
3. 不要把 continuity 原封不動重貼；要收斂成「目前判斷 / 下一步 / 已驗證 / 待確認」。
4. 如果主線已清楚，除非使用者明確說只讀不做，否則直接推進最小下一手。
5. 若 continuity 與現況衝突，以最新可驗證現況為準，並明確指出衝突。
6. 若 repo 內有多個 thread，先找對 thread，再開始讀；不要一次把所有 thread note 倒進腦袋。

## 預設讀取順序

依序找最適合的來源：

1. 使用者明確指定的 thread continuity 檔
2. 專案內既有、且明確屬於當前 thread 的 campaign / handoff / status 檔
3. `docs/memory/THREAD_INDEX.md` 用來找 thread 路由
4. `docs/memory/threads/<thread-slug>.md`
5. `docs/memory/project_spine.md` 只作跨 thread 共用背景補充
6. 舊的 `docs/memory/session_continuity.md` 只作遷移參考
7. 與 continuity 對應的 state、log、verify 輸出

若找到多份檔案，優先採：

- 最近更新
- 最貼近目前工作目錄
- 有明確 `下一手` / `blocker` / `已驗證真相` 的文件
- thread 名稱與目前任務最一致

若發現多個 thread 都可能相關，先選最貼近當前請求的一個；其他 thread 只保留成「可能相關」，不要全部混讀。

## 讀完後至少要收斂這 6 項

1. `thread`
2. `目前相位`
3. `主線`
4. `已驗證真相`
5. `主要 blocker / 風險`
6. `現在最合理的下一手`
7. `需要立刻打開或驗證的檔案 / 指令 / 狀態`

## 預設回報格式

優先用短格式：

```md
## 目前判斷
- …

## 下一步
- …

## 結果
- 已驗證：…
- 待確認：…
```

如果使用者不是只要摘要，而是要你「接著做」，那在回報 `下一步` 後就直接執行。

## 工作流

1. 先看專案根目錄與既有 continuity / handoff / status 檔。
2. 先判斷這次要接的是哪個 thread；必要時先看 `THREAD_INDEX.md`。
3. 判斷哪一份最能代表上一輪收斂出的主線。
4. 補看必要的 verify / state / log，避免把舊 note 當最新真相。
5. 用最短文字告訴使用者：
   - 剛讀到什麼主線
   - 現在卡在哪
   - 下一步要做什麼
6. 若使用者沒有要求只討論，直接執行最小但有意義的下一手。
7. 若 continuity 過期、互相矛盾或缺欄位，先明講，再自己補查現況，不要停在抱怨檔案不完整。

## 與 close-out 的銜接規則

- 預設優先讀 `close-out` 寫入的 thread continuity 檔。
- 若 note 內有：
  - `下一手`
  - `關鍵檔案 / 驗證`
  - `不要再碰什麼`
  就把它們視為新對話的起手邊界。
- 若有 `thread` 欄位，先把自己鎖定在該 thread，除非現場證據明確顯示主線已切換。
- 若 note 有明寫 MemPalace 已同步，可把 MemPalace 當補充檢索，不可反客為主取代 repo 內現況。

## 禁止事項

- 不要只念摘要，不接回主線。
- 不要把舊 continuity 當成最新真相，卻不看現場狀態。
- 不要因為找到很多 note 就全部攤給使用者自己消化。
- 不要把新對話變成「我先整理一下」的拖延現場。
- 不要把不同 thread 的 continuity 混成單一總結。

## 完成標準

只有在以下條件都成立時，才算 `/load_contxt` 完成：

1. 已找到並讀過最相關的 thread continuity / handoff / status
2. 已把 thread、主線、phase、blocker、下一手收斂清楚
3. 已指出哪些是已驗證、哪些待確認
4. 若使用者不是只要摘要，已開始執行最小下一手
