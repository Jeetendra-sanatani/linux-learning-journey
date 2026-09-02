# 🛠️ Day 06 — Services & Systemctl

<p align="center">
  <img src="https://img.shields.io/badge/day-06%2F30-blue?style=for-the-badge" alt="Day 06"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie-yellow?style=for-the-badge" alt="Level"/>
</p>

> Day 4 taught you to manage individual processes by hand. Day 6 shows you what actually starts, stops, and babysits those processes in the background — every single time your machine boots. 🔧

---

## 🏆 Day 05 Recap — Challenge Solutions

**Challenge 1 (Open Door Check):**
```bash
$ ss -tuln | grep :22
```

**Challenge 2 (The Silent Target):**
Not necessarily — many servers/firewalls deliberately block ICMP (ping) for security reasons. The server could be perfectly alive; it's just ignoring ping requests specifically.

**Challenge 3 (Status Code Detective):**
```bash
$ curl -I https://example.com
```

---

## 🎯 Mission Briefing

That SSH server that's always running? The web server that starts the instant you boot up? None of that happens by magic — it's **systemd**, the init system, quietly starting, stopping, and supervising background services (called "daemons") the entire time your machine is on. Today you learn to control that machinery directly.

```
🛠️  MISSION: Master the Service Layer
──────────────────────────────────────────
[ ] Check status of any running service
[ ] Start, stop, and restart services
[ ] Enable/disable services on boot
[ ] Read service logs with journalctl
──────────────────────────────────────────
STATUS: Day 06 — In Progress...
```

Security relevance: attackers often try to **persist** by installing a malicious service that auto-starts on boot. Knowing how to inspect and audit services is exactly how defenders catch that.

---

## ⚡ Quick Theory — What's a Service, Really?

A **service** (or **daemon**) is just a process designed to run continuously in the background — no user interaction needed. Think `sshd` (SSH server), `nginx` (web server), `cron` (job scheduler). These don't wait for you to type a command; they just... run, forever, quietly.

**systemd** is the modern init system that manages all of this on most Linux distros (including Kali). It's the very first thing that starts when your machine boots (PID 1), and it's responsible for starting every other service afterward, in the right order, with the right dependencies.

**The core systemctl commands, in plain English:**
```
status    → "Is this thing running right now?"
start     → "Turn it on, right now, once"
stop      → "Turn it off, right now"
restart   → "Turn it off, then back on" (useful after config changes)
enable    → "Also turn this on automatically every time the machine boots"
disable   → "Stop auto-starting this on boot" (doesn't stop it if already running)
```

🔑 **Key distinction that trips people up:** `start`/`stop` affects the service RIGHT NOW. `enable`/`disable` affects what happens on the NEXT BOOT. You often need both — e.g., `systemctl enable --now nginx` starts it immediately AND makes it survive a reboot.

**Where service definitions actually live:**
```
/etc/systemd/system/       → custom/user-installed services
/lib/systemd/system/       → services installed by packages
journalctl                 → the tool to read logs for any service
```

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔍 Checking service status
```bash
$ sudo systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled)
     Active: active (running) since Wed 2025-08-27 09:00:00 IST

$ systemctl is-active ssh
active

$ systemctl is-enabled ssh
enabled
```

### 🔧 Starting, stopping, restarting
```bash
$ sudo systemctl stop ssh
$ systemctl is-active ssh
inactive

$ sudo systemctl start ssh
$ systemctl is-active ssh
active

$ sudo systemctl restart ssh    # useful after editing sshd_config
```

### 🚀 Controlling boot behavior
```bash
$ sudo systemctl enable ssh
Created symlink /etc/systemd/system/multi-user.target.wants/ssh.service

$ sudo systemctl disable ssh
Removed symlink /etc/systemd/system/multi-user.target.wants/ssh.service

$ sudo systemctl enable --now ssh    # enable AND start in one command
```

### 📋 Listing all services
```bash
$ systemctl list-units --type=service --state=running
UNIT              LOAD   ACTIVE  SUB
ssh.service       loaded active  running
cron.service      loaded active  running

$ systemctl list-unit-files --type=service | grep enabled
```

### 📜 Reading service logs with journalctl
```bash
$ journalctl -u ssh                # all logs for the ssh service
$ journalctl -u ssh -f              # follow logs live (like tail -f)
$ journalctl -u ssh --since "1 hour ago"
$ journalctl -p err -b               # only error-level logs, since last boot
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Check the status of the SSH service on your machine
- [ ] Stop it, confirm it's inactive with `systemctl is-active`, then start it again
- [ ] Check whether SSH is enabled to auto-start on boot
- [ ] List every currently running service with `systemctl list-units --type=service --state=running`
- [ ] View the last 20 log lines for the SSH service using `journalctl -u ssh -n 20`
- [ ] Find any FAILED services on your system: `systemctl --failed`

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — The Persistence Check**
> Write a single command to check if the `cron` service is set to auto-start on boot, WITHOUT starting or stopping it.

> **🥊 Challenge 2 — One-Shot Fix**
> A service needs to be both started immediately AND enabled for every future boot. What's the single command that does both?

> **🥊 Challenge 3 — The Audit**
> Write a command to list every service currently set to auto-start on boot (`enabled` state) — a classic first step when auditing a machine for suspicious persistence.

🏆 Solutions drop in Day 07.

---

## 🧩 Quick Brain Check

1. What's the actual difference between `systemctl start` and `systemctl enable`?
2. If a service shows `Active: inactive (dead)`, is it enabled or disabled on boot? (Trick question — think about it.)
3. What does PID 1 refer to on a systemd-based Linux system?
4. Why would an attacker want to `enable` a malicious service instead of just starting it once?
5. What command shows you ONLY the failed services on a system?

*(Reason it out first — discussed in Day 07.)*

---

## 🐛 Gotchas That'll Trip You Up

- `disable`-ing a service does NOT stop it if it's already running — it only prevents it from starting on the NEXT boot. You need `stop` too if you want it off right now.
- Forgetting `sudo` on `systemctl start/stop/restart` gives a permission error — but `status` usually works fine without it.
- Service names sometimes differ slightly from what you expect (`ssh` vs `sshd`) depending on the distro — use `systemctl list-unit-files` if unsure what it's actually called.

---

## 🧠 Today's Takeaway

Behind every "it just works" background service is systemd quietly managing state. `start`/`stop` = right now. `enable`/`disable` = on boot. And `journalctl` is your window into what a service has actually been doing — invaluable both for debugging AND for spotting something suspicious.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 07 — Logs & Log Analysis**
