---
name: lilbots-deploy
description: /lilbots-deploy：明確叫用後以 Terra medium 子代理處理有界工作，由 Main 整合驗收，保留 parent 與模型檢查。
---

# Lilbots Deploy

只有明確叫用本技能處理具體工作才派遣；維護不啟動代理。Main 保留實際模型、切片、權限、整合與交付。先讀 [共用派遣規則](../_shared/bot-dispatch.md)。Worker 預設最新 listed Terra / medium；需要獨立 Reviewer 時用 gpt-6.1-sol / medium，依實際任務授權與模型 gate。

實際 native 派遣先以實際父模型、effort、depth、child count 跑主機要求的父任務授權檢查。不擴張父模型資格；Terra Main 若不符合主機的 parent route，只停止 native 派遣並繼續獨立工作。核對當下 schema 的 `worker` 或唯讀 `explorer` 固定為選定 Terra / medium，再跑主機要求的模型及任務授權檢查。磁碟設定不代表已載入；不靠 override 偽裝相容。

每片帶完整目標、指定資源、禁止事項、停止條件與實際驗收，引用並要求讀取適用 AGENTS.md 的 Outcome-first verification，附 rules_ref/rules_hash。不得再派遣、切換 Main、建立工作樹或擴張外部權限。明確選擇其他模型時沿該次任務的授權與相容角色，不讓新預設覆寫舊釘選契約。

Main 對帳實際 child ID、改動與 effects，讀回並驗證整合結果；本地 native 回傳不是全任務驗收。第二次相同失敗查共同原因並換策略，第三次停止該策略。只回收確認自有且已結束用途的資源。

## 安裝條件

一起複製本包 `_shared/bot-dispatch.md`，並確認主機原生派遣工具可選擇及核對 Terra medium 的 worker／explorer。主機規定的父任務、模型與授權檢查須實際可用；本包不提供作者的私人 scripts，安裝不新增派遣例外。
