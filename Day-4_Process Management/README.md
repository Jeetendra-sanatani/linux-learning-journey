# ⚙️ Day 04 — Process Management

<p align="center">
  <img src="https://img.shields.io/badge/day-04%2F30-blue?style=for-the-badge" alt="Day 04"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie-yellow?style=for-the-badge" alt="Level"/>
</p>

> Day 3 was about WHO exists on the system. Day 4 is about WHAT they're actually doing right now — every running program, every background service, every zombie lurking in the process table. 🧟

---

## 🏆 Day 03 Recap — Challenge Solutions

**Challenge 1 (The Impersonator):**
```bash
$ grep ":1050:" /etc/passwd
```
If nothing prints, "ghost" with UID 1050 doesn't exist.

**Challenge 2 (Group Detective):**
```bash
$ getent group sudo
```

**Challenge 3 (Safe Removal):**
```bash
$ sudo userdel tempuser
```
(no `-r` flag → deletes the account only, home folder stays untouched)

---

## 🎯 Mission Briefing

Right now, dozens of processes are running on your machine — some you started, most you never even see. Every one has a PID, an owner, a status, and a resource footprint. Today you learn to see them all, understand what "zombie" and "sleeping" actually mean, and — most importantly — how to kill something that's misbehaving.

```
⚙️  MISSION: Command the Process Table
──────────────────────────────────────────
[ ] List and filter running processes
[ ] Read CPU/memory usage per process
[ ] Send signals (kill gracefully vs forcefully)
[ ] Manage background & foreground jobs
──────────────────────────────────────────
STATUS: Day 04 — In Progress...
```

In security work, **process enumeration** is exactly how you spot something that shouldn't be there — a hidden miner, a reverse shell, a service running as root that shouldn't be. This is a core recon skill.

---

## ⚡ Quick Theory — What Even IS a Process?

A **process** is simply a program that's currently running. The moment you type a command and hit Enter, Linux creates a process for it — assigns it a **PID** (Process ID), tracks its memory and CPU usage, and manages its lifecycle until it exits.

**Key columns you'll see in `ps aux`:**
```
USER   → who owns this process
PID    → unique process ID number
%CPU   → CPU usage right now
%MEM   → memory usage right now
STAT   → current state (see below)
COMMAND → what's actually running
```

**Process states (the STAT column) — decode these on sight:**
```
R  → Running        (actively executing)
S  → Sleeping        (waiting for something, e.g. input)
D  → Uninterruptible sleep (usually waiting on disk I/O)
Z  → Zombie          (finished, but not yet cleaned up by its parent)
T  → Stopped         (paused, e.g. via Ctrl+Z)
```

🧟 **Zombie processes explained simply:** when a process finishes, it doesn't disappear instantly — its exit status waits for the parent process to "collect" it. If the parent never does, it becomes a zombie: dead, but still sitting in the process table. A handful of zombies is harmless; hundreds usually means a buggy parent process.

**Signals — how you actually "kill" something:**
```
SIGTERM (15) → "please stop when you're ready" — graceful, default with kill
SIGKILL (9)  → "stop RIGHT NOW" — forceful, cannot be ignored, last resort
SIGHUP  (1)  → "reload your config" — often used to restart services gracefully
```

**Rule of thumb:** always try `kill -15` (or plain `kill`) first. Jump to `kill -9` only if the process refuses to die — force-killing skips cleanup, which can leave temp files or corrupted state behind.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔍 Viewing processes
```bash
$ ps aux | head -6
USER   PID  %CPU  %MEM  STAT  COMMAND
root     1   0.0   0.1  Ss    /sbin/init
raven  842   0.2   1.3  S     bash
raven  910   0.0   0.5  R     ps aux

$ ps aux --sort=-%cpu | head -6     # top CPU consumers
$ ps aux --sort=-%mem | head -6     # top memory consumers
```

### 🎯 Finding a specific process
```bash
$ pgrep bash
842

$ pgrep -l bash
842 bash

$ ps aux | grep firefox | grep -v grep
raven  1523  4.2  8.1  /usr/lib/firefox/firefox
```

### 🔪 Killing processes
```bash
$ kill 1523              # graceful (SIGTERM)
$ kill -9 1523            # forceful (SIGKILL) — only if it won't die
$ pkill firefox           # kill by name instead of PID
```

### 📦 Background & foreground jobs
```bash
$ sleep 300 &
[1] 2044

$ jobs
[1]+  Running    sleep 300 &

$ fg %1                   # bring it to foreground
^Z                        # Ctrl+Z suspends it
$ bg %1                   # resume it in background
```

### 🔧 Managing services with systemctl
```bash
$ sudo systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Active: active (running)

$ sudo systemctl stop ssh
$ sudo systemctl start ssh
$ sudo systemctl restart ssh
$ sudo systemctl enable ssh    # start automatically on boot
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Run `ps aux` and identify the STAT column for 3 different processes
- [ ] Find the top 5 CPU-consuming processes on your system
- [ ] Start a background process with `sleep 100 &`, then find it with `jobs`
- [ ] Kill that background process using its PID
- [ ] Use `pgrep` to find the PID of your own shell
- [ ] Check the status of the SSH service with `systemctl status ssh`

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — Zombie Hunt**
> Write a single command that counts how many zombie processes currently exist on your system.

> **🥊 Challenge 2 — The Graceful Exit**
> A process with PID `2044` is stuck. Show the correct ORDER of commands you'd try — starting gentle, escalating only if needed.

> **🥊 Challenge 3 — Resource Hog**
> Without opening `top`, find the single process using the most memory RIGHT NOW, and print just its PID and command name.

🏆 Solutions drop in Day 05.

---

## 🧩 Quick Brain Check

1. What's the actual difference between `SIGTERM` and `SIGKILL`?
2. What does the `Z` state mean in `ps aux`, and why does it happen?
3. If you press `Ctrl+Z` on a running command, what state does it go into?
4. What's the difference between `kill` and `pkill`?
5. Why would `kill -9` sometimes leave a mess behind that `kill -15` wouldn't?

*(Reason it out first — discussed in Day 05.)*

---

## 🐛 Gotchas That'll Trip You Up

- `kill -9` looks like the "strong" option so beginners reach for it first — but it skips all cleanup. Always try `kill` (SIGTERM) before escalating.
- `ps aux | grep processname` almost always also matches the `grep` command itself in the output — filter it out with `grep -v grep`.
- A background job (`&`) still dies when you close the terminal, unless you run it with `nohup` first.

---

## 🧠 Today's Takeaway

Every running thing on Linux is just a process with a PID, an owner, and a state. `ps aux` is your window into all of it. Kill gently first (`SIGTERM`), force only as a last resort (`SIGKILL`). And zombies aren't scary — they're just processes waiting to be cleaned up.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 05 — Networking Basics**
