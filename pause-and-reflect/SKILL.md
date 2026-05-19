---
name: pause-and-reflect
description: Use when the user asks Codex to pause mid-work, recenter, autoresearch lightly, inspect whether current work is genuinely going well, avoid over-focusing on a local detail, look at the project from a big-picture view, detect fake success, or invoke "/pause-and-reflect", "pause and reflect", "稍微 Recenter / Autoresearch", "不要鑽牛角尖", "俯瞰專案", "是否有假成功", "檢查現在工作是否順利".
---

# Pause And Reflect

`pause-and-reflect` 是任務中途的主線稽核器。使用它來短暫停手、讀現場真相、俯瞰專案、抓假成功，然後選出下一個最小但有槓桿的行動。

它結合 `recenter` 的主線回正與 `autoresearch` 的 bounded evidence loop，但只做輕量檢查；不要把它變成長篇研究、重寫計畫，或逃避執行的儀式。

## 核心原則

1. 先停下來看現況，不要沿著慣性繼續做。
2. 先看 live truth，再判斷；不要把對話記憶、印象或摘要當成現況。
3. THINK BIG：先看主線、產品、產線、完成標準，再看局部問題。
4. 找假成功：工具成功、測試片段成功、fallback 成功、文件完成、或 agent 很忙，都不等於 goal 完成。
5. 區分 `已驗證`、`高信心推論`、`待確認`。
6. 若發現可能做錯，視為 blocker：先停、修正、驗證，再繼續。
7. 最後一定拍板下一步；不要只產生分析。

## 快速流程

### 1. 重建主線

用一句話說清楚：

- 原始目標是什麼
- 現在實際在做什麼
- 兩者是否偏離

如果 goal 已經漂移，直接指出偏移，不要美化。

### 2. 讀 live truth

依任務類型讀最小必要現況。優先順序：

1. 使用者最新明確指令
2. terminal、log、process、API、UI、測試輸出
3. 檔案現況、git diff、狀態檔、handoff、可重跑報告
4. 對話記憶與舊摘要

只讀足夠判斷主線是否健康的證據。不要因為觸發此 skill 就展開大規模調查。

### 3. 做輕量 evidence loop

用 1 到 2 個小問題檢查不確定性：

```text
問題：
查了什麼：
已驗證：
推論：
判斷：
```

問題範例：

- 目前宣稱完成的部分，有沒有可重跑驗證？
- 現在卡住的是產品、工具、資料、權限、流程，還是目標定義？
- 是否把 fallback、stub、降級、或暫時 workaround 當成完成態？
- 是否正在過度優化一個局部，而主線沒有前進？
- 是否有使用者最新指令被舊脈絡蓋掉？

### 4. 掃假成功

至少檢查：

- 工具成功是否被誤當成任務成功
- 測試是否只驗到窄案例，沒有覆蓋真正完成標準
- UI 或功能是否只在理想路徑看起來可用
- 文件、報告、計畫是否替代了產品或產線進展
- fallback 是否被包裝成長期完成態
- 長跑任務是否同時改善 product 或 factory；若兩者都沒有，stop and pivot
- 是否留下不可重跑、不可驗證、不可交棒的狀態

### 5. 拍板下一步

只選一個主決策：

- 繼續原主線
- 先補驗證
- 收斂成最小完成
- 切掉支線，回主線
- 暫停實作，重寫計畫
- 建立或更新狀態檔再繼續
- 標記 blocker，換方法或請使用者決策

下一步要具體到能立刻執行，例如「跑完整測試 X」、「開瀏覽器驗證 Y」、「修正 Z 檔案的錯誤處理」、「把 incident 留在狀態檔後回主線」。

## 回覆格式

預設保持短：

```md
目前判斷：
- 原始目標：...
- 現在真相：...
- 主線進度：...%

假成功檢查：
- ...

風險 / 盲點：
- ...

下一步：
- ...
```

若情況很簡單，壓成三句：

1. 現在真相是什麼
2. 有沒有假成功或最大風險
3. 下一步做什麼

## 完成標準

只有以下都成立，才算完成一次 pause-and-reflect：

1. 已重新表述主線與目前狀態。
2. 已至少讀一個 live truth 來源，或明確說目前沒有可讀現場證據。
3. 已分開已驗證事實與推論。
4. 已檢查假成功風險。
5. 已拍板下一個具體行動。
