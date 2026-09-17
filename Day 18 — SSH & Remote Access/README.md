# 🔗 Day 18 — SSH & Remote Access

<p align="center">
  <img src="https://img.shields.io/badge/day-18%2F30-blue?style=for-the-badge" alt="Day 18"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> Every server you'll ever manage professionally — you won't be sitting in front of it. SSH is how you control a machine that's in another room, another building, or another country. 🔗

---

## 🏆 Day 17 Recap — Challenge Solutions

**Challenge 1 (Weekend Warrior):**
```bash
0 9 * * 6,0    /path/to/script.sh
```

**Challenge 2 (The Silent Failure):**
Cron runs with a stripped-down environment — no custom `$PATH`, no `.bashrc` loaded. A script that works manually might fail in cron because a command it relies on isn't found. Fix: use FULL paths inside the script/cron entry, and always redirect output (`>> log 2>&1`) to actually SEE the error.

**Challenge 3 (Business Hours Only):**
```bash
*/15 9-17 * * 1-5    /path/to/health_check.sh
```

---

## 🎯 Mission Briefing

SSH (Secure Shell) is THE tool for logging into a remote machine over a network, securely. Today you connect to another machine, run commands remotely, and start understanding why this one protocol is the backbone of literally all remote server administration.

```
🔗 MISSION: Control a Machine From Afar
──────────────────────────────────────────
[ ] Connect to a remote machine via SSH
[ ] Run a single command remotely without logging in fully
[ ] Understand what happens on first connection
[ ] Copy files to/from a remote machine
──────────────────────────────────────────
STATUS: Day 18 — In Progress...
```

Security relevance: SSH is also one of the MOST commonly attacked services on the internet — brute-force login attempts against port 22 are constant. Understanding SSH deeply is both an admin skill and a defense skill.

---

## ⚡ Quick Theory — How SSH Actually Works (High Level)

SSH creates an **encrypted tunnel** between your machine and a remote one. Everything you type, everything that comes back, is encrypted in transit — unlike old protocols like Telnet, which sent everything (including passwords) in plain text.

**Basic connection syntax:**
```bash
ssh username@hostname
ssh raven@192.168.1.100
```

**What happens on your VERY FIRST connection to a new server:**
```
The authenticity of host '192.168.1.100' can't be established.
ED25519 key fingerprint is SHA256:xxxxxx...
Are you sure you want to continue connecting (yes/no)?
```
This isn't a bug — it's SSH asking "I've never seen this server before, do you trust it?" Once you say yes, that server's fingerprint gets saved in `~/.ssh/known_hosts`, so future connections skip this prompt (unless the server's identity changes, which then triggers a scary warning — a possible sign of an attack).

**Running ONE command remotely, without a full interactive session:**
```bash
ssh raven@server "uptime"
```
This connects, runs `uptime` on the REMOTE machine, prints the result, and disconnects — no full login needed.

**Copying files between machines with `scp`:**
```
scp file.txt raven@server:/remote/path/     → send a file TO the remote machine
scp raven@server:/remote/file.txt .          → pull a file FROM the remote machine
```

🔑 **Key distinction:** `ssh` gets you a shell/terminal on the remote machine. `scp` just moves files — no shell involved, just secure transfer.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven` connecting to a test server)*

### 🔗 Basic SSH connection
```bash
$ ssh raven@192.168.1.100
The authenticity of host '192.168.1.100' can't be established.
Are you sure you want to continue connecting (yes/no)? yes
raven@192.168.1.100's password: ********

raven@remoteserver:~$          # now you're on the REMOTE machine's shell
```

### 🚪 Exiting back to your own machine
```bash
raven@remoteserver:~$ exit
logout
Connection to 192.168.1.100 closed.

$                                # back on your own machine
```

### ⚡ Running a single remote command
```bash
$ ssh raven@192.168.1.100 "uptime"
raven@192.168.1.100's password: ********
 14:32:01 up 3 days,  2:14,  1 user,  load average: 0.15, 0.10, 0.05

$ ssh raven@192.168.1.100 "df -h && free -h"
```

### 📤 Copying files with scp
```bash
$ scp notes.txt raven@192.168.1.100:/home/raven/
notes.txt    100%   45     1.2KB/s   00:00

$ scp raven@192.168.1.100:/home/raven/report.txt .
report.txt   100%  120     3.1KB/s   00:00

$ scp -r practice/ raven@192.168.1.100:/home/raven/backup/
```

### 🔍 Checking active SSH connections (from the server's side)
```bash
$ who
raven    pts/0    2025-08-27 14:30 (192.168.1.50)

$ w
14:32:01 up 3 days,  USER  TTY  FROM
raven    pts/0    192.168.1.50
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] SSH into a test machine (a VM, another Kali install, or a cloud instance if you have one)
- [ ] Note what happens the FIRST time you connect (the fingerprint prompt)
- [ ] Run a single remote command without fully logging in: `ssh user@host "whoami"`
- [ ] Copy a file TO the remote machine using `scp`
- [ ] Copy a file BACK from the remote machine using `scp`
- [ ] Check who else is logged into that machine with `who` or `w`

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — Quick Check**
> Write a single SSH command that connects to `raven@192.168.1.50` and immediately runs `df -h` without giving you an interactive shell.

> **🥊 Challenge 2 — The Whole Folder**
> Write an `scp` command that copies an ENTIRE folder called `project/` to a remote server at `/home/raven/backup/`.

> **🥊 Challenge 3 — Fingerprint Change Warning**
> You SSH into a server you've connected to many times, and suddenly get a big scary warning about the host key changing. What are TWO possible explanations — one harmless, one concerning?

🏆 Solutions drop in Day 19.

---

## 🧩 Quick Brain Check

1. What does SSH actually protect that older tools like Telnet didn't?
2. What gets stored in `~/.ssh/known_hosts`, and why does it matter?
3. What's the difference between `ssh user@host` and `ssh user@host "command"`?
4. What does the `-r` flag do when used with `scp`?
5. Why is SSH (port 22) such a common target for brute-force attacks?

*(Reason it out first — discussed in Day 19.)*

---

## 🐛 Gotchas That'll Trip You Up

- If a server gets reinstalled/reconfigured, its SSH fingerprint changes — you'll get a scary "REMOTE HOST IDENTIFICATION HAS CHANGED" warning. Legitimate reason? Fine, remove the old entry from `known_hosts`. Unexpected? Investigate before proceeding — could indicate an attack.
- Forgetting `-r` when using `scp` on a folder gives "not a regular file" — `scp` needs `-r` for directories, just like `cp`.
- Typing the wrong IP/hostname just hangs the connection attempt for a while before timing out — double-check the address first.

---

## 🧠 Today's Takeaway

SSH replaces "walking over to the server" with an encrypted terminal session from anywhere. `ssh user@host` gets you a shell; adding a command runs it remotely without a full login; `scp` moves files securely, same login credentials. And that first-connection fingerprint prompt isn't paranoia — it's SSH actually doing its job.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 19 — SSH Key-Based Authentication**
