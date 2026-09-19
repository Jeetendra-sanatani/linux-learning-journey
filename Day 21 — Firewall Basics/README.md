# 🧱 Day 21 — Firewall Basics (ufw)

<p align="center">
  <img src="https://img.shields.io/badge/day-21%2F30-blue?style=for-the-badge" alt="Day 21"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> Day 5 taught you to check open ports. Day 21 teaches you to actually CONTROL which ports are reachable — a firewall is the bouncer standing at every door on your machine. 🧱

---

## 🏆 Day 20 Recap — Challenge Solutions

**Challenge 1 (The Efficient Backup):**
```bash
$ rsync -avz --progress practice/ raven@remoteserver:/home/raven/backup/
```

**Challenge 2 (Preview First):**
```bash
$ rsync -avz --dry-run --delete practice/ practice_backup/
```

**Challenge 3 (Selective Sync):**
```bash
$ rsync -avz --exclude="*.log" --exclude="temp/" practice/ backup/
```

---

## 🎯 Mission Briefing

Remember from Day 5 — every open port is a potential door into your machine. A firewall decides, port by port, WHO gets to knock and who gets turned away. Today you set up `ufw` (Uncomplicated Firewall) — the beginner-friendly firewall tool used on Debian/Ubuntu/Kali systems.

```
🧱 MISSION: Guard Your Doors
──────────────────────────────────────────
[ ] Check firewall status
[ ] Allow specific ports/services
[ ] Deny/block specific ports
[ ] Enable logging to see what's being blocked
──────────────────────────────────────────
STATUS: Day 21 — In Progress...
```

Security relevance: a properly configured firewall is one of the most basic yet most important hardening steps — it's often the FIRST thing checked (or exploited, if missing) during a security assessment.

---

## ⚡ Quick Theory — How a Firewall Actually Decides

At its core, a firewall checks incoming (and sometimes outgoing) network traffic against a set of RULES, in order, and decides: allow it through, or block it.

```
Default DENY approach (most secure): block everything, then explicitly ALLOW only what you need
Default ALLOW approach (less secure): allow everything, then explicitly DENY specific things
```

Most security-conscious setups use **default deny** — you only open the doors you actually need (like SSH on port 22, or a web server on port 80), and everything else stays closed by default.

**ufw's basic vocabulary:**
```
ufw enable/disable    → turn the firewall on/off entirely
ufw allow <port>       → let traffic through on this port
ufw deny <port>         → block traffic on this port
ufw status              → see current rules and whether ufw is even active
```

🚨 **The mistake that locks people out of their own server:** if you're connected via SSH (port 22) and you enable `ufw` WITHOUT first allowing port 22, you can instantly lock yourself out of a remote server with no way back in except physical/console access. ALWAYS allow SSH before enabling the firewall on a remote machine.

**Allowing by service name vs port number — both work:**
```bash
sudo ufw allow ssh      # ufw recognizes common service names
sudo ufw allow 22       # or specify the port number directly — same result
```

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔍 Checking firewall status
```bash
$ sudo ufw status
Status: inactive
```

### ✅ Allowing essential services BEFORE enabling (critical order!)
```bash
$ sudo ufw allow ssh
Rule added
Rule added (v6)

$ sudo ufw allow 22/tcp
Rule added
```

### 🟢 Enabling the firewall
```bash
$ sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
```

### 🔍 Checking status again (now with rules visible)
```bash
$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing)

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
```

### ✅ Allowing more services
```bash
$ sudo ufw allow 80/tcp       # HTTP
$ sudo ufw allow 443/tcp      # HTTPS
$ sudo ufw allow from 192.168.1.0/24 to any port 22   # only allow SSH from a specific subnet
```

### 🚫 Denying/removing rules
```bash
$ sudo ufw deny 23              # block Telnet (should never be open anyway)
$ sudo ufw delete allow 80      # remove a rule you previously added
```

### 📊 Checking logs for blocked attempts
```bash
$ sudo ufw logging on
$ sudo tail -f /var/log/ufw.log
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Check current firewall status with `sudo ufw status`
- [ ] Allow SSH BEFORE doing anything else (`sudo ufw allow ssh`)
- [ ] Enable the firewall and confirm you're still connected
- [ ] Check verbose status to see your active rules
- [ ] Allow one more port (like 80 for HTTP)
- [ ] Remove that rule using `ufw delete allow <port>`

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — The Safe Order**
> You're setting up a NEW remote server via SSH and need to enable ufw for the first time. Write the EXACT two-command sequence, in the correct order, to avoid locking yourself out.

> **🥊 Challenge 2 — Restricted Access**
> Write a `ufw` rule that allows SSH access ONLY from the subnet `192.168.1.0/24`, blocking SSH attempts from anywhere else.

> **🥊 Challenge 3 — The Audit**
> Write a command to see all currently active ufw rules in detail, including default policies (not just a simple yes/no active check).

🏆 Solutions drop in Day 22.

---

## 🧩 Quick Brain Check

1. What's the difference between "default deny" and "default allow" firewall approaches?
2. Why is the ORDER of commands critical when setting up ufw on a remote SSH session?
3. What does `ufw allow from 192.168.1.0/24 to any port 22` actually restrict?
4. What's the difference between `ufw deny` and `ufw delete allow`?
5. Why would enabling firewall logging be useful for security monitoring?

*(Reason it out first — discussed in Day 22.)*

---

## 🐛 Gotchas That'll Trip You Up

- Enabling `ufw` before allowing SSH on a remote server is one of the most common ways people accidentally lock themselves out — ALWAYS allow SSH first.
- `ufw deny 80` and `ufw delete allow 80` do DIFFERENT things — the first adds a new blocking rule, the second removes a previous allow rule. Know which one you actually want.
- Forgetting `/tcp` or `/udp` on a rule usually defaults to allowing both — sometimes fine, but be intentional about it for tighter control.

---

## 🧠 Today's Takeaway

A firewall is just a rule-based bouncer for network traffic — "default deny, then explicitly allow what's needed" is the security-conscious approach. `ufw allow ssh` BEFORE `ufw enable` is the golden rule that saves you from locking yourself out. And logging turns your firewall from a silent blocker into a source of security visibility.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 22 — System Monitoring (top, htop, vmstat)**
