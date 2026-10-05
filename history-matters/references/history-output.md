格式：

```markdown
/goal [一句話主目標]

Current state:
- Verified: [仍成立的歷史與 live 證據]
- Drifted or unproven: [最新 context 需要校正的點]
- Main bottleneck: [真正限制主線的瓶頸]

Roadmap:
1. [歷史證據校正] - evidence: [可重跑證據]
2. [主線薄片] - evidence: [存在證據]
3. [工廠/驗證補強] - evidence: [同類問題更早被抓到或更便宜被處理]

Rules:
- Do not trust latest context or old memory without evidence.
- Report delta only: verified / changed / blocker / next.
- Stop on evidence conflict, safety gate, missing source, or goal complete.
```

若不需要 terminal-ready `/goal`，只輸出短版：

```markdown
判斷：
[一句話主戰場]

歷史證據：
- Verified: [...]
- Inferred: [...]
- Unknown: [...]

最新 context 校正：
- Still true: [...]
- Drifted: [...]
- Unproven: [...]

未來路線：
1. [...]
2. [...]
3. [...]

下一個最小動作：
[action] -> verify: [evidence]
```
