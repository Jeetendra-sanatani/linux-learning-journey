# 📦 Day 09 — Package Management

<p align="center">
  <img src="https://img.shields.io/badge/day-09%2F30-blue?style=for-the-badge" alt="Day 09"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie-yellow?style=for-the-badge" alt="Level"/>
</p>

> Days 1-8 were about the system you already have. Day 9 is about ADDING new tools to it — safely, and without breaking anything. 📦

---

## 🏆 Day 08 Recap — Challenge Solutions

**Challenge 1 (The SUID Hunt):**
```bash
$ find / -perm -4000 -type f 2>/dev/null
```

**Challenge 2 (Odd One Out):**
`/usr/bin/nano` is suspicious — `passwd` and `sudo` genuinely NEED SUID root to function, but a text editor having SUID root makes no sense and would be a serious privilege escalation risk (anyone could use it to edit any file as root).

**Challenge 3 (The Checklist):**
Sample answer: (1) Check for unnecessary SUID binaries, (2) Check `auth.log` for brute-force attempts, (3) Confirm `PermitRootLogin no` in SSH config.

---

## 🎯 Mission Briefing

Every tool you've used so far — `ps`, `grep`, `find`, `ssh` — came from somewhere. Today you learn HOW software actually gets installed, updated, and removed on Kali/Debian-based systems, and why "downloading random binaries off the internet" is exactly what you should NOT be doing.

```
📦 MISSION: Control What Gets Installed
──────────────────────────────────────────
[ ] Update package lists safely
[ ] Install and remove software properly
[ ] Search for packages before installing
[ ] Check what's already installed on your system
──────────────────────────────────────────
STATUS: Day 09 — In Progress...
```

Security relevance: attackers sometimes trick people into installing malicious packages from untrusted sources. Knowing the OFFICIAL way to manage packages is your first defense against that.

---

## ⚡ Quick Theory — How Software Actually Gets Installed

Kali (like Ubuntu and Debian) uses the **APT** (Advanced Package Tool) system. Two layers work together:

```
dpkg  → the LOW-LEVEL tool that actually installs/removes .deb package files
apt   → the HIGH-LEVEL tool that talks to online repositories, handles
        dependencies automatically, and calls dpkg behind the scenes
```

You'll almost always use `apt` day-to-day — `dpkg` is more for troubleshooting or installing a `.deb` file you downloaded manually.

**The core APT workflow, in order:**
```
1. apt update    → refresh the LIST of available packages (doesn't install anything)
2. apt upgrade    → actually install newer versions of already-installed packages
3. apt install    → install a NEW package
4. apt remove      → uninstall a package (keeps its config files)
5. apt purge        → uninstall a package AND delete its config files too
```

🔑 **Common beginner confusion:** `apt update` does NOT upgrade your software — it just refreshes the catalog of what's available. You still need `apt upgrade` afterward to actually install newer versions. Skipping `update` means `apt` might try installing based on a stale, outdated package list.

**Why this matters for security:** installing software ONLY through `apt` (from official repositories) means every package is cryptographically signed and comes from a trusted source. Downloading and running random `.sh` install scripts from the internet is a common way malware gets onto a system.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔄 Updating package lists
```bash
$ sudo apt update
Hit:1 http://kali.download/kali kali-rolling InRelease
Reading package lists... Done
All packages are up to date.
```

### 🔍 Searching for a package before installing
```bash
$ apt search nmap | head -5
nmap - The Network Mapper
nmap-common - Architecture independent files for nmap

$ apt show nmap
Package: nmap
Version: 7.94-1
Description: The Network Mapper
```

### 📥 Installing a package
```bash
$ sudo apt install tree
Reading package lists... Done
The following NEW packages will be installed:
  tree
Setting up tree (2.1.1-2) ...
```

### 📋 Checking installed packages
```bash
$ apt list --installed | grep tree
tree/kali-rolling,now 2.1.1-2 amd64 [installed]

$ dpkg -l | grep nmap
ii  nmap  7.94-1  Network exploration tool
```

### 🗑️ Removing a package
```bash
$ sudo apt remove tree          # removes package, keeps config files
$ sudo apt purge tree           # removes package AND config files
$ sudo apt autoremove           # cleans up unused leftover dependencies
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Run `sudo apt update` and read through the output
- [ ] Search for a package you're curious about with `apt search <name>`
- [ ] Install a small, harmless package (like `tree` or `htop`)
- [ ] Verify it's installed using `apt list --installed | grep <name>`
- [ ] Check the same package's info using `dpkg -l | grep <name>`
- [ ] Remove it cleanly with `sudo apt purge <name>`, then run `autoremove`

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — Version Check**
> Write a single command to check the exact installed version of a package called `openssh-server`, without installing or removing anything.

> **🥊 Challenge 2 — Clean Sweep**
> You installed a package, then removed it with `apt remove`. Its config files are still hanging around. What's the correct command to remove them too?

> **🥊 Challenge 3 — The Difference**
> Explain in one line: what's the actual difference between running `apt update` and `apt upgrade`? Why would running only one of them leave your system in a weird state?

🏆 Solutions drop in Day 10.

---

## 🧩 Quick Brain Check

1. What's the difference between `dpkg` and `apt`?
2. Why doesn't `apt update` actually install anything?
3. What's the difference between `apt remove` and `apt purge`?
4. Why is installing software through official repositories safer than downloading random install scripts?
5. What does `apt autoremove` actually clean up?

*(Reason it out first — discussed in Day 10.)*

---

## 🐛 Gotchas That'll Trip You Up

- Forgetting `sudo apt update` before `install` can cause "package not found" errors if your package list is outdated.
- `apt remove` vs `apt purge` confusion is common — if you want a COMPLETELY clean removal (including configs), you need `purge`, not `remove`.
- Installing packages from random third-party `.deb` files bypasses APT's trust/signature checks — stick to official repos unless you really know what you're doing.

---

## 🧠 Today's Takeaway

`apt update` refreshes the catalog, `apt upgrade` installs newer versions, `apt install`/`remove`/`purge` manage individual packages. Under the hood, `dpkg` does the actual work — `apt` is just the friendly, dependency-aware wrapper around it. Stick to official repos, and package management stays boring (in a good way).

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 10 — Disk & Storage Management**
