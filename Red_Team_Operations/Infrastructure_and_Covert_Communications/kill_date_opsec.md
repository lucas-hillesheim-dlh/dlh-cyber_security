# Kill Date & Jitter — OPSEC Rationale

## Implant Configuration

| Setting   | Value                    | OPSEC Reason                                                                 |
|-----------|--------------------------|------------------------------------------------------------------------------|
| Kill date | 2026-10-21T11:21:51 | Implant self-destructs after operation window. If captured post-op, it won't execute or phone home, limiting forensic value and preventing defenders from repurposing it against your infrastructure. |
| Interval  | 60 seconds               | Balances responsiveness with noise. Very short intervals (1-5s) look like beaconing to a SIEM. Very long intervals reduce operator control. 60s is a reasonable middle ground. |
| Jitter    | 30%                      | Randomizes callback timing between 42-78s. Regular, clock-like intervals are trivially detected by network anomaly detection. Jitter breaks the pattern, making it look like normal periodic background traffic. |

## implants command output

```
(paste output here after running: sliver > implants)
```

## Additional OPSEC Notes

- Kill date prevents stale implants from persisting after an engagement ends
- Jitter is arguably more important than the interval itself — flat timing is a detection signature
- Interval should be tuned to the environment: noisy networks tolerate shorter; quiet networks need longer
