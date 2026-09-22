# 🔗 Day 24 — Symbolic & Hard Links

<p align="center">
  <img src="https://img.shields.io/badge/day-24%2F30-blue?style=for-the-badge" alt="Day 24"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> Six days left! Today's topic is one of those "wait, THAT'S how that works?" moments — links are how Linux lets one file appear in multiple places without actually duplicating it. 🔗

---

## 🏆 Day 23 Recap — Challenge Solutions

**Challenge 1 (The Diagnosis):**
The disk is the bottleneck, not the CPU — high `wa` with low CPU usage means the processor is sitting idle, waiting on slow disk operations. Next step: run `iostat -x 1 5` to confirm disk-level statistics, then `iotop` to find the responsible process.

**Challenge 2 (The Culprit):**
```bash
$ sudo iotop
```

**Challenge 3 (Quick Speed Test):**
```bash
$ dd if=/dev/zero of=testfile bs=1M count=50
$ rm testfile
```
Delete it afterward because it's just test data taking up disk space for no reason — not a real file you need.

---

## 🎯 Mission Briefing

Remember `/usr/bin/python3` linking to a specific version back on Day 1? That's a symbolic link in action. Today you create your own links, understand the crucial difference between symbolic and hard links, and learn exactly when to use which.

```
🔗 MISSION: Understand File Links
──────────────────────────────────────────
[ ] Create a symbolic (soft) link
[ ] Create a hard link
[ ] Understand what happens when the original is deleted
[ ] Know when to use which type
──────────────────────────────────────────
STATUS: Day 24 — In Progress...
```

---

## ⚡ Quick Theory — Two Types of Links, One Big Difference

**Symbolic link (symlink) — a pointer/shortcut to another path:**
```bash
ln -s /path/to/original /path/to/link
```
Think of it EXACTLY like a Windows shortcut. It's a separate, tiny file that just says "the real thing is over THERE." If you delete the original file, the symlink becomes BROKEN — pointing to nothing.

**Hard link — another NAME for the exact same data:**
```bash
ln original.txt hardlink.txt
```
This is trickier to wrap your head around: a hard link isn't a pointer at all — it's literally ANOTHER directory entry pointing to the exact same data on disk (the same "inode," if you want the technical term). Delete the "original" file, and the hard link STILL WORKS — because the actual data isn't gone until EVERY hard link pointing to it is removed.

**The key difference, side by side:**
```
                    Symlink                    Hard Link
─────────────────────────────────────────────────────────
Points to:          a PATH                     the actual DATA
Survives original    NO — breaks                YES — data persists
                      deletion?
Can link across       YES                        NO (same filesystem only)
filesystems/directories?
Shows in ls -la as:   link -> target             looks like a normal file
```

🔑 **Real-world use case that makes this click:** software often gets updated with a new version installed alongside the old one, and a symlink like `/usr/bin/python3` gets repointed to the new version — instantly, without moving or renaming anything, and every script referencing `python3` automatically uses the new version.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔗 Creating a symbolic link
```bash
$ echo "original content" > original.txt
$ ln -s original.txt mylink.txt

$ ls -la
-rw-r--r--  1 raven raven  18  original.txt
lrwxrwxrwx  1 raven raven  12  mylink.txt -> original.txt
```
Notice the `l` at the start of the permission string, and the `->` showing where it points.

### 🔍 Testing what happens when the original is deleted
```bash
$ rm original.txt
$ cat mylink.txt
cat: mylink.txt: No such file or directory     # BROKEN link!

$ ls -la mylink.txt
lrwxrwxrwx  1 raven raven  12  mylink.txt -> original.txt   # still "exists" but broken
```

### 🔗 Creating a hard link
```bash
$ echo "important data" > realfile.txt
$ ln realfile.txt hardlink.txt

$ ls -la
-rw-r--r--  2 raven raven  16  realfile.txt      # notice link count = 2!
-rw-r--r--  2 raven raven  16  hardlink.txt
```

### 🔍 Testing what happens when the "original" is deleted this time
```bash
$ rm realfile.txt
$ cat hardlink.txt
important data                                    # STILL WORKS! Data survived.

$ ls -la hardlink.txt
-rw-r--r--  1 raven raven  16  hardlink.txt        # link count back to 1
```

### 🔍 Checking where a symlink actually points
```bash
$ readlink mylink.txt
original.txt

$ readlink -f mylink.txt
/home/raven/practice/original.txt      # full absolute path
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Create a file, then a symbolic link pointing to it
- [ ] Confirm the `l` and `->` in `ls -la` output
- [ ] Delete the original file and try reading the symlink — see it break
- [ ] Create a NEW file, then a hard link to it
- [ ] Delete the "original" and confirm the hard link still has the data
- [ ] Use `readlink -f` to see the full absolute path a symlink resolves to

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — Predict the Outcome**
> You create a symlink to `config.txt`, then delete `config.txt` and create a BRAND NEW `config.txt` with different content. What happens when you read the symlink now — does it show the new content, old content, or break?

> **🥊 Challenge 2 — The Link Detective**
> Write a command that shows the FULL absolute path a symlink named `shortcut` actually resolves to.

> **🥊 Challenge 3 — Choosing the Right Tool**
> You want to back up an important config file with a "safety copy" that survives even if the original gets deleted. Symlink or hard link — which one, and why?

🏆 Solutions drop in Day 25.

---

## 🧩 Quick Brain Check

1. What's the fundamental difference between what a symlink points to vs what a hard link points to?
2. Why does a symlink break when the original is deleted, but a hard link doesn't?
3. What does the `l` at the very start of `ls -la` output tell you about a file?
4. Can you create a hard link to a file on a DIFFERENT filesystem/partition? Why or why not?
5. What real-world situation would you use a symlink for that a hard link couldn't handle?

*(Reason it out first — discussed in Day 25.)*

---

## 🐛 Gotchas That'll Trip You Up

- A broken symlink still SHOWS UP in `ls` (often in red/blinking in terminal colors) — it "exists" as a link file, even though what it points to is gone.
- Hard links CANNOT cross filesystem boundaries (e.g., linking a file on `/` to a mounted USB drive) — you'll get an error; symlinks CAN cross filesystems fine.
- Deleting a symlink itself (`rm mylink.txt`) does NOT delete the original file it pointed to — only the link/shortcut disappears.

---

## 🧠 Today's Takeaway

A symlink is a pointer to a PATH — fragile if that path disappears, but flexible (works across filesystems, can link to directories). A hard link is another name for the same DATA — survives the "original" being deleted, but can't cross filesystem boundaries. Choose based on whether you need the link to survive the source file's deletion.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 25 — Finding Files: find & locate**
