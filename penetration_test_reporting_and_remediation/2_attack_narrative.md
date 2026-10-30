ATTACK NARRATIVE

Engagement: Nibbles
Target: 10.10.10.75
Attack Chain: Recon → Web Enum → Admin Access → File Upload → Reverse Shell → Privesc → Root

[09:00] Reconnaissance
-----------------------
A full service scan was performed against the target to identify exposed
attack surface.

Command:
  nmap -sC -sV 10.10.10.75

Result:
  22/tcp  open  ssh    OpenSSH 7.2p2
  80/tcp  open  http   Apache httpd 2.4.18

Analysis: Two services exposed - SSH (not targeted at this stage due to
lack of credentials) and a web server. The web server became the primary
avenue of attack, as HTTP services are the most common source of
exploitable application-layer flaws.

[09:15] Web Enumeration
------------------------
Directory brute-forcing was used against the web server to discover
content not linked from the visible site.

Command:
  gobuster dir -u http://10.10.10.75 -w /usr/share/wordlists/dirb/common.txt

Result:
  /nibbleblog (Status: 301)

Analysis: A hidden application directory, "/nibbleblog", was discovered,
revealing that the target runs the Nibbleblog CMS. Identifying the
specific application is a key pivot point, as it allows the attack to
move from generic web testing to targeted research of known weaknesses
and administrative interfaces specific to that software.

[09:25] Admin Panel Discovery & Access
----------------------------------------
The Nibbleblog administrative login was located and tested against
commonly used/default-style credentials.

Target:
  http://10.10.10.75/nibbleblog/admin.php

Credentials tested: admin:nibbles (guessed, based on the application
name - a weak-credential pattern)

Result: Authentication succeeded, granting full administrative access
to the CMS.

Analysis: This represents the initial compromise of the application
layer. The weak, guessable password - rather than any software
vulnerability - was the actual root cause of this access, and is a
significant finding in its own right independent of the exploit chain
that follows.

[09:35] File Upload Exploit (Initial Access Vector)
-----------------------------------------------------
With administrative access to the CMS, the built-in "My Image" plugin
was abused to upload a malicious file.

Action:
  Admin Panel → Plugins → My Image → Upload PHP reverse shell
  (disguised as an image upload, but the plugin does not validate file
  type/content, allowing a .php payload to be stored and later executed
  by the web server)

Analysis: This step converts administrative CMS access into code
execution on the underlying host. The flaw is an unrestricted file
upload vulnerability in the Nibbleblog "My Image" plugin, reachable only
because step 3 provided authenticated access.

[09:40] Reverse Shell - Initial Access Achieved
---------------------------------------------------
A listener was started on the attacker machine, and the uploaded
payload was triggered by requesting it directly via HTTP.

Commands:
  # Attacker host
  nc -lvnp 4444

  # Trigger payload
  curl http://10.10.10.75/nibbleblog/content/private/plugins/my_image/image.php

Result:
  nibbler@Nibbles:/$ whoami
  nibbler

Analysis: Requesting the uploaded PHP file caused the web server to
execute it, returning an interactive shell as the low-privileged
service account "nibbler." This is the formal point of Initial Access
to the underlying operating system, achieved roughly 40 minutes into
the engagement.

[09:45] Privilege Escalation
-------------------------------
With a foothold established, the attacker enumerated the nibbler
account's sudo permissions.

Command:
  sudo -l

Result:
  (root) NOPASSWD: /home/nibbler/personal/stuff/monitor.sh

Analysis: The nibbler account was permitted to run a specific script as
root without a password. Critically, this script was writable by
nibbler, meaning its contents could be fully replaced before execution
- a sudo misconfiguration combined with insecure file permissions.

[09:50] Exploiting the Sudo Misconfiguration
------------------------------------------------
The writable script was overwritten with attacker-controlled content
and then executed via the permitted sudo rule.

Commands:
  echo '#!/bin/bash' > /home/nibbler/personal/stuff/monitor.sh
  echo 'bash -i' >> /home/nibbler/personal/stuff/monitor.sh
  sudo /home/nibbler/personal/stuff/monitor.sh

Result:
  root@Nibbles:/# whoami
  root

[10:00] Root Access Achieved
--------------------------------
Full root access was confirmed on the target host, completing the
attack chain from unauthenticated network access to full system
compromise.

Total time elapsed: Approximately 1 hour from initial scan to root
access, using only publicly known attack techniques and no custom
exploit development.

Attack Chain Summary
------------------------
1. Recon           -> identified exposed web service (Apache 2.4.18)
2. Web Enum         -> discovered hidden Nibbleblog CMS install
3. Admin Access     -> compromised via weak/guessable credentials
4. File Upload      -> abused plugin to upload malicious PHP file
5. Reverse Shell     -> executed payload to gain shell as "nibbler"
6. Privesc          -> abused misconfigured, writable sudo script
7. Root             -> obtained full root shell on the host

Root Cause Analysis
------------------------
This attack chain succeeded due to three independent, compounding
weaknesses, any one of which - if remediated - would have broken the
chain:
  1. A weak, predictable administrative password on the CMS.
  2. An unrestricted file upload flaw in a third-party CMS plugin.
  3. An insecure sudo configuration that granted passwordless root
     execution of a script the lower-privileged user could edit.

Recommendations (for Blue Team)
------------------------------------
1. Enforce strong, unique credentials on all administrative interfaces
   and consider rate-limiting/lockout on login endpoints.
2. Remove or update the vulnerable Nibbleblog plugin; validate file
   type/content server-side on any upload functionality, and store
   uploads outside the web root or block execution of scripts in
   upload directories.
3. Audit all sudoers entries for NOPASSWD rules; never grant
   passwordless sudo on a script or binary that is writable by the
   same user being granted the privilege.
4. Deploy file integrity monitoring on privileged scripts referenced
   in sudoers.
5. Enable logging/alerting on web server requests to unusual or
   recently modified file paths, which could have surfaced the
   payload execution in step 5 in near real time.
