# 角色安裝與設定

只讀檢查與 diff 準備不啟動子代理。先確認目前 Main、可用模型、effort、現有角色與真正載入的設定來源。不要把預設設定當成當前 runtime 證據，也不要覆寫別人的角色、shell/profile、容量或安全政策。

本公開版使用主機正式的角色登記與派遣檢查，不安裝作者的 parent-gate 修改器、hooks 或背景程序。Main 保留實際模型；如果該 Main 不符合主機原生派遣資格，就只停止相依派遣，繼續獨立已授權工作。

完整複製本技能後，在支援以下 config_file 形式的主機中檢查或登記：

```toml
[agents.sol_astra_explorer]
description = "Terra medium read-only code exploration."
config_file = "skills/sol-astra-team/agents/sol_astra_explorer.toml"

[agents.sol_astra_worker]
description = "Terra medium bounded implementation."
config_file = "skills/sol-astra-team/agents/sol_astra_worker.toml"

[agents.sol_astra_researcher]
description = "Terra medium read-only official-documentation research."
config_file = "skills/sol-astra-team/agents/sol_astra_researcher.toml"

[agents.sol_astra_architect]
description = "Sol 6.1 medium read-only review; legacy role name."
config_file = "skills/sol-astra-team/agents/sol_astra_architect.toml"
```

自訂安裝位置須調整路徑。先準備具體 diff，按目前使用者授權套用；缺少授權時才詢問，不重複索取已有的同範圍授權。保留既有容量、Main 模型與安全設定。

重新載入設定後，從當前工具 schema 核對精確角色、模型、effort、可寫範圍與容量。靜態 TOML 不等於已載入或 runtime 隔離；缺角色時不發探測 child 或借用其他技能專屬角色。只有另有實際任務執行叫用才可派遣，維護不啟動團隊。
