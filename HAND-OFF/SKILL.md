---
name: hand-off
description: Use when starting a new session on an existing project and you need a clean handoff that reads current truth from project files and outputs one long prompt for the next agent without writing any handoff files.
---

# HAND-OFF

## Overview

這個 skill 用來在**不落任何 handoff 檔案**的前提下，讀專案現況並輸出一段可直接貼給新 agent 的長 prompt。目標是保持專案乾淨，同時把主線、真相、風險與下一步一次交接清楚。

## When to Use

- 新開一個對話，要快速接手既有專案
- 使用者說「先讀 handoff / load context / 接手」
- 專案已經有長跑 worker、active stack、session log、repair/review artifacts
- 不想靠對話記憶猜現況
- 使用者明確要求不要新建 handoff 檔案

不要用在：
- 全新專案、沒有可讀現場的情況
- 單純問一個孤立小問題、且不需要全局上下文

## Required Flow

1. 先看專案真相檔
   - `AGENT_STARTUP_SOP.md`
   - `PROJECT_STATUS.md`
   - `docs/SESSION_LOG.md` 最新幾段

2. 再查現場
   - `output/.../active_stack.json`
   - 相關 run dir 的 `state.json / manifest.json / pipeline.log`
   - 實際 worker process

3. 只輸出一段長 prompt
   - 不建立 `LATEST_HANDOFF.md`
   - 不建立 dated handoff note
   - 不更新專案內 handoff 檔
   - 只把接手內容整理成單一長 prompt
   - 讓使用者可直接貼給新 agent

## Output Contract

輸出格式必須是：

- 一段單一長 prompt
- 預設放在一個 fenced code block 裡，方便整段複製
- 不要拆成多個版本
- 不要另外再落任何 handoff 檔

這段 prompt 至少要講清楚：

1. 哪條主線是活的
2. 哪條其實已停或已失敗收尾
3. 哪份 artifact 是目前最值得看的
4. 目前最大 blocker 是什麼
5. 接下來最小但有意義的一步是什麼

建議長 prompt 結構：

1. 專案與目標
2. 目前主線真相
3. 已驗證事實
4. 不要信的舊說法
5. 目前 blocker
6. 建議下一步
7. 必看檔案 / artifact / run dir

## Quick Reference

- 最新 session truth：
  - `docs/SESSION_LOG.md`
- 活動 run 真相：
  - `output/**/active_stack.json`
  - `state.json`
  - `manifest.json`
  - `pipeline.log`

## Common Mistakes

- 只讀 handoff，不查 active stack / worker
- 把 monitor 畫面當真相
- 把舊對話說法當真相
- 一進來就開 patch，沒先確認主線是否仍活著
- 為了交接方便又偷偷落一份 handoff 檔

## Default Prompt Style

- 白話
- 可直接貼給新 agent
- 以外部實在為主，不靠記憶
- 明確列出「現在真相」與「下一步」
