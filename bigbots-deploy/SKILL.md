---
name: bigbots-deploy
description: 使用者叫用 /bigbots-deploy 時，依有效切片派送已授權的 Sol/medium 或 Astra 子代理，由 Main 驗證整合。
---

# Bigbots Deploy

讓已授權的子代理完成有邊界的工作切片；預設 `gpt-5.6-sol/medium`，使用者也可逐任務明確選擇 `gpt-6-astra`。Main 擁有任務切分、權限、風險、衝突處理、驗證與最後結論；不要重做已派出的切片。

只使用 collaboration subagents，不建立使用者可見的新 task/thread。

## Fail-close model lock

- Sol 路由維持 `model="gpt-5.6-sol"`、`reasoning_effort="medium"`，medium 仍是 Sol 的硬上限。只有該子任務取得明確 Astra 授權時，才可選 `gpt-6-astra` 的 `low / medium / high / xhigh / max / ultra`，保留已選 effort。不可改用 Terra、Luna、未指定模型或隱性 fallback。
- 每次 spawn 前，先檢查當下 collaboration tool schema 確實接受這組 model/effort，再執行：

```powershell
python C:\Users\user\.codex\scripts\subagent_model_gate.py --agents-dir C:\Users\user\.codex\agents --selected-model gpt-5.6-sol --selected-effort medium
```

  Repo 若有 `.codex/agents/*.toml`，每個檔案都另加一個 `--agent-config <absolute-path>`。任何非零結果都阻止該次 spawn。
- Astra 路由把上述 selected model/effort 換成實際選定值，並依 `C:\Users\user\.codex\harness_docs\10_model_dispatch.md` 傳入 `--task-id` 與 `--astra-approval`。技能支援或叫用 bigbots 不等於 Astra 授權，不得自製同意紀錄。
- 帶 model override 時，使用 `fork_turns="none"` 與完整 delegation packet；真的需要近期對話時，才用正整數的有限 fork。不可用 `fork_turns="all"`。
- 只有使用者在目前任務明確叫用 `/bigbots-deploy` 或 `$bigbots-deploy`，才算這一輪 Sol subagents 的 fresh approval。若沒有 fresh approval，先取得同意再 spawn。
- 若 schema、model gate、授權、容量或工具不能證明所選路由成立，完全不派子代理、不 fallback、不提高 effort、不假裝 army 已執行。回報 `blocking_rule / missing_proof_or_gate / minimal_safe_next / why_agent_cannot_run_it`。

## Adaptive force size

先列出真正獨立且有驗收證據的工作切片，再決定兵力：

- `N = 1`：任務高度耦合、只有一個有效切片、共享同一寫入面，或新增子代理的邊際效益低。
- `N >= 3`：至少有三個可獨立完成、互不等待、產出不重複的有效切片。
- 不使用 `N = 2`。若只找到兩個候選，合併為一個完整切片；只有找到真實且有價值的第三個研究、實作或驗證責任時才擴成三個。
- 不為湊數創造角色、重複問題或假平行。計畫需要 `N >= 3` 但目前不足三個可用 slot 時，等待容量或回報容量 gate；不可偷偷降成兩個。
- 超過同時可用 slot 的工作分波執行。上一波 terminal 後的 agent 是 disposable，不可重用；新切片使用新的 agent。

## Slice and dispatch

1. 定義 battlefield、成功條件、權限與 frozen surface。
2. 建立最小 slice ledger：`slice_id / depends_on / read scope / write owner / acceptance evidence`。Ready 且互不衝突的切片才可同波。
3. 同一檔案、狀態或決策只能有一個 writer。Read-only 角色可以重疊讀，但問題與證據責任必須不同。
4. 每次 spawn 都重新跑 model gate，並顯式傳入已授權路由的 model/effort。省略 `agent_type`，除非當下 schema 能證明它不會蓋掉 model lock。
5. Main 在波次進行時只做不重疊的協調、讀回、整合準備與驗證，不接手子代理的 bounded task。

每個 delegation packet 必須能在零背景下執行：

```text
Mission and why it matters:
Workspace / inputs:
Your bounded task:
Read scope:
Write scope: none | exact paths
Do not:
Acceptance evidence:
Return only:
  status: completed | failed | blocked | cancelled
  summary: <= 600 chars
  blocker: none | concise blocker
  artifacts: absolute path + SHA256
  next_action:
```

禁止回傳 raw transcript、full log、reasoning 或 tool trace。長內容寫入 artifact；Main 只接收 compact handoff。

## Ingest and verify

- 使用較長的 bounded wait 收件，不忙輪詢。進行中的 agent 偏題時只修正一次；terminal agent 不再派新任務。
- Main 逐一驗證 artifact 存在、SHA256、關鍵內容與對應 acceptance evidence。程式碼跑最相關測試；重要 claim 用第二條便宜路徑反查。
- 去重 findings，將衝突拆成 `觀察 / 證據 / 待決定問題`。子代理結論是證據，不是完成判定。
- 只有 Main 可以 merge、改變 canonical state、判定 ship，並對使用者輸出最後答案。

## Mandatory wave closeout

每波建立 `codex.subagent_wave.v1` manifest。每個 terminal agent 必須記錄：

```json
{
  "agent_id": "...",
  "status": "completed",
  "disposable": true,
  "reuse_allowed": false,
  "merged": true,
  "result_summary": "<= 600 chars",
  "output_artifacts": [{"path": "absolute path", "sha256": "SHA256"}],
  "blockers": []
}
```

Manifest 頂層另含：

```json
{
  "artifact_type": "codex.subagent_wave.v1",
  "main_return": {
    "status": "...",
    "summary": "<= 1200 chars",
    "next_action": "..."
  },
  "subagents": []
}
```

若 agent 沒有 artifact，必須有具名 blocker。用新的 output 路徑執行：

```powershell
python C:\Users\user\.codex\scripts\subagent_lifecycle_gate.py --manifest <manifest.json> --output <audit.json>
```

Gate 失敗只阻止 wave closeout；保留證據、修正 manifest 或回報缺口，不把失敗包裝成完成。

## Stop

所有有用切片已 terminal、lifecycle gate 通過、Main 已驗證原任務 acceptance criteria 時停止。權限與安全界線不因 `/bigbots-deploy` 擴張；需要新權限、live 高風險動作或外部決定時，在邊界前停下。
