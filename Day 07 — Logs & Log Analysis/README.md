# 📜 Day 07 — Logs & Log Analysis

<p align="center">
  <img src="https://img.shields.io/badge/day-07%2F30-blue?style=for-the-badge" alt="Day 07"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie-yellow?style=for-the-badge" alt="Level"/>
</p>

> Day 6 taught you what runs in the background. Day 7 teaches you where those services WRITE DOWN everything they do — logs are the paper trail of your entire system. 📝

---

## 🏆 Day 06 Recap — Challenge Solutions

**Challenge 1 (The Persistence Check):**
```bash
$ systemctl is-enabled cron
```

**Challenge 2 (One-Shot Fix):**
```bash
$ sudo systemctl enable --now <service>
```

**Challenge 3 (The Audit):**
```bash
$ systemctl list-unit-files --type=service | grep enabled
```

---

## 🎯 Mission Briefing

Every login, every failed password, every service crash, every kernel hiccup — Linux writes it ALL down somewhere. Today you learn WHERE these logs live and how to actually read them without drowning in thousands of lines of text.

```
📜 MISSION: Read the System's Diary
──────────────────────────────────────────
[ ] Know where the important log files live
[ ] Read logs with cat, tail, and less
[ ] Filter huge log files with grep
[ ] Check authentication logs for failed logins
──────────────────────────────────────────
STATUS: Day 07 — In Progress...
```

Security relevance: **log analysis is literally how breaches get detected.** A failed-login spike, a weird process start time, an unexpected user login — it's all sitting in logs, waiting to be noticed.

---

## ⚡ Quick Theory — Where Does Linux Keep Its Diary?

Most logs live in one folder: **`/var/log/`**. Here's what actually matters as a beginner:

```
/var/log/syslog       → general system activity (Debian/Ubuntu/Kali)
/var/log/auth.log     → login attempts, sudo usage, authentication events
/var/log/kern.log     → kernel-level messages (hardware, drivers)
/var/log/dmesg        → boot-time messages
```

**Why `auth.log` matters most for security:** this is where every login attempt (successful AND failed) gets recorded. If someone's trying to brute-force SSH into your machine, `auth.log` is where you'd see it — dozens of "Failed password" lines from the same IP.

**Three tools to read logs, each for a different job:**
```
cat <file>      → dump the WHOLE file (fine for small logs, useless for huge ones)
tail -f <file>  → watch a log LIVE as new lines get added (great while testing something)
grep "text"     → search a huge log for exactly the lines you care about
```

🔑 **Key habit to build today:** never scroll through a massive log file manually. Always combine `grep` with the log file to jump straight to what matters — e.g. `grep "Failed password" auth.log` instantly shows every failed login, instead of you reading 10,000 lines by hand.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔍 Finding and viewing logs
```bash
$ ls /var/log
auth.log  syslog  kern.log  dmesg  boot.log

$ tail -20 /var/log/syslog
Aug 27 10:15:02 kali systemd[1]: Started SSH server.
Aug 27 10:15:10 kali sudo: raven : COMMAND=/usr/bin/apt update
```

### 📡 Watching a log live
```bash
$ sudo tail -f /var/log/syslog
# (stays open, shows new lines as they happen — Ctrl+C to stop)
```

### 🔎 Searching authentication logs
```bash
$ sudo grep "Failed password" /var/log/auth.log
Aug 27 09:40:12 kali sshd[1203]: Failed password for root from 203.0.113.5 port 51422

$ sudo grep "sudo" /var/log/auth.log | tail -5
Aug 27 10:15:10 kali sudo: raven : TTY=pts/0 ; COMMAND=/usr/bin/apt update
```

### 📊 Counting occurrences (useful for spotting patterns)
```bash
$ sudo grep -c "Failed password" /var/log/auth.log
14

$ sudo grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c
      12 203.0.113.5
       2 198.51.100.7
```

### 🗓️ Filtering by today's date
```bash
$ sudo grep "$(date '+%b %d')" /var/log/syslog | tail -10
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] List everything inside `/var/log` with `ls /var/log`
- [ ] View the last 20 lines of `/var/log/syslog` using `tail -20`
- [ ] Search `/var/log/auth.log` for the word "sudo" and see your own command history
- [ ] Count how many failed login attempts exist (if any) using `grep -c`
- [ ] Try `tail -f /var/log/syslog` and open a new terminal to trigger some activity — watch it appear live
- [ ] Filter `/var/log/syslog` to show only today's entries

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — The Intruder Count**
> Write a single command that counts exactly how many "Failed password" entries exist in `/var/log/auth.log`.

> **🥊 Challenge 2 — Who's Knocking?**
> Using the failed password log entries, write a command that extracts and lists the UNIQUE IP addresses attempting logins (hint: combine `grep`, `awk`, `sort`, `uniq`).

> **🥊 Challenge 3 — Today Only**
> Write a command that shows ONLY today's log entries from `/var/log/syslog`, without manually typing today's date.

🏆 Solutions drop in Day 08.

---

## 🧩 Quick Brain Check

1. What's the difference between `/var/log/syslog` and `/var/log/auth.log`?
2. Why is `cat` a bad idea for reading a log file that's several GB in size?
3. What does `tail -f` actually do differently from plain `tail`?
4. If you see 200 "Failed password" attempts from the same IP in `auth.log`, what does that likely indicate?
5. Why would `grep -c` be more useful than `grep` alone when checking for suspicious activity?

*(Reason it out first — discussed in Day 08.)*

---

## 🐛 Gotchas That'll Trip You Up

- Most log files under `/var/log` need `sudo` to read — especially `auth.log`, since it contains sensitive info.
- Log files rotate (get archived/compressed) after a certain size or age — you might find `auth.log.1` or `syslog.gz` sitting next to the current one.
- `tail -f` keeps running forever until you press `Ctrl+C` — don't forget you're "stuck" in it if the terminal seems frozen.

---

## 🧠 Today's Takeaway

Every meaningful event on a Linux system gets written down somewhere in `/var/log`. `auth.log` is your window into every login attempt — legitimate or malicious. And the real skill isn't reading logs line-by-line; it's knowing how to `grep` your way straight to what matters.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 08 — Linux Security Basics**
