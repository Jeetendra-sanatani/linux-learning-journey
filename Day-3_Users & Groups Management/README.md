# 👥 Day 03 — Users & Groups Management

<p align="center">
  <img src="https://img.shields.io/badge/day-03%2F30-blue?style=for-the-badge" alt="Day 03"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie-yellow?style=for-the-badge" alt="Level"/>
</p>

> Day 2 taught you who's allowed to touch what. Day 3 teaches you WHO those "whos" even are — and how to create, manage, and lock them down. 👤

---

## 🏆 Day 02 Recap — Challenge Solutions

**Challenge 1 (Decode This):** `drwxrwxr-x` → (a) it's a **directory** (starts with `d`), (b) owner can **read, write, enter** (`rwx`), (c) octal = **775**.

**Challenge 2 (Fix the Danger):**
```bash
$ chmod 750 deploy.sh
```
`750` = owner: rwx (7), group: r-x (5), others: nothing (0).

**Challenge 3 (The Hunt):**
```bash
$ find /tmp -perm -002 -type f
```

---

## 🎯 Mission Briefing

Every file has an owner. Every process runs as someone. But who exactly IS that "someone"? Today you crack open `/etc/passwd`, learn to create real user accounts, organize them into groups, and understand the ONE command that decides who gets to act like root: `sudo`.

```
👤 MISSION: Control the Population
──────────────────────────────────────────
[ ] Read user account info from /etc/passwd
[ ] Create and delete users
[ ] Create and manage groups
[ ] Understand sudo & privilege escalation
──────────────────────────────────────────
STATUS: Day 03 — In Progress...
```

This matters more than it sounds — in security work, **enumerating users and groups** is one of the very first things done during a penetration test. Weak or forgotten accounts are a classic way in.

---

## ⚡ Quick Theory — Users, Groups & the Root of All Power

**Every user on Linux has three key identifiers:**
```
UID (User ID)   → a unique number identifying the user (root = 0, normal users usually start at 1000)
GID (Group ID)  → the user's PRIMARY group
Groups          → a user can belong to MANY additional (secondary) groups
```

**Where this info actually lives:**
```
/etc/passwd   → username : x : UID : GID : comment : home_dir : shell
/etc/shadow   → hashed passwords (root-only, this is the vault)
/etc/group    → groupname : x : GID : list_of_members
```

Fun detail: the `x` in `/etc/passwd` isn't a placeholder for nothing — it means "the real password hash lives in `/etc/shadow` instead," which only root can read. This split exists purely for security — everyone can read `/etc/passwd` (for basic info), but nobody except root can peek at password hashes.

**Why groups even matter:** instead of setting permissions user-by-user (a nightmare at scale), you put related users in a group (e.g. `developers`, `security-team`) and give the GROUP permission on shared files. Add someone to the group → they instantly inherit access. Remove them → access instantly gone.

**sudo — the most important command you'll learn all week:**
There's no "Administrator" account like Windows. Instead, the **root** user has unlimited power, and normal users borrow that power temporarily using `sudo` (Super User DO). Being in the `sudo` group is literally what makes this borrowing possible — that's why adding a user to `sudo` group is such a big deal.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔍 Reading user info
```bash
$ whoami
raven

$ id
uid=1000(raven) gid=1000(raven) groups=1000(raven),27(sudo)

$ cat /etc/passwd | tail -3
raven:x:1000:1000:raven,,,:/home/raven:/bin/bash

$ groups raven
raven : raven sudo
```

### 👤 Creating a new user
```bash
$ sudo useradd -m -s /bin/bash phoenix
$ sudo passwd phoenix
New password: ********
Retype new password: ********
passwd: password updated successfully

$ id phoenix
uid=1001(phoenix) gid=1001(phoenix) groups=1001(phoenix)
```

### 🔧 Modifying a user
```bash
$ sudo usermod -aG sudo phoenix
$ groups phoenix
phoenix : phoenix sudo

$ sudo usermod -L phoenix        # lock the account
$ sudo usermod -U phoenix        # unlock the account
```

### 👥 Creating and managing groups
```bash
$ sudo groupadd security-team
$ sudo usermod -aG security-team raven
$ groups raven
raven : raven sudo security-team

$ getent group security-team
security-team:x:1002:raven
```

### 🗑️ Deleting a user
```bash
$ sudo userdel -r phoenix       # -r also removes home directory
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Run `id` and identify your UID, GID, and every group you belong to
- [ ] Look up your own entry in `/etc/passwd` using `grep $(whoami) /etc/passwd`
- [ ] Create a new user with a home directory and bash shell
- [ ] Set a password for that user
- [ ] Create a new group and add your new user to it
- [ ] Verify group membership with `groups <username>` and `getent group <groupname>`
- [ ] Delete the test user and its home directory

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — The Impersonator**
> Someone claims a user called `ghost` exists on the system with UID `1050`. Write a single command to check if that's true using `/etc/passwd`.

> **🥊 Challenge 2 — Group Detective**
> Find every user who belongs to the `sudo` group (i.e., who has admin powers) without opening a text editor — one command only.

> **🥊 Challenge 3 — Safe Removal**
> You need to delete a user called `tempuser` but their home directory has files a teammate still needs. What's the correct `userdel` command that removes the ACCOUNT but keeps the home folder?

🏆 Solutions drop in Day 04.

---

## 🧩 Quick Brain Check

1. What's the difference between a user's UID and GID?
2. Why does `/etc/passwd` show `x` instead of an actual password?
3. What command adds an EXISTING user to an EXISTING group without removing them from their other groups?
4. If a user is in the `sudo` group, what can they actually do that a normal user can't?
5. What's the risk of typing `sudo groupdel sudo` (deleting the sudo group entirely)?

*(Reason it out first — discussed in Day 04.)*

---

## 🐛 Gotchas That'll Trip You Up

- `usermod -G` (capital G, no `-a`) **replaces** ALL of a user's groups instead of adding one — always use `-aG` (append + groups) unless you actually mean to wipe their other memberships.
- Forgetting `-m` when creating a user (`useradd` without `-m`) means NO home directory gets created — the user technically exists but has nowhere to live.
- After adding yourself to a new group, you often need to **log out and back in** (or run `newgrp <group>`) before the change actually takes effect in your current session.

---

## 🧠 Today's Takeaway

Users aren't just names — they're UIDs, GIDs, and group memberships that decide exactly what a person (or attacker) can touch on a system. `/etc/passwd` shows the roster, `/etc/shadow` guards the secrets, and `sudo` is the one gate between "normal user" and "root." Enumerate users first — it's day one of any real investigation.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 04 — Process Management**
