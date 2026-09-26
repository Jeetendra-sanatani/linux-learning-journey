# 🕵️ Day 28 — Log Analysis for Security

<p align="center">
  <img src="https://img.shields.io/badge/day-28%2F30-blue?style=for-the-badge" alt="Day 28"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> 2 days left! Day 7 taught you WHERE logs live and basic reading. Today you combine that with Day 16's awk and Day 26's regex to actually INVESTIGATE — like a real incident, not just a tutorial. 🕵️

---

## 🏆 Day 27 Recap — Challenge Solutions

**Challenge 1 (The Quick Audit):**
Sample order: (1) Firewall status — is it even active, (2) SSH config — is root login blocked, (3) sudo access review — who has power, (4) SUID check, (5) world-writable files, (6) pending updates. Logic: check the outer defenses first (firewall/SSH), then internal privilege escalation risks (SUID/sudo), then hygiene (patches).

**Challenge 2 (Red Flag Spotting):**
`/usr/bin/find` with SUID root is dangerous because `find` has a documented `-exec` capability — an attacker could use `find / -exec /bin/sh \; -quit` to spawn a ROOT shell instantly. Any general-purpose tool with unnecessary SUID is a privilege escalation goldmine.

**Challenge 3 (The One-Liner Report):**
```bash
$ getent group sudo && sudo ufw status verbose
```

---

## 🎯 Mission Briefing

A real security incident doesn't announce itself — it hides in thousands of mundane log lines. Today you practice piecing together a timeline: WHO tried to log in, WHEN, FROM WHERE, and whether it succeeded — the exact process used in real investigations.

```
🕵️  MISSION: Investigate Like It's Real
──────────────────────────────────────────
[ ] Build a timeline of login attempts
[ ] Identify brute-force patterns
[ ] Correlate failed attempts with successful logins
[ ] Generate a simple incident summary
──────────────────────────────────────────
STATUS: Day 28 — In Progress...
```

---

## ⚡ Quick Theory — What a Real Investigation Looks Like

A basic login-attack investigation asks 4 questions, in order:

```
1. Are there failed login attempts at all?        → grep -c "Failed password"
2. Where are they coming from?                     → extract IPs (Day 26 regex)
3. Is any IP trying MANY times (brute force)?       → count occurrences per IP
4. Did any of those IPs eventually SUCCEED?           → check for "Accepted password" from the same IP
```

**The line that changes everything — a successful login from a brute-forcing IP:**
```
Failed password for root from 203.0.113.5 (x47 attempts)
Accepted password for root from 203.0.113.5     ← THIS is the moment of compromise
```
Forty-seven failures followed by ONE success from the same IP is a textbook brute-force compromise — exactly the pattern real security tools are built to detect.

**Combining everything you've learned into one investigation:**
```
grep (Day 3/7)     → filter relevant log lines
regex (Day 26)      → extract IP addresses precisely
awk (Day 16)         → pull out specific fields
sort/uniq -c (Day 8) → count occurrences, find the worst offenders
```

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔍 Step 1 — Confirm there ARE failed attempts
```bash
$ sudo grep -c "Failed password" /var/log/auth.log
47
```

### 🔍 Step 2 — Extract every IP involved in failed attempts
```bash
$ sudo grep "Failed password" /var/log/auth.log | grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | sort -u
203.0.113.5
198.51.100.7
```

### 🔍 Step 3 — Count attempts PER IP (find the worst offender)
```bash
$ sudo grep "Failed password" /var/log/auth.log | grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | sort | uniq -c | sort -rn
     44 203.0.113.5
      3 198.51.100.7
```
44 attempts from ONE ip = strong brute-force indicator.

### 🔍 Step 4 — Check if that suspicious IP EVER succeeded
```bash
$ sudo grep "203.0.113.5" /var/log/auth.log | grep "Accepted"
Aug 27 09:52:03 kali sshd[1301]: Accepted password for root from 203.0.113.5 port 51500
```
🚨 Found a successful login from the same IP that was brute-forcing — this is a compromise indicator.

### 🔍 Step 5 — Build a timeline around the compromise
```bash
$ sudo grep "203.0.113.5" /var/log/auth.log
Aug 27 09:40:01 kali sshd[1203]: Failed password for root from 203.0.113.5
Aug 27 09:40:03 kali sshd[1204]: Failed password for root from 203.0.113.5
... (44 attempts) ...
Aug 27 09:52:03 kali sshd[1301]: Accepted password for root from 203.0.113.5
```

### 🔍 Step 6 — Quick summary report (combining everything)
```bash
$ echo "=== Login Attack Summary ==="
$ echo "Total failed attempts: $(sudo grep -c 'Failed password' /var/log/auth.log)"
$ echo "Top offending IP:"
$ sudo grep "Failed password" /var/log/auth.log | grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | sort | uniq -c | sort -rn | head -1
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Count total failed login attempts in `/var/log/auth.log`
- [ ] Extract all unique IPs involved in failed attempts
- [ ] Count attempts per IP and identify the top offender
- [ ] Check if the top offending IP ever had a SUCCESSFUL login
- [ ] Build a full timeline of that IP's activity using `grep "<ip>" auth.log`
- [ ] Write a 3-line summary of what you'd tell someone about this "incident"

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — The Full Investigation**
> Write the FULL command sequence (as a chain, using `|`) that goes from raw `auth.log` to a sorted list of IPs with their failed-attempt counts, worst offender first.

> **🥊 Challenge 2 — Compromise Confirmation**
> Given a suspicious IP `203.0.113.5`, write a single command that checks whether it EVER had a successful login.

> **🥊 Challenge 3 — The Report**
> Write a short script (using what you learned in Day 12-13) that prints: total failed attempts, unique IP count, and the top offending IP, all in one run.

🏆 Solutions drop in Day 29.

---

## 🧩 Quick Brain Check

1. Why is "47 failed attempts then 1 success from the same IP" more suspicious than 47 failures alone?
2. What's the purpose of `sort | uniq -c | sort -rn` when analyzing log data?
3. Why would you check `/var/log/auth.log` specifically, rather than `/var/log/syslog`, for this kind of investigation?
4. If an attacker successfully logs in, what would you check NEXT after confirming the compromise?
5. Why is having a REPEATABLE process (a checklist/script) better than manually eyeballing logs each time?

*(Reason it out first — discussed in Day 29.)*

---

## 🐛 Gotchas That'll Trip You Up

- A high failed-attempt count alone doesn't confirm compromise — always check for a FOLLOWING successful login from the same source before concluding anything.
- Log timestamps can be in different timezones than you expect — always double check against `date` on the same system.
- Real attackers sometimes rotate through many IPs (distributed brute-force) — a single-IP count might miss a more sophisticated, distributed attack pattern.

---

## 🧠 Today's Takeaway

Real log analysis is detective work: confirm there's activity, identify WHO, count HOW OFTEN, and check if it ever SUCCEEDED. Every tool used today — grep, regex, awk, sort/uniq — you already knew individually; today they became an actual investigative workflow. This is genuinely close to what junior SOC analysts do daily.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 29 — Mini Project: System Health Dashboard Script**
