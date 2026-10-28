# NovaTech Email Security Audit — Phishing Campaign Gap Report

**Prepared by:** SecureTech Inc.
**Audience:** NovaTech Solutions IT Team

---

## 1. Analysis

**Campaign A ("Critical: Update Your VPN Client Immediately")** failed on every authentication check. DKIM verification failed on the signing domain, SPF returned a softfail because the sending IP was not authorized for `novatech-secure-portal.com`, and DMARC — configured with `p=reject`, `sp=reject`, `dis=reject` — rejected the message outright for failing alignment. The mail gateway flagged it accordingly (`X-Spam-Status: Yes, hits=8.5`). The pretext itself (urgent IT/VPN language) is a classic lure, but it never had a chance to reach an inbox cleanly because the sending infrastructure was unauthenticated.

**Campaign B ("Free Lunch Friday – RSVP Required!")** passed DKIM, SPF, and DMARC. The domain `trusted-vendor-news.com` is correctly configured on the attacker's side — its own DKIM signature validates, its SPF record authorizes the sending IP, and its DMARC policy (`p=none`) imposes no restriction. Passing authentication here does **not** mean the sender was legitimate or authorized to contact NovaTech employees — it only means the domain's own records are internally consistent. Nothing in NovaTech's mail flow distinguished "an authenticated domain" from "an authenticated domain NovaTech has never done business with."

### Engagement data (Campaign B, `gophish_campaign_B_metrics.csv`)

| Department | Recipients (sample) | Submitted Data | Clicked Link | Opened Only | Reported |
|---|---|---|---|---|---|
| HR | 3 | 3 | 0 | 0 | 0 |
| IT | 3 | 0 | 1 | 1 | 1 |

All three sampled HR recipients submitted data, typically within 15–45 minutes of send — fast engagement consistent with a low-suspicion pretext delivered to a department with no obvious reason to scrutinize sender domains. By contrast, the IT sample shows a materially different response: one employee reported the email rather than engaging. This gap suggests department-level awareness, not infrastructure, is the deciding factor once a message passes authentication — IT staff are more likely to scrutinize unsolicited external email, HR staff less so.

---

## 2. Critical Gaps

| Gap | Root Cause | Why It Matters |
|---|---|---|
| No DMARC enforcement gap on NovaTech's side for *look-alike/unaffiliated* senders | Authentication validates domain ownership, not sender legitimacy or business relationship | A never-before-seen external domain with no affiliation to NovaTech was able to reach HR inboxes unchallenged because it technically "passed" |
| No external-sender flagging | No banner/warning policy for mail from outside the organization | Recipients have no visual cue to prompt extra scrutiny, even when a sender is unfamiliar |
| Uneven security awareness by department | No evidence of phishing simulation training targeted at HR | HR's 100% submission rate vs. IT's reporting behavior indicates a training gap, not a technical one |
| Misconfigured DMARC on the legitimate NovaTech domain is not the issue here — the gap is the *absence* of a vendor/sender allow-list or domain reputation check | NovaTech currently relies solely on SPF/DKIM/DMARC pass/fail as the sole filter signal | A correctly authenticated but illegitimate sender bypasses the only control in place |
| Subject-line/pretext targeting | Campaign A used an IT-specific pretext; Campaign B used a low-friction, high-interest consumer pretext ("free lunch") | Generic, low-stakes pretexts bypass the skepticism that IT-themed pretexts often trigger, and are harder to filter on content alone |

---

## 3. Risk Impact

- **Credential/data exfiltration from HR systems:** Three HR staff submitted data to an unauthenticated third party. HR handles employee PII and payroll information, so this specific compromise path risks exposure of personal and financial records, not just generic "sensitive data."
- **Account takeover → lateral movement:** Submitted credentials could be reused to access NovaTech's HR platforms or VPN/email, enabling privilege escalation into adjacent systems (payroll, clinical/administrative data depending on scope).
- **Inconsistent incident response:** One IT employee reported the email; no equivalent reporting occurred in HR. Without a reporting culture across all departments, similar future campaigns may go undetected until after data loss occurs.

---

## 4. Recommendations

1. **Harden DMARC posture and monitoring on NovaTech's own domain** (not the attacker's) — ensure `p=reject` is enforced for `novatech.local`-equivalent production domains and that DMARC aggregate/forensic reports are actively reviewed, so NovaTech can detect spoofing attempts against its own brand.
2. **Add external-sender banners** to all mail arriving from outside the organization, regardless of authentication status, so recipients have a consistent visual cue.
3. **Deploy brand/domain-similarity monitoring** to catch look-alike or newly registered domains (e.g., `trusted-vendor-news.com`) impersonating vendors or partners before they reach inboxes.
4. **Target phishing-awareness training by department risk profile**, prioritizing HR, Finance, and other high-engagement/low-technical departments, using the clicked/submitted data from this exercise as a baseline metric.
5. **Reinforce and reward reporting behavior** — the IT employee who reported Campaign B is the behavior to replicate org-wide; consider a visible "report phishing" button and positive feedback loop tied to simulation results.
6. **Re-run simulations quarterly** segmented by department to track whether submission rates in HR decline after targeted training.
