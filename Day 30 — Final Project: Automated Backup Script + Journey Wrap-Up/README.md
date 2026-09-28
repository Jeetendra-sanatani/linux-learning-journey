# 🏁 Day 30 — Final Project: Automated Backup Script + Journey Wrap-Up

<p align="center">
  <img src="https://img.shields.io/badge/day-30%2F30-brightgreen?style=for-the-badge" alt="Day 30"/>
  <img src="https://img.shields.io/badge/status-COMPLETE-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-final_project-orange?style=for-the-badge" alt="Level"/>
</p>

> Day 30. The last one. Day 1 started with `whoami`. Today you ship a script that backs up, verifies, and cleans up automatically. Let's finish this. 🏁

---

## 🏆 Day 29 Recap — Challenge Solutions

**Challenge 1 (Add a Security Section):**
```bash
security_check() {
    echo "SECURITY CHECK"
    divider
    echo "Sudo group members:"
    getent group sudo
    echo "Firewall status:"
    sudo ufw status
}
```
Then add `security_check` and `echo ""` inside `main()`.

**Challenge 2 (Save to File):**
```bash
mkdir -p ~/dashboard_reports
./health_dashboard.sh | tee ~/dashboard_reports/report_$(date +%F).txt
```

**Challenge 3 (Schedule It):**
```bash
0 7 * * * /home/raven/health_dashboard.sh > /home/raven/dashboard_reports/report_$(date +\%F).txt 2>&1
```
The `\%` is needed because plain `%` has a special meaning inside crontab.

---

## 🎯 Mission Briefing

Backups are the most boring and most important thing a sysadmin does. Today you build one that actually behaves like a professional tool: it creates the backup, CHECKS that the backup is readable, logs everything, and deletes old backups so your disk doesn't fill up.

```
🏁 MISSION: Ship the Final Tool
──────────────────────────────────────────
[ ] Build a backup script with functions
[ ] Verify the backup after creating it
[ ] Log every action with timestamps
[ ] Auto-delete old backups
[ ] Schedule it with cron
──────────────────────────────────────────
STATUS: Day 30 — FINAL DAY
```

---

## ⚡ Quick Theory — What Makes a Backup "Real"

A backup you never checked is just a hope. A proper backup script does four things:

```
1. CREATE    → tar -czf (Day 11)
2. VERIFY    → tar -tzf, listing contents proves the archive is readable
3. LOG       → timestamped record of what happened and when
4. CLEAN UP  → find -mtime +7 -exec rm (Day 25), so old backups don't pile up
```

**Where every piece comes from:**
```
Variables & functions    → Day 12-13
tar -czf / tar -tzf      → Day 11
find -mtime -exec        → Day 25
tee -a (log + screen)    → Day 29
if/else checks           → Day 12
cron scheduling          → Day 17
du -h, awk               → Day 10, Day 16
```

🔑 **The rule to remember:** backup and restore are a pair. A backup is only proven good when you've actually restored from it at least once.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

The full script is in this folder as `backup.sh` (tested, runs clean). Here is how it is built, section by section.

### 🧩 Variables at the top
```bash
SOURCE="$HOME/practice"       # what to back up
DEST="$HOME/backups"          # where backups go
DATE=$(date +%F_%H-%M)        # timestamp for the filename
BACKUP_FILE="$DEST/backup_$DATE.tar.gz"
LOG="$DEST/backup.log"
KEEP_DAYS=7                   # how long to keep old backups
```

### 🧩 Logging function (prints AND saves)
```bash
log() {
    echo "[$(date '+%F %T')] $1" | tee -a "$LOG"
}
```

### 🧩 Create + verify
```bash
tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"
tar -tzf "$BACKUP_FILE" > /dev/null 2>&1     # succeeds only if archive is readable
```

### 🧩 Cleanup old backups
```bash
find "$DEST" -name "backup_*.tar.gz" -mtime +$KEEP_DAYS -exec rm {} \;
```

### ▶️ Running it
```bash
$ chmod +x backup.sh
$ ./backup.sh
[2025-09-24 14:00:00] Starting backup of /home/raven/practice
[2025-09-24 14:00:00] Backup created: /home/raven/backups/backup_2025-09-24_14-00.tar.gz
[2025-09-24 14:00:00] Verified OK (size: 4.0K)
[2025-09-24 14:00:00] Removing backups older than 7 days
[2025-09-24 14:00:00] Backup complete

$ ls ~/backups
backup.log  backup_2025-09-24_14-00.tar.gz
```

### 🔄 Testing a restore (the step people skip)
```bash
$ mkdir /tmp/restore_test
$ tar -xzf ~/backups/backup_2025-09-24_14-00.tar.gz -C /tmp/restore_test
$ ls /tmp/restore_test/practice
notes.txt  logs
```

### ⏰ Scheduling with cron (daily at 2 AM)
```bash
$ crontab -e
0 2 * * * /home/raven/backup.sh >> /home/raven/backups/cron.log 2>&1
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Make sure `~/practice` exists with a few files inside
- [ ] Make `backup.sh` executable and run it
- [ ] Check `~/backups` for the archive and `backup.log`
- [ ] Run `tar -tzf` on the archive to look inside it
- [ ] Restore it into `/tmp/restore_test` and confirm your files are there
- [ ] Add the cron entry and confirm with `crontab -l`

---

## 🎯 Final Boss Challenges

> **🥊 Challenge 1: Change the Source**
> Modify the script to accept the source folder as an argument: `./backup.sh ~/Documents`. (Hint: `$1`, and a default value if none is given.)

> **🥊 Challenge 2: Failure Alert**
> Make the script write a line to `~/backups/FAILED.txt` whenever the backup or the verification fails.

> **🥊 Challenge 3: The Dry Run**
> Add a check so that running `./backup.sh --list` just prints the existing backups in `~/backups` (with sizes) without creating a new one.

🏆 These are open-ended. There is no single right answer, so compare your version with your notes.

---

## 🧩 Final Brain Check

1. Why does the script verify the backup right after creating it?
2. What does `tee -a` do that plain `>>` doesn't?
3. Why does the script `exit 1` on failure instead of just carrying on?
4. What would happen if `KEEP_DAYS` were set to `0`?
5. Why is testing a restore more important than testing the backup itself?

---

## 🐛 Gotchas That'll Trip You Up

- If `~/practice` doesn't exist, the script stops on purpose and logs an error. Create the folder first.
- `\%` in crontab, not `%`, whenever you use `date +%F` inside a cron line.
- Backups saved on the SAME disk as the original protect you from accidental deletion, but not from disk failure. Real backups should also be copied elsewhere (`rsync` or `scp` from Day 20).

---

# 🎓 30-DAY JOURNEY WRAP-UP

## 📊 The Full Map

| Phase | Days | What I learned |
|---|---|---|
| **Foundations** | 01-03 | Linux basics, filesystem, permissions, users & groups |
| **System Control** | 04-06 | Processes, networking, services & systemctl |
| **Security Basics** | 07-08 | Log reading, SUID/SGID and hardening basics |
| **Admin Toolkit** | 09-11 | Package management, disk & storage, archiving |
| **Scripting** | 12-14 | Variables, if/else, loops, functions, shell config |
| **Text Power Tools** | 15-16 | grep, sed, awk |
| **Automation & Remote** | 17-20 | Cron, SSH, SSH keys, scp & rsync |
| **Defense & Monitoring** | 21-23 | Firewall (ufw), top/htop/vmstat, disk I/O |
| **Advanced Basics** | 24-26 | Links, find & locate, regular expressions |
| **Security in Practice** | 27-28 | Hardening checklist, log analysis for security |
| **Projects** | 29-30 | Health dashboard script, automated backup script |

## 🛠️ Skills Built

```text
Command Line          ██████████  Solid
Filesystem            ██████████  Solid
Permissions           █████████░  Solid
Users & Groups        █████████░  Solid
Processes & Services  ████████░░  Good
Networking Basics     ████████░░  Good
Shell Scripting       ████████░░  Good
Text Processing       ████████░░  Good
SSH & Remote Access   ████████░░  Good
Security Basics       ███████░░░  Good
```
*Be honest when you update these bars. They should reflect what you can do without looking it up.*

## 🧠 The 5 Big Ideas of the Journey

1. **Everything is a file.** Devices, processes, configs, all of it.
2. **Permissions are the security model.** Owner, group, others, and the special bits.
3. **Small tools, chained together.** `grep | awk | sort | uniq -c` beats any single big tool.
4. **Logs tell the story.** If it happened on the system, it's written down somewhere.
5. **Automate what you repeat.** Scripts + cron turn skills into tools.

## 🚀 What's Next

Linux fundamentals are done. Next phase: take these skills into hands-on tools, starting with **networking tools**, then Linux/sysadmin tools, then cybersecurity tools, then cloud/DevOps and advanced Git. Same rule as this journal: run it yourself first, then document it.

---

<p align="center">
🐧 Learn • 💻 Practice • 🐛 Troubleshoot • 🔐 Secure<br/>
<b>30 days. 30 topics. One habit built.</b>
</p>

---

⬅️ [Back to main journal](../README.md)
