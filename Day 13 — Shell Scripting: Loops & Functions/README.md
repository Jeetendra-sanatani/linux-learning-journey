# 🔁 Day 13 — Shell Scripting: Loops & Functions

<p align="center">
  <img src="https://img.shields.io/badge/day-13%2F30-blue?style=for-the-badge" alt="Day 13"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> Day 12 gave your scripts the ability to DECIDE. Day 13 gives them the ability to REPEAT and REUSE — loops and functions are what separate a one-off script from something you'd actually keep around. 🔁

---

## 🏆 Day 12 Recap — Challenge Solutions

**Challenge 1 (The Bouncer Script):**
```bash
#!/bin/bash
read -p "Enter password: " pass
if [ "$pass" = "letmein" ]; then
    echo "Access granted."
else
    echo "Access denied."
fi
```

**Challenge 2 (Directory Checker):**
```bash
#!/bin/bash
if [ -d "backups" ]; then
    echo "backups folder exists."
else
    echo "backups folder is missing!"
fi
```

**Challenge 3 (The Silent Script):**
```bash
$ chmod +x myscript.sh
```
Happens because scripts need execute permission (`x` bit) before Linux will run them directly — a Day 2 concept resurfacing.

---

## 🎯 Mission Briefing

Imagine checking 50 usernames one by one with copy-pasted if/else blocks. Painful, right? Today you learn **loops** (do something repeatedly) and **functions** (package logic once, reuse it forever) — the two things that make scripts actually scale.

```
🔁 MISSION: Stop Repeating Yourself
──────────────────────────────────────────
[ ] Write a for loop
[ ] Write a while loop
[ ] Define and call a function
[ ] Pass arguments into a function
──────────────────────────────────────────
STATUS: Day 13 — In Progress...
```

---

## ⚡ Quick Theory — Loops & Functions, Plain and Simple

**`for` loop — when you know WHAT you're looping over:**
```bash
for name in raven phoenix ghost; do
    echo "Hello, $name"
done
```
Runs once for each item in the list — 3 items, 3 iterations.

**`while` loop — when you loop UNTIL a condition becomes false:**
```bash
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    ((count++))
done
```
Keeps going as long as the condition inside `[ ]` stays true.

**Functions — package logic once, call it by name repeatedly:**
```bash
greet() {
    echo "Hello, $1!"
}

greet "raven"
greet "phoenix"
```

🔑 **The `$1` thing that confuses everyone at first:** inside a function, `$1` is the FIRST argument passed in, `$2` is the second, and so on — NOT related to variables you defined elsewhere. `greet "raven"` means `$1` = `"raven"` INSIDE that function call only.

**Why functions matter beyond "less typing":** if you find a bug in your logic, you fix it in ONE place (the function) instead of hunting down every copy-pasted block that has the same mistake.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔁 A basic for loop
```bash
#!/bin/bash
for name in raven phoenix ghost; do
    echo "Hello, $name!"
done
```
```bash
$ ./greet_all.sh
Hello, raven!
Hello, phoenix!
Hello, ghost!
```

### 🔁 A for loop over a range of numbers
```bash
#!/bin/bash
for i in {1..5}; do
    echo "Iteration number $i"
done
```

### 🔁 A for loop over files
```bash
#!/bin/bash
for file in *.txt; do
    echo "Found file: $file"
done
```

### ⏳ A while loop
```bash
#!/bin/bash
count=1
while [ $count -le 5 ]; do
    echo "Count: $count"
    ((count++))
done
```
```bash
$ ./countdown.sh
Count: 1
Count: 2
Count: 3
Count: 4
Count: 5
```

### 🧩 Defining and using a function
```bash
#!/bin/bash
check_file() {
    if [ -f "$1" ]; then
        echo "$1 exists."
    else
        echo "$1 is missing."
    fi
}

check_file "notes.txt"
check_file "ghost_file.txt"
```
```bash
$ ./check.sh
notes.txt exists.
ghost_file.txt is missing.
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Write a for loop that prints "Day X" for X from 1 to 13
- [ ] Write a for loop that lists every `.txt` file in your current folder
- [ ] Write a while loop that counts down from 10 to 1
- [ ] Write a function called `say_hello` that takes a name and prints a greeting
- [ ] Call `say_hello` three times with three different names
- [ ] Combine a for loop WITH a function — loop through 3 names, calling `say_hello` on each

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — The Counter**
> Write a script using a `for` loop that prints the numbers 1 to 20, but SKIPS printing 13 (bad luck, apparently).

> **🥊 Challenge 2 — The Reusable Checker**
> Write a function `is_number` that takes one argument and checks (using a basic if condition) whether it looks like a positive number greater than 0. Call it with 3 different test values.

> **🥊 Challenge 3 — Loop + Function Combo**
> Write a script with a function `check_file` (like the example above) and a `for` loop that checks THREE different filenames using that same function.

🏆 Solutions drop in Day 14.

---

## 🧩 Quick Brain Check

1. What's the key difference between when you'd use a `for` loop vs a `while` loop?
2. Inside a function, what does `$1` actually refer to?
3. What does `{1..5}` expand to inside a `for` loop?
4. Why is reusing a function better than copy-pasting the same code block multiple times?
5. What would happen if a `while` loop's condition NEVER became false?

*(Reason it out first — discussed in Day 14.)*

---

## 🐛 Gotchas That'll Trip You Up

- Forgetting `((count++))` (or similar) inside a `while` loop means the condition never changes — infinite loop! `Ctrl+C` gets you out.
- Function definitions must come BEFORE you call them in the script — bash reads top to bottom, so calling a function before it's defined causes a "command not found" error.
- `$1` inside a function refers to that function's OWN argument, not a global script argument, even if the names look similar.

---

## 🧠 Today's Takeaway

`for` loops handle "do this for each item in a known list." `while` loops handle "keep going until something changes." Functions turn repeated logic into a single, reusable, fixable block. Put loops and functions together, and you've basically got the building blocks for real automation — backup scripts, health checks, anything that repeats.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 14 — Environment Variables & Shell Config**
