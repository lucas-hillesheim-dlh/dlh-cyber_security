# Post-Mortem Debrief — RT-2026-001

---

## Timeline with OPSEC Classification

| Timestamp | Action | Classification | Notes |
|---|---|---|---|
| 08:00 | Infrastructure verified | ✅ Clean | All services confirmed |
| 08:15 | Implant generated on Kali | ✅ Clean | Through proxychains |
| 08:30 | Direct SSH from Kali to Ubuntu | ⚠️ Mistake | IP logged before proxy configured |
| 08:35 | Implant served over HTTP (port 80) | ⚠️ Mistake | URL path visible in Nginx logs |
| 08:36 | Implant executed on Windows | ✅ Clean | No Defender alert |
| 08:41 | Beacon check-in received | ✅ Clean | Graph API traffic undetected |
| 08:45 | Recon commands executed | ✅ Clean | Async, minimal noise |
| 09:05 | Files exfiltrated | ✅ Clean | Via encrypted C2 channel |

---

## OPSEC Failures Found

### Failure 1 — Kali IP in Ubuntu Logs (Pre-Proxy)
**Evidence:** 231 occurrences of 192.168.56.10 found in /var/log/
**What a defender sees:** Clear attribution of operator IP across all log files,
allowing reconstruction of the full timeline before proxy was configured.
**Prevention:** Configure and verify SOCKS proxy BEFORE any connection to target
infrastructure. Proxy setup should be step 0, not an afterthought.

### Failure 2 — Implant Served Over HTTP
**Evidence:** /var/log/nginx/access.log shows GET /update.exe from 192.168.56.30
**What a defender sees:** A Windows host downloaded an .exe file from an internal
server — highly anomalous and easily detectable by DLP or proxy inspection.
**Prevention:** Use an encrypted channel (HTTPS) for payload delivery, or better,
simulate phishing delivery via email attachment rather than a web server.

### Failure 3 — Sliver Logs Contain Session IP
**Evidence:** 434 occurrences in /home/sliver-op/.sliver/logs/
**What a defender sees:** If teamserver is compromised during an investigation,
full session history including operator IP is recoverable.
**Prevention:** Rotate logs more aggressively. Run log cleanup after each session,
not just post-operation.

---

## Lessons Learned

### What Went Well
- Redirector chain successfully masked C2 infrastructure
- Graph API mimicry made beacon traffic visually indistinguishable
- Agent filtering blocked automated scanners throughout the operation
- Burn notice mechanism provided automated defensive pivot capability
- CDN header masking prevented server fingerprinting

### What to Improve
1. **Proxy-first discipline:** SOCKS proxy must be configured and verified
   before the first connection — not after initial setup is complete
2. **Payload delivery:** Never serve implants over plaintext HTTP.
   HTTPS + a plausible filename (e.g., OneDriveSetup.exe) reduces detection
3. **Log hygiene during operation:** Implement rolling log cleanup every
   30 minutes during active operations, not just at cleanup phase
4. **Implant staging:** Use a multi-stage payload — a small stager that
   downloads the full implant over encrypted channel rather than serving
   the full binary directly

### Recommended Procedure Changes
- Pre-engagement checklist: proxy verified → then connect
- During operation: log wipe every 30 min via cron
- Post-operation: run wipe script within 1 hour of operation end
- Always verify proxy is working with `proxychains4 curl ifconfig.me`
  before starting operations
