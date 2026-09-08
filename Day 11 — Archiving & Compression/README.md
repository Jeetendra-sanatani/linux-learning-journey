# 🗜️ Day 11 — Archiving & Compression

<p align="center">
  <img src="https://img.shields.io/badge/day-11%2F30-blue?style=for-the-badge" alt="Day 11"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie-yellow?style=for-the-badge" alt="Level"/>
</p>

> Day 10 taught you to measure space. Day 11 teaches you to SHRINK it — bundling and compressing files is one of the most-used skills in backups, transfers, and everyday sysadmin life. 🗜️

---

## 🏆 Day 10 Recap — Challenge Solutions

**Challenge 1 (The Space Hog):**
```bash
$ du -sh /var/* 2>/dev/null | sort -rh | head -5
```

**Challenge 2 (Almost Full):**
```bash
$ df -h
```
(Scan the `Use%` column manually for anything above 80% — no scripting needed at this stage.)

**Challenge 3 (The Mismatch):**
`df` counts filesystem-level overhead (reserved blocks, metadata) and includes ALL files, even ones a specific `du` scope might skip (like sparse files or hard links counted differently) — the two tools measure space from slightly different angles, so exact matches are rare.

---

## 🎯 Mission Briefing

Sending a project folder to a teammate? Backing up your `practice/` directory before an experiment? You don't send 500 loose files — you bundle them into ONE archive, often compressed to save space. Today's the day `tar` stops being a mystery.

```
🗜️  MISSION: Bundle & Shrink
──────────────────────────────────────────
[ ] Create a tar archive
[ ] Compress it with gzip
[ ] Extract archives back out
[ ] Know when to use zip instead of tar
──────────────────────────────────────────
STATUS: Day 11 — In Progress...
```

---

## ⚡ Quick Theory — tar, gzip & the Confusing Extensions

**Important distinction:** `tar` by itself does NOT compress anything — it just BUNDLES multiple files into one. Compression is a separate step, usually done together in one command.

```
tar   → bundles files together (like a box)
gzip  → compresses data (like vacuum-sealing that box)
```

**Reading `tar` flags (this is the part everyone forgets and re-googles):**
```
c → create an archive
x → extract an archive
t → list contents WITHOUT extracting
z → also compress/decompress with gzip
f → "the next thing is a filename" (almost always needed)
v → verbose (show files as they're processed)
```

So `tar -czf archive.tar.gz folder/` reads as: **c**reate, **z** (gzip), **f**ilename follows → compress `folder/` into `archive.tar.gz`.

**File extension cheat sheet:**
```
.tar      → bundled, NOT compressed
.tar.gz   → bundled AND gzip-compressed (most common on Linux)
.zip      → bundled AND compressed, cross-platform (works on Windows too)
```

🔑 **Why Linux prefers `.tar.gz` over `.zip`:** tar preserves Linux-specific file metadata (permissions, ownership, symlinks) that zip doesn't always handle well. Use `zip` mainly when sending files to Windows users.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 📦 Creating an archive
```bash
$ tar -cf backup.tar practice/
$ ls -lh backup.tar
-rw-r--r--  1 raven raven  20K  backup.tar
```

### 🗜️ Creating a COMPRESSED archive (most common use case)
```bash
$ tar -czf backup.tar.gz practice/
$ ls -lh backup.tar.gz
-rw-r--r--  1 raven raven  8.2K  backup.tar.gz
```

### 👀 Viewing contents WITHOUT extracting
```bash
$ tar -tzf backup.tar.gz
practice/
practice/notes.txt
practice/logs/2024/
```

### 📤 Extracting an archive
```bash
$ tar -xzf backup.tar.gz
$ ls
practice/  backup.tar.gz

$ tar -xzf backup.tar.gz -C /tmp/restore/     # extract to a specific location
```

### 🤐 Using gzip directly (single file compression)
```bash
$ gzip notes.txt
$ ls
notes.txt.gz          # original notes.txt is now replaced by this

$ gunzip notes.txt.gz
$ ls
notes.txt             # back to normal
```

### 🗂️ Using zip / unzip (cross-platform)
```bash
$ zip -r archive.zip practice/
  adding: practice/ (stored 0%)
  adding: practice/notes.txt (deflated 12%)

$ unzip archive.zip -d /tmp/extracted/
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Create a `tar` archive (no compression) of your `practice` folder
- [ ] Create a compressed `.tar.gz` version of the same folder
- [ ] Compare the two file sizes with `ls -lh`
- [ ] List the contents of your `.tar.gz` archive WITHOUT extracting it
- [ ] Extract it into a NEW folder using the `-C` flag
- [ ] Try zipping the same folder with `zip -r` and compare its size to the `.tar.gz`

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — One-Liner Backup**
> Write a single command that creates a compressed archive called `daily_backup.tar.gz` from your entire home directory's `practice` folder.

> **🥊 Challenge 2 — Peek Before You Leap**
> You downloaded a `.tar.gz` file from someone and don't fully trust it. Write a command to see what's INSIDE it before extracting anything.

> **🥊 Challenge 3 — Extension Detective**
> You find three files: `data.tar`, `data.tar.gz`, and `data.zip`. Which one is smallest, most likely, and why?

🏆 Solutions drop in Day 12.

---

## 🧩 Quick Brain Check

1. What's the actual difference between `tar -cf` and `tar -czf`?
2. Why does Linux commonly use `.tar.gz` instead of just `.zip`?
3. What does the `-t` flag in `tar -tzf` actually do?
4. If you `gzip` a file, what happens to the ORIGINAL file?
5. What does the `-C` flag do when extracting a tar archive?

*(Reason it out first — discussed in Day 12.)*

---

## 🐛 Gotchas That'll Trip You Up

- Forgetting the `z` flag when extracting a gzip-compressed archive (`tar -xf` instead of `tar -xzf`) gives a confusing "not a tar archive" error.
- `gzip file.txt` REPLACES the original file with `file.txt.gz` by default — use `gzip -k file.txt` if you want to keep the original too.
- Extracting an untrusted archive without checking contents first (`tar -tzf`) can silently overwrite existing files — always peek first.

---

## 🧠 Today's Takeaway

`tar` bundles, `gzip` compresses — together they make `.tar.gz`, the standard Linux archive format. `zip` is the cross-platform alternative for sharing with Windows users. And always `-t` (list) an unfamiliar archive before you `-x` (extract) it — a five-second habit that saves you from surprises.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 12 — Shell Scripting Basics**
