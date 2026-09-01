# 🌐 Day 05 — Networking Basics

<p align="center">
  <img src="https://img.shields.io/badge/day-05%2F30-blue?style=for-the-badge" alt="Day 05"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie-yellow?style=for-the-badge" alt="Level"/>
</p>

> Days 1-4 were all about the machine itself. Day 5 is where the machine starts talking to OTHERS — IPs, ports, connections. This is where security work really begins. 🌐

---

## 🏆 Day 04 Recap — Challenge Solutions

**Challenge 1 (Zombie Hunt):**
```bash
$ ps aux | awk '$8=="Z"' | wc -l
```

**Challenge 2 (The Graceful Exit):**
```bash
$ kill 2044        # try SIGTERM first
$ sleep 3          # give it a moment
$ kill -9 2044     # only if it's still alive
```

**Challenge 3 (Resource Hog):**
```bash
$ ps aux --sort=-%mem | awk 'NR==2 {print $2, $11}'
```

---

## 🎯 Mission Briefing

Every machine on a network has an address, and every service running on it listens on a port. Today you learn to see your own network identity, check what's actually listening for connections, and test whether you can reach the outside world at all.

```
🌐 MISSION: Map the Network
──────────────────────────────────────────
[ ] Find your IP address & network interfaces
[ ] Test connectivity to other machines
[ ] See what ports are open and listening
[ ] Make basic HTTP requests from the terminal
──────────────────────────────────────────
STATUS: Day 05 — In Progress...
```

This is the literal first step of any penetration test: **scan, discover, enumerate.** You can't attack (or defend) what you can't see.

---

## ⚡ Quick Theory — IPs, Ports & the Basics

**IP address** = a machine's address on a network, like a street address for data. Two flavors:
```
Private IP   → 192.168.x.x, 10.x.x.x  (only reachable inside your local network)
Public IP    → visible to the entire internet
```

**Ports** = numbered "doors" on a machine, each usually tied to a specific service:
```
22   → SSH (remote login)
80   → HTTP (websites)
443  → HTTPS (secure websites)
21   → FTP (file transfer)
3306 → MySQL database
```

When a service is "listening" on a port, it means that door is open and waiting for someone to knock (connect). **Finding open ports on a target** is the very first move in almost every security assessment — this is literally what `nmap` does at scale, but you can already peek at your own machine with basic tools today.

**The tools you'll actually use daily:**
```
ip addr     → shows your IP address(es) and network interfaces
ping        → checks if a machine is reachable at all
ss -tuln    → shows every port currently listening on YOUR machine
curl        → makes HTTP requests straight from the terminal, no browser needed
```

🔑 **Key mental model:** `ping` answers "is it alive?" — `ss`/`netstat` answers "what's open on THIS machine?" — `curl` answers "what does that web service actually say back?" Three different questions, three different tools.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔍 Finding your own network identity
```bash
$ ip addr show
2: eth0: <BROADCAST,MULTICAST,UP>
    inet 192.168.1.42/24 brd 192.168.1.255 scope global eth0

$ hostname -I
192.168.1.42
```

### 📡 Testing connectivity
```bash
$ ping -c 4 google.com
PING google.com (142.250.183.14): 56 data bytes
64 bytes from 142.250.183.14: icmp_seq=0 ttl=113 time=14.2 ms
64 bytes from 142.250.183.14: icmp_seq=1 ttl=113 time=13.8 ms
--- google.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss
```

### 🔎 Checking listening ports (what's open on YOUR machine)
```bash
$ ss -tuln
Netid  State    Local Address:Port
tcp    LISTEN   0.0.0.0:22
tcp    LISTEN   127.0.0.1:3306

$ ss -tulnp        # add process names (needs sudo for full detail)
```

### 🌍 Making requests with curl
```bash
$ curl -I https://example.com
HTTP/1.1 200 OK
Content-Type: text/html

$ curl https://api.ipify.org
203.0.113.45          # your public IP address
```

### 🛣️ Checking DNS & routing
```bash
$ cat /etc/resolv.conf
nameserver 8.8.8.8

$ dig google.com +short
142.250.183.14
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Find your machine's local IP address using `ip addr show`
- [ ] Ping a well-known site 4 times and note the average response time
- [ ] List every port your machine is currently listening on with `ss -tuln`
- [ ] Use `curl -I` on a website and identify the HTTP status code returned
- [ ] Find your public IP using `curl https://api.ipify.org`
- [ ] Look up a domain's IP address using `dig <domain> +short`

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — Open Door Check**
> Write a single command to check if port 22 (SSH) is currently listening on your machine.

> **🥊 Challenge 2 — The Silent Target**
> You `ping` a server and get 100% packet loss. Does that definitely mean the server is down? Explain in one line why it might not be.

> **🥊 Challenge 3 — Status Code Detective**
> Use `curl` to check the HTTP status code of `https://example.com` WITHOUT downloading the full page content.

🏆 Solutions drop in Day 06.

---

## 🧩 Quick Brain Check

1. What's the difference between a private IP and a public IP?
2. What port does HTTPS typically use, and why is it different from HTTP's port?
3. What does `ss -tuln` actually stand for/show, piece by piece?
4. If `ping` succeeds but a website won't load in the browser, what could still be wrong?
5. Why is port scanning considered one of the first steps in a penetration test?

*(Reason it out first — discussed in Day 06.)*

---

## 🐛 Gotchas That'll Trip You Up

- Some servers deliberately **block ping (ICMP)** for security reasons — "no ping response" doesn't always mean "server is down."
- `ss -tulnp` needs `sudo` to show which PROCESS owns each port — without it, some entries just show blank.
- `curl` without `-I` downloads the entire page body — use `-I` (headers only) when you just want status codes, not content.

---

## 🧠 Today's Takeaway

Every machine has an address, every service has a port, and `ping`/`ss`/`curl` are your three go-to tools for asking "is it alive?", "what's open?", and "what does it say back?" This is recon at the network level — the exact same instinct as Day 1's system recon, just aimed outward now.

---

⬅️ [Back to main journal](../README.md) | ➡️ Day 05 complete — 5/30 days done! 🎉
