# ⏰ Day 17 — Cron Jobs & Task Scheduling

<p align="center">
  <img src="https://img.shields.io/badge/day-17%2F30-blue?style=for-the-badge" alt="Day 17"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> You've written scripts (Day 12-13) — but who's going to actually RUN them every day at 2 AM while you sleep? That's cron's whole job. ⏰

---

## 🏆 Day 16 Recap — Challenge Solutions

**Challenge 1 (Real Users Only):**
```bash
$ awk -F: '$3 >= 1000 {print $1}' /etc/passwd
```

**Challenge 2 (The Shell Report):**
```bash
$ awk -F: '{print $1, $7}' /etc/passwd
```

**Challenge 3 (Context Detective):**
```bash
$ grep -B 2 "Failed password" /var/log/auth.log
```

---

## 🎯 Mission Briefing

Backups that run every night. Log cleanups every week. Health checks every 5 minutes. None of these need a human sitting there pressing Enter — that's exactly what **cron** exists for: a built-in scheduler that runs your scripts automatically, on whatever timetable you define.

```
⏰ MISSION: Automate on a Schedule
──────────────────────────────────────────
[ ] Understand cron's 5-field time syntax
[ ] View and edit your own crontab
[ ] Schedule a script to run automatically
[ ] Use shortcuts like @daily and @reboot
──────────────────────────────────────────
STATUS: Day 17 — In Progress...
```

---

## ⚡ Quick Theory — Decoding Cron's Weird Syntax

Every cron job follows this 5-field format, and yes, everyone Googles this every single time at first:

```
┌───── minute (0-59)
│ ┌───── hour (0-23)
│ │ ┌───── day of month (1-31)
│ │ │ ┌───── month (1-12)
│ │ │ │ ┌───── day of week (0-7, both 0 and 7 = Sunday)
│ │ │ │ │
* * * * *  command_to_run
```

**Special characters that make this readable:**
```
*     → "every" (every minute, every hour, etc.)
,     → a list (e.g., 1,3,5 = at minutes 1, 3, and 5)
-     → a range (e.g., 1-5 = Monday through Friday)
/     → a step (e.g., */5 = every 5 units)
```

**Reading real examples out loud (this is how you should practice it):**
```
0 6 * * *      → "at minute 0, hour 6, every day"        = 6:00 AM daily
*/5 * * * *    → "every 5 minutes"
0 9-17 * * 1-5 → "hour 9 through 17, Monday through Friday" = business hours
```

🔑 **Shortcuts that skip the 5-field syntax entirely:**
```
@reboot   → run once when the system starts up
@daily    → same as "0 0 * * *" (midnight every day)
@hourly   → same as "0 * * * *"
@weekly   → same as "0 0 * * 0"
```

**Where your cron jobs actually live:** `crontab -e` opens YOUR personal schedule — it's stored separately per user, so your jobs won't clash with anyone else's on a shared system.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 📝 Viewing and editing your crontab
```bash
$ crontab -l
no crontab for raven

$ crontab -e
# opens an editor — pick nano if asked
```

### ⏰ Adding a simple scheduled job
Inside the crontab editor, add:
```bash
* * * * * echo "cron is alive" >> /home/raven/cron_test.log
```
Save and exit. Wait a minute, then check:
```bash
$ cat /home/raven/cron_test.log
cron is alive
cron is alive
```

### ⏰ A more realistic example — daily backup at 2 AM
```bash
0 2 * * * /home/raven/practice/backup.sh >> /home/raven/backup.log 2>&1
```

### ⏰ Running something every 5 minutes
```bash
*/5 * * * * /home/raven/scripts/health_check.sh
```

### ⏰ Using shortcuts
```bash
@reboot /home/raven/scripts/startup_check.sh
@daily /home/raven/scripts/daily_report.sh
```

### 📋 Listing and removing cron jobs
```bash
$ crontab -l                    # view your current cron jobs
$ crontab -r                    # REMOVE all your cron jobs (careful — no confirmation!)
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Open your crontab with `crontab -e` (choose nano if prompted)
- [ ] Add a test job that appends a timestamp to a log file every minute
- [ ] Wait 2-3 minutes and confirm the log file is actually growing
- [ ] Remove the test job (edit crontab again, delete that line)
- [ ] Write a cron entry (just the syntax, don't have to run it) for "every day at 6 AM"
- [ ] Write a cron entry for "every 10 minutes, Monday to Friday only"

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — Weekend Warrior**
> Write a cron schedule that runs a script every Saturday and Sunday at 9 AM only.

> **🥊 Challenge 2 — The Silent Failure**
> You set up a cron job to run a backup script, but it never seems to actually create the backup. The exact same script works fine when you run it manually. What's a common reason cron jobs fail silently, and how would you debug it?

> **🥊 Challenge 3 — Business Hours Only**
> Write a cron schedule that runs a health-check script every 15 minutes, but ONLY between 9 AM and 5 PM, Monday through Friday.

🏆 Solutions drop in Day 18.

---

## 🧩 Quick Brain Check

1. In `0 6 * * *`, what does each of the 5 fields represent?
2. What's the difference between `crontab -e` and directly editing `/etc/crontab`?
3. What does `@reboot` actually trigger?
4. Why should cron job commands always use FULL paths (like `/usr/bin/python3` instead of just `python3`)?
5. What does `crontab -r` do, and why is it risky to run carelessly?

*(Reason it out first — discussed in Day 18.)*

---

## 🐛 Gotchas That'll Trip You Up

- Cron runs with a MINIMAL environment — no `$PATH` customizations from your `.bashrc`. A script using `python3` directly might fail in cron even though it works fine manually; use full paths (`/usr/bin/python3`) to be safe.
- Forgetting to redirect output (`>> logfile 2>&1`) means cron job errors vanish silently — you'll never know it failed unless you check.
- `crontab -r` deletes ALL your cron jobs instantly, with NO confirmation prompt — always double-check before running it.

---

## 🧠 Today's Takeaway

Cron's 5-field syntax (minute, hour, day, month, weekday) looks cryptic at first but reads naturally once you practice a few. `crontab -e` is your personal schedule editor, shortcuts like `@daily` save typing for common patterns, and always redirecting output (`>> log 2>&1`) is the difference between debugging a failed job and never knowing it failed at all.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 18 — SSH & Remote Access**
