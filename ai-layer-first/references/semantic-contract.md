## Required AI Evidence

每個 AI 結果至少要留下：

```json
{
  "model_call_attempted": true,
  "model": "...",
  "model_tier": "low|stronger|critic",
  "prompt_version": "...",
  "input_ref": "...",
  "raw_output_ref": "...",
  "validated_output_ref": "...",
  "evidence_refs": [],
  "confidence": {},
  "unknowns": [],
  "fields_to_change": [],
  "fields_to_preserve": [],
  "validators_required": []
}
```

如果 `model_call_attempted=false`，只能標成 rules-only 或 placeholder，不能標成 AI-layer-complete。

## Structured Output

AI 必須回結構化資料，不要只回自然語言，也不要直接回可執行 SQL、API payload、writer call 或權限判斷。

通用輸出形狀：

```json
{
  "decision": "repair|preserve|degrade|escalate|business_decision",
  "target": {},
  "confidence": {},
  "supporting_evidence": [],
  "contradicting_evidence": [],
  "unknowns": [],
  "fields_to_change": [],
  "fields_to_preserve": [],
  "validators_required": [],
  "needs_higher_tier": false
}
```
