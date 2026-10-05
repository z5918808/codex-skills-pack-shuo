---
name: thermo-nuclear-agent-harness-feedback-loop
description: Use when repeated failures, conflicting evidence, or weak workers require a testable harness and feedback loop.
---

# Agent Harness Feedback Loop

反覆故障或相互矛盾的結果，需要可操作的觀測入口及可重跑的驗證迴圈。已有清楚重現與小修正時直接沿現有驗證；缺少需求、必要權限、可觀測結果或只有主觀判斷時，先指出該缺口。

測試選擇與驗收沿所在環境的 Outcome-first verification；使用專案既有 runner、命令及證據。

## 授權與主線

預設作分析 overlay，保留既有主線、roadmap、active workstream、完成標準及記憶契約。使用者要求修復時實作已授權的最小變更。

分析涉及換主線、升級 factory、改 guard／verifier、正式設定或新的 live／order／API／DB 操作時，先提出證據、取捨與建議，依使用者既有授權判斷。範圍外的變更需取得明確授權；分析結論留作建議，不宣告為已採用決策。破壞性、重置、資料庫或正式設定操作依適用 preview、影響與回復 gate 處理。

## 觀測入口

先找到可執行命令、可讀 log、重現步驟、可比較結果及最小可回復路徑。中途加入本技能時沿用已知證據、排除過的假設與可重跑入口。

缺觀測入口時先補最小入口，避免一次改多處。需要 local／cloud 細節時讀 [觀測清單](references/observability.md) 中相關分支；環境設定只讀必要資訊，秘密留在受控位置。

## 迴圈

1. 用具體證據提出一個假設及值得查的理由。
2. 指定能區分假設的命令或觀測、成立時預期結果，再執行。
3. 記錄實際結果，分開成立、排除、部分成立或下一個待查假設。矛盾先釐清；暫時故障需要重跑或另一條證據支持。
4. 結果支持後才做最小可逆修正，再驗證實際使用者結果。測試失敗就回到證據，資訊不足就補入口。

根因、修正及穩定結果都有驗證才完成。安全／必要權限邊界阻擋時報具體缺口；重複查證無新資訊時換方法。已有足夠證據時結束，避免為了完整流程擴張工作。

## 回報

簡述適用性、目標、主線影響、可用／缺少入口、關鍵迴圈結果、已驗證或待驗根因、實際修正、驗收、剩餘風險與下一步。需要交接時附原始證據、排除路線與下一個最小動作。

需要比較測量的例子時讀 [部署診斷範例](references/example.md)。範例只示範查證，不授權平台遷移或 cache 重構。
