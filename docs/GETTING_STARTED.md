# Codex Skills 新手使用指南

這份指南帶你完成四件事：選 skill、安裝、在 prompt 觸發，以及安全地更新或移除。

## 1. Skill 是什麼

Skill 是一份可重用的工作流程。它通常放在一個同名目錄中，入口是 `SKILL.md`：

```text
diagnose/
├── SKILL.md
├── agents/       # 選用
├── references/   # 選用
└── scripts/      # 選用
```

你不需要先讀完整內容。安裝後，只要在 prompt 明確點名，Codex 會在任務需要時讀取。

```text
請使用 $diagnose，先重現錯誤，再找 root cause。
```

## 2. 安裝前準備

你需要：

- Git。
- 可使用本機 skills 的 Codex 環境。
- 寫入使用者 skills 目錄的權限。

預設安裝位置：

- Windows：`%USERPROFILE%\.codex\skills`
- macOS / Linux：`~/.codex/skills`

如果你的 Codex 設定使用不同目錄，請以實際設定為準。

## 3. 下載

```bash
git clone https://github.com/z5918808/codex-skills-pack-shuo.git
cd codex-skills-pack-shuo
```

## 4. 安裝單一 skill

新手建議先裝一到三個，不必整包複製。若使用具有相依關係的完整工作流，請依對應章節一次安裝完整集合。

### Windows PowerShell

```powershell
$skillsRoot = Join-Path $env:USERPROFILE ".codex\skills"
New-Item -ItemType Directory -Force -Path $skillsRoot | Out-Null
Copy-Item -LiteralPath ".\diagnose" -Destination $skillsRoot -Recurse -Force
```

### macOS / Linux

```bash
mkdir -p ~/.codex/skills
cp -R ./diagnose ~/.codex/skills/
```

把 `diagnose` 換成任何 skill 目錄名稱即可。

## 5. 安裝整包

整包安裝只複製含 `SKILL.md` 的目錄，不會複製 repository 的 README、docs 或 `AGENTS.md`。

### Windows PowerShell

```powershell
$skillsRoot = Join-Path $env:USERPROFILE ".codex\skills"
New-Item -ItemType Directory -Force -Path $skillsRoot | Out-Null

Get-ChildItem -Directory |
  Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md") } |
  ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $skillsRoot -Recurse -Force
  }
```

### macOS / Linux

```bash
mkdir -p ~/.codex/skills

for dir in */; do
  if [ -f "${dir}SKILL.md" ]; then
    cp -R "$dir" ~/.codex/skills/
  fi
done
```

安裝後重新開啟 Codex task，讓 skill index 重新載入。

## 6. 安裝 Matt 工程工作流

Matt 工程工作流會依任務狀態選擇需求釐清、規格、拆票、實作、審查或驗證階段。因為這些 skills 彼此組合使用，請一次安裝完整集合。

### Windows PowerShell

```powershell
$mattSkills = @(
  "ask-matt",
  "setup-matt-pocock-skills",
  "grill-with-docs",
  "domain-modeling",
  "codebase-design",
  "to-spec",
  "to-tickets",
  "implement",
  "prototype",
  "tdd",
  "code-review",
  "improve-codebase-architecture",
  "triage",
  "diagnosing-bugs",
  "wayfinder",
  "research",
  "grill-me",
  "grilling",
  "handoff",
  "writing-great-skills",
  "matt-flow"
)

$skillsRoot = Join-Path $env:USERPROFILE ".codex\skills"
New-Item -ItemType Directory -Force -Path $skillsRoot | Out-Null

foreach ($name in $mattSkills) {
  Copy-Item -LiteralPath (Join-Path $PWD $name) -Destination $skillsRoot -Recurse -Force
}
```

### macOS / Linux

```bash
matt_skills=(
  ask-matt
  setup-matt-pocock-skills
  grill-with-docs
  domain-modeling
  codebase-design
  to-spec
  to-tickets
  implement
  prototype
  tdd
  code-review
  improve-codebase-architecture
  triage
  diagnosing-bugs
  wayfinder
  research
  grill-me
  grilling
  handoff
  writing-great-skills
  matt-flow
)

mkdir -p ~/.codex/skills

for name in "${matt_skills[@]}"; do
  cp -R "./$name" ~/.codex/skills/
done
```

重新開啟 Codex task 後，在每個 repository 第一次使用時先完成設定：

```text
請使用 $setup-matt-pocock-skills，設定 issue tracker、triage labels 與 domain docs。
```

之後用 `matt-flow` 從目前已有的證據進入最近的必要階段：

```text
請使用 $matt-flow，根據目前已有的規格和程式碼完成這項功能，並做到驗證通過。
```

`matt-flow` 只會在你明確指定時啟用。預設會重用已完成的階段；只有你明確要求完整、從頭或重建流程時，才會跑較重的路線。

## 7. 第一次怎麼用

最穩定的格式是：

```text
請使用 $skill-name。

目標：
我真正要完成的結果。

範圍：
可以讀寫哪些檔案或系統。

完成條件：
要看到哪些 test、command、畫面或 artifact 才算完成。
```

範例：

```text
請使用 $repo-bootstrap。

目標：
替這個新 repo 建立最小 Codex 工作約定。

範圍：
只處理 AGENTS.md 與必要的驗證入口，不改產品程式碼。

完成條件：
規則短而可執行，並指出至少一個可重跑驗證命令。
```

## 8. 不知道該選哪個

先從問題類型判斷：

| 你的情況 | 建議 skill |
|---|---|
| 不知道目前是否真的完成 | [`check`](../check/) |
| 有 Bug 或測試失敗 | [`diagnose`](../diagnose/) |
| 一直修小問題但沒有前進 | [`step-back-and-think`](../step-back-and-think/) |
| 新 repo 沒有工作規則 | [`repo-bootstrap`](../repo-bootstrap/) |
| 要做高風險操作 | [`risk-preflight`](../risk-preflight/) |
| 要做安全審查 | [`security-review`](../security-review/) |
| 要跨 task 保存狀態 | [`handoff`](../handoff/) 或 [`resume`](../resume/) |
| 長任務要有獨立 Runner | [`duo-long-running`](../duo-long-running/) |
| 想改善 UI | [`impeccable`](../impeccable/) 或 [`critique`](../critique/) |
| 想用白話理解狀態 | [`question-eli10`](../question-eli10/) |
| 想讓工程工作流自動選擇目前階段 | [`matt-flow`](../matt-flow/) |

完整分類請看 [README 的 Skill 目錄](../README.md#skill-目錄)。

## 9. 可以組合 skills 嗎

可以，但不要一次指定太多。通常兩到三個已足夠。

```text
請先使用 $diagnose 找 root cause。
確認修復方向後，用 $tdd 寫 failing test，再做最小修復。
完成前使用 $check 反查結果。
```

常見組合：

- 修復 Bug：`diagnose` → `tdd` → `check`
- 新 repo：`repo-bootstrap` → `security-review`
- 改善 UI：`critique` → `shape` → `polish`
- 長任務：`prompt-for-goal` → `duo-long-running` → `handoff`
- 高風險工作：`risk-preflight` → 對應領域 skill → `check`

## 10. Skill 沒有被觸發

依序檢查：

1. 目錄是否位於正確的 `skills` 根目錄。
2. 目錄內是否直接存在 `SKILL.md`，而不是多包一層同名目錄。
3. `SKILL.md` 是否有 YAML frontmatter、`name` 與 `description`。
4. 是否重新開啟 Codex task。
5. Prompt 是否明確寫出 `$skill-name`。

錯誤結構：

```text
~/.codex/skills/diagnose/diagnose/SKILL.md
```

正確結構：

```text
~/.codex/skills/diagnose/SKILL.md
```

## 11. 更新

先更新 repository：

```bash
git pull --ff-only
```

再重新執行單一 skill 或整包安裝命令。複製前若你曾自行修改已安裝版本，請先做 diff 或備份；不要默默覆蓋自己的客製內容。

## 12. 移除

移除只需刪除明確的 skill 目錄。

### Windows PowerShell

先確認目標：

```powershell
$target = Join-Path $env:USERPROFILE ".codex\skills\diagnose"
Resolve-Path -LiteralPath $target
```

確認輸出正確後再移除：

```powershell
Remove-Item -LiteralPath $target -Recurse
```

### macOS / Linux

```bash
rm -r ~/.codex/skills/diagnose
```

不要對整個 `~/.codex/skills` 執行遞迴刪除。

## 13. `AGENTS.md` 要一起安裝嗎

不需要。

Repository 根目錄的 `AGENTS.md` 是可選 starter contract，不是 skill。只有在新專案真的需要時才審閱並複製到 project root；不要覆蓋既有 `AGENTS.md`，也不要直接放到 global scope。

## 14. 安全提醒

- Skill 不會創造外部系統權限。
- Dry-run 成功不代表已獲准執行 live action。
- 不要把 API key、token、cookie、`.env` 或客戶資料貼進公開 issue、PR 或報告。
- Production、database、金錢、bulk write、upload、delete 前，先用 `risk-preflight`。
- 第一次使用會寫檔或呼叫外部系統的 skill 時，先讀它的 `SKILL.md`。

## 15. 驗證這份 skill pack

從 repository root 執行：

```powershell
node --experimental-strip-types .\skill-cleaner\scripts\validate-skill-index.ts --root .
node --experimental-strip-types --test .\skill-cleaner\scripts\validate-skill-index.test.ts
```

驗證通過只代表結構與索引規則正確，不代表每個外部工具、登入態或專案條件都已具備。
