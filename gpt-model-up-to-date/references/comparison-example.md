# GPT-6.2 Sol 成本比較實例

2026-11-18 查得的比較，用於示範如何判斷模型選擇。實際升版以當期資料及專案驗收結果為準。

| 模型／effort | Intelligence Index | 估計每題耗時 | 平均每題 API 成本 |
| --- | ---: | ---: | ---: |
| GPT-6.1 Terra／medium | 38 | 2.8 分鐘 | US$0.17 |
| GPT-6.1 Sol／low | 35 | 1.9 分鐘 | US$0.16 |
| GPT-6.2 Sol／low | 41 | 1.4 分鐘 | US$0.18 |
| GPT-6.1 Sol／medium | 46 | 4.3 分鐘 | US$0.36 |
| GPT-6.2 Sol／medium | 53 | 3.1 分鐘 | US$0.41 |

同一公開評測對照顯示，Sol 6.2／low 相對 Terra 6.1／medium 高 3 分，估計時間約一半，平均每題成本多 US$0.01。Sol 原本使用 medium 的角色升版後高 7 分，估計快 1.2 分鐘，平均每題成本多 US$0.05。時間依輸出 token 和 API 速度推估。用專案的實際合格交付衡量節省幅度。[Artificial Analysis 對照](https://artificialanalysis.ai/providers/openai/) · [計算方法](https://artificialanalysis.ai/methodology)

Codex Standard 每百萬輸入／快取輸入／輸出 token，兩代 Sol 為 50／2.5／250 點，Terra 6.1 為 25／1.25／125 點。標準 API 單價依序是 Sol US$2／0.10／10、Terra US$1／0.05／5。每件費用仍取決於實際 token 組成、重試和返工。[Codex 費率](https://learn.chatgpt.com/docs/pricing#token-rates) · [Sol 6.2 公告](https://openai.com/zh-Hant/index/introducing-gpt-6-2-astra-sol/) · [Terra 6.1 公告](https://openai.com/index/introducing-gpt-6-1-terra/)

以商品備料為例，用相同原廠資料與現行終審標準，比對首審通過率、每個終審合格商品頁的耗時與用量。由實際要切換的角色涵蓋需要讀懂的表格或圖面。先重用已具備相同條件的回執，補測足以決定是否換型的部分。
