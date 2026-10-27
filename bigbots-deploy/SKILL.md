---
name: bigbots-deploy
description: "/bigbots-deploy：在本次明確授權及模型 gate 允許時，派三位 Sol/medium 唯讀分析者，由 Main 整合。"
---

# Bigbots Deploy

這是三人分析技能，不承接實作或檔案寫入。只有目前任務的使用者明確叫用 `/bigbots-deploy` 或 `$bigbots-deploy` 才啟動；討論或修改本技能不算叫用。三個子代理固定使用`gpt-6.1-sol` 與 medium effort；若固定的 `bigbots_sol` 角色不是該模型，停止派遣並回報。需要其他模型或 effort 時使用 `$bots-deploy`。

先讀本機 `~/.codex/skills/_shared/bot-dispatch.md` 的共用派遣規則，並遵守本技能更窄的唯讀與三角色限制。

## 三個切點

Main 先定義同一個待分析問題、原始證據、權限與需要的決策，再給三個子代理不同的責任：

1. **事實與來源**：核對現況、原始資料、已知限制；指出未驗證的主張。
2. **反例與風險**：找出會讓方案失效的情境、衝突與代價；提出可判別的證據。
3. **替代方案**：比較最小可行修正與其他方案、整合影響及驗收方式。

三者可讀同一資料，但各自只回答自己的切點，直接交回 Main。不得彼此派工、互相背書、編造不同意見或寫入檔案。Main 查核並整合結論，不把投票當成驗收。

## 派遣

- 核對 `gpt-6.1-sol/medium` 在主機可用，並以它作為本次 `$selectedSol`。確認當下 collaboration tool schema 已載入 `bigbots_sol`，且角色固定為該模型/medium、唯讀。若角色、實際模型或容量不符，不改用 Terra、另一 effort 或預設角色，也不建立探測用子代理。
- 對三個切點各建立唯一 planned subtask ID。依 `~/.codex/harness_docs/10_model_dispatch.md`，以本次明確叫用的原始使用者訊息、來源和時間建立各自的 Sol 授權紀錄；確認沒有撤回。每次 spawn 前執行 `subagent_model_gate.py --agent-config ~/.codex/agents/bigbots_sol.toml --selected-model <selectedSol> --selected-effort medium --task-id <該切點ID> --sol-approval <該切點授權紀錄>`。非零即停止該次派遣。
- 顯式使用 `agent_type="bigbots_sol"`、`model=<selectedSol>`、`reasoning_effort="medium"`、`fork_turns="none"`。每份任務包只含該切點、相同的原始問題與必要證據、唯讀範圍、禁止動作、證據要求與停止條件。當容量只有兩個 child slot 時分成 2+1 波；第三人仍只收到原始輸入，不收到前兩人的答案，保持獨立切點。
- 收件只要精簡結論、可定位證據、未確定處與建議。Main 查核關鍵主張，處理分歧，交付一份綜合分析。未完成三個角色時明示已完成數與阻礙，不宣稱三方分析已完成。

## 安裝條件

本包提供工作流程，未包含 `bigbots_sol` 執行角色、`~/.codex/agents/bigbots_sol.toml`、共用派遣規則、`subagent_model_gate.py` 或 `harness_docs/10_model_dispatch.md`。先在主機配置並確認這些實際入口。缺角色、工具或 gate 時回報缺口，保持停止派遣；單獨複製本技能不能建立角色或取得授權。改用 `bots-deploy` 也須另行安裝該技能及取得本次模型／effort 的明確授權。
