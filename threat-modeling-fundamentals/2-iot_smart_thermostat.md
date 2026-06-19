## Question 1 - Identify IoT-specific threats that don't typically apply to web applications

### Physical Hardware Tampering:

* **Description**: Attackers have unrestricted physical proximity to the device casing and internal circuit board;
* **Potential impact**: Attacker bypasses software controls by directly probing internal communication buses (e.g., I2C, SPI, UART) to dump the device's firmware or memory contents.

### Fleet-Wide Hardcoded Credentials:

* **Description**: Devices shipping with universal, static default credentials (e.g., root passwords for local maintenance or ssh/telnet daemons) across the entire product line;
* **Potential impact**: Massive, automated botnet recruitment (like the Mirai botnet) where attackers scan the internet/local networks to hijack thousands of thermostats simultaneously.

### Side-Channel Attacks (SCA):

* **Description**: Extracting sensitive cryptographic keys by monitoring physical characteristics of the microcontroller during operation, such as power consumption, electromagnetic radiation, or timing variations;
* **Potential impact**: Private encryption keys are compromised without leaving any trace in application software logs.

### Resource Constraints Exhaustion (Physical DoS):

* **Description**: IoT microcontrollers have severely limited CPU, RAM, and power capabilities compared to cloud servers hosting web applications;
* **Potential impact**: Sending complex TLS handshakes, large payloads, or malformed packets easily exhausts device memory, causing a physical system crash that shuts down local climate control.

### Insecure Over-the-Air (OTA) Environment:

* **Description**: The application depends on local client-side logic to pull, unpack, and apply system-level operating updates from external networks;
* **Potential impact**: If the update mechanism lacks strict cryptographic checks, an attacker can push a corrupted binary that permanently "bricks" the hardware or gains kernel-level execution privileges.

---

## Question 2 - What happens if an attacker gains physical access to the device?

### The Attack Chain:

1. **Physical Disassembly**: The attacker detaches the smart thermostat from the residential wall and opens the plastic chassis to expose the Printed Circuit Board (PCB).
2. **Interface Identification**: The attacker uses a multimeter or logic analyzer to identify exposed hardware testing points or debugging interfaces, such as **UART** or **JTAG** pins, or pins on an external SPI Flash memory chip.
3. **Hardware Exploitation**: Using an interface tool (e.g., a Bus Pirate or J-Link debugger), the attacker connects to the UART port to intercept the boot sequence and drop into an unauthenticated root shell, or attaches a clip to the flash chip to extract the raw binary data.
4. **Credential and Code Extraction**: The extracted filesystem is reverse-engineered to harvest local home Wi-Fi passwords stored in plaintext, hardcoded cloud API keys, or proprietary algorithms.

### Potential Impacts:

* **Local Network Intrusion**: The attacker steals the homeowner's Wi-Fi SSID and password, pivoting from the physical thermostat to target other sensitive devices on the private home network (e.g., laptops, NAS drives).
* **Physical Safety/Property Damage**: The attacker gains direct control over the relays operating the building's HVAC system. They could shut off heating during sub-zero winter temperatures, causing water pipes to freeze and burst, resulting in massive property damage.
* **Global Zero-Day Discovery**: By analyzing the reverse-engineered firmware extraction, the attacker can find unpatched software vulnerabilities to develop an exploit that can be launched remotely over the internet against *all* active thermostats in production.

---

## Question 3 - Design security controls for the OTA (Over-The-Air) update process.

### Asymmetric Code Signing (Authenticity & Integrity):

* **Requirement**: All firmware binaries must be signed cryptographically by the manufacturer using a highly secured offline private key (ideally kept inside a Hardware Security Module / HSM). The thermostat must contain the corresponding public key hardcoded into its read-only memory to verify the signature before any update is written to storage.

### Hardware-Enforced Secure Boot (Root of Trust):

* **Requirement**: The microcontroller must utilize a secure bootloader locked in write-protected flash memory. Every time the device power-cycles, the bootloader must verify the cryptographic signature of the operating firmware. If verification fails, the device refuses to execute the code.

### Anti-Rollback Protection (Version Control):

* **Requirement**: The system must utilize hardware-backed monotonic counters (e-fuses or secure non-volatile storage) to keep track of the current firmware version number. The device must automatically reject any update payload carrying a version number lower than the currently installed version, preventing attackers from downgrading the device to an older, legally signed version containing a known vulnerability.

### Transport Layer Security with Mutual Authentication (mTLS):

* **Requirement**: Firmware payloads must be downloaded over an encrypted HTTPS connection to prevent binary reverse-engineering during transit. Furthermore, **Mutual TLS (mTLS)** should be enforced, meaning the server verifies the individual thermostat's unique device certificate before allowing the download to proceed.

### Dual-Bank Partitioning / Fault-Tolerant Flashing (Resilience):

* **Requirement**: The device flash storage must be split into two separate storage regions ("A/B" packaging slots). The new firmware is completely written to Slot B while the device continues safely running the old version on Slot A. Once downloaded and cryptographically verified, the system flips a boot flag to test the new version. If it crashes or fails verification upon reboot, it automatically rolls back to the stable image in Slot A, preventing accidental field bricking.