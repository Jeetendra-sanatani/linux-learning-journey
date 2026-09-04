# 🔒 Day 08 — Linux Security Basics

<p align="center">
  <img src="https://img.shields.io/badge/day-08%2F30-blue?style=for-the-badge" alt="Day 08"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie-yellow?style=for-the-badge" alt="Level"/>
</p>

> Day 2 taught basic permissions. Day 7 taught you to read the diary. Day 8 connects the dots — this is where "using Linux" starts turning into "securing Linux." 🛡️

---

## 🏆 Day 07 Recap — Challenge Solutions

**Challenge 1 (The Intruder Count):**
```bash
$ sudo grep -c "Failed password" /var/log/auth.log
```

**Challenge 2 (Who's Knocking?):**
```bash
$ sudo grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort -u
```

**Challenge 3 (Today Only):**
```bash
$ sudo grep "$(date '+%b %d')" /var/log/syslog
```

---

## 🎯 Mission Briefing

Everything so far — permissions, users, processes, logs — all quietly feeds into ONE goal: keeping a system secure. Today you learn the special permission bits attackers specifically look for (SUID/SGID), and build a basic mental checklist for "does this system look reasonably locked down?"

```
🔒 MISSION: Think Like a Defender
──────────────────────────────────────────
[ ] Understand SUID and SGID bits
[ ] Find dangerous SUID files
[ ] Check for world-writable files (again, deeper this time)
[ ] Build a basic hardening checklist
──────────────────────────────────────────
STATUS: Day 08 — In Progress...
```

Security relevance: **SUID binaries are one of the most common privilege escalation paths.** If a random program has SUID root and isn't supposed to, that's a red flag pentesters actively hunt for.

---

## ⚡ Quick Theory — Beyond Basic Permissions

Remember `rwx` from Day 2? There are two special permission bits that go beyond that:

**SUID (Set User ID)** — when set on an executable, it runs with the **file owner's** privileges, not the privileges of whoever ran it.
```
Example: /usr/bin/passwd has SUID set to root.
This is WHY a normal user can change their own password —
passwd needs to edit /etc/shadow (root-only file), and SUID
temporarily lends it root power just for that task.
```

**SGID (Set Group ID)** — similar idea, but for group ownership. On a directory, it makes every NEW file created inside automatically inherit the directory's group.

**How you SEE these bits in `ls -la`:**
```
-rwsr-xr-x   → the 's' instead of 'x' in the OWNER slot = SUID is set
-rwxr-sr-x   → the 's' in the GROUP slot = SGID is set
```

🚨 **Why this matters for security:** SUID root binaries are gold for attackers during privilege escalation. If they find a poorly-known SUID binary that lets them read/write arbitrary files, they can potentially escalate from a normal user to root. **Auditing SUID binaries** is a standard step in both attacking and defending a system.

**A basic hardening mindset (just the essentials for today):**
```
1. No unnecessary SUID binaries lying around
2. No world-writable files that shouldn't be
3. SSH root login disabled (from Day 5-6 context)
4. Keep an eye on auth.log for brute-force attempts (Day 7)
5. Only give sudo access to users who actually need it
```

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔍 Spotting SUID/SGID in permission strings
```bash
$ ls -la /usr/bin/passwd
-rwsr-xr-x  1 root root  68208  /usr/bin/passwd
#    ^-- that 's' means SUID is active, running as root
```

### 🔎 Finding all SUID binaries on the system
```bash
$ find / -perm -4000 -type f 2>/dev/null
/usr/bin/passwd
/usr/bin/sudo
/usr/bin/su

$ find / -perm -4000 -type f 2>/dev/null | wc -l
23
```

### 🔎 Finding all SGID binaries
```bash
$ find / -perm -2000 -type f 2>/dev/null
/usr/bin/wall
/usr/bin/write
```

### 🔎 Revisiting world-writable files (deeper check)
```bash
$ find / -perm -002 -type f 2>/dev/null | grep -v "^/proc"
/tmp/shared_notes.txt
```

### 🔧 Removing a dangerous/unnecessary SUID bit (if you ever find one)
```bash
$ sudo chmod u-s /path/to/suspicious_binary
```

### 🛡️ Quick SSH hardening check (revisiting Day 5-6 territory)
```bash
$ sudo grep "PermitRootLogin" /etc/ssh/sshd_config
PermitRootLogin no
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Check `/usr/bin/passwd` permissions and spot the SUID bit yourself
- [ ] List every SUID binary on your system with `find / -perm -4000 -type f 2>/dev/null`
- [ ] Count how many SUID binaries exist using `wc -l`
- [ ] List every SGID binary using `-perm -2000`
- [ ] Re-check for world-writable files across the whole system (not just /tmp this time)
- [ ] Check your SSH config for `PermitRootLogin` — is it `yes` or `no`?

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — The SUID Hunt**
> Write a single command that lists all SUID binaries on the system, hiding permission-denied error noise.

> **🥊 Challenge 2 — Odd One Out**
> You run the SUID hunt and find `/usr/bin/passwd`, `/usr/bin/sudo`, AND `/usr/bin/nano` in the results. Which one looks suspicious, and why?

> **🥊 Challenge 3 — The Checklist**
> Write down (in your notes) 3 things you'd check FIRST if someone handed you a random Linux server and said "is this secure?"

🏆 Solutions drop in Day 09.

---

## 🧩 Quick Brain Check

1. What's the actual difference between SUID and SGID?
2. Why does `/usr/bin/passwd` NEED the SUID bit to function correctly?
3. If you see `-rwsr-xr-x` in `ls -la`, what does that lowercase `s` tell you?
4. Why would a pentester specifically search for SUID binaries during privilege escalation?
5. What permission number represents SUID in octal (the "4" in `4755`)?

*(Reason it out first — discussed in Day 09.)*

---

## 🐛 Gotchas That'll Trip You Up

- `find / -perm -4000` without `2>/dev/null` floods your screen with "Permission denied" errors from folders you can't access — always redirect those away.
- A capital `S` (instead of lowercase `s`) in the permission string means SUID is set but the execute bit ISN'T — usually a sign of a misconfigured file, worth investigating.
- Removing SUID from an important system binary (like `passwd`) will BREAK it — never touch SUID bits on files you don't fully understand.

---

## 🧠 Today's Takeaway

SUID/SGID bits let a program temporarily borrow someone else's permissions — genuinely useful (like `passwd`), but a favorite target for privilege escalation when misused. Security isn't one big lock — it's a dozen small checks like this one, done consistently.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 09 — Package Management**
