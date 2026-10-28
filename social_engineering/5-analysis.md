##### Which SET menu option creates a payload?
    1) Social-Engineering Attacks → 9) Create a Payload and Listener
##### Which SET menu option sends emails?
    1) Social-Engineering Attacks → 5) Mass Mailer Attack → E-Mail Attack Single Email Address
##### Why did we host the payload on a web server instead of attaching it directly?
- Attachment scanning: Most mail gateways run attachments through AV/sandbox analysis before delivery. A .exe, macro-enabled doc, or raw payload attached directly is far more likely to be flagged or stripped than a plain link.
- Signature detection at rest: An attached binary sits as a static file the filter can hash/scan immediately. A link defers that exposure — nothing malicious crosses the mail gateway itself, only a URL.
- User interaction / pretext control: Hosting it lets you control what happens when the link is clicked — e.g., land on a believable “VPN client download” page first, which also lets you log clicks separately from downloads/executions (as your campaign metrics CSV does: “Clicked Link” vs. “Submitted Data” are distinguishable events).
- SET’s built-in web server (2) Website Attack Vectors, or the java applet/credential harvester modules) does exactly this — it serves the payload or a cloned page and can combine it with a credential harvester, giving you richer telemetry than an attachment ever could (IP, user agent, timestamp of click vs. execution).
- Realism: Real-world phishing overwhelmingly uses links rather than raw attachments for these same reasons, so this choice also makes the simulation a more accurate test of NovaMedix’s actual exposure.
