# 📊 Day 16 — Text Processing: awk & Advanced grep

<p align="center">
  <img src="https://img.shields.io/badge/day-16%2F30-blue?style=for-the-badge" alt="Day 16"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> Day 15 taught you to find and replace text. Day 16 teaches you to slice it apart, column by column — awk is the tool that turns messy text output into structured data you can actually work with. 📊

---

## 🏆 Day 15 Recap — Challenge Solutions

**Challenge 1 (Comment Remover):**
```bash
$ grep -v "^#" config.txt
```

**Challenge 2 (Safe Replace):**
```bash
$ sed -i.bak 's/localhost/127.0.0.1/g' hosts.txt
```

**Challenge 3 (Line Number Hunt):**
```bash
$ grep -n "root" /etc/passwd
```

---

## 🎯 Mission Briefing

Remember `/etc/passwd`'s colon-separated fields from Day 3? Or `ps aux`'s columns from Day 4? Today you learn `awk` — the tool built specifically to grab "just column 3" or "just column 1" from any structured text, instead of eyeballing it manually.

```
📊 MISSION: Slice Text Into Columns
──────────────────────────────────────────
[ ] Extract specific columns with awk
[ ] Use a custom delimiter with awk
[ ] Combine awk with conditions
[ ] Chain grep + awk + sort for real analysis
──────────────────────────────────────────
STATUS: Day 16 — In Progress...
```

---

## ⚡ Quick Theory — awk Thinks in Columns

`awk` automatically splits every line into fields (columns), separated by whitespace by default. You reference them as `$1`, `$2`, `$3`... and `$0` means "the whole line."

```bash
$ echo "raven security 1000" | awk '{print $1}'
raven

$ echo "raven security 1000" | awk '{print $1, $3}'
raven 1000
```

**Custom delimiter with `-F` — this is where it gets genuinely useful:**
```bash
$ awk -F: '{print $1}' /etc/passwd
```
`-F:` tells awk "fields are separated by colons, not spaces" — perfect for `/etc/passwd`'s `username:x:UID:GID:...` format you learned about on Day 3.

**Adding conditions — filtering by column value:**
```bash
awk -F: '$3 >= 1000 {print $1}' /etc/passwd
```
This reads as: "where field 3 (UID) is 1000 or more, print field 1 (username)" — instantly separates real user accounts (UID ≥ 1000) from system accounts.

**Advanced grep you'll actually reach for:**
```bash
grep -E "err|warn|crit" logfile.txt      # match ANY of multiple patterns (extended regex)
grep -A 3 "error" log.txt                # show 3 lines AFTER each match
grep -B 3 "error" log.txt                # show 3 lines BEFORE each match
```

🔑 **The mental model that ties this together:** `grep` finds LINES matching a pattern. `awk` extracts COLUMNS from lines (matching or not). Combine them — `grep` narrows down the lines, `awk` pulls out exactly the field you need from what's left.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 📊 Basic awk column extraction
```bash
$ ps aux | awk '{print $1, $2, $11}' | head -5
USER  PID   COMMAND
root  1     /sbin/init
raven 842   bash
```

### 📊 Custom delimiter with /etc/passwd
```bash
$ awk -F: '{print $1}' /etc/passwd | head -5
root
daemon
raven

$ awk -F: '{print $1, $3}' /etc/passwd | head -5
root 0
raven 1000
```

### 📊 Filtering by column value (real accounts vs system accounts)
```bash
$ awk -F: '$3 >= 1000 {print $1}' /etc/passwd
raven
phoenix
```

### 📊 Line number and pattern matching in awk
```bash
$ awk 'NR==5' file.txt              # print exactly line 5
$ awk 'NR>=5 && NR<=10' file.txt    # print lines 5 through 10
$ awk '/error/ {print}' log.txt      # print lines matching a pattern
```

### 🔍 Advanced grep in action
```bash
$ grep -E "error|warning|critical" /var/log/syslog | head -5

$ grep -A 2 "Failed password" /var/log/auth.log
Aug 27 09:40:12 kali sshd[1203]: Failed password for root from 203.0.113.5
Aug 27 09:40:12 kali sshd[1203]: (line right after, for context)
```

### 🔗 Chaining grep + awk + sort (real analysis)
```bash
$ ps aux --sort=-%mem | awk 'NR<=6 {print $1, $4, $11}'
USER   %MEM  COMMAND
raven  8.1   firefox
raven  2.3   bash
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Use `awk` to print just usernames from `/etc/passwd` (using `-F:`)
- [ ] Print usernames AND their UID together, space-separated
- [ ] Use a condition to print only accounts with UID 1000 or higher
- [ ] Use `awk 'NR==3'` to print just the 3rd line of any file
- [ ] Use `grep -E` to search a log for 3 different keywords at once
- [ ] Use `grep -A 2` to see context after a match in a log file

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — Real Users Only**
> Write a single `awk` command that prints ONLY the usernames of real user accounts (UID ≥ 1000) from `/etc/passwd`.

> **🥊 Challenge 2 — The Shell Report**
> Write an `awk` command that prints BOTH the username and their login shell (field 7) from `/etc/passwd`, space-separated.

> **🥊 Challenge 3 — Context Detective**
> Write a `grep` command that searches `/var/log/auth.log` for "Failed password" and shows 2 lines of context BEFORE each match.

🏆 Solutions drop in Day 17.

---

## 🧩 Quick Brain Check

1. What does `$1`, `$2`, `$0` mean inside an awk command?
2. Why is `-F:` needed when running awk on `/etc/passwd` but not on `ps aux` output?
3. What does `awk -F: '$3 >= 1000 {print $1}' /etc/passwd` actually do, piece by piece?
4. What's the difference between `grep -A 3` and `grep -B 3`?
5. When would you reach for `awk` instead of `grep`?

*(Reason it out first — discussed in Day 17.)*

---

## 🐛 Gotchas That'll Trip You Up

- Forgetting `-F:` on colon-delimited files (like `/etc/passwd`) means awk treats the WHOLE line as one field — nothing gets split correctly.
- `awk '{print $1}'` uses whitespace as the default delimiter — this breaks if your data has variable spacing (multiple spaces between fields can shift column numbers unexpectedly in some edge cases).
- `grep -E` is needed for extended regex features like `|` (OR) — plain `grep` without `-E` treats `|` as a literal character, not "or."

---

## 🧠 Today's Takeaway

`awk` thinks in columns (`$1`, `$2`, `$3`...) instead of whole lines — perfect for structured text like `/etc/passwd` or `ps aux`. Add `-F` for custom delimiters, add conditions to filter by column value, and you've got a genuinely powerful one-liner tool. Combined with `grep`'s line-filtering, this is 90% of real-world text processing on Linux.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 17 — Cron Jobs & Task Scheduling**
