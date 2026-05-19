# Odoo Live Truth Patterns

## 最小 checklist

1. 找到具體單據 / record id
2. 同時查：
   - 主表
   - line 表
   - product
   - 報表 XML
3. 分清楚：
   - technical field
   - live value
   - UI label
   - rendered output
4. 把衝突寫成一句白話

## 常見來源對照

### 銷售

- `sale.order.name`：單號
- `sale.order.line.name`：行描述，不一定等於產品名
- `sale.order.line.x_studio_specification`：很多客製案會把商業名稱塞這裡
- `product.product.name`：有些公司直接拿來放料號
- `product.product.display_name`：UI 顯示字，不一定是你要的來源

### 庫存 / 出貨

- `stock.picking.origin`：來源單號
- `stock.move.sale_line_id`：回勾銷售行的重要橋
- `stock.move.product_id`：實體扣庫存產品

### 會計 / 發票

- `account.move.invoice_date`
- 客製欄位的發票號碼通常在 `x_studio_*`

## 亮紫研發案例摘要

2026-04-20 已驗證：

- `product.product(294776).name = 99B-999-999-9999-99`
- `product.product(294776).display_name = 99B-999-999-9999-99`
- `product.product(294776).x_studio_specification = 研發類費用-99B-999-999-9999-99`
- `sale.order.line(2866).name = 99B-999-999-9999-99`
- `sale.order.line(2866).x_studio_specification = 研發類費用`

結論：

- 亮紫研發主項若要印成 `99B-999-999-9999-99 研發類費用`
- 應優先取：
  - `sale.order.line.product_id.display_name`
  - `sale.order.line.x_studio_specification`
- 不該只吃 `product.name`
