# RFID Technology Identification — Sentinel Defense Systems (Fictional)

## Reader 1
**Description:** Black rectangular reader, waist height, no keypad, single LED, card held 2-3 inches away.
- **Likely technology:** Proximity card reader — most consistent with **HID Prox / EM4100-class** 125 kHz proximity technology (read range of a few inches, no contact needed, single status LED is typical of low-frequency prox readers rather than high-frequency ones, which usually require near-contact tap).
- **Frequency:** 125 kHz
- **Cloning difficulty:** **Trivial.** These formats have no encryption; the card simply broadcasts a fixed ID.

## Reader 2
**Description:** Gray reader, illuminated logo, tap-on-surface read, 10-digit keypad below.
- **Likely technology:** Contactless smart card reader with an integrated PIN pad — consistent with **HID iCLASS** (13.56 MHz), matching the scenario's stated badge system for sensitive areas (badge + PIN).
- **Frequency:** 13.56 MHz
- **Additional factor:** PIN keypad — this is two-factor (something you have + something you know), which is why it's deployed at the server room / R&D lab rather than the main entrance.

## Reader 3
**Description:** Slim white wall-mounted unit, phone held near it, NFC symbol visible.
- **Likely technology:** **NFC-based access** (phone-as-credential / mobile wallet badge, e.g. HID Mobile Access or a similar NFC credential system), not a traditional plastic-card-only reader.
- **Protocol:** NFC (ISO/IEC 14443, 13.56 MHz) — the same RF layer as iCLASS/MIFARE but used for phone-based credentials rather than a physical card.
- **Cloning difficulty:** Generally **harder** than a static card: phone-based credentials typically use dynamic, cryptographically signed tokens rather than a static UID, but this depends entirely on the specific mobile-credential implementation and should be confirmed, not assumed.
