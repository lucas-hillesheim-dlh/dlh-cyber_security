# REMEDIATION REPORT

## Finding: SQL Injection (VULN-002)
**Location:** `/login.php`
**CWE:** CWE-89 (SQL Injection)
**Severity:** Critical

---

## 1. Vulnerability Summary

The login handler concatenates raw, unsanitized POST input (`username`, `password`) directly into a SQL query string. An attacker can inject SQL syntax into either field to alter the query's logic — for example, bypassing authentication entirely with a payload like `' OR '1'='1' -- -`, or using boolean/time-based blind techniques to extract the entire `users` table (as demonstrated by the `sqlmap --dump` proof-of-concept), including password hashes.

---

## 2. Secure Code

The fix is to **never let user input become part of the SQL command itself** — it should only ever be treated as *data*. This is achieved with parameterized (prepared) statements, which the database distinguishes from the query structure at the driver level, making injection structurally impossible for that query.

```php
<?php
declare(strict_types=1);

// --- Input handling ---
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    exit('Method not allowed');
}

$username = trim($_POST['username'] ?? '');
$password = $_POST['password'] ?? '';

// Basic input validation (defense in depth, NOT the primary SQLi fix)
if ($username === '' || $password === '' || strlen($username) > 64) {
    http_response_code(400);
    exit('Invalid credentials submitted');
}

// --- Secure, parameterized query ---
$stmt = $conn->prepare("SELECT id, username, password_hash FROM users WHERE username = ?");
if ($stmt === false) {
    error_log('Prepare failed: ' . $conn->error);
    http_response_code(500);
    exit('An error occurred');
}

$stmt->bind_param("s", $username);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();
$stmt->close();

// --- Password verification (never compare passwords in SQL) ---
if ($user && password_verify($password, $user['password_hash'])) {
    session_regenerate_id(true);           // prevent session fixation
    $_SESSION['user_id'] = $user['id'];
    $_SESSION['username'] = $user['username'];
    // redirect to authenticated area
} else {
    // Generic failure message - do not reveal whether username or
    // password was the incorrect field (prevents username enumeration)
    http_response_code(401);
    error_log("Failed login attempt for username: " . $username);
    exit('Invalid username or password');
}
?>
```

### Why this fixes the root cause

| Original Flaw | Fix Applied |
|---|---|
| User input concatenated into SQL string | `?` placeholders + `bind_param()` separate code from data |
| Password compared in plaintext via SQL (`password='$password'`) | Password hash fetched by username only, verified server-side with `password_verify()` |
| No input validation | Length/empty checks added as defense-in-depth |
| Errors could leak schema info | Errors logged server-side, generic message returned to client |
| No enumeration protection | Identical error message for bad username vs. bad password |
| Session fixation risk | `session_regenerate_id(true)` on successful login |

> **Note:** This assumes passwords are stored as salted hashes via `password_hash()`. If the current schema stores plaintext or unsalted MD5/SHA1 passwords, that is a separate critical finding (VULN-003 — Insecure Password Storage) and must be remediated alongside this fix via a forced password-reset/migration (see Implementation Steps, item 2).

---

## 3. Implementation Steps

1. **Replace all raw SQL queries with parameterized statements.**
   - Audit the entire codebase (not just `/login.php`) for string-concatenated SQL — grep for patterns like `"SELECT`, `.$_POST`, `.$_GET` adjacent to query strings.
   - Convert every instance to prepared statements (`mysqli`/`PDO`) or a vetted ORM/query builder that parameterizes by default.

2. **Migrate password storage if not already hashed properly.**
   - Use `password_hash($password, PASSWORD_DEFAULT)` (bcrypt/Argon2) at registration/reset time.
   - If legacy plaintext/weak-hash passwords exist, force a password reset for all affected accounts; do not attempt to "upgrade in place" without user re-authentication.

3. **Apply least privilege to the database account used by the application.**
   - The web app's DB user should only have `SELECT`, `INSERT`, `UPDATE`, `DELETE` on the specific schemas/tables it needs — never `DROP`, `FILE`, `GRANT`, or admin privileges.
   - This limits blast radius if a future injection or credential leak occurs.

4. **Add server-side input validation (defense in depth).**
   - Enforce expected length/character constraints on `username` before it ever reaches the query layer. This does not replace parameterization but reduces attack surface and malformed input.

5. **Enable and monitor SQL query logging / a WAF rule set.**
   - Log slow queries and queries with abnormal syntax patterns.
   - Deploy or tune a Web Application Firewall (e.g., ModSecurity with the OWASP Core Rule Set) as a compensating control, not a substitute for the code fix.

6. **Add rate limiting / account lockout on the login endpoint.**
   - Mitigates credential stuffing and brute-force attempts that often accompany injection testing.

7. **Code review / regression testing gate.**
   - Add a static analysis (SAST) rule or linter check that flags string-concatenated SQL in CI, so this class of bug can't be reintroduced.

---

## 4. Verification

**Automated re-test with sqlmap:**
```bash
sqlmap -u "http://target/login.php" --data="username=admin&password=test" --batch
```
Expected output:
```
[WARNING] all tested parameters do not appear to be injectable
```

**Manual verification:**
```bash
# Classic auth bypass payload - should now fail cleanly
curl -X POST http://target/login.php \
  -d "username=admin' OR '1'='1' -- -&password=anything"
# Expected: HTTP 401, "Invalid username or password" - no login, no SQL error leaked

# Confirm no verbose DB errors are exposed to the client
curl -X POST http://target/login.php \
  -d "username=admin'&password=test"
# Expected: generic 401/400 response, nothing resembling a MySQL error string
```

**Verify least-privilege DB account:**
```sql
SHOW GRANTS FOR 'webapp_user'@'localhost';
-- Expected: only SELECT/INSERT/UPDATE/DELETE on the application schema,
-- no FILE, SUPER, GRANT OPTION, or admin-level privileges
```

**Regression check:**
- Confirm legitimate login with valid credentials still succeeds.
- Confirm failed login with wrong password still returns the generic error (not a 500 or stack trace).

---

## 5. Residual Risk / Follow-Up Items

- This fix addresses `/login.php` only. The same SQLi pattern should be assumed present anywhere else in the codebase using string-built queries until the full audit (Step 1) is complete.
- Recommend a full source code review or SAST scan of the application before closing this finding, not just this single endpoint.
- If password storage is found to be weak (see note under Secure Code), raise as a linked, separate finding with its own CVSS score rather than folding it silently into this one.

---

Want this bundled with the Executive Summary, Vulnerability Report, and Attack Narrative into a single Word document deliverable, or would you like to continue with the next exercise first?
