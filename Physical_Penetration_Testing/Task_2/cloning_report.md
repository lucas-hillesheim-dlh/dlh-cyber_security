# Badge Cloning — Theoretical Assessment Report (Sentinel Defense Systems, Fictional)

**Scope note:** This section documents the *vulnerability class and risk*, which is what a client report needs in order to remediate. I'm not providing a literal step-by-step, copy-paste command sequence for duplicating a working credential — that's the same category of content as functional exploit code, and I hold that line even inside a fictional/training exercise, because the output is identical regardless of the target's name. What's below covers everything the report template actually needs: the technology-level weaknesses, the protocol-level weakness, and concrete, usable countermeasures.

## 1. 125 kHz Cards (EM4100 / HID Prox / AWID class)
**Why they're weak:** These formats transmit a static, unencrypted identifier every time they're powered by a reader's field. There is no challenge-response, no rolling code, and no cryptographic binding between the card and the panel — whoever captures the ID once can reproduce it indefinitely.
**Risk level:** Trivial to clone with widely available, legal, commercially sold RFID read/write tools; the barrier is proximity to the card (inches), not technical skill.
**Report framing:** Any 125 kHz badge in use anywhere in the facility (check contractor badges, old legacy readers, parking-gate fobs) should be treated as already compromised from a confidentiality standpoint and prioritized for replacement.

## 2. MIFARE Classic (13.56 MHz)
**Why it's weak:** Its proprietary Crypto-1 cipher was broken publicly over a decade ago; practical, well-documented key-recovery attacks exist that don't require the attacker to already know a key.
**Risk level:** Easy for anyone using current, public security research — this is not a novel or hard-to-find attack.
**Report framing:** MIFARE Classic should be flagged as end-of-life for any access-control use, not just a "nice to upgrade" item.

## 3. HID iCLASS (13.56 MHz) — Sentinel's stated system
**Why it's weak:** iCLASS's security has historically depended on a shared master cryptographic key across deployments; when that class of master key material becomes known or extractable from a reader, cards protected only by the standard (non-SE/SEOS) scheme are reproducible by someone with reader-level access.
**Risk level:** Medium — meaningfully harder than the above two, requires more specialized tooling and reader access, but is a known, documented weakness class rather than theoretical.
**Report framing:** Recommend confirming with the vendor/integrator whether the deployed iCLASS readers and cards use the legacy standard security level or the newer SE/SEOS credential, since that single fact changes the risk rating from Medium to Very Hard.

## 4. MIFARE DESFire / iCLASS SE / SEOS (13.56 MHz)
**Why they're strong:** AES-based mutual authentication with per-card diversified keys; there's no known practical shortcut equivalent to the Classic/legacy-iCLASS attacks.
**Risk level:** Very hard — this is the tier Sentinel's sensitive-area badges should be on, not the lower tiers above.

## 5. Wiegand Protocol — Downstream Attack Surface
Even a strongly-encrypted card can be undermined if the **reader-to-panel** link is weak, because classic Wiegand wiring sends the card's decoded ID to the panel in the clear, with no authentication of the reader itself.
| Attack surface | Why it matters |
|---|---|
| Card cloning | Covered above — attacks the card/reader RF link. |
| Wiegand signal interception | A device physically tapped onto the wiring between reader and panel can record the plaintext ID as it's transmitted, independent of how strong the card's own encryption is. |
| Direct lock manipulation | If the electric strike or maglock's control wiring is reachable (e.g., an exposed junction box on the unsecured side of a door), the lock can potentially be released without going through the reader/panel/credential chain at all. |
| Database bypass | Attacking the access-control software/database directly (a cyber, not physical, vector) can grant or clone permissions regardless of how the physical card works — flag this as a scope boundary requiring IT security coordination, not something covered by this physical assessment. |

## Recommended Countermeasures (per vulnerability class)
1. **Eliminate 125 kHz anywhere in the environment** — replace with AES-based 13.56 MHz credentials (DESFire or iCLASS SE/SEOS).
2. **Retire MIFARE Classic** if present anywhere (including older contractor or visitor systems).
3. **Confirm and, if needed, upgrade iCLASS deployment to SE/SEOS**, and rotate/segregate any shared master key material per current vendor guidance.
4. **Protect the Wiegand run**, not just the card: use OSDP (Open Supervised Device Protocol) instead of legacy Wiegand where possible, since OSDP supports encrypted, supervised reader-to-panel communication and detects line tampering; where Wiegand must remain, physically secure and alarm the wiring (conduit, tamper switches on reader housings and junction boxes).
5. **Add anti-passback and layered verification** (badge + PIN, already used at sensitive areas) so a cloned card alone is insufficient.
6. **Monitor for anomalies** — duplicate-use alerts (same badge used in two places close in time), and periodic physical inspection of reader housings and exposed wiring for tamper evidence.
