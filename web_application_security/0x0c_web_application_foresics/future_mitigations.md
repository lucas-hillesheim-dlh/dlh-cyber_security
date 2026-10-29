# Web Application Forensics Series, Part 1: SSH Brute-Force Compromise of app-1

*Incident report, implementation plan and monitoring protocol. Source evidence: auth.log from host app-1 (102,164 lines, May to June).*

## 1. Introduction

Analyzing logs is how defenders reconstruct what an attacker did, judge the damage, and decide which protections to build. This report opens a series on web application forensics. It starts one layer below the application, because the host that runs a web application is part of its attack surface: whoever controls the server controls the application, its database, its secrets and its users.

The evidence is the authentication log of app-1, a Debian-based server that hosts a Python (WSGI) web application under Apache, deployed from Subversion to /opt/software/web/app, with MySQL installed. The log was analyzed for authentication events, account changes, privileged commands and firewall changes. Web server access and error logs were not part of this dataset, so conclusions about the application layer are inferred and are flagged as such.

The log is not in chronological order (entries from May 2 are appended at the end) and month names are in French (Mai, Juin).

## 2. Incident Report

### 2.1 Executive summary

Between June 19 and June 26 the server was subjected to a large-scale SSH password-guessing campaign. It succeeded: the attackers obtained working root passwords, logged in directly as root over SSH, created two additional accounts with UID 0 (root-equivalent), created further user accounts, and altered the firewall. The host must be treated as fully compromised. Because the web application, its database and its TLS key live on this host, they must be treated as compromised as well.

**Severity: Critical.**

### 2.2 Key findings

| Metric | Value |
| --- | --- |
| Failed SSH password attempts | 20,338 |
| Attempts against non-existent accounts (Invalid user) | 14,478 |
| Failed attempts against root | 5,479 |
| Distinct source IPs in failed or invalid attempts | 46 |
| Successful root logins over SSH (whole log) | 28 |
| Reverse-DNS mismatch warnings (POSSIBLE BREAK-IN ATTEMPT) | 383 |
| Scanner probes with no SSH banner (Did not receive identification string) | 44 |
| Share of the whole log produced on June 19 | 41% (42,115 lines) |

**Top sources of failed passwords:** 220.151.162.21 (9,259), 9.13.46.243 (3,037), 223.67.205.247 (1,573), 122.12.67.71 (1,435), 125.208.118.10 (650).

**Most guessed usernames:** admin (447), test (282), administrator (155), 123456 (154), 12345 (137), user, qwerty, oracle. This is the typical dictionary pattern of automated tooling, not a targeted attack on named staff.

### 2.3 Timeline of the compromise

| Date and time | Event |
| --- | --- |
| Jun 19, 05:32 | First contact from 220.151.162.21, which goes on to make the most guesses in the log. More than 34,000 log lines are generated between 05:00 and 08:59. |
| Jun 19, 05:41 to 05:56 | Four successful root password logins from 220.151.162.21. The brute force worked. |
| Jun 19, 10:45 | Root login from 223.67.205.247, an IP that had also been guessing passwords. |
| Jun 19, 22:37 | Root login from 191.167.88.165 (reverse DNS lookup failed). |
| Jun 19, 22:38 | Account **packet** created with **UID 0**, GID 0, shell /bin/sh, and a password set. This is a backdoor root account. |
| Jun 19, 22:45 | Account **dhg** created (UID 1003). It then logs in 20 times from the same IP, 191.167.88.165. |
| Jun 20, 06:51 to 07:06 | From /home/dhg/eggdrop, root-level commands open firewall ports (ufw allow 113, 53, 22, 2685) and toggle ufw on and off. Eggdrop is an IRC bot framework, so this is consistent with setting up an IRC bot or botnet component. |
| Jun 20 to Jun 24 | More root logins from IPs that had been guessing passwords: 122.12.67.71 (Jun 20 and Jun 24), 223.170.225.198 (Jun 22), 123.227.203.13 (Jun 23, twice), 62.169.228.13 (Jun 24). |
| Jun 24, 19:25 to 20:18 | Busiest day after Jun 19 (17,133 lines). Firewall inspected and rewritten: ufw allow, ufw disable and enable, and six iptables -A INPUT commands, several with invalid syntax (for example -p ssh and -dport). |
| Jun 25, 10:41 | Second backdoor account **Fido** created with **UID 0**, shell /bin/sh, after a root SSH session opened at 10:38. |
| Jun 26, 04:43 | Account **Senna** created (UID 1004). |

### 2.4 Indicators of compromise

- **Source IPs with successful root logins:** 220.151.162.21, 223.67.205.247, 122.12.67.71, 223.170.225.198, 123.227.203.13, 62.169.228.13, 191.167.88.165.
- **Accounts to remove or investigate:** packet (UID 0), Fido (UID 0), dhg, Senna.
- **Artifacts:** a /home/dhg/eggdrop directory; unexpected firewall rules and ufw state changes.
- **Behaviors:** root login by password over SSH; useradd, groupadd and passwd activity outside change windows; ufw or iptables changes by root from interactive terminals.

### 2.5 Impact assessment

- **Confidentiality:** with root access an attacker can read the application source, configuration and secrets, the MySQL data, and the TLS private key generated in /etc/apache2. Whether any data was actually copied cannot be determined from auth.log.
- **Integrity:** the application code, templates and fixtures (for example the profile fixtures and the proxy iptables.conf template) could have been altered. The firewall was demonstrably changed.
- **Availability:** the server could be used as a platform for attacks and bots, with a risk of resource abuse and of the address being blocklisted.
- **Persistence:** two UID 0 accounts and several extra users mean the attacker can return even if the original root password is changed.
- **Compliance and trust:** if the application handles personal data, a breach notification assessment is required.

### 2.6 Confidence and limitations

- High confidence: brute-force success against root, the creation of UID 0 accounts, and the firewall changes. These are recorded directly in the log.
- Medium confidence: attribution of the June 20 and June 24 activity to the same actor as the June 19 compromise. The linkage is by shared IP (191.167.88.165) and account (dhg), and legitimate administrators (Jax, Kayn) also use this server.
- Not visible: commands typed inside shells, file changes, outbound traffic, and web-layer attacks such as SQL injection. These need shell history, auditd, Apache logs and network telemetry.

## 3. Implementation Plan

### 3.1 Selected security measures

The measures map directly to the failures observed: password authentication and direct root login over SSH, an unrestricted SSH exposure, no automatic blocking of repeated failures, no detection of account creation or firewall changes, and a web application running on a host that can be fully taken over.

### Phase 0: Contain and preserve (first 24 hours)

1. **Isolate the host.** Restrict network access to a management IP, or take the server off the network. Do not wipe it yet.
2. **Preserve evidence.** Snapshot the disk and memory if possible. Copy /var/log, shell histories and the /home/dhg directory to a write-protected location and record SHA-256 hashes.
3. **List root-equivalent accounts:** `awk -F: '$3==0 {print $1}' /etc/passwd`. Expect only root. Lock the others with `usermod -L` and `chsh -s /usr/sbin/nologin`. Review packet, Fido, dhg and Senna, and the authorized\_keys files of every user.
4. **Terminate active sessions** and block the source IPs listed in section 2.4 at the network edge.
5. **Rotate every secret that lived on the host:** root and user passwords, the MySQL and application database credentials, API keys, the Subversion credentials and the TLS key and certificate.
6. **Plan a rebuild.** After a root-level compromise, the safe course is to rebuild from a known-good image and redeploy the application from version control, verifying it with `svn status` and `svn diff` against the repository. Restore data only after it has been checked.

### Phase 1: Harden remote access (days 1 to 7)

1. Edit /etc/ssh/sshd\_config:
   - `PermitRootLogin no`
   - `PasswordAuthentication no` and `PubkeyAuthentication yes`
   - `MaxAuthTries 3` and `LoginGraceTime 30`
   - `AllowUsers` (or `AllowGroups`) limited to named administrators
2. Issue SSH keys to each administrator, protected by a passphrase. Add multi-factor authentication through a bastion host or VPN where possible.
3. Set the firewall to default deny on inbound traffic. Allow SSH only from the VPN or bastion address range, and allow ports 80 and 443 publicly. Re-create the rules from a reviewed script rather than typing them interactively. The malformed iptables commands in this incident show why.
4. Install fail2ban (or sshguard) so that repeated failures produce a temporary ban.
5. Replace shared administrator access with named accounts, and require sudo with logging instead of su to root.

### Phase 2: Secure the application layer (days 7 to 30)

1. Run Apache and the WSGI process as an unprivileged user with read-only access to the code. The application database account should have only the privileges it needs, and MySQL should listen on localhost.
2. Move secrets out of the code tree into environment variables or a secrets manager.
3. Deploy a web application firewall or a reverse proxy rule set, and enable Apache access and error logging with a retention period.
4. Remove unneeded software (IRC bots, development tools) and unused services. Keep the operating system and packages patched.
5. Review the codebase and the proxy and Apache configuration for tampering: modified files, new cron jobs, unexpected SUID binaries, new systemd or init scripts.

### Phase 3: Verify and institutionalize (days 30 to 90)

1. Ship auth.log, syslog, Apache logs and auditd records to a central log server, so that a root compromise cannot erase the evidence.
2. Enable auditd rules for changes to /etc/passwd, /etc/shadow, /etc/sudoers and /etc/ssh/sshd\_config, and for execution of ufw and iptables.
3. Run a vulnerability scan and an external penetration test against the rebuilt environment.
4. Hold a tabletop exercise and update the incident response runbook with the lessons from this case.

## 4. Monitoring Protocol

### 4.1 Data sources

auth.log (SSH, sudo, su, useradd, passwd), Apache access and error logs, auditd, firewall logs, and a daily snapshot of listening ports and of accounts with UID 0.

### 4.2 Detection rules and alert levels

| Detection | Threshold | Severity | Response |
| --- | --- | --- | --- |
| Failed SSH logins from one IP | 5 or more in 5 minutes | Low | Automatic temporary ban |
| Successful login after repeated failures from the same IP | 1 success after 5 or more failures within 1 hour | Critical | Terminate the session, disable the account, start incident response |
| Any root login over SSH | 1 event (target is zero) | Critical | Investigate at once |
| Any password-based SSH login | 1 event (target is zero after hardening) | High | Verify the configuration |
| Account created or modified (useradd, usermod, groupadd) | Any event outside a change window | High | Verify against the change ticket |
| Account with UID 0 other than root | Daily check | Critical | Lock and investigate |
| Firewall change (ufw or iptables) | Any event outside a change window | High | Verify and restore from the baseline |
| New listening port | Any difference from the baseline | High | Identify the process |
| Login from a new country or IP outside the allowlist | Any | Medium | Confirm with the user |
| Spike in Invalid user events | More than 3 times the 7-day average | Medium | Review the sources and tighten rules |

Useful starting queries against auth.log:

- Top failing IPs: `grep 'Failed password' auth.log | grep -oE 'from [0-9.]+' | sort | uniq -c | sort -rn | head`
- Successful root logins: `grep -E 'Accepted .* for root' auth.log`
- Account changes: `grep -E 'useradd|usermod|groupadd|passwd\[' auth.log`

### 4.3 Review cadence

- **Daily:** triage alerts, check for UID 0 accounts and new ports, and confirm that log shipping is working.
- **Weekly:** review the top failing sources, banned IPs, new accounts and sudo activity by user.
- **Monthly:** run the effectiveness review below, update the allowlists and test restoration from backup.
- **Quarterly:** run a penetration test or red-team exercise and a tabletop exercise, and review all administrator access.

### 4.4 Measures of effectiveness

| Indicator | Target |
| --- | --- |
| Successful root SSH logins | 0 |
| Successful password-based SSH logins | 0 |
| Accounts with UID 0 other than root | 0 |
| Time to detect a successful unauthorized login | Under 15 minutes |
| Time to contain a confirmed incident | Under 1 hour |
| Failed attempts per source IP before an automatic ban | 5 or fewer |
| Unapproved firewall or account changes | 0 |
| Critical and high patches applied | Within 7 days |

Attack attempts will continue, so the volume of failed logins is not a measure of success. The measures that matter are that attempts are blocked early, that none succeed, and that any unauthorized change is detected and handled within the target times. If a target is missed, the cause is recorded and the control is adjusted at the next monthly review.

### 4.5 Escalation

A critical alert starts the incident response runbook: contain, preserve evidence, notify the security lead and management, assess legal and notification duties, eradicate and recover, then hold a post-incident review within five working days.

## 5. Next in the series

Part 2 will move up to the application layer: reading Apache access and error logs to identify injection, path traversal and credential-stuffing attacks against the web application itself.
