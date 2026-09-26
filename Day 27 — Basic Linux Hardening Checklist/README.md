# 🛡️ Day 27 — Basic Linux Hardening Checklist

<p align="center">
  <img src="https://img.shields.io/badge/day-27%2F30-blue?style=for-the-badge" alt="Day 27"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> 3 days left! Today isn't a new tool — it's a CHECKLIST. Everything from permissions (Day 2) to SUID (Day 8) to SSH (Day 18-19) to firewalls (Day 21) comes together into one practical hardening routine. 🛡️

---

## 🏆 Day 26 Recap — Challenge Solutions

**Challenge 1 (Digit Extractor):**
```bash
$ echo "Order #45231 shipped on day 12" | grep -Eo "[0-9]+"
```

**Challenge 2 (IP Harvester):**
```bash
$ grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" /var/log/auth.log | sort -u
```

**Challenge 3 (The Redactor):**
```bash
$ sed -E 's/[0-9]{10}/[PHONE REDACTED]/g' file.txt
```

---

## 🎯 Mission Briefing

You've learned dozens of individual security-relevant commands across 26 days. Today you turn them into a REPEATABLE ROUTINE — the kind of checklist a real sysadmin runs on any server they inherit, before trusting it.

```
🛡️  MISSION: Build Your Hardening Routine
──────────────────────────────────────────
[ ] Check for weak/unnecessary SUID binaries
[ ] Verify SSH is properly locked down
[ ] Confirm firewall is active with minimal open ports
[ ] Check for world-writable files and weak permissions
[ ] Review sudo access and user accounts
──────────────────────────────────────────
STATUS: Day 27 — In Progress...
```

This is genuinely how junior security/sysadmin roles start — not writing exploits, but running through a checklist like this on real systems, consistently.

---

## ⚡ Quick Theory — Why a Checklist, Not Just "Be Careful"

Security isn't one big lock — it's dozens of small, boring checks done CONSISTENTLY. A machine is "hardened" not because of one heroic fix, but because someone systematically closed every small gap: no unnecessary SUID, no world-writable files, no default passwords, no unneeded open ports.

**Today's checklist pulls together commands you already know:**
```
Day 2  → permissions & world-writable files
Day 3  → users & sudo access
Day 8  → SUID/SGID binaries
Day 9  → keeping packages updated (patched = secure)
Day 18 → SSH configuration
Day 21 → firewall rules
```

🔑 **The mindset shift today:** you're not learning a NEW command — you're learning to run OLD commands in sequence, as a habit, every time you touch a new or existing server. This is what separates "knows Linux commands" from "can actually secure a system."

---

## 💻 Let's Get Our Hands Dirty — The Checklist in Action

*(Machine: Kali Linux | User: `raven`)*

### ✅ Step 1 — Check for unnecessary SUID binaries (Day 8)
```bash
$ find / -perm -4000 -type f 2>/dev/null
/usr/bin/passwd
/usr/bin/sudo
/usr/bin/su
# Review this list — anything unexpected here is a red flag
```

### ✅ Step 2 — Check for world-writable files (Day 2)
```bash
$ find / -perm -002 -type f 2>/dev/null | grep -v "^/proc"
# Ideally, this should return NOTHING important
```

### ✅ Step 3 — Review user accounts & sudo access (Day 3)
```bash
$ awk -F: '$3 >= 1000 {print $1}' /etc/passwd    # list real user accounts
$ getent group sudo                               # who has admin powers?
# Every name here should be someone who ACTUALLY needs sudo access
```

### ✅ Step 4 — Check SSH configuration (Day 18-19)
```bash
$ sudo grep "PermitRootLogin" /etc/ssh/sshd_config
PermitRootLogin no          # should say 'no'

$ sudo grep "PasswordAuthentication" /etc/ssh/sshd_config
PasswordAuthentication no    # ideally 'no', if key-based auth is fully set up
```

### ✅ Step 5 — Confirm firewall is active (Day 21)
```bash
$ sudo ufw status verbose
Status: active
Default: deny (incoming), allow (outgoing)
22/tcp    ALLOW   Anywhere
```

### ✅ Step 6 — Check for pending security updates (Day 9)
```bash
$ sudo apt update
$ apt list --upgradable
```

### ✅ Step 7 — Quick failed-login check (Day 7)
```bash
$ sudo grep -c "Failed password" /var/log/auth.log
```

### 📋 Putting it all in ONE script (preview — full script tomorrow!)
```bash
#!/bin/bash
echo "=== SUID Check ==="
find / -perm -4000 -type f 2>/dev/null

echo "=== World-Writable Files ==="
find / -perm -002 -type f 2>/dev/null | grep -v "^/proc"

echo "=== Sudo Group Members ==="
getent group sudo

echo "=== Firewall Status ==="
sudo ufw status
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Run the SUID check and review every result — is anything unexpected?
- [ ] Run the world-writable file check across your whole system
- [ ] List every account with sudo access using `getent group sudo`
- [ ] Check your SSH config's `PermitRootLogin` and `PasswordAuthentication` settings
- [ ] Confirm your firewall status with `ufw status verbose`
- [ ] Check for pending updates with `apt list --upgradable`

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — The Quick Audit**
> Write down (in your notes) the exact ORDER you'd run these 6 checks on a brand-new server someone just handed you, and why that order makes sense.

> **🥊 Challenge 2 — Red Flag Spotting**
> You run the SUID check and see `/usr/bin/find` in the results (a file-searching tool having SUID root). Why is this a serious red flag, and what real-world risk does it create?

> **🥊 Challenge 3 — The One-Liner Report**
> Combine ANY 2 checks from today into a single command using `&&` or `;` that runs them back-to-back.

🏆 Solutions drop in Day 28.

---

## 🧩 Quick Brain Check

1. Why is "hardening" described as many small checks rather than one big fix?
2. Why does checking `PermitRootLogin` matter even if you have a strong root password?
3. What's the security reasoning behind checking sudo group membership regularly?
4. Why should package updates (Day 9) be considered part of a security checklist, not just a maintenance task?
5. If you could only run 3 of today's 6 checks on a time-limited audit, which 3 would you prioritize, and why?

*(Reason it out first — discussed in Day 28.)*

---

## 🐛 Gotchas That'll Trip You Up

- Running these checks ONCE and forgetting about them defeats the purpose — hardening is a routine, not a one-time task.
- Disabling `PasswordAuthentication` in SSH BEFORE confirming key-based login actually works can lock you out entirely — always test key login first (Day 19), then disable passwords.
- A "clean" SUID/world-writable check today doesn't guarantee it stays clean tomorrow — new software installs can introduce new SUID binaries or misconfigured permissions.

---

## 🧠 Today's Takeaway

Hardening isn't a single command — it's a habit built from everything you've already learned: permissions, SUID awareness, sudo hygiene, SSH configuration, firewall rules, and staying patched. Today's checklist is the first draft of a routine real sysadmins run repeatedly. Tomorrow, you turn this into an actual automated script.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 28 — Log Analysis for Security**
