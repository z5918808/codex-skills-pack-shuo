---
name: trim-repo-agents-md
description: Use when trimming a repo AGENTS.md while preserving entrypoints, behavior rules, safety gates, and verification.
---

# trim-repo-agents-md

修剪 repo-local `AGENTS.md`。目標不是越短越好，而是讓它像可執行契約：短、準、能改變 agent 行為。

## Scope

1. 預設只改目前 repo 內最近的 `AGENTS.md`。
2. 不改全域 `$env:USERPROFILE\.codex\AGENTS.md`，除非使用者明說全域。
3. 若有多個 repo AGENTS，先列候選；能安全判斷時改離 cwd 最近者。

## Keep

- live truth / 不靠聊天記憶
- 下一步計劃先行
- verification before completion
- 重要入口 command / script
- project-specific safety gates
- long-run / worker / session / tab budget 規則
- completion definition
- AI boundary
- fallback / debug route
- routing to real docs / `_ctx` / scripts / skills

## Cut

- 長篇原因解釋
- 歷史報告與流水帳
- Codex 已知道的通用 coding advice
- 已在全域 AGENTS 出現的重複規則
- 大段 SOP，若可指向真實 script / doc / skill
- stale tool/version/session 細節
- 單次事故細節，除非它是仍有效的 runtime rule

## Preferred Shape

```md
# AGENTS.md

## Core
## Project Truth
## Commands / Entrypoints
## Runtime / Background
## Mainline
## Safety / Apply Boundary
## AI Boundary
## Validator / Launch
## Fallback
## Reporting
```

依專案改名可以，但不要變百科。

## Workflow

1. 量尺寸：line / word / character count。
2. 讀 headings，找膨脹區。
3. 確認被指向的 docs/scripts 存在；不存在就保留最小規則。
4. 重寫成短契約。
5. 回讀驗證：
   - 尺寸明顯下降
   - 關鍵入口仍在
   - safety / validator / completion definition 仍在
   - 沒動全域檔
6. 回報 before/after 與保留重點。

## Style

- 使用繁中。
- 短句。
- 不寫長哲學。
- 不為了漂亮刪掉硬邊界。
- 寧可保留 1 行硬規則，也不要保留 10 行故事。
- 「詳細流程見 X」可以，但 X 必須真的存在。

## Done

完成時回報：

- 改了哪個 `AGENTS.md`
- before / after 尺寸
- 保留哪些主線能力
- 刪掉哪些類型內容
- 是否有缺失的 doc/script/skill routing
