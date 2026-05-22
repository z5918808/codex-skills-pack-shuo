# Codex Skills Pack

這個 repo 是一組 Codex skills 的公開分享版本，目標是讓不同使用者都能直接挑選、複製、調整後使用。

這個版本只保留通用 workflow、debug、review、design、document、verification 類 skills；不包含私人專案、特定客戶系統、或需要特定公司環境才能運作的技能。

## 內容

- Skills：可複製到自己的 Codex skills 目錄使用
- `AGENTS.md`：全域 Codex agent defaults 範例
- 隱私處理：已移除本機絕對路徑、個人化資料夾名稱與 runtime cache
- 私用排除：私人專案橋接、特定 ERP / commerce 平台專用技能不放在公開版
- 預設排除：`.system`、`__pycache__`、`.pyc`、`.venv`、marker 檔

## 安裝

把需要的 skill 資料夾複製到你的 Codex skills 目錄：

```powershell
Copy-Item -Recurse -Force .\step-back-and-think "<your-codex-skills-dir>\step-back-and-think"
```

也可以整包同步：

```powershell
robocopy . "<your-codex-skills-dir>" /E /XD .git __pycache__ .venv /XF *.pyc
```

## 維護原則

- 不提交 API key、token、cookie、session、密碼或個資。
- 不提交 runtime cache、編譯產物或本機暫存檔。
- 不提交只能在個人機器、特定公司帳號、特定客戶系統中運作的技能。
- 更新 skill 後，優先確認 `SKILL.md` 的 frontmatter 有 `name` 與 `description`。
- 若 skill 會執行高風險操作，應先寫清楚 dry-run、preview、rollback 與 confirmation 規則。
