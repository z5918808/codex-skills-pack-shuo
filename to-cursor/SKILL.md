---
name: to-cursor
description: Use when the user wants Codex to save tokens by acting only as a dispatcher that writes an execution prompt for Cursor to do the heavy implementation, debugging, or long-running work.
---

# To Cursor

## Overview

Codex 在這個技能下只做一件事：把任務收斂成一段可直接貼給 Cursor 的執行 prompt。
不要自己展開重度實作、長鏈 debug、或大規模驗證，除非使用者明確改口要 Codex 親自做。

## When to Use

- 使用者明講要省 Codex token
- 使用者要「給 Cursor 的 prompt」
- 任務適合讓 Cursor 吃長上下文或重度實作
- 使用者要 Codex 當指揮工具，而不是主執行者

不要用在：
- 使用者明確要 Codex 直接改檔
- 只需一句短答，不需要交辦 Cursor

## Output Contract

只輸出一段給 Cursor 的 prompt。
不要加前言、不要再分析一輪、不要附多個方案，除非使用者要求。

預設 prompt 結構：

1. 直接要求 Cursor 實作，不要只分析
2. `目標`
3. `已知事實`
4. `你要做的事`
5. `限制`
6. `完成標準`

## Default Rules

- 預設把 Cursor 視為主執行者，Codex 視為 prompt writer / reviewer
- prompt 內要盡量放已知事實，減少 Cursor 重查成本
- 若任務是重度實作，明講「請直接實作，不要只分析」
- 若使用者有指定模型或平台限制，要寫進 prompt

## Cursor-Specific Constraint

若使用者明確要求走 Cursor 自身路徑，優先把任務表述為：

- 由 Cursor / Cursor agent / `composer2-fast` 執行
- 不要替換成其他獨立 CLI 或外部 auth 路徑
- 不要擅自把需求改寫成「改用 Claude CLI / `claude auth login`」

若目前系統已經綁到別的執行鏈，prompt 裡要直接要求 Cursor 修正成符合使用者指定的 Cursor 路徑。

## Tone

- 白話
- 直接
- 可執行
- 少廢話
