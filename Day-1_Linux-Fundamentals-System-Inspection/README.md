# 🐧 Day 01 — Welcome to the Linux Terminal, Rookie

<p align="center">
  <img src="https://img.shields.io/badge/day-01%2F30-blue?style=for-the-badge" alt="Day 01"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie-yellow?style=for-the-badge" alt="Level"/>
  <img src="https://img.shields.io/badge/vibe-terminal_gang-black?style=for-the-badge" alt="Vibe"/>
</p>

> Day 1. No GUI. No mouse. Just me, a blinking cursor, and a whole new language to learn. Let's go. 🚀

---

## 🎯 Mission Briefing

You just sat down at a terminal you've never touched before. No icons. No taskbar. No "Recycle Bin" to click on. Just a blinking cursor staring back at you, waiting.

Here's a secret every hacker, sysadmin, and DevOps engineer already knows: **the very first move is never an attack, a fix, or a deployment.** It's recon on yourself. *Who am I on this box? What machine did I even land on? What's silently running in the background? Where the hell am I standing in this filesystem?*

Four questions. Answer them, and you've already out-leveled 90% of beginners who jump straight to "fancy commands" without knowing where they are.

```
🕵️  MISSION: Know Your Machine
────────────────────────────────
[ ] Who am I?
[ ] What system is this?
[ ] What's running?
[ ] Where am I standing?
────────────────────────────────
STATUS: Day 01 — In Progress...
```

That's it. That's the whole brief. Deceptively simple — but this exact instinct is what separates someone who *uses* Linux from someone who actually *understands* it.

---

## ⚡ So... What IS Linux, Actually?

Skip the Wikipedia definition. Here's the actual story, and it's a good one.

Back in **1991**, a broke Finnish college student named **Linus Torvalds** was annoyed that operating systems were expensive, closed-off, and controlled by corporations. So he did what any stubborn 21-year-old with too much free time does — he built his own kernel from scratch, purely as a hobby project, and posted about it online like it was no big deal.

> *"I'm doing a (free) operating system (just a hobby, won't be big and professional...)"* — Linus Torvalds, 1991, severely underestimating himself.

Fast forward to today: that "hobby" now runs **the majority of the internet's servers, every Android phone on Earth, every supercomputer in the Top 500, and yes — the exact machine you're learning security on right now.**

Here's the entire architecture, no fluff:

```
┌─────────────────────────────────────────────┐
│  🗣️  SHELL                                   │
│  The translator. Turns what YOU type         │
│  into something the kernel understands.      │
└──────────────────┬────────────────────────────┘
                   ↓
┌─────────────────────────────────────────────┐
│  🧠  KERNEL                                   │
│  The brain. Talks directly to your CPU,      │
│  RAM, and disk. The real boss.               │
└──────────────────┬────────────────────────────┘
                   ↓
┌─────────────────────────────────────────────┐
│  🖥️  HARDWARE                                 │
│  The muscle. CPU, RAM, disk, network card.   │
└─────────────────────────────────────────────┘

📦 DISTRO = Kernel + Shell + a pile of pre-installed
   tools, wrapped up and made bootable for humans.
```

🔑 **The one fact that'll make Linux click instantly:** everything is a file. Your entire hard disk? A file (`/dev/sda`). A running process? A file (`/proc/1234`). Even the stream of keys you're typing right now? Technically a file. Once this idea lands, half the "weirdness" of Linux disappears.

**So why are we running Kali instead of Ubuntu?**

| | Ubuntu | Kali |
|---|---|---|
| Vibe | Daily driver 🚗 | Tactical toolkit 🎒 |
| Built for | General everyday use | Penetration testing & security |
| Comes with | Browser, office apps | 600+ hacking/security tools pre-installed (nmap, wireshark, metasploit...) |

We're not here to browse the internet — we're here to build security skills. So from Day 1, home base is **Kali**.

---

## 🗺️ The Linux Filesystem — Your New City Map

Coming from Windows? Forget `C:\`, `D:\`. Linux has **ONE tree**, starting from a single root: `/`. Everything — every disk, every USB, every file — lives somewhere under this one tree. No exceptions.

Think of it like a city map. You don't need to memorize every street on Day 1 — just know which neighborhood does what:

```text
/                    ← Root: the top of EVERYTHING
├── bin/             ← Everyday tools (ls, cp, mv, cat)
├── boot/            ← Boot loader files — what runs before Linux even starts
├── dev/             ← Device files (yes, your hard disk is literally "a file" here)
├── etc/             ← ALL system config lives here — the control room
│   ├── passwd       ← List of user accounts
│   ├── shadow       ← Hashed passwords (root-only, top secret)
│   └── hosts        ← Manual hostname → IP mappings
├── home/            ← Every user's personal space
│   └── raven/       ← My home: /home/raven
├── proc/            ← A "fake" filesystem — live kernel & process data
│   ├── cpuinfo      ← Your CPU's specs, live
│   └── meminfo      ← Your RAM usage, live
├── root/            ← The root USER's home (different from / root directory!)
├── tmp/             ← Junk drawer — wiped clean on every reboot
├── usr/             ← Most installed programs live here (python3, git, vim)
└── var/             ← Stuff that keeps changing
    └── log/         ← Where all your system's logs pile up
```

**The one thing worth remembering today:** `/etc` = configs, `/var/log` = logs, `/home` = your stuff, `/proc` = live system data. That's 80% of what you'll actually touch as a beginner.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔍 Who am I? Where am I?
```bash
$ whoami
raven

$ id
uid=1000(raven) gid=1000(raven) groups=1000(raven),27(sudo)

$ pwd
/home/raven
```

### 🖥️ What machine is this?
```bash
$ uname -a
Linux kali 6.6.9-amd64 #1 SMP Debian 6.6.9-1kali1 x86_64 GNU/Linux

$ cat /etc/os-release
NAME="Kali GNU/Linux"
VERSION="2024.1"

$ hostname
kali
```

### ⚙️ What's running right now?
```bash
$ ps aux | head -5
USER   PID  %CPU  %MEM  COMMAND
root     1   0.0   0.1  /sbin/init
raven  842   0.2   1.3  bash

$ free -h
              total   used   free   available
Mem:          7.6Gi   1.2Gi  4.8Gi  6.1Gi
```

### 📂 Exploring the city map for real
```bash
$ ls /
bin  boot  dev  etc  home  proc  root  tmp  usr  var

$ ls /etc | head -5
passwd
shadow
hosts
fstab
ssh

$ ls -la
drwxr-xr-x  4 raven raven 4096 Aug 27 10:00 .
drwxr-xr-x  3 raven raven 4096 Aug 27 09:50 ..
-rw-r--r--  1 raven raven   45 Aug 27 10:00 notes.txt

$ mkdir practice
$ touch practice/notes.txt
$ echo "Day 1 complete" > practice/notes.txt
$ cat practice/notes.txt
Day 1 complete
```

That's it. That's the whole recon toolkit for today — but you'll use these literally every single day from here on.

---

## 🧪 Your Turn — Prove You Got This

Don't just read the commands above — **actually type them.** Reading terminal commands without running them is like watching gym videos and expecting biceps.

- [ ] Run `uname -a` — what kernel version did YOU get?
- [ ] Check your distro info from `/etc/os-release`
- [ ] Find your user ID and group memberships with `id`
- [ ] Explore `/etc` and `/var/log` — just `ls` into them and see what's there
- [ ] Hunt down the top 5 memory-hungry processes: `ps aux --sort=-%mem | head -6`
- [ ] Build a `practice` folder, drop a file in it, write something into it, read it back
- [ ] Check how long your system's been running: `uptime`

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — User Hunting**
> Somewhere in `/etc/passwd` are real login accounts and fake service accounts mixed together. Find only the users whose shell is `/bin/bash` (skip the `nologin` ones).

> **🥊 Challenge 2 — The Memory Trap**
> `free -h` shows low "free" memory but high "available" memory. A beginner panics. You don't — explain in one line why this is actually fine.

> **🥊 Challenge 3 — One-Line Setup**
> Create this entire folder chain in a SINGLE command: `practice/logs/2024`. (Hint: one flag on `mkdir` does all the magic.)

🏆 Solutions drop in Day 02. No cheating by googling — struggle with it first, that's where the learning actually happens.

---

## 🧩 Quick Brain Check

1. `uname -a` vs `uname -r` — what's the actual difference?
2. Which file spills the distro name — `/etc/os-release` or `/etc/passwd`?
3. What's stored inside `/etc/shadow`, and why can only root read it?
4. `/proc` isn't a "real" filesystem on disk — so what actually is it?
5. You're in `/home/raven/practice`. One command gets you back to `/home/raven`. What is it?
6. Why would a security learner pick Kali over vanilla Ubuntu?

*(No answer key here on purpose — force yourself to reason it out. Discussed in Day 02.)*

---

## 🐛 Gotchas That'll Trip You Up

- `hostnamectl` sometimes ghosts you on minimal/container setups — `hostname` is the reliable fallback.
- `cd` into a folder that doesn't exist yet? Instant "No such file or directory." Make the folder first.
- Don't confuse `/root` (the root user's home folder) with `/` (the root of the whole filesystem) — two very different things with a suspiciously similar name.

---

## 🧠 Today's Takeaway

Linux isn't scary — it's just a conversation. Kernel, Shell, Distro. Everything's a file. One single filesystem tree starting at `/`, with `/etc` for configs, `/var/log` for logs, `/home` for your stuff. And `pwd` is your best friend when you're 5 folders deep and suddenly lost.

Small commands today. But every recon skill in security starts exactly here.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 02 — File Permissions & Ownership** (where things get spicy 🔐)
