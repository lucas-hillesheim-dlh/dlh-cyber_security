## Question 1 - Which asset is most critical in this system?

The patients information (SSN). 
- **Confidentiality**: Preventing unauthorized access to SSNs and medical histories protects patient privacy and prevents identity theft.
- **Integrity**: If an attacker alters a patient's medical records a doctor could administer a fatal treatment.
- **Availability**: If a attack locks down the database, providers cannot view patient histories or allergies during an emergency, delaying life-saving care.

## Question 2 - Apply STRIDE to the "message healthcare providers" feature.

- **Spoofing**: An unauthorized user intercepts a session or manipulates API requests to impersonate a healthcare provider, giving a patient malicious medical advice or illegally authorizing a refill.

- **Tampering**: An attacker intercepts API traffic (via a Man-in-the-Middle attack) or uses injection techniques to alter the content of a message between a doctor and patient, changing treatment advice.

- **Repudiation**: A provider sends an incorrect medical instruction through the app, but because the system lacks secure, unalterable logs, they can claim, "I never sent that message, the patient is making it up".

- **Information** Disclosure: An attacker exploits a Broken Object Level Authorization (BOLA) vulnerability in the REST API backend, changing a message ID parameter to read private conversations belonging to other patients.

## Question 3 - What security controls would you prioritize to protect patient data?

### **1. Identity Verification: Multi-Factor Authentication (MFA)**

- **Why**: This is your first line of defense. Even if passwords are leaked, stolen, or phished, MFA prevents unauthorized access to the mobile client. For healthcare apps, biometric MFA (FaceID/TouchID) provides excellent security with low user friction.

### **2. Access Control: Role-Based Access Control (RBAC) & Principle of Least Privilege**

- **Why**: Once a user is authenticated, RBAC ensures they can only see what they are legally allowed to see. A patient should only access their own record; a nurse might see general scheduling; a doctor sees clinical records. This stops lateral movement if an account is compromised.

### **3. Data Protection: Encryption (In Transit and At Rest)**

- **Why**: This protects the data itself. Enforcing TLS 1.3 for the REST API backend protects data in transit from interception. Using AES-256 encryption on the cloud-hosted database protects data at rest from physical hardware theft or cloud storage misconfigurations.

### **4. Accountability: Audit Logging & Monitoring (Your Missing 5th Control)**

- **Why**: To achieve HIPAA compliance and solve your Repudiation threat from Question 2, you must implement immutable, time-stamped logs of all user activities (logins, message sent, records viewed). These logs must be pushed to a centralized SIEM (Security Information and Event Management) system.

### **5. Resilience: Automated Database Backups & Disaster Recovery**

- **Why**: This addresses the Availability component of your CIA triad. Backups must be encrypted, regularly tested for restoration speed, and ideally stored in an immutable, air-gapped environment to prevent ransomware from wiping out your history.