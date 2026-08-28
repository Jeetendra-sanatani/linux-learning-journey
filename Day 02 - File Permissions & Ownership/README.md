# 🔐 Day 02 — File Permissions & Ownership

<p align="center">
  <img src="https://img.shields.io/badge/day-02%2F30-blue?style=for-the-badge" alt="Day 02"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie-yellow?style=for-the-badge" alt="Level"/>
</p>

> Day 1 was recon — figuring out where you landed. Day 2 is about power: who's allowed to touch what, and why Linux is so paranoid about it. 🔒

---

## 🏆 Day 01 Recap — Challenge Solutions

**Challenge 1 (User Hunting):**
```bash
$ grep "/bin/bash" /etc/passwd
```
`/etc/passwd` lines have 7 colon-separated fields; the shell is the last one. Grepping for `/bin/bash` filters out service accounts (which use `nologin`).

**Challenge 2 (Memory Trap):**
Not a problem — Linux fills idle RAM with disk cache to speed things up. That cache is instantly reclaimable the moment an app needs it. "Available" reflects real usable memory; "free" doesn't.

**Challenge 3 (One-Line Setup):**
```bash
$ mkdir -p practice/logs/2024
```
`-p` creates all missing parent folders in the chain automatically.

---

## 🎯 Mission Briefing

Yesterday you learned to look around. Today you learn the rule that runs the ENTIRE Linux security model: **every single file has an owner, a group, and a strict set of rules about who can read it, write it, or run it.**

This isn't just trivia — this is THE mechanism behind privilege escalation, misconfigurations, and half the vulnerabilities you'll study in security work. A wrongly permissioned file is often the first crack an attacker finds.

```
🔒 MISSION: Decode the Permission System
──────────────────────────────────────────
[ ] Read any permission string on sight
[ ] Change permissions with chmod
[ ] Change ownership with chown
[ ] Understand WHY 777 is dangerous
──────────────────────────────────────────
STATUS: Day 02 — In Progress...
```

---

## ⚡ Quick Theory — Cracking the Permission Code

Run `ls -la` on any file and you'll see something like this:

```
-rwxr-xr--  2  raven  security  4096  Aug 27 09:00  scan.sh
```

Break it down, piece by piece:

```
┌─ File type (- = file, d = directory, l = symlink)
│┌─┬─┐┌─┬─┐┌─┬─┐
-rwx r-x r--
│└┬┘ └┬┘ └┬┘
│ │   │   └── OTHERS  → r-- (read only)
│ │   └────── GROUP   → r-x (read + execute)
│ └────────── OWNER   → rwx (read + write + execute)
```

Three permission types, each worth a number:
```
r (read)    = 4
w (write)   = 2
x (execute) = 1
- (none)    = 0
```

Add them up per group → that's your **octal number**. `rwx` = 4+2+1 = **7**. `r-x` = 4+0+1 = **5**. `r--` = 4+0+0 = **4**. So `rwxr-xr--` becomes **754** — this is exactly what `chmod 754 file` sets.

**Common patterns you'll see everywhere:**
```
644 (rw-r--r--)  → normal files — owner edits, everyone else just reads
755 (rwxr-xr-x)  → scripts & folders — owner does everything, others can run/enter
700 (rwx------)  → private stuff — only the owner can touch it at all
777 (rwxrwxrwx)  → EVERYONE can do EVERYTHING — a security nightmare, avoid this
```

🚨 **Why 777 is a red flag in security work:** if a file or folder is `777`, literally any user (or attacker who got a foothold) can read, modify, or execute it. This is one of the first things a pentester checks for during privilege escalation — misconfigured world-writable files are a classic way in.

**Ownership is a separate thing from permissions.** Every file has an **owner** (a user) and a **group**. Permissions decide *what's allowed*; ownership decides *who the "owner" and "group" categories actually refer to*.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔍 Reading permissions
```bash
$ touch scan.sh
$ ls -la scan.sh
-rw-r--r--  1 raven raven  0 Aug 27 10:00 scan.sh
```

### 🔧 Changing permissions with chmod
```bash
$ chmod +x scan.sh
$ ls -la scan.sh
-rwxr--r--  1 raven raven  0 Aug 27 10:00 scan.sh

$ chmod 755 scan.sh
$ ls -la scan.sh
-rwxr-xr-x  1 raven raven  0 Aug 27 10:00 scan.sh

$ chmod 700 scan.sh
$ ls -la scan.sh
-rwx------  1 raven raven  0 Aug 27 10:00 scan.sh
```

### 👤 Changing ownership with chown / chgrp
```bash
$ sudo chown raven:security scan.sh
$ ls -la scan.sh
-rwx------  1 raven security  0 Aug 27 10:00 scan.sh

$ sudo chgrp sudo scan.sh
$ ls -la scan.sh
-rwx------  1 raven sudo  0 Aug 27 10:00 scan.sh
```

### 📁 Directories behave differently
```bash
$ mkdir private_folder
$ chmod 700 private_folder
$ ls -la
drwx------  2 raven raven 4096 Aug 27 10:05 private_folder
```
For directories: `r` = list contents, `w` = create/delete files inside, `x` = actually enter (`cd`) the folder.

---

## 🧪 Your Turn — Prove You Got This

- [ ] Create a file, check its default permissions with `ls -la`
- [ ] Make it executable using symbolic mode: `chmod u+x <file>`
- [ ] Set it to `644` using octal mode, then verify with `ls -la`
- [ ] Create a folder, set it to `700`, and confirm only you can enter it
- [ ] Change a file's owner to yourself explicitly: `chown $(whoami) <file>`
- [ ] Find every file in your home folder that's world-writable: `find ~ -perm -002 -type f`

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — Decode This**
> A file shows permissions `drwxrwxr-x`. Without running any command, tell me: (a) is this a file or a folder, (b) what can the OWNER do, (c) what's the octal number?

> **🥊 Challenge 2 — Fix the Danger**
> You find a script `deploy.sh` set to `777`. Fix it so only the owner can read/write/execute it, and the group can only read + execute — nothing for others. What's the exact `chmod` command?

> **🥊 Challenge 3 — The Hunt**
> Write a single command that finds every file in `/tmp` that is world-writable (a common security red flag).

🏆 Solutions drop in Day 03.

---

## 🧩 Quick Brain Check

1. What's the difference between `chmod 644` and `chmod 600`?
2. If a directory has permission `r-x` for a user (no `w`), can that user create a new file inside it?
3. What does `chown alice:devs file.txt` actually change — one thing or two?
4. Why is `777` considered dangerous instead of just "convenient"?
5. What's the octal value for `rw-rw-r--`?

*(Reason it out first — discussed in Day 03.)*

---

## 🐛 Gotchas That'll Trip You Up

- `chmod +x file` only adds execute for the OWNER by default in some shells — always double check with `ls -la` after.
- Changing ownership (`chown`) usually needs `sudo` — you can't hand a file to another user without elevated privileges.
- A directory needs BOTH `r` (to list) AND `x` (to enter) to actually be usable — having only one without the other causes confusing "permission denied" errors.

---

## 🧠 Today's Takeaway

Permissions aren't bureaucracy — they're the wall between "this is fine" and "this is how attackers get in." Owner, group, others. Read, write, execute. Three numbers (0-7) that control everything. And `777` is never the lazy fix it looks like.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 03 — Users & Groups**
