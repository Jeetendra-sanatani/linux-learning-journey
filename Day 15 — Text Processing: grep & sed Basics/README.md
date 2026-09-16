# 🔍 Day 15 — Text Processing: grep & sed Basics

<p align="center">
  <img src="https://img.shields.io/badge/day-15%2F30-blue?style=for-the-badge" alt="Day 15"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> Halfway point crossed! You've been using `grep` casually since Day 3 — today you actually understand it, plus meet `sed`, the tool that edits text without ever opening an editor. 🔍

---

## 🏆 Day 14 Recap — Challenge Solutions

**Challenge 1 (PATH Detective):**
```bash
$ echo $PATH | tr ':' '\n' | wc -l
```

**Challenge 2 (The Missing Command):**
The tool's folder probably isn't in `$PATH`. Fix: `export PATH="$PATH:/path/to/tool"` (temporary), or add that line to `~/.bashrc` to make it permanent.

**Challenge 3 (Make It Stick):**
```bash
$ echo 'export TOOL_HOME="/opt/mytool"' >> ~/.bashrc && source ~/.bashrc
```

---

## 🎯 Mission Briefing

You've `grep`-ed logs, `grep`-ed process lists, `grep`-ed `/etc/passwd`. Today you go deeper — real regex patterns, not just plain word searches — and pick up `sed`, which lets you find-and-replace text across entire files in a single command, no text editor required.

```
🔍 MISSION: Master Text Filtering & Editing
──────────────────────────────────────────
[ ] Use grep with real regex patterns
[ ] Combine grep flags for smarter searches
[ ] Use sed to find and replace text
[ ] Edit files in-place safely with sed
──────────────────────────────────────────
STATUS: Day 15 — In Progress...
```

Security relevance: log analysis (Day 7) and text-based enumeration during security assessments both live and die by how well you can `grep`/`sed` through large amounts of text quickly.

---

## ⚡ Quick Theory — grep Beyond the Basics, and Meeting sed

**grep flags you've been missing:**
```bash
grep -i "error"      # case-insensitive (matches Error, ERROR, error)
grep -v "debug"       # INVERT match — show lines that DON'T contain "debug"
grep -n "pattern"     # show line NUMBERS alongside matches
grep -c "pattern"     # COUNT matching lines instead of printing them
grep -r "TODO" ./src  # RECURSIVE search through an entire folder
```

**Basic regex patterns (just enough for today, not the full deep-dive):**
```
^word    → line STARTS WITH "word"
word$    → line ENDS WITH "word"
.        → matches ANY single character
[0-9]    → matches any digit
```

**sed — the "stream editor":** think of it as find-and-replace, but from the command line, and able to process entire files (or streams of text) in one pass.

```bash
sed 's/old/new/' file.txt        # replace FIRST occurrence per line
sed 's/old/new/g' file.txt       # replace ALL occurrences per line (g = global)
```

🔑 **The critical safety habit:** by default, `sed 's/old/new/' file.txt` just PRINTS the result to your screen — it does NOT modify the file. To actually change the file, you need `-i` (in-place):
```bash
sed -i 's/old/new/g' file.txt         # actually edits the file, no undo!
sed -i.bak 's/old/new/g' file.txt     # edits the file, but keeps a .bak backup first
```

**Always test without `-i` first, THEN add it once you're confident** — this one habit saves you from accidentally mangling an important file.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔍 grep with useful flags
```bash
$ grep -i "error" logfile.txt
Error: connection timeout
ERROR: disk full

$ grep -v "^#" /etc/ssh/sshd_config | head -5
# skips comment lines, shows actual config

$ grep -n "raven" /etc/passwd
23:raven:x:1000:1000:raven,,,:/home/raven:/bin/bash

$ grep -c "Failed" /var/log/auth.log
14
```

### 🔍 grep with basic regex
```bash
$ echo -e "apple\nbanana\navocado" | grep "^a"
apple
avocado

$ echo -e "cat\ncar\ncap" | grep "^ca."
cat
car
cap
```

### ✏️ sed — testing before committing
```bash
$ cat notes.txt
Day 1 was great.
Day 1 taught me a lot.

$ sed 's/Day 1/Day 15/' notes.txt
Day 15 was great.
Day 15 taught me a lot.

$ cat notes.txt
Day 1 was great.               # original file UNCHANGED — sed just printed the result
Day 1 taught me a lot.
```

### ✏️ sed — actually editing the file (with backup)
```bash
$ sed -i.bak 's/Day 1/Day 15/g' notes.txt
$ cat notes.txt
Day 15 was great.
Day 15 taught me a lot.

$ ls
notes.txt  notes.txt.bak        # original saved as .bak, just in case
```

### ✏️ sed — deleting lines
```bash
$ sed '/^#/d' config.txt          # delete all comment lines
$ sed '1d' file.txt                # delete the first line
$ sed '$d' file.txt                # delete the last line
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Search a log file case-insensitively using `grep -i`
- [ ] Use `grep -v` to exclude comment lines from a config file
- [ ] Use `grep -n` to find the line number of your username in `/etc/passwd`
- [ ] Create a test file, use `sed 's/old/new/'` WITHOUT `-i` to preview a change
- [ ] Now use `sed -i.bak` to actually make that change, keeping a backup
- [ ] Use `sed '/pattern/d'` to delete lines matching a pattern from a test file

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — Comment Remover**
> Write a single `grep` command that shows only the NON-comment lines of a config file (lines that don't start with `#`).

> **🥊 Challenge 2 — Safe Replace**
> You want to replace "localhost" with "127.0.0.1" in a file called `hosts.txt`, but you want a backup kept automatically. Write the exact `sed` command.

> **🥊 Challenge 3 — Line Number Hunt**
> Write a command that finds the word "root" in `/etc/passwd` and shows exactly which line number it's on.

🏆 Solutions drop in Day 16.

---

## 🧩 Quick Brain Check

1. What's the difference between `grep "error"` and `grep -v "error"`?
2. Without the `-i` flag, does `sed 's/old/new/'` change the original file?
3. What does the `g` at the end of `sed 's/old/new/g'` actually do?
4. What does `^` mean at the start of a regex pattern, and what does `$` mean at the end?
5. Why would you use `sed -i.bak` instead of just `sed -i`?

*(Reason it out first — discussed in Day 16.)*

---

## 🐛 Gotchas That'll Trip You Up

- Running `sed -i` WITHOUT testing the pattern first can silently corrupt a file with no undo — always dry-run without `-i` first.
- `grep "pattern"` without `-i` is case-SENSITIVE by default — "Error" and "error" are treated as completely different matches.
- Forgetting the `g` flag in `sed 's/old/new/g'` means only the FIRST match per line gets replaced, not all of them.

---

## 🧠 Today's Takeaway

`grep` finds; `sed` finds AND changes. Both process text at massive scale in a single command — something that would take forever to do manually. And the golden rule for `sed`: preview without `-i`, THEN commit with `-i` (ideally with a `.bak` backup) once you trust the result.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 16 — Text Processing: awk & Advanced grep**
