# 📈 Day 22 — System Monitoring (top, htop, vmstat)

<p align="center">
  <img src="https://img.shields.io/badge/day-22%2F30-blue?style=for-the-badge" alt="Day 22"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> Day 4 gave you `ps aux` — a snapshot. Day 22 gives you LIVE, real-time dashboards of your entire system's health, updating every second. 📈

---

## 🏆 Day 21 Recap — Challenge Solutions

**Challenge 1 (The Safe Order):**
```bash
$ sudo ufw allow ssh
$ sudo ufw enable
```

**Challenge 2 (Restricted Access):**
```bash
$ sudo ufw allow from 192.168.1.0/24 to any port 22
```

**Challenge 3 (The Audit):**
```bash
$ sudo ufw status verbose
```

---

## 🎯 Mission Briefing

`ps aux` from Day 4 gives you a single photograph of your system. Today's tools give you a live VIDEO — constantly refreshing views of CPU, memory, and process activity, which is exactly what you need when something's acting weird RIGHT NOW.

```
📈 MISSION: Watch Your System Live
──────────────────────────────────────────
[ ] Navigate top's live interface confidently
[ ] Use htop as a friendlier alternative
[ ] Read vmstat's system-wide statistics
[ ] Sort and filter what you're watching
──────────────────────────────────────────
STATUS: Day 22 — In Progress...
```

Real-world relevance: when a server feels sluggish, these tools are the FIRST thing any sysadmin opens — before checking logs, before restarting anything.

---

## ⚡ Quick Theory — Reading a Live Dashboard

**`top` — built-in on every Linux system, no install needed:**

The top section shows SYSTEM-WIDE stats; the bottom section lists individual PROCESSES, refreshing continuously.

```
Key numbers in the header:
load average: 0.52, 0.48, 0.35   → system load over last 1, 5, 15 minutes
%Cpu(s): 12.3 us, 2.1 sy, 85.1 id  → us=user processes, sy=system, id=idle
```

**Understanding "load average" (a genuinely confusing concept at first):** it roughly represents how many processes are actively wanting CPU time. On a single-core machine, a load average of 1.0 means it's fully busy; on a 4-core machine, 4.0 means fully busy. Below your core count = generally fine.

**Useful keys while `top` is running:**
```
q        → quit
M        → sort by memory usage
P        → sort by CPU usage
k        → kill a process (will ask for PID)
1        → show individual CPU cores separately (instead of combined average)
```

**`htop` — the friendlier, color-coded version** (needs installing: `sudo apt install htop`):
Same information as `top`, but with visual bars for CPU/memory, mouse support, and generally easier for beginners to read at a glance.

**`vmstat` — a different angle: system-wide resource stats, not per-process:**
```bash
vmstat 1 5
```
Shows CPU, memory, and I/O statistics, refreshing every 1 second, 5 times total — great for spotting patterns over a short window without an interactive interface.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 📊 Using top
```bash
$ top
top - 14:32:01 up 3 days,  2:14,  1 user,  load average: 0.52, 0.48, 0.35
Tasks: 215 total,   1 running, 214 sleeping
%Cpu(s): 12.3 us,  2.1 sy,  0.0 ni, 85.1 id
MiB Mem :   7834.0 total,   4821.2 free,   1203.5 used

  PID USER   %CPU  %MEM  COMMAND
 1523 raven   4.2   8.1  firefox
  842 raven   0.2   1.3  bash
```
Press `M` to sort by memory, `P` to sort by CPU, `q` to quit.

### 📊 Installing and using htop
```bash
$ sudo apt install htop
$ htop
# same info as top, but color-coded bars for CPU cores and memory
# use arrow keys to navigate, F9 to kill a process, F10 or q to quit
```

### 📊 Using vmstat
```bash
$ vmstat 1 5
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 1  0      0 4821248 102400 1650000    0    0     2     5  120  250 12  2 85  1
 0  0      0 4820900 102400 1650100    0    0     0     0  115  240 10  1 89  0
```

### 🔍 Checking CPU core count and details
```bash
$ nproc
4

$ lscpu | grep "Model name"
Model name: Intel(R) Core(TM) i5-1035G1
```

### 📊 Quick one-time snapshot (non-interactive)
```bash
$ top -bn1 | head -15    # -b = batch mode, -n1 = one iteration, good for scripts/logs
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Open `top`, note your current load average, then press `q` to quit
- [ ] Reopen `top`, press `M` to sort by memory — identify the top consumer
- [ ] Press `P` to sort by CPU instead
- [ ] Install and try `htop` — compare the visual difference to `top`
- [ ] Run `vmstat 1 5` and watch the numbers update in real-time
- [ ] Check your CPU core count with `nproc` and relate it to what a "high" load average would mean on your machine

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — The Snapshot**
> Write a command that captures a ONE-TIME, non-interactive snapshot of `top`'s output (no live refreshing) — useful for logging or scripts.

> **🥊 Challenge 2 — Load Average Reading**
> Your machine has 4 CPU cores, and `top` shows a load average of `6.2, 5.8, 4.1`. Is this machine overloaded right now? Explain your reasoning.

> **🥊 Challenge 3 — Quick Comparison**
> In one line each, explain when you'd reach for `ps aux` (Day 4) vs `top` vs `vmstat` — what's each one actually best for?

🏆 Solutions drop in Day 23.

---

## 🧩 Quick Brain Check

1. What does "load average" actually represent, in plain English?
2. Why does a load average of 2.0 mean something different on a 2-core machine vs an 8-core machine?
3. What's the practical difference between `top` and `htop`?
4. What does `vmstat 1 5` mean — what do the two numbers control?
5. Why would `top -bn1` be more useful than plain `top` inside a script?

*(Reason it out first — discussed in Day 23.)*

---

## 🐛 Gotchas That'll Trip You Up

- `top`'s live refresh makes it impossible to copy-paste output cleanly — use `top -bn1` for a one-time, scriptable snapshot instead.
- A "high" load average is meaningless without knowing your CPU core count first — always check `nproc` for context.
- `htop` isn't installed by default on all systems — if you get "command not found," install it first (`sudo apt install htop`).

---

## 🧠 Today's Takeaway

`top` and `htop` give you a live, refreshing view of exactly what's consuming CPU and memory RIGHT NOW — essential for diagnosing a slow system in real time. `vmstat` steps back to system-wide statistics over a time window. And "load average" only means something relative to how many CPU cores you actually have.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 23 — Disk I/O & Performance Basics**
