# 🖥️ Day 29 — Mini Project: System Health Dashboard Script

<p align="center">
  <img src="https://img.shields.io/badge/day-29%2F30-blue?style=for-the-badge" alt="Day 29"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-project-orange?style=for-the-badge" alt="Level"/>
</p>

> 1 day left! No new commands today — everything you need, you already learned across 28 days. Today you BUILD something real: a script that reports your system's health in one run. 🖥️

---

## 🏆 Day 28 Recap — Challenge Solutions

**Challenge 1 (The Full Investigation):**
```bash
$ sudo grep "Failed password" /var/log/auth.log | grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | sort | uniq -c | sort -rn
```

**Challenge 2 (Compromise Confirmation):**
```bash
$ sudo grep "203.0.113.5" /var/log/auth.log | grep "Accepted"
```

**Challenge 3 (The Report):** covered in full below — today's project builds exactly this, and more.

---

## 🎯 Mission Briefing

This is a PROJECT day, not a lesson day. You're combining: variables (Day 12), functions (Day 13), system info commands (Day 1), disk checks (Day 10), process monitoring (Day 4/22), and network info (Day 5) into ONE cohesive script that gives you a full system snapshot on demand.

```
🖥️  MISSION: Build a Real Tool
──────────────────────────────────────────
[ ] Structure a multi-section script using functions
[ ] Pull together commands from across the whole journey
[ ] Format output so it's actually readable
[ ] Test the finished script end-to-end
──────────────────────────────────────────
STATUS: Day 29 — In Progress...
```

---

## ⚡ Quick Theory — Designing a Script, Not Just Writing One

A good script isn't just commands dumped in a file — it's ORGANIZED. Today's design pattern:

```
1. One function per "section" (system info, memory, disk, processes, network)
2. A main flow at the bottom that calls each function in order
3. Simple formatting (headers, spacing) so the output is actually readable
```

**Why functions matter here specifically:** if you want to add a NEW check later (say, a security check from Day 27), you just add ONE more function and call it — the rest of the script doesn't need to change. This is the real payoff of Day 13's lesson.

**A formatting trick worth knowing — printing a divider line:**
```bash
divider() { printf '=%.0s' {1..50}; echo; }
```
This is a tiny function that just prints 50 `=` characters — a clean visual separator between sections, used constantly in real scripts.

---

## 💻 Building the Script — Piece by Piece

*(Machine: Kali Linux | User: `raven`)*

### 🧩 Section 1 — Setup and helper function
```bash
#!/bin/bash
divider() { printf '=%.0s' {1..50}; echo; }
```

### 🧩 Section 2 — System info function (Day 1)
```bash
system_info() {
    echo "SYSTEM INFORMATION"
    divider
    echo "Hostname: $(hostname)"
    echo "Kernel:   $(uname -r)"
    echo "Uptime:   $(uptime -p)"
}
```

### 🧩 Section 3 — Memory function (Day 1/22)
```bash
memory_check() {
    echo "MEMORY USAGE"
    divider
    free -h
}
```

### 🧩 Section 4 — Disk function (Day 10)
```bash
disk_check() {
    echo "DISK USAGE"
    divider
    df -h / /home 2>/dev/null
}
```

### 🧩 Section 5 — Top processes function (Day 4/22)
```bash
top_processes() {
    echo "TOP 5 PROCESSES BY MEMORY"
    divider
    ps aux --sort=-%mem | head -6
}
```

### 🧩 Section 6 — Network info function (Day 5)
```bash
network_info() {
    echo "NETWORK INFO"
    divider
    hostname -I
    echo "Listening ports:"
    ss -tuln | grep LISTEN
}
```

### 🧩 Putting it ALL together — the main flow
```bash
main() {
    echo "SYSTEM HEALTH DASHBOARD — $(date)"
    divider
    system_info
    echo ""
    memory_check
    echo ""
    disk_check
    echo ""
    top_processes
    echo ""
    network_info
}

main
```

### ▶️ Running the finished script
```bash
$ chmod +x health_dashboard.sh
$ ./health_dashboard.sh

SYSTEM HEALTH DASHBOARD — Wed Sep 24 14:00:00 IST 2025
==================================================
SYSTEM INFORMATION
==================================================
Hostname: kali
Kernel:   6.6.9-amd64
Uptime:   up 3 days, 2 hours

MEMORY USAGE
==================================================
              total   used   free   available
Mem:          7.6Gi   1.2Gi  4.8Gi  6.1Gi
...
```

**The full script file is included as `health_dashboard.sh` in this folder — copy it, chmod +x it, and run it yourself.**

---

## 🧪 Your Turn — Prove You Got This

- [ ] Copy the full script (provided in this folder) into your own environment
- [ ] Make it executable and run it — confirm every section works
- [ ] Modify the divider function to use a different character (like `-` instead of `=`)
- [ ] Add a NEW function that shows disk I/O stats (Day 23's `iostat`) and call it in `main()`
- [ ] Add a timestamp to the OUTPUT filename if you redirect it: `./health_dashboard.sh > report_$(date +%F).txt`
- [ ] Schedule this script to run daily using cron (Day 17) — save output to a log file

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — Add a Security Section**
> Add a NEW function called `security_check` that shows: sudo group members, and firewall status (pull from Day 27's checklist). Call it in `main()`.

> **🥊 Challenge 2 — Save to File**
> Modify the script so running it ALSO saves a copy of the output to `~/dashboard_reports/report_$(date +%F).txt`, creating the folder if it doesn't exist.

> **🥊 Challenge 3 — Schedule It**
> Write the cron entry that runs this script automatically every day at 7 AM, saving output to a dated log file.

🏆 Solutions drop in Day 30 — the FINAL day.

---

## 🧩 Quick Brain Check

1. Why is splitting the script into functions better than one long block of commands?
2. What does `printf '=%.0s' {1..50}` actually do to produce a divider line?
3. If you wanted to add a new check tomorrow, what's the minimum change needed to this script?
4. Why does `main()` call all the other functions instead of just running everything directly in the file?
5. How would you redirect this script's output to a file WHILE still seeing it on screen? (Hint: think back to a command from Day 6/7 involving `tee`.)

*(Reason it out first — discussed in Day 30.)*

---

## 🐛 Gotchas That'll Trip You Up

- Forgetting to define a function BEFORE it's called in `main()` causes a "command not found" error — order matters in bash scripts (Day 13 concept).
- Some commands (`ss -tuln` for full detail, `ufw status`) may need `sudo` — running the whole script with `sudo ./health_dashboard.sh` avoids partial permission errors.
- If disk paths like `/home` don't exist as separate mount points on your system, `df -h / /home` might show duplicate or odd output — adjust the paths to match your actual setup.

---

## 🧠 Today's Takeaway

This script isn't new knowledge — it's PROOF that 28 days of individual commands can combine into something genuinely useful. Functions organize it, a `main()` flow ties it together, and now you have a real, reusable tool sitting in your journal. Tomorrow: the final project, and the wrap-up of the whole 30-day journey.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 30 — Final Project: Automated Backup Script + Journal Wrap-Up**
