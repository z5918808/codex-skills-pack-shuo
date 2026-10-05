# Prompting Philosophy

修整 skill 描述、步驟或參考結構時讀本頁。採用 [mattpocock/skills v1.3.1](https://github.com/mattpocock/skills/releases/tag/v1.3.1) 的 [writing-for-agents](https://github.com/mattpocock/skills/blob/v1.3.1/skills/productivity/writing-for-agents/SKILL.md) 與 [invocation](https://github.com/mattpocock/skills/blob/v1.3.1/.agents/invocation.md)，依目前環境與使用者契約調整。

## 描述與結構

- 描述先說能力，再保留實際觸發分支。合併同義詞；有用途差異的分支各留一個指標。模型可選技能的描述須能判斷適用性；既有明示技能以使用者可讀用途為主，保留環境要求的命令別名。
- 全部分支都需要的規則留入口；只有部分角色、模式或事件需要的內容，移至參考並說明何時讀。規則、定義與例外放在一起。短技能直接自足。
- 每個步驟以可查證、涵蓋該步結果的條件結束。先修清楚驗收，才考慮拆流程；額外任務或 subagent 的權限仍由現行契約決定。
- 優先寫目標行為。必要硬禁止仍保留，並給安全的下一步。每個意思保留一個 owner，刪除重複敘述與能從設定直接查到的環境快取。

## 相依與叫用

保留既有 invocation policy。更改明示／自動叫用需要使用者要求，不能只依參考文章切換。

步驟需要執行另一技能時，明確載入它：環境提供技能工具就一個名稱一次呼叫；Codex 只有檔案工具時，定位並讀取目標 `SKILL.md`，再依其條件讀參考。先核對目標的叫用契約，使用者限定的流程只有在本次已明確授權時才執行。被動查閱方法不等於啟動該流程。工具或授權不足時指出具體缺口，保留獨立工作。

## 驗證

包裝依 `skill-creator`；用實際描述、相依、引用與情境確認可到達結果。保留模型、角色、單一 writer、回復、驗收與停止契約。字數下降只證明入口變小，速度及 agent 行為改善要有實際執行證據。
