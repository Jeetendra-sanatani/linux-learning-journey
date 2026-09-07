# 💽 Day 10 — Disk & Storage Management

<p align="center">
  <img src="https://img.shields.io/badge/day-10%2F30-blue?style=for-the-badge" alt="Day 10"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie-yellow?style=for-the-badge" alt="Level"/>
</p>

> Double digits! Day 9 was about installing software. Day 10 is about the physical space that software actually lives on — disks, partitions, and knowing before you run out of room. 💽

---

## 🏆 Day 09 Recap — Challenge Solutions

**Challenge 1 (Version Check):**
```bash
$ apt show openssh-server | grep Version
```
or
```bash
$ dpkg -s openssh-server | grep Version
```

**Challenge 2 (Clean Sweep):**
```bash
$ sudo apt purge <package>
```

**Challenge 3 (The Difference):**
`apt update` refreshes the CATALOG of available package versions — it installs nothing. `apt upgrade` actually installs newer versions of packages you already have. Running only `update` means you know what's available but never get it; running only `upgrade` without a recent `update` risks upgrading against a stale/outdated catalog.

---

## 🎯 Mission Briefing

Every file, every log, every package you've installed since Day 1 — all of it sits on a disk with a finite amount of space. Today you learn to check exactly how much space you have, which folders are secretly eating it, and how storage devices actually get recognized and mounted.

```
💽 MISSION: Know Your Storage
──────────────────────────────────────────
[ ] Check overall disk space (df)
[ ] Find which folders are eating your space (du)
[ ] List physical storage devices (lsblk)
[ ] Understand what "mounting" actually means
──────────────────────────────────────────
STATUS: Day 10 — In Progress...
```

Real-world relevance: "disk full" errors crash services, block logins, and can even prevent logs from being written (ironic, since Day 7 taught you logs matter). Checking disk space is routine sysadmin hygiene.

---

## ⚡ Quick Theory — Disks, Partitions & Mounting

**Three tools, three different questions:**
```
df -h     → "How much space is left on each MOUNTED filesystem?"
du -sh    → "How much space does THIS specific folder use?"
lsblk     → "What physical disks/partitions does this machine even have?"
```

**Why `df` and `du` often give confusing numbers:** `df` looks at the WHOLE filesystem (like asking "how full is the entire warehouse?"), while `du` looks at ONE folder's actual usage (like asking "how much stuff is in THIS specific box?"). They're answering different questions — that's why they don't always match up.

**Understanding "mounting" (a genuinely confusing concept for beginners):**

On Windows, plug in a USB drive and it shows up as `E:\`. On Linux, there's no separate drive letters — instead, a storage device gets **attached ("mounted")** onto a folder somewhere in the single filesystem tree you learned about on Day 1.

```
Example: a USB drive gets mounted at /media/raven/USB_DRIVE
Now, browsing to /media/raven/USB_DRIVE IS browsing the USB drive —
even though it "looks like" just another folder.
```

**Device naming convention you'll see constantly:**
```
/dev/sda     → first disk detected
/dev/sda1    → first PARTITION on that disk
/dev/sdb     → second disk
```

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 📊 Checking overall disk space
```bash
$ df -h
Filesystem      Size  Used  Avail  Use%  Mounted on
/dev/sda1        40G   18G    20G   47%  /
tmpfs           3.9G     0   3.9G    0%  /dev/shm

$ df -h /home
Filesystem      Size  Used  Avail  Use%  Mounted on
/dev/sda1        40G   18G    20G   47%  /
```

### 📁 Finding which folders eat the most space
```bash
$ du -sh /var/log
125M    /var/log

$ du -sh /home/raven/*
2.1G    /home/raven/Downloads
340M    /home/raven/practice

$ du -sh /home/raven/* | sort -rh | head -5
2.1G    /home/raven/Downloads
340M    /home/raven/practice
```

### 🔌 Listing storage devices
```bash
$ lsblk
NAME   SIZE  TYPE  MOUNTPOINT
sda    40G   disk
├─sda1 39G   part  /
└─sda2  1G   part  [SWAP]

$ lsblk -f
NAME   FSTYPE  UUID                                  MOUNTPOINT
sda1   ext4    a1b2c3d4-e5f6-7890-abcd-ef1234567890  /
```

### 📥 Mounting a USB drive (typical example)
```bash
$ lsblk
sdb1   16G   part

$ sudo mount /dev/sdb1 /mnt
$ ls /mnt
(contents of the USB drive show up here)

$ sudo umount /mnt      # ALWAYS unmount before physically removing the drive
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Run `df -h` and note your root filesystem's usage percentage
- [ ] Find the size of your home directory: `du -sh ~`
- [ ] Find the top 5 largest folders inside your home directory
- [ ] Run `lsblk` and identify your main disk and its partitions
- [ ] Run `lsblk -f` and note the filesystem type (ext4, etc.) of your root partition
- [ ] If you have a USB drive handy, plug it in, mount it, browse it, then unmount it properly

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — The Space Hog**
> Write a single command that lists the top 5 largest folders inside `/var`, sorted from biggest to smallest.

> **🥊 Challenge 2 — Almost Full**
> Write a command using `df -h` output that would help you quickly spot any filesystem that's over 80% full (you can eyeball the output — no scripting needed yet).

> **🥊 Challenge 3 — The Mismatch**
> `df -h /` shows 18G used, but `du -sh /` shows only 12G. Give one plausible reason these numbers don't match exactly.

🏆 Solutions drop in Day 11.

---

## 🧩 Quick Brain Check

1. What's the actual difference between what `df` measures and what `du` measures?
2. What does "mounting" a drive actually mean on Linux?
3. In `/dev/sda1`, what does the "1" at the end represent?
4. Why should you always `umount` a USB drive before physically removing it?
5. If `lsblk` shows a partition with no `MOUNTPOINT` listed, what does that tell you?

*(Reason it out first — discussed in Day 11.)*

---

## 🐛 Gotchas That'll Trip You Up

- `du` can take a while on large directories — use `du -sh` (summarize) instead of full recursive output unless you specifically need per-file detail.
- Unplugging a USB drive WITHOUT unmounting it first can corrupt data still being written — always `umount` first.
- `df -h` shows filesystems, not individual folders — for folder-level detail, you need `du`, not `df`.

---

## 🧠 Today's Takeaway

`df` tells you the big picture (how full is the whole filesystem), `du` tells you the specific culprit (which folder is actually eating space), and `lsblk` shows you the physical hardware layout underneath it all. Mounting isn't magic — it's just attaching a device onto a folder in the one big filesystem tree.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 11 — Archiving & Compression**
