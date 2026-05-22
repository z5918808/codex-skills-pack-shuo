---
name: codex-app-cleanup
description: Use when Codex App 變慢、sessions 或 logs 過大、需要盤點或歸檔 7 天前 threads、輪替 logs、整理全域 Codex 狀態，或建立週期清理流程
---

# Codex App Cleanup

## 核心判斷

Codex App 變慢時，先處理全域 hot path，不要跳去每個 repo 或 thread。

主要位置：

- `C:\Users\user\.codex\sessions`
- `C:\Users\user\.codex\archived_sessions`
- `C:\Users\user\.codex\logs_*.sqlite*`
- `C:\Users\user\.codex\state_*.sqlite*`
- `C:\Users\user\.codex\config.toml`
- `C:\Users\user\.codex\.codex-global-state.json`
- `C:\Users\user\.codex\session_index.jsonl`

本機冷 archive 預設統一放在：

- `E:\CodexArchive\archived_sessions`
- `E:\CodexArchive\archived_logs`
- `E:\CodexArchive\backups`

`cleanup_reports` 仍保留在 `C:\Users\user\.codex\cleanup_reports`，方便 Codex App 與後續 repair 找 report / manifest。

## 預設政策

- 先 inspect，再 apply。
- Codex App 正在跑時，只能 dry-run，不准搬動 session、state DB 或 log DB。
- 預設 cutoff 是 7 天。
- 使用者明確要求「7 天前所有 thread 歸檔」時，pinned 只標記，不自動排除。
- 只有使用者明確要求保留 pinned 時，才加 `-KeepPinned`。
- 不刪資料；只備份、搬移、歸檔、輪替 log。
- 重要主線要先做 handoff doc，但只做仍活躍的重要 thread，不需要每個 thread 都做。

## 操作順序

1. 先跑 dry-run，確認候選數、體積、pinned 候選、最大檔案。
2. 若有重要舊 thread，先產 handoff doc。
3. 關閉 Codex App。
4. 從外部 PowerShell 跑 apply。
5. 重開 Codex App。
6. 驗證 active sessions 變小、logs 變新、pinned 狀態符合預期、Codex 開啟正常。

## 指令

Dry-run，可在 Codex 開著時跑：

```powershell
pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\codex-app-cleanup\scripts\codex-cleanup.ps1"
```

Apply，必須先關閉 Codex App：

```powershell
pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\codex-app-cleanup\scripts\codex-cleanup.ps1" -Apply
```

指定 E 槽 archive root：

```powershell
pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\codex-app-cleanup\scripts\codex-cleanup.ps1" -ArchiveStorageRoot "E:\CodexArchive" -Apply
```

把既有 C 槽冷 archive / logs / backups 遷移到 E 槽，並改寫 state DB 裡的 archived rollout path。必須先關閉 Codex App：

```powershell
pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\codex-app-cleanup\scripts\codex-cleanup.ps1" -ArchiveStorageRoot "E:\CodexArchive" -MigrateExistingArchivesToStorage
```

保留 pinned threads：

```powershell
pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\codex-app-cleanup\scripts\codex-cleanup.ps1" -Apply -KeepPinned
```

調整天數：

```powershell
pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\codex-app-cleanup\scripts\codex-cleanup.ps1" -ArchiveOlderThanDays 14
```

## 驗證標準

完成後要回報：

- dry-run 或 apply 狀態
- cutoff 日期
- active sessions 原始大小
- 候選數與候選大小
- pinned 候選數
- logs 是否需要 rotate / 是否已 rotate
- state DB 是否有 active thread 指向缺失 rollout path
- config 是否有 missing/temp/case-duplicate project entries
- 備份位置
- report / manifest 位置
- blocker，如果有

## Repair 模式

如果之前已經移動 sessions，但 `state_5.sqlite` 還有 active thread 指向缺失檔案，先關閉 Codex App，再跑：

```powershell
pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\codex-app-cleanup\scripts\codex-cleanup.ps1" -RepairStateDbFromLatestManifest
```

這只同步 Codex state DB，會先備份 `state_*.sqlite*`，並產生 `restore-sessions.py`。

若舊 apply manifest 不只一份，優先跑全量 repair：

```powershell
pwsh -ExecutionPolicy Bypass -File "$env:USERPROFILE\.codex\skills\codex-app-cleanup\scripts\codex-cleanup.ps1" -RepairStateDbFromAllApplyManifests
```

全量 repair 會先同步所有 apply manifests，再把舊於 cutoff、rollout 檔已不存在、未 pinned 的 active residue 標成 archived；會先備份 state DB，並產生 manifest 與 restore script。

桌面捷徑 `Codex Cleanup Apply + Repair.lnk` 會先關閉 Codex App，再依序跑既有 archive 遷移、Apply、全量 Repair、Verify，最後輸出 Final summary 的 PASS / FAIL；預設 archive storage root 是 `E:\CodexArchive`。

沒驗證前不要說完成。
