# 📝 Day 12 — Shell Scripting Basics

<p align="center">
  <img src="https://img.shields.io/badge/day-12%2F30-blue?style=for-the-badge" alt="Day 12"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> Days 1-11 were all typing commands one at a time. Day 12 is the turning point — today you write a file that runs a WHOLE SEQUENCE of commands for you. Welcome to scripting. 📝

---

## 🏆 Day 11 Recap — Challenge Solutions

**Challenge 1 (One-Liner Backup):**
```bash
$ tar -czf daily_backup.tar.gz ~/practice
```

**Challenge 2 (Peek Before You Leap):**
```bash
$ tar -tzf suspicious_file.tar.gz
```

**Challenge 3 (Extension Detective):**
`data.tar.gz` is most likely smallest — `.tar` alone isn't compressed, and `.zip` typically compresses slightly less efficiently than gzip for most file types (though it's close).

---

## 🎯 Mission Briefing

Everything you've typed so far — one command, Enter, repeat — works fine for small tasks. But what about a sequence you'll run again and again? Today you stop typing commands one-by-one and start writing them into a **script**: a file Linux can run as a single unit.

```
📝 MISSION: Write Your First Script
──────────────────────────────────────────
[ ] Write and run a basic bash script
[ ] Use variables to store values
[ ] Accept user input with read
[ ] Make decisions with if/else
──────────────────────────────────────────
STATUS: Day 12 — In Progress...
```

This is genuinely a milestone — every automation tool, every backup job, every security scan script you'll ever write starts from exactly what you learn today.

---

## ⚡ Quick Theory — Your First Script, Piece by Piece

**Every bash script starts with a shebang** — a special first line telling Linux which interpreter to use:
```bash
#!/bin/bash
```
This isn't a comment for humans (even though it starts with `#`) — the kernel actually reads this line to know how to execute the file.

**Variables — storing values to reuse:**
```bash
name="raven"          # NO spaces around the = sign (this trips up everyone at first)
echo "Hello, $name"   # use $ to ACCESS a variable's value
```

**Reading user input:**
```bash
read -p "Enter your name: " username
echo "Hi, $username!"
```

**Making decisions with if/else:**
```bash
if [ "$name" = "raven" ]; then
    echo "Welcome back!"
else
    echo "Who are you?"
fi
```

🔑 **The spacing rule that breaks everyone's first script:** inside `[ ]`, you NEED spaces around everything — `[ "$name" = "raven" ]` works, but `["$name"="raven"]` (no spaces) throws a confusing error. Bash is oddly picky about this.

**Making a script actually runnable:**
```bash
chmod +x myscript.sh    # give it execute permission (remember Day 2!)
./myscript.sh            # run it (the ./ means "look in the current folder")
```

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 📝 Writing your first script
```bash
$ nano greet.sh
```
Type this inside:
```bash
#!/bin/bash
name="raven"
echo "Hello, $name! Today is day 12."
```
Save and exit (`Ctrl+O`, Enter, `Ctrl+X` in nano).

### ▶️ Making it executable and running it
```bash
$ chmod +x greet.sh
$ ./greet.sh
Hello, raven! Today is day 12.
```

### ⌨️ Accepting user input
```bash
#!/bin/bash
read -p "What's your name? " username
echo "Nice to meet you, $username!"
```
```bash
$ ./ask.sh
What's your name? raven
Nice to meet you, raven!
```

### 🔀 Using if/else for decisions
```bash
#!/bin/bash
read -p "Enter a number: " num

if [ "$num" -gt 10 ]; then
    echo "That's bigger than 10."
else
    echo "That's 10 or smaller."
fi
```
```bash
$ ./check.sh
Enter a number: 15
That's bigger than 10.
```

### 🔍 Checking if a file exists (a real, practical use case)
```bash
#!/bin/bash
if [ -f "notes.txt" ]; then
    echo "notes.txt exists."
else
    echo "notes.txt is missing!"
fi
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Write a script that stores your name in a variable and echoes a greeting
- [ ] Make the script executable with `chmod +x` and run it with `./scriptname.sh`
- [ ] Write a script that uses `read` to ask for the user's age
- [ ] Add an if/else that prints "Adult" if age is 18 or above, "Minor" otherwise
- [ ] Write a script that checks if a specific file exists using `[ -f "filename" ]`
- [ ] Try running the script WITHOUT `chmod +x` first — see what error you get

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — The Bouncer Script**
> Write a script that asks for a password using `read`. If it matches `"letmein"`, print "Access granted." Otherwise print "Access denied."

> **🥊 Challenge 2 — Directory Checker**
> Write a script that checks if a folder called `backups` exists in the current directory. If not, print a message saying it's missing (don't worry about creating it yet — that's Day 13 territory).

> **🥊 Challenge 3 — The Silent Script**
> You run `./myscript.sh` and get `Permission denied`. What's the exact command that fixes this, and why does it happen in the first place?

🏆 Solutions drop in Day 13.

---

## 🧩 Quick Brain Check

1. What does the `#!/bin/bash` line at the top of a script actually do?
2. Why does `name = "raven"` (with spaces around `=`) NOT work in bash?
3. What's the difference between `$name` and `name` when referring to a variable?
4. Why do you need spaces inside `[ ]` when writing an if condition?
5. What does `-f` check for inside an if condition (`[ -f "file.txt" ]`)?

*(Reason it out first — discussed in Day 13.)*

---

## 🐛 Gotchas That'll Trip You Up

- Forgetting `chmod +x` before running a script gives `Permission denied` — scripts need execute permission just like any other program (Day 2 concept coming back!).
- Spaces around `=` when assigning a variable (`name = "raven"`) breaks the script — bash reads it as trying to run a command called `name`.
- Missing spaces inside `[ ]` conditions (`["$x"="y"]` instead of `[ "$x" = "y" ]`) causes cryptic syntax errors.

---

## 🧠 Today's Takeaway

A script is just commands in a file, run in order — but variables and if/else are what turn "a list of commands" into something that actually THINKS. Get the spacing rules right (around `=`, inside `[ ]`) and scripting stops feeling fragile. This is the real starting line for automation.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 13 — Shell Scripting: Loops & Functions**
