# 💾 Day 23 — Disk I/O & Performance Basics

<p align="center">
  <img src="https://img.shields.io/badge/day-23%2F30-blue?style=for-the-badge" alt="Day 23"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> Day 22 taught you to watch CPU and memory live. Day 23 fills the last piece of the performance puzzle — is the DISK itself the bottleneck? Sometimes it's not the CPU that's slow, it's the disk struggling to keep up. 💾

---

## 🏆 Day 22 Recap — Challenge Solutions

**Challenge 1 (The Snapshot):**
```bash
$ top -bn1
```

**Challenge 2 (Load Average Reading):**
Yes, this machine IS overloaded. With 4 cores, "fully busy" = load average around 4.0. A reading of 6.2 means there's consistently MORE work queued up than the CPUs can handle at once.

**Challenge 3 (Quick Comparison):**
`ps aux` = one-time snapshot of processes. `top` = live, continuously refreshing view of processes + system stats. `vmstat` = system-wide numeric stats over a time window, good for spotting trends without an interactive UI.

---

## 🎯 Mission Briefing

A server can have plenty of free CPU and RAM, yet still feel sluggish — because the DISK is the bottleneck, struggling to read/write fast enough. Today you learn to check disk I/O activity and spot when storage itself is the problem, not the processor.

```
💾 MISSION: Find the Real Bottleneck
──────────────────────────────────────────
[ ] Check disk I/O activity in real time
[ ] Understand read/write speed basics
[ ] Identify which process is hammering the disk
[ ] Know when disk (not CPU) is your actual problem
──────────────────────────────────────────
STATUS: Day 23 — In Progress...
```

---

## ⚡ Quick Theory — What "Disk I/O" Actually Means

**I/O = Input/Output** — in this context, specifically reading FROM and writing TO your storage device. Every time a program opens a file, saves data, or a database writes a record, that's disk I/O happening.

**Why disk can be the hidden bottleneck:** CPUs are blazing fast; even a good SSD is comparatively much slower at reading/writing data. If a process is constantly waiting on disk operations, your CPU sits IDLE waiting for data — this shows up as high "wa" (I/O wait) time, something you might have glossed over in Day 22's `top` output without realizing its significance.

**Revisiting that `%Cpu(s)` line from Day 22, this time focusing on `wa`:**
```
%Cpu(s): 12.3 us,  2.1 sy,  0.0 ni, 40.1 id, 45.5 wa
                                              ^^^^^^^^
                                    High "wa" = CPU is waiting on disk, not actually busy
```

If `wa` (I/O wait) is consistently high, your bottleneck is likely the DISK, not the CPU — a completely different problem requiring a different fix (faster storage, fewer simultaneous disk operations, etc.) than a CPU-bound issue would.

**`iostat` — the dedicated tool for this (needs installing):**
```bash
sudo apt install sysstat
iostat -x 1
```
Shows detailed read/write statistics PER DISK, refreshing continuously — this is where you'd actually confirm "yes, the disk is genuinely overloaded right now."

**`iotop` — like `top`, but for disk usage specifically:**
Shows WHICH PROCESS is doing the most disk reading/writing right now — genuinely useful when one runaway process is hogging your disk.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔍 Checking I/O wait via top (recap, focused this time)
```bash
$ top
%Cpu(s): 8.2 us,  1.5 sy,  0.0 ni, 75.3 id, 15.0 wa
                                              ^^^^^^
                                    15% I/O wait — worth watching if it climbs higher
```

### 📊 Installing and using iostat
```bash
$ sudo apt install sysstat
$ iostat -x 1 5
Device    r/s   w/s   rkB/s   wkB/s   %util
sda       2.1   5.3   84.2    212.6   3.2
```
`%util` close to 100% means the disk is essentially maxed out, working flat-out.

### 📊 Installing and using iotop (needs root)
```bash
$ sudo apt install iotop
$ sudo iotop
TID   PRIO  USER    DISK READ   DISK WRITE   COMMAND
1523  be/4  raven   1.2 M/s     450.0 K/s    firefox
```
Press `q` to quit — shows which process is actually generating disk activity RIGHT NOW.

### 🔍 Checking disk read/write speed (rough, manual test)
```bash
$ dd if=/dev/zero of=testfile bs=1M count=100
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 0.82 s, 128 MB/s

$ rm testfile     # clean up the test file afterward
```

### 📋 Combining with Day 10 knowledge — checking disk usage AND performance together
```bash
$ df -h              # how full is the disk (Day 10)
$ iostat -x 1 3       # how BUSY is the disk right now (today)
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Open `top` and specifically watch the `wa` (I/O wait) percentage for a minute
- [ ] Install `sysstat` and run `iostat -x 1 5`
- [ ] Note the `%util` column — how close to 100% does your disk get during normal use?
- [ ] Install `iotop` and run it while doing something disk-heavy (like copying a large file)
- [ ] Identify which process shows the highest disk activity in `iotop`
- [ ] Run the `dd` test command to get a rough read of your disk's write speed

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — The Diagnosis**
> `top` shows CPU usage at only 20% but the system feels sluggish. `wa` shows 60%. What's actually going on, and which tool would you reach for NEXT to confirm it?

> **🥊 Challenge 2 — The Culprit**
> Your disk is at 95% utilization consistently. Write the command that would show you EXACTLY which process is responsible.

> **🥊 Challenge 3 — Quick Speed Test**
> Write a `dd` command that writes a 50MB test file to measure rough write speed, then explain why you should delete the test file afterward.

🏆 Solutions drop in Day 24.

---

## 🧩 Quick Brain Check

1. What does "I/O wait" (the `wa` value in top) actually indicate?
2. Why might a system with LOW CPU usage still feel slow?
3. What does `iostat -x`'s `%util` column tell you?
4. What's the difference between what `top` shows you and what `iotop` shows you?
5. Why is disk I/O often a "hidden" bottleneck that beginners miss when troubleshooting a slow system?

*(Reason it out first — discussed in Day 24.)*

---

## 🐛 Gotchas That'll Trip You Up

- `sysstat` (for `iostat`) and `iotop` aren't installed by default — you'll get "command not found" until you install them.
- The `dd` speed test writes real data to disk — always clean up the test file afterward, and never point it at a device path (`/dev/sda`) by mistake, which could destroy real data.
- High CPU usage grabs attention immediately in `top`, but a high `wa` value quietly sitting there is just as important to notice — don't only look at `us`/`sy`.

---

## 🧠 Today's Takeaway

Not every performance problem is a CPU problem — a high `wa` (I/O wait) value in `top` is your signal that the DISK, not the processor, is the bottleneck. `iostat` confirms disk-level statistics; `iotop` pinpoints WHICH process is responsible. This completes the performance troubleshooting toolkit: CPU (Day 22), memory (Day 1/22), and now disk I/O.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 24 — Symbolic & Hard Links**
