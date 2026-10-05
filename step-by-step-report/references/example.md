## Mini Template

結論：這條產線不是把資料丟給 AI 就算完成；每一筆都要從 evidence → target → preview → owner → live QA 才能算 production_ready。

1 → Raw data enters

- 做什麼：收 product id、source、current manager state、current front state
- 產出：input evidence pack
- 門檻：product id / source / generation 對得上
- 擋爛品質：避免拿錯產品或 stale artifact

2 → Deterministic gate

- 做什麼：先用程式擋機械錯
- 產出：pass / blocker
- 門檻：schema、hash、欄位、protected fields 全通過
- 擋爛品質：避免 AI 補洞或 writer 漂移

3 → AI semantic gate

- 做什麼：只判斷語意品質，不寫資料
- 產出：structured target / reject reason
- 門檻：語意正確、商用繁中、source-backed
- 擋爛品質：避免怪翻、錯詞、錯圖

4 → Owner gate

- 做什麼：用同代證據重算是否可上線
- 產出：live_ready_ok 或 blocker
- 門檻：完整商品頁全部通過
- 擋爛品質：避免 partial green 當完成

5 → Live and final QA

- 做什麼：小批 live，前台驗證，rollback 保留
- 產出：production_ready
- 門檻：front QA + stable diff + final owner pass
- 擋爛品質：避免 ON / HTTP 200 被誤當完成
