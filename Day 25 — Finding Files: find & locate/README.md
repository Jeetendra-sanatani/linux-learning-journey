# 🔎 Day 25 — Finding Files: find & locate

<p align="center">
  <img src="https://img.shields.io/badge/day-25%2F30-blue?style=for-the-badge" alt="Day 25"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> 5 days left! You've used `find -perm` since Day 2, always for a specific purpose. Today you learn `find` properly, PLUS its much faster cousin `locate` — the two tools for "where the heck is that file?" 🔎

---

## 🏆 Day 24 Recap — Challenge Solutions

**Challenge 1 (Predict the Outcome):**
The symlink shows the NEW content — a symlink points to a PATH (the filename), not the specific data. Once a new `config.txt` exists at that same path, the symlink automatically follows it.

**Challenge 2 (The Link Detective):**
```bash
$ readlink -f shortcut
```

**Challenge 3 (Choosing the Right Tool):**
A hard link — it survives the original being deleted, since the data isn't actually gone until every hard link to it is removed. A symlink would just break.

---

## 🎯 Mission Briefing

You've used `find /path -perm -XXXX` a dozen times by now for security checks. Today you learn `find`'s FULL power — searching by name, size, modification time, type — plus `locate`, a completely different (and much faster) approach using a pre-built database.

```
🔎 MISSION: Never Lose a File Again
──────────────────────────────────────────
[ ] Search by filename with find
[ ] Search by size and modification time
[ ] Combine find with -exec to act on results
[ ] Use locate for instant searches
──────────────────────────────────────────
STATUS: Day 25 — In Progress...
```

---

## ⚡ Quick Theory — find vs locate: Two Completely Different Approaches

**`find` — searches LIVE, right now, through the actual filesystem:**
```
Pros: always accurate, up-to-the-second, tons of filter options
Cons: can be slow on large filesystems (it's literally walking every folder)
```

**`locate` — searches a PRE-BUILT DATABASE, updated periodically:**
```
Pros: nearly instant, even on huge filesystems
Cons: can be slightly OUT OF DATE (misses files created since the last database update)
```

🔑 **The habit that fixes locate's biggest downside:** run `sudo updatedb` to manually refresh locate's database before an important search, if you need it to be 100% current.

**find's basic syntax pattern:**
```bash
find <where_to_look> <what_to_look_for>
```

**Common find filters:**
```bash
find . -name "*.txt"           # by filename pattern
find . -type f                  # only regular files
find . -type d                  # only directories
find . -size +100M              # larger than 100MB
find . -size -1k                # smaller than 1KB
find . -mtime -7                # modified in the last 7 days
find . -empty                    # empty files/folders
```

**The genuinely powerful part — `-exec`, running a command on every result:**
```bash
find . -name "*.log" -exec rm {} \;
```
This reads as: "find every `.log` file, and for EACH one, run `rm` on it." The `{}` gets replaced by each found filename, and `\;` marks the end of the command.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔎 Basic find by name
```bash
$ find ~ -name "notes.txt"
/home/raven/practice/notes.txt

$ find / -name "*.conf" 2>/dev/null | head -5
/etc/ssh/sshd_config
/etc/nginx/nginx.conf
```

### 🔎 Finding by type
```bash
$ find ~ -type d -name "practice"
/home/raven/practice

$ find ~ -type f -name "*.sh"
/home/raven/scripts/backup.sh
```

### 🔎 Finding by size
```bash
$ find / -size +100M 2>/dev/null | head -5
/var/log/syslog
/home/raven/Downloads/bigfile.iso

$ find ~ -size -1k -name "*.txt"      # small text files
```

### 🔎 Finding by modification time
```bash
$ find ~ -mtime -7            # modified in the last 7 days
$ find ~ -mtime +30            # modified MORE than 30 days ago (old, potentially stale)
```

### 🔎 Finding and acting with -exec
```bash
$ find ~/practice -name "*.tmp" -exec rm {} \;
$ find ~ -name "*.sh" -exec chmod +x {} \;
$ find ~ -name "*.log" -exec wc -l {} \;
```

### ⚡ Using locate (much faster)
```bash
$ sudo apt install mlocate      # install if not present
$ sudo updatedb                  # refresh the database first

$ locate notes.txt
/home/raven/practice/notes.txt

$ locate -i "readme"             # case-insensitive search
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Use `find` to search for a specific filename in your home directory
- [ ] Use `find -type d` to find only directories matching a pattern
- [ ] Find every file larger than 50MB on your system
- [ ] Find every file modified in the last 24 hours: `find ~ -mtime -1`
- [ ] Use `-exec` to make every `.sh` file in a folder executable
- [ ] Install `locate`, run `updatedb`, then search for a filename with `locate`

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — The Cleanup**
> Write a single `find` command that finds and deletes every `.tmp` file inside `~/practice`.

> **🥊 Challenge 2 — Empty Space Hunt**
> Write a command that finds all EMPTY files and directories inside your home folder.

> **🥊 Challenge 3 — Speed Comparison**
> Explain (in your notes) why `locate notes.txt` returns instantly while `find / -name notes.txt` can take several seconds — what's fundamentally different about how each one works?

🏆 Solutions drop in Day 26.

---

## 🧩 Quick Brain Check

1. What's the core architectural difference between how `find` and `locate` work?
2. Why might `locate` MISS a file that was just created 2 minutes ago?
3. What does `{}` represent inside a `find -exec` command?
4. What's the difference between `find . -mtime -7` and `find . -mtime +7`?
5. Why is it dangerous to run `find . -name "*.txt" -exec rm {} \;` without double-checking the search first?

*(Reason it out first — discussed in Day 26.)*

---

## 🐛 Gotchas That'll Trip You Up

- `locate` can return files that no longer exist (if deleted after the last `updatedb` run) — always verify important results, or run `sudo updatedb` first.
- `-exec ... {} \;` runs the command ONCE PER FILE (slower for huge result sets) — `-exec ... {} +` batches multiple files into fewer command calls (faster, when the command supports it).
- Running `find` with `-exec rm` is genuinely destructive with no undo — ALWAYS run the `find` part alone first to see what would be deleted, before adding `-exec rm`.

---

## 🧠 Today's Takeaway

`find` searches live and supports powerful filters (name, size, time, type) plus `-exec` to act on results directly. `locate` trades a bit of freshness for near-instant speed via a pre-built database. Use `find` when you need precision and up-to-date accuracy; use `locate` when you just need "where is this file" answered fast.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 26 — Regular Expressions in Linux**
