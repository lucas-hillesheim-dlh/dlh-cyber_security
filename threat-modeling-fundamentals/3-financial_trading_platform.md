## Question 1 - Which CIA component is most critical for this system and why?

### Integrity:

* **Description**: Ensuring that financial data, account balances, and trade orders are accurate and cannot be modified by unauthorized parties;
* **Reasoning**: While Availability is vital to hit the 99.99% uptime metric, a failure in **Integrity** is catastrophic for a trading platform. If an attacker alters the quantity of a buy order from 10 shares to 10,000 shares, or manipulates the account balance database, it causes immediate, irreversible financial ruin and instantaneous regulatory decertification by the SEC and FINRA. A system can recover from being temporarily offline, but it cannot easily recover from a corrupted ledger.

### Security vs. Performance Conflict:

* **Yes, they directly conflict**: Achieving a trade execution latency of `<100ms` requires minimizing processing overhead. Standard security controls—such as deep packet inspection via a Web Application Firewall (WAF), decryption/encryption of network payloads, complex identity access checks, and strict database transactional locking (ACID compliance)—all consume critical CPU cycles and introduce millisecond delays. Engineers must use highly optimized security designs, such as hardware-accelerated TLS termination and in-memory security validation, to balance these competing requirements.

## Question 2 - Threat model the "automated trading rules" feature.

### Unauthorized Rule Tampering:

* **Description**: An attacker bypasses authorization checks to modify another user's pre-configured trading rules, or injects malicious rules into an active account;
* **Potential impact**: The attacker configures the compromised account to buy an obscure, illiquid penny stock at an inflated price, effectively executing a "pump-and-dump" scheme to extract capital into an external account;
* **Suggested mitigation**: Implement strict Broken Object Level Authorization (BOLA) defenses. Every API request to modify or execute a rule must validate that the authenticated session token perfectly matches the cryptographic owner ID of that specific rule group in the database.

### Logic Exploitation / Execution Race Conditions:

* **Description**: A user configures a poorly designed automated loop, or an attacker exploits a race condition in the rule execution engine (e.g., sending simultaneous triggers before the account balance updates);
* **Potential impact**: The rule engine enters an infinite loop of executing high-velocity buy orders, rapidly blowing past the user's actual margin limits, exhausting platform liquidity, and flooding the execution clearinghouse with unauthorized debt;
* **Suggested mitigation**: Enforce a kernel-level throttling mechanism and validation layer that evaluates account balances *synchronously* before any order is dispatched to the market router, instantly killing any rule that triggers more than a set threshold of actions per second.

### Price Feed Poisoning (Oracle Tampering):

* **Description**: An attacker manipulates or introduces latency into the real-time market data feed flowing into the automated rule engine;
* **Potential impact**: The automated rule engine reads artificial or outdated stock prices, triggering massive, unintended buy or sell liquidations based on fraudulent data metrics;
* **Suggested mitigation**: Cross-reference price data across multiple independent high-availability market feeds (e.g., direct exchange feeds plus consolidated tape) and implement anomaly detection to flag and reject data packets that show impossible mathematical variances or spikes.

## Question 3 - An attacker compromises a user account. What defense-in-depth controls should limit the damage?

### Layer 1 - Context-Aware Anomaly Detection (Behavioral Layer):

* **Mechanism**: Continuous tracking of user behavior patterns, including IP reputation, geovelocity (impossible travel), device fingerprinting, and trading consistency;
* **Impact**: If a user who typically trades blue-chip stocks from New York suddenly logs in from a high-risk IP range and attempts to liquidate their entire portfolio, the platform instantly flags the session for suspicious activity.

### Layer 2 - Step-Up Authentication for High-Risk Actions (Identity Layer):

* **Mechanism**: Requiring secondary out-of-band Multi-Factor Authentication (MFA) challenges when a user attempts a critical action;
* **Impact**: Even if the attacker holds the primary session cookie, they are blocked from executing high-impact operations—such as adding a new banking routing number, modifying automated trading rules, or initiating a wire transfer—without passing a hardware token or biometric prompt.

### Layer 3 - Financial Velocity and Trading Limits (Business Logic Layer):

* **Mechanism**: Hardcoded and user-defined caps on daily trading volumes, maximum transaction sizes, and maximum daily outbound fund transfers;
* **Impact**: Limits the absolute "blast radius" of a compromised account. An attacker cannot instantly drain a million-dollar account because the system enforces hard circuit breakers on daily capital flight.

### Layer 4 - Secure Session Isolation and Token Binding (Session Layer):

* **Mechanism**: Implementing short-lived access tokens, strict concurrent session limits, and binding sessions to the user's TLS connection characteristics;
* **Impact**: Prevents session hijacking and token theft. If a session token is copied to an attacker's machine, the platform rejects it because the underlying network fingerprint and geographic routing do not match the authorized state.

### Layer 5 - Delayed Settlements & Immutable Compliance Logging (Data/Operations Layer):

* **Mechanism**: Enforcing a mandatory hold window (e.g., T+1 or T+2) on large outbound fund transfers alongside Write-Once-Read-Many (WORM) audit logging as mandated by SEC/FINRA;
* **Impact**: Provides the platform operations team a manual intervention window to freeze and reverse fraudulent fund transfers before cash physically leaves the ecosystem, while ensuring the forensic evidence cannot be erased or altered by the attacker.