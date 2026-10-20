# Rules of Engagement
## CyberCorp Industries — Red Team Assessment

---

## 1. Engagement Overview

| Field | Detail |
|---|---|
| Client | CyberCorp Industries |
| Engagement Type | Full-Scope Red Team Assessment |
| Start Date | 2026-10-20 08:00 UTC |
| End Date | 2026-10-21 17:00 UTC |
| Duration | 33 hours |
| Red Team Lead | Operator: lucas-hillesheim-dlh |
| Engagement ID | RT-2026-001 |

---

## 2. Scope

### In-Scope Targets
| Asset | Type | Notes |
|---|---|---|
| 192.168.56.20 | Ubuntu teamserver | Full scope |
| 192.168.56.30 | Windows workstation | Full scope |
| my-website.com | Domain | Lab C2 domain |

### Out-of-Scope Targets
- Any IP outside the 192.168.56.0/24 range
- Production systems not listed above
- Third-party infrastructure
- Client employee personal devices

### Allowed Techniques
- Phishing simulation (internal only)
- Privilege escalation
- Lateral movement within scope
- Credential harvesting (simulated)
- C2 beacon establishment
- File exfiltration (test files only)
- Post-exploitation reconnaissance

### Prohibited Techniques
- Denial of Service (DoS/DDoS)
- Data destruction or encryption
- Exploitation of real vulnerabilities in production
- Social engineering of real employees
- Exfiltration of real PII or sensitive data
- Persistence mechanisms that survive reboot (without prior approval)

---

## 3. Rules

### Working Hours
- Primary operations: 08:00–20:00 UTC
- Off-hours operations require prior written approval from client POC

### Notification Requirements
- Notify client POC before executing any destructive test
- Notify immediately if any unintended system impact is observed
- Daily status updates at 17:00 UTC

### Data Handling
- No real PII to be collected or stored
- All exfiltrated test files destroyed within 24h of engagement end
- Screenshots and logs stored encrypted on red team infrastructure only

### Evidence Preservation
- All commands logged with timestamps
- Screenshots taken at each phase milestone
- Engagement logs retained for 30 days post-engagement

---

## 4. Communication

| Role | Contact | Method |
|---|---|---|
| Client POC | poc@cybercorp.local | Encrypted email / Signal |
| Red Team Lead | lucas-hillesheim-dlh | Direct |
| Escalation | poc@cybercorp.local | Phone (emergency only) |

### Status Reporting
- Daily written update at 17:00 UTC
- Immediate verbal notification for critical findings
- Final report delivered within 5 business days of engagement end

---

## 5. Deconfliction

### Identification
- Red team activity tagged with engagement ID: RT-2026-001
- All C2 traffic originates from 192.168.56.10 or through proxy
- Implants contain engagement ID string in beacon metadata

### Deconfliction Code
- Verbal phrase: "Sierra Tango Zero One"
- Written code: RT-2026-001

### Blue Team Detection Process
1. Blue team contacts client POC immediately
2. Client POC contacts red team lead within 15 minutes
3. Red team confirms or denies activity within 30 minutes
4. If unconfirmed → treat as real incident, red team pauses operations
5. Document deconfliction event in engagement log

---

## 6. Legal

### Authorization
This engagement is authorized under signed Statement of Work (SOW-2026-RT-001)
between CyberCorp Industries and the red team operator. All activities performed
under this RoE are explicitly authorized by CyberCorp Industries.

### Liability Limitations
- Red team not liable for unintended impacts outside defined scope
- Client responsible for ensuring backup/recovery procedures are in place
- Any scope expansion requires written amendment to this RoE

### Data Retention and Destruction Policy
- Engagement artifacts retained 30 days post-engagement
- All client data (screenshots, exfiltrated test files) destroyed after final report delivery
- Destruction confirmed in writing to client POC
- Engagement logs retained 1 year for liability purposes
