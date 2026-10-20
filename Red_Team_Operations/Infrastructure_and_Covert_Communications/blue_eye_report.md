# Blue Eye — Infrastructure Exposure Report

## Initial Scan Findings

| Port | Service | Version Leaked | Should be Visible | Risk |
|------|---------|---------------|-------------------|------|
| 22   | SSH     | OpenSSH X.X   | Kali only (UFW)   | Low — restricted by firewall |
| 80   | HTTP    | nginx (no version after fix) | Yes | Low |
| 443  | HTTPS   | nginx (no version after fix) | Yes | Low |
| 8443 | HTTPS   | nginx         | No — internal only | Medium — should not appear |
| 9443 | HTTPS   | (bound to 127.0.0.1) | No | None — not externally visible |

## Fixes Applied

1. `server_tokens off` in nginx.conf — removes version from Server header and error pages
2. `DebianBanner no` in sshd_config — removes OS/version from SSH banner
3. CDN headers mask backend identity (X-CDN-Node, X-Cache)
4. Server header stripped via headers-more module
5. UFW rules confirmed: only 22 (Kali only), 443, 31337 (Kali only) allowed

## Re-scan Results

- No version strings in HTTP/HTTPS responses
- SSH banner shows no Debian/Ubuntu version
- Sliver port (9443) not visible — bound to 127.0.0.1 only
- socat/Nginx 8443 reviewed — add UFW rule if externally visible:
  `sudo ufw deny 8443`

## Residual Exposure

- Port 22 visible to 192.168.56.10 (by design — operator access)
- Port 443 visible to all (by design — beacon traffic)
- All other ports blocked or localhost-only
