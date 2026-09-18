# 📤 Day 20 — File Transfer: scp & rsync

<p align="center">
  <img src="https://img.shields.io/badge/day-20%2F30-blue?style=for-the-badge" alt="Day 20"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> Two-thirds of the way there — Day 20 of 30! You've used `scp` a bit already (Day 18). Today you go deeper, and meet `rsync` — the smarter, faster alternative for anything beyond a one-off file copy. 📤

---

## 🏆 Day 19 Recap — Challenge Solutions

**Challenge 1 (Permission Check):**
```bash
$ chmod 600 ~/.ssh/id_ed25519
```
SSH refuses to use a private key with overly open permissions as a built-in safety check — anyone else on the system could otherwise read your private key.

**Challenge 2 (Manual Setup):**
```bash
$ cat ~/.ssh/id_ed25519.pub | ssh user@host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
$ ssh user@host "chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
```

**Challenge 3 (Which Key Goes Where):**
Copy `id_ed25519.pub` (the PUBLIC key) to the remote server. Copying the private key instead would mean anyone with server access could steal it and impersonate you everywhere else that key is trusted.

---

## 🎯 Mission Briefing

`scp` works fine for a quick one-off copy. But what about syncing an entire project folder daily, where most files haven't even changed? Copying everything again, every time, wastes time and bandwidth. That's exactly the problem `rsync` was built to solve.

```
📤 MISSION: Master Real File Transfer
──────────────────────────────────────────
[ ] Use scp confidently for quick transfers
[ ] Understand why rsync exists
[ ] Sync folders efficiently with rsync
[ ] Preview changes before syncing (dry-run)
──────────────────────────────────────────
STATUS: Day 20 — In Progress...
```

---

## ⚡ Quick Theory — scp vs rsync: When to Use Which

**scp — simple, does the whole job every time:**
```
Good for: quick one-off transfers, small files, "just move this one thing now"
Downside: re-copies EVERYTHING every time, even files that haven't changed
```

**rsync — smart, only transfers what's actually DIFFERENT:**
```
Good for: syncing folders regularly, large datasets, backups, ongoing project transfers
Advantage: compares source and destination, only sends the CHANGES (much faster on repeat runs)
```

**The basic rsync flags that matter most:**
```
-a    → "archive" mode — preserves permissions, timestamps, symlinks (use this basically always)
-v    → verbose — actually shows you what's happening
-z    → compress data during transfer (great over slow networks)
--progress  → show a progress bar for each file
--dry-run   → PREVIEW what would happen, without actually doing it
```

**The command you'll use constantly:**
```bash
rsync -avz source/ destination/
```

🔑 **The trailing slash trap that confuses everyone:** `rsync -av folder/ dest/` copies the CONTENTS of `folder` into `dest`. `rsync -av folder dest/` (no trailing slash on source) copies the FOLDER ITSELF into `dest`, creating `dest/folder/`. This one slash changes the entire result — always double-check with `--dry-run` first if unsure.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 📤 scp — quick recap from Day 18
```bash
$ scp notes.txt raven@192.168.1.100:/home/raven/
$ scp -r practice/ raven@192.168.1.100:/home/raven/backup/
```

### 🔄 rsync — basic local sync
```bash
$ rsync -av practice/ practice_backup/
sending incremental file list
notes.txt
logs/
logs/2024/

sent 1,234 bytes  received 45 bytes
```

### 🔄 rsync — over SSH to a remote machine
```bash
$ rsync -avz practice/ raven@192.168.1.100:/home/raven/backup/
sending incremental file list
notes.txt
sent 890 bytes  received 35 bytes
```

### 👀 rsync — dry run (preview without actually copying)
```bash
$ rsync -avz --dry-run practice/ raven@192.168.1.100:/home/raven/backup/
sending incremental file list
notes.txt              # this WOULD be copied, but wasn't yet
(dry run) sent 200 bytes  received 20 bytes
```

### 📊 rsync — with progress bar (useful for large transfers)
```bash
$ rsync -avz --progress bigfile.iso raven@192.168.1.100:/home/raven/
bigfile.iso
  1,048,576,000 100%   45.2MB/s    0:00:22
```

### 🗑️ rsync — mirroring exactly (deletes extra files in destination)
```bash
$ rsync -avz --delete practice/ practice_backup/
# any file in practice_backup/ that's NOT in practice/ gets DELETED — use carefully!
```

### 🚫 rsync — excluding files you don't want synced
```bash
$ rsync -avz --exclude="*.log" practice/ backup/
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Copy a single file with `scp` to a remote server (recap from Day 18)
- [ ] Sync an entire local folder to another local folder using `rsync -av`
- [ ] Run the SAME rsync command again — notice it's much faster the second time (nothing changed)
- [ ] Modify one file, run rsync again — confirm ONLY that file gets transferred
- [ ] Try a `--dry-run` before an actual sync to preview what would happen
- [ ] Use `--exclude` to skip a specific file type during a sync

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — The Efficient Backup**
> Write an `rsync` command that syncs your local `practice/` folder to a remote server at `/home/raven/backup/`, with compression enabled and a progress bar shown.

> **🥊 Challenge 2 — Preview First**
> You're about to run a sync with `--delete` (which removes extra files in the destination). Write the SAME command but as a safe preview first, showing what WOULD be deleted without actually doing it.

> **🥊 Challenge 3 — Selective Sync**
> Write an `rsync` command that syncs a folder but EXCLUDES both `.log` files and a subfolder called `temp/`.

🏆 Solutions drop in Day 21.

---

## 🧩 Quick Brain Check

1. What's the core difference between how `scp` and `rsync` handle a repeat transfer?
2. What does the `-a` (archive) flag in rsync actually preserve?
3. What's the difference between `rsync source/ dest/` and `rsync source dest/` (trailing slash)?
4. Why is `--dry-run` especially important before using `--delete`?
5. When would `scp` actually be the better choice over `rsync`?

*(Reason it out first — discussed in Day 21.)*

---

## 🐛 Gotchas That'll Trip You Up

- The trailing slash on the SOURCE folder in rsync changes the result completely — always double-check, or use `--dry-run` when unsure.
- `--delete` is powerful but dangerous — it can wipe out files in the destination that you actually wanted to keep. Always `--dry-run` first.
- Forgetting `-a` (or at least `-r` for directories) means rsync won't recurse into subfolders at all — a very common first mistake.

---

## 🧠 Today's Takeaway

`scp` is the simple, always-copy-everything tool — perfect for quick one-offs. `rsync` is the smart tool that only moves what actually changed, making it dramatically faster for repeated syncs and backups. `-avz` is the combo you'll type constantly, and `--dry-run` is your safety net before anything destructive like `--delete`.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 21 — Firewall Basics (ufw)**
