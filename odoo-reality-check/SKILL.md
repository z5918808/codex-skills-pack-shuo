---
name: odoo-reality-check
description: Verify real Odoo field truth when front-end labels, Studio translations, report output, and backend technical fields may disagree. Use when the task is "這個欄位到底是哪來的", "為什麼前台顯示是這樣", "列印為什麼少欄位/名稱不對", "這個品名到底吃 product 還是 order line", or any time you need live source-of-truth before changing Odoo views, reports, or logic.
---

# Odoo Reality Check

先查 live 真相，再談修法。這個 skill 專門拿來避免把：

- `product.name`
- `display_name`
- `x_studio_*`
- related 欄位
- 前台翻譯字樣
- QWeb 列印顯示

混成一團。

## 核心原則

1. **先看 live record，不先猜欄位。**
2. **先分層**：資料層、翻譯層、列印層。
3. **用實際單據驗證，不只看 `fields_get`。**
4. **把已驗證真相寫進專案紀錄**，不要只留在對話。

## 什麼時候用

- 使用者問「這個欄位是哪來的」
- 前台顯示與後台欄位名稱對不上
- Studio 翻譯名稱讓語意變模糊
- 報價單 / 銷貨單 / picking 列印名稱看起來不對
- 同一個值可能來自 `product`、`sale.order.line`、`stock.move`、`account.move`
- 要改報表前，先確認真實欄位來源

## 工作流

### 1. 鎖定目標物件

先抓最小可驗證對象：

- 指定單號，例如 `S202604200089`
- 指定產品，例如 `product.product(294776)`
- 指定報表 view / action
- 指定前台看到的字，例如 `研發類費用`

不要一開始就泛查整個 model。

### 2. 查三層真相

#### A. 資料層

用 live Odoo API 查實際 record 值，至少對：

- 主 record
- 關聯 record
- 真正列印會用到的 line record

常見優先順序：

1. `sale.order.line`
2. `stock.move / stock.move.line`
3. `product.product`
4. `product.template`
5. `account.move`

#### B. 翻譯 / 命名層

分清楚：

- 技術欄位名：`x_studio_specification`
- record value：`研發類費用`
- 前台標籤：`規格` / `品名`
- 使用者口語：`產品名稱`

這四個很常不是同一件事。

#### C. 列印 / 邏輯層

查 QWeb / view 真正吃哪個來源：

- `product.name`
- `product.display_name`
- `sale.order.line.name`
- `sale.order.line.x_studio_specification`
- related field
- conditional branch (`fmt == 'blank'`, `show_invoice_number` 之類)

## 常見陷阱

### 1. `product.name` 不等於使用者認知的品名

有些專案把料號放在 `product.name`，真正商業名稱放在：

- `sale.order.line.x_studio_specification`
- `product.x_studio_specification`
- `sale.order.line.name`

### 2. `display_name` 只是顯示字，不一定是邏輯來源

很多地方看起來像「同一欄」，其實只是 Odoo UI 顯示字串。

### 3. 前台欄名不是技術欄位

`規格`、`品名`、`備註` 很常只是翻譯 label，不是 technical source。

### 4. 報表少欄位，常常是條件 gate 寫錯

像：

- `發票日期` 被綁到 `show_invoice_number`
- `blank` 被錯套 `prov/svf` 的 gate

這種不是資料沒有，是模板邏輯錯。

### 5. related 欄位容易讓人誤判

例如 `廠商單號` 看起來像報關號，結果其實只是 `purchase.partner_ref`。

## 建議工具路徑

在 `anti-odoo` 這類專案，優先沿用 repo 既有 helper：

- `scripts/export_odoo_custom_assets.py` 裡的 `OdooJsonRpc`

不要每次重新手寫一套 RPC client，除非目前 repo 沒有可用 helper。

## 紀錄要求

每次做完 reality check，至少留下：

- 查了哪個 record
- 查了哪些欄位
- 哪個值是 live 真相
- 哪個前台語意其實對應哪個技術欄位
- 哪個報表條件是錯的 / 哪個是刻意設計

建議寫到：

- `reports/odoo_reality_check_YYYYMMDD_<topic>.md`

## 回報格式

1. **已驗證真相**
2. **常見誤解 / 衝突點**
3. **這次列印 / 畫面實際吃哪個欄位**
4. **待確認**

## 參考

- 需要案例時，讀 [references/live-truth-patterns.md](references/live-truth-patterns.md)
