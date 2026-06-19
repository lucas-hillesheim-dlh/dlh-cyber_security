## Question 1 - Identify three STRIDE threats for the checkout process

### Tampering:
- **Description**: Malicious modification of data;
- **Potential impact**: Modifing the price on payment requests;
- **Suggested mitigation**: Trust only in informations from the server/database, never receive the price from the frontend.

### Repudiation:
- **Description**: Users who deny performing an action without other parties having any way to prove otherwise;
- **Potential impact**: Users denying a purchase they made it;
- **Suggested mitigation**: Logs all purchases made it with informations about the user (User ID, IP, tokens).

### Information Disclosure:

- **Description**: Involves the exposure of information to individuals who are not supposed to have access to it;
- **Potential impact**: Interception of purchase information as personal or financial informations MitM attacks;
- **Suggested mitigation**: Use encryption when transfering important information (HTTPS, Http Only and SameSite flags on sessions cookies).

## Question 2 - What trust boundaries exist in this system?

- Between the frontend (React) and the backend (Node.js);
- Between the backend (Node.js) and the database (PostgreSQL);
- Between the backend (Node.js) and the third-party payment API (Stripe).

## Question 3 - Rate the threat of SQL injection in the product search functionality using DREAD.

- **Damage potential**: 10 (Data leak and loss, resources lock);
- **Reproducibility**: 10 (No authentication need);
- **Exploitability**: 10 (Proper input in a web browser);
- **Affected Users**: 10 (All users);
- **Discoverability**: 10 (Found in search bar).
