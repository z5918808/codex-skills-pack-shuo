### 7. 設計最低可用大工廠

對選中的突破點，產出一個小規格：

- Factory name：這個機制叫什麼。
- Game-board role：它改善哪個主戰場瓶頸。
- Job：它替人或 agent 承擔哪個重複工作。
- Failure class absorbed：它吸收哪一類反覆問題。
- Interface：使用者只需要知道哪些 input、output、command、文件、或規則。
- Hidden work：哪些複雜度被藏到裡面。
- Deleted / simplified：先刪掉或簡化了什麼。
- Owner / state：誰維護，狀態住哪裡。
- First useful version：最小可用版本是什麼。
- Verification：怎麼證明它真的降低重複成本、提前發現錯誤，或縮短 debug / review / release。
- Stop rule：什麼情況下不要繼續擴建。

偏好順序：

1. Delete / simplify requirement、step、part、state、interface
2. Product architecture / module boundary / state ownership
3. Verification point：test / guard / schema / type / assertion
4. Script / command / reusable route
5. Review gate / checklist / release gate
6. Runbook / debug route / recovery path
7. Skill / handoff / agent workflow
8. AGENTS 或 global rule

原則：先刪除，再簡化，再穩定介面，再驗證，再自動化。不要替壞流程蓋工廠。
