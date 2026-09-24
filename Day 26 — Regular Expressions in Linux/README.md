# 🧩 Day 26 — Regular Expressions in Linux

<p align="center">
  <img src="https://img.shields.io/badge/day-26%2F30-blue?style=for-the-badge" alt="Day 26"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> 4 days left! You've used `^` and `$` in grep since Day 15 without fully understanding regex. Today you go deeper — patterns that can match phone numbers, IPs, emails, and way more than plain text search ever could. 🧩

---

## 🏆 Day 25 Recap — Challenge Solutions

**Challenge 1 (The Cleanup):**
```bash
$ find ~/practice -name "*.tmp" -exec rm {} \;
```

**Challenge 2 (Empty Space Hunt):**
```bash
$ find ~ -empty
```

**Challenge 3 (Speed Comparison):**
`find` walks the ENTIRE live filesystem every single search, checking every file/folder in real time. `locate` just queries a pre-built INDEX (database) — like searching a book's index instead of reading every page. That's why locate is near-instant, at the cost of possibly being slightly out of date.

---

## 🎯 Mission Briefing

Plain text search finds exact words. Regex finds PATTERNS — "any line that looks like an IP address," "any line starting with a number," "anything that resembles an email." Today you build real regex patterns and use them with tools you already know: `grep`, `sed`, and `awk`.

```
🧩 MISSION: Think in Patterns
──────────────────────────────────────────
[ ] Understand core regex building blocks
[ ] Match digits, letters, and repetition
[ ] Build a pattern to match an IP address
[ ] Use extended regex with grep -E
──────────────────────────────────────────
STATUS: Day 26 — In Progress...
```

Security relevance: parsing logs for IP addresses, detecting suspicious patterns in text, and validating input are all regex-powered tasks in security tooling.

---

## ⚡ Quick Theory — Building Blocks of Regex

You already know `^` (start of line) and `$` (end of line) from Day 15. Here's the rest of the essential toolkit:

```
.        → matches ANY single character
*        → the PREVIOUS character, zero or more times
+        → the PREVIOUS character, one or more times (needs -E in grep)
?        → the PREVIOUS character, zero or ONE time (needs -E)
[abc]    → matches ANY ONE of a, b, or c
[0-9]    → matches ANY single digit
[a-z]    → matches ANY single lowercase letter
[^0-9]   → matches anything EXCEPT a digit (^ inside [] means NOT)
{3}      → the previous character/group, EXACTLY 3 times (needs -E)
```

**Building up to something real — matching a digit sequence:**
```bash
[0-9]        → one digit
[0-9]+       → one or more digits (needs grep -E)
[0-9]{1,3}   → between 1 and 3 digits (needs grep -E)
```

**Putting it together — matching an IP address (simplified pattern):**
```bash
grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
```
Reads as: "1-3 digits, a literal dot, 1-3 digits, a literal dot, 1-3 digits, a literal dot, 1-3 digits." Notice the `\.` — a plain `.` means "any character," so to match a LITERAL dot, you escape it with a backslash.

🔑 **Basic regex (BRE) vs Extended regex (ERE):** plain `grep` uses basic regex, where `+`, `?`, `{}` need extra escaping (`\+`, `\?`) to work as special characters. `grep -E` (extended) makes them work directly, without escaping — which is why almost everyone just uses `-E` from the start.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔍 Basic character classes
```bash
$ echo -e "cat\nbat\nhat\ncot" | grep "[cb]at"
cat
bat

$ echo -e "file1\nfile2\nfileA" | grep "file[0-9]"
file1
file2
```

### 🔍 Using + and ? (extended regex)
```bash
$ echo -e "color\ncolour" | grep -E "colou?r"
color
colour

$ echo "aaa bbb aaaa" | grep -Eo "a+"
aaa
aaaa
```

### 🔍 Matching digit sequences
```bash
$ echo "Order #12345 placed" | grep -Eo "[0-9]+"
12345

$ echo -e "phone: 9876543210\nphone: 12345" | grep -E "[0-9]{10}"
phone: 9876543210
```

### 🌐 Matching an IP address in logs
```bash
$ grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" /var/log/auth.log | head -3
Aug 27 09:40:12 kali sshd[1203]: Failed password for root from 203.0.113.5

$ grep -Eo "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" /var/log/auth.log | sort -u
203.0.113.5
198.51.100.7
```

### 🔍 Using regex with sed
```bash
$ echo "Contact: 9876543210" | sed -E 's/[0-9]{10}/[REDACTED]/'
Contact: [REDACTED]
```

### 🔍 Simple email-like pattern (not perfect, but a solid start)
```bash
$ echo "reach me at raven@example.com" | grep -Eo "[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+"
raven@example.com
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Write a grep pattern matching any line containing exactly 10 digits in a row
- [ ] Use `grep -Eo` to EXTRACT just the numbers from a line of mixed text
- [ ] Build the IP address pattern and test it against `/var/log/auth.log`
- [ ] Extract all unique IP addresses from a log file using the pattern + `sort -u`
- [ ] Use `sed -E` to redact/replace something matching a digit pattern
- [ ] Try matching a simple email-like pattern in a test string

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — Digit Extractor**
> Write a `grep -Eo` command that extracts ONLY the numbers from the line: `"Order #45231 shipped on day 12"` — expecting output `45231` and `12` separately.

> **🥊 Challenge 2 — IP Harvester**
> Write a command that extracts every UNIQUE IP address that appears anywhere in `/var/log/auth.log`.

> **🥊 Challenge 3 — The Redactor**
> Write a `sed -E` command that finds any 10-digit phone number in a text file and replaces it with `"[PHONE REDACTED]"`.

🏆 Solutions drop in Day 27.

---

## 🧩 Quick Brain Check

1. What's the difference between `.` and `\.` in regex?
2. Why does `+` need `grep -E` to work, but `^` and `$` don't?
3. What does `[0-9]{1,3}` mean, piece by piece?
4. What's the difference between basic regex (BRE) and extended regex (ERE)?
5. Why would `grep -Eo` be more useful than plain `grep -E` when extracting specific data?

*(Reason it out first — discussed in Day 27.)*

---

## 🐛 Gotchas That'll Trip You Up

- Forgetting to escape a literal dot (`\.`) means it matches ANY character, not just a period — a subtle bug that can silently match wrong data.
- Using `+`, `?`, or `{}` WITHOUT `-E` in grep either fails silently or requires awkward backslash-escaping — just default to `grep -E` to avoid the confusion entirely.
- The simplified IP pattern shown today would technically also match invalid IPs like `999.999.999.999` — real production regex for IP validation is more complex; today's version is intentionally simplified for learning.

---

## 🧠 Today's Takeaway

Regex turns "find this exact text" into "find anything that LOOKS like this shape" — digits, IPs, emails, patterns of any kind. `grep -E` unlocks the full toolkit (`+`, `?`, `{}`) without escaping headaches, and `-o` extracts just the matched part instead of the whole line. This is genuinely one of the most reusable skills across all of Linux, scripting, and security work.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 27 — Basic Linux Hardening Checklist**
