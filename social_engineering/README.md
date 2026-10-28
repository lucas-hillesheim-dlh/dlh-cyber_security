# Social Engineering Operations

## Background Context

In cybersecurity, the weakest link is often not a misconfigured server or unpatched software, it's a person. Social engineering attacks exploit human trust rather than technical vulnerabilities.

The best firewall in the world is useless if an employee opens the door themselves.

NovaMedix is a fictional pharmaceutical company that stores sensitive clinical trial data on its internal servers. Their IT department has recently implemented network-level protections but has never tested the human layer. They have hired you as a penetration tester to simulate a full spear-phishing attack chain from initial reconnaissance to an active reverse shell to measure employee susceptibility and assess response readiness.

## Resources
### Read or watch:

- Social Engineering Operations
- [GoPhish: Open Source Phishing Framework](https://docs.getgophish.com/user-guide)
- [The Social Engineer Toolkit (SET)](https://github.com/trustedsec/social-engineer-toolkit)
- [The SET user manual](https://raw.githubusercontent.com/trustedsec/social-engineer-toolkit/master/readme/User_Manual.pdf)

## Learning Objectives

At the end of this project, you are expected to be able to [explain to anyone](https://fs.blog/feynman-learning-technique/), without the help of Google:

- Understand what Social Engineering is and how attackers exploit human behavior
- Analyze email authentication mechanisms (SPF, DKIM, DMARC) and identify security gaps
- Use SET (Social Engineering Toolkit) to perform various social engineering attacks
- Clone a legitimate website using SET's Credential Harvester to capture login credentials
- Generate a payload and listener using SET's built-in payload generator
- Craft and send a convincing spear-phishing email using SET's Mass Mailer Attack
- Understand how typosquatting and email spoofing are used in phishing campaigns
- Generate an encoded PowerShell Reverse Shell payload using SET
- Analyze and interpret GoPhish campaign metrics to measure phishing effectiveness
- Write a professional penetration testing report documenting findings and recommendations
- Understand defensive measures and how to protect organizations against social engineering attacks

## Requirements
### General

- All your files will be run on Kali Linux 2023.2
- Allowed editors: vi, vim, emacs
- All your files should end with a new line [Why?](https://unix.stackexchange.com/questions/18743/whats-the-point-in-adding-a-new-line-to-the-end-of-a-file/18789)
- HTML/Markdown files must be valid and render correctly
- A README.md file, at the root of the folder of the project, is mandatory

###### Lab Environment – VM Access Links

- Windows Victim Machine:
    - Password: 1122

###### Here's how to installSET on Kali Linux:
    sudo apt-get update
    sudo apt install set -y

###### Then launch:
    sudo setoolkit

**NB**: `The tools used in this lab are powerful weapons in a pentester's arsenal. They must only be used in authorized testing environments. We learn to exploit the human layer not to cause harm, but to secure the 'weakest link' in cybersecurity.`
