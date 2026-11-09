# 第三方來源與授權聲明

本 repository 收錄的部分 skills 來自 [mattpocock/skills](https://github.com/mattpocock/skills)，同步基準為 commit `ed37663cc5fbef691ddfecd080dff42f7e7e350d`。為符合本套件的索引與安全邊界，部分 frontmatter description 經過縮短，並修正少量過時引用、補上 live-write safety gate；核心工作流保持一致：

- `ask-matt`
- `setup-matt-pocock-skills`
- `grill-with-docs`
- `domain-modeling`
- `codebase-design`
- `to-spec`
- `to-tickets`
- `implement`
- `prototype`
- `tdd`
- `code-review`
- `improve-codebase-architecture`
- `triage`
- `diagnosing-bugs`
- `wayfinder`
- `research`
- `grill-me`
- `grilling`
- `handoff`
- `writing-great-skills`

上述內容依 MIT License 提供：

```text
MIT License

Copyright (c) 2026 Matt Pocock

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

`matt-flow` 是本套件提供的明示啟用路由器，用來選擇上述工作流中的最近必要階段。

## 本次採用的寫作指引

個人技能的修整方法參考 [mattpocock/skills v1.3.1](https://github.com/mattpocock/skills/releases/tag/v1.3.1) 的 `writing-for-agents`、`SKILL-MECHANICS.md` 與 `.agents/invocation.md`；以摘要及來源連結收錄於 `harness-fine-tuning/references/prompting-philosophy.md`。這次沒有整包升級上述第三方技能；其既有來源、MIT 授權與客製差異仍沿原聲明。

## Swarm Planner

`swarm-planner` 改寫自 [am-will/swarms 的技能](https://github.com/am-will/swarms/tree/main/skills/swarm-planner)。上游 [README 的 License 章節](https://github.com/am-will/swarms#license) 標示 MIT，於 2026-10-27 核對；取得的入口及 README 未另列著作權聲明。本包保留來源與 [MIT 條款](./swarm-planner/LICENSE)，並加入模型預設、主機授權／父任務限制及公開相依說明；未複製或執行上游安裝器。

## Verification Before Completion

`verification-before-completion/SKILL.md` 原文來自 [obra/superpowers](https://github.com/obra/superpowers/blob/22f0b463e7a5e579904dd6211a520321035526f7/skills/verification-before-completion/SKILL.md)，同步基準為 commit `22f0b463e7a5e579904dd6211a520321035526f7`，於 2026-11-05 核對。本包只新增允許自動選用的 `agents/openai.yaml`，未修改技能原文。原作依 MIT License 提供，Copyright (c) 2025 Jesse Vincent；完整條款隨目錄保留於 [LICENSE](./verification-before-completion/LICENSE)。

## Untangle Codebase

`untangle-codebase` 來自 [caldoai/skills](https://github.com/caldoai/skills/tree/f3cf47774975a7d9fca45730babf4ff7ad765ada/skills/untangle-codebase)，依 MIT License 提供，Copyright (c) 2026 Maze。本包加入 Codex 手動叫用設定，並依使用者授權限制重構範圍、持續目標與代理派遣。完整條款見 [LICENSE](./untangle-codebase/LICENSE)。

## gstack QA Only

`gstack-qa-only` 改寫自 [garrytan/gstack 的 qa-only](https://github.com/garrytan/gstack/tree/74418edabc0ed566de97a7283e09543604de883c/qa-only)，依 MIT License 提供，Copyright (c) 2026 Garry Tan。本包保留上游 QA 文件、範本與共用章節，將未隨包收錄的文件連回原始版本，並加入 Codex 入口和執行條件。完整條款見 [LICENSE](./gstack-qa-only/LICENSE)。

## Cloudflare Security Audit

`cloudflare-security-audit` 來自 [cloudflare/security-audit-skill](https://github.com/cloudflare/security-audit-skill/tree/c1c8a8c1471069fb0e188eeaff69b8e8db6564a8/skills/security-audit)，依 MIT License 提供，Copyright (c) 2025-2026 Cloudflare, Inc. 本包保留原有稽核文件、驗證器和測試，將入口名稱改為 `cloudflare-security-audit`，以區分既有安全審查技能。完整條款見 [LICENSE](./cloudflare-security-audit/LICENSE)。
