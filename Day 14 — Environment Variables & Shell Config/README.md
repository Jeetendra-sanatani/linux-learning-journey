# ⚙️ Day 14 — Environment Variables & Shell Config

<p align="center">
  <img src="https://img.shields.io/badge/day-14%2F30-blue?style=for-the-badge" alt="Day 14"/>
  <img src="https://img.shields.io/badge/status-done-success?style=for-the-badge" alt="Status"/>
  <img src="https://img.shields.io/badge/level-rookie%2B-yellow?style=for-the-badge" alt="Level"/>
</p>

> Halfway there — Day 14 of 30! Today's topic explains something that's been quietly working behind the scenes since Day 1: how your shell actually KNOWS things like your home folder, your prompt style, and where to find commands. ⚙️

---

## 🏆 Day 13 Recap — Challenge Solutions

**Challenge 1 (The Counter):**
```bash
for i in {1..20}; do
    if [ "$i" -eq 13 ]; then
        continue
    fi
    echo "$i"
done
```

**Challenge 2 (The Reusable Checker):**
```bash
is_number() {
    if [ "$1" -gt 0 ] 2>/dev/null; then
        echo "$1 is a positive number."
    else
        echo "$1 is not a positive number."
    fi
}
is_number 5
is_number -3
is_number abc
```

**Challenge 3 (Loop + Function Combo):**
```bash
check_file() {
    if [ -f "$1" ]; then echo "$1 exists."; else echo "$1 is missing."; fi
}
for f in file1.txt file2.txt file3.txt; do
    check_file "$f"
done
```

---

## 🎯 Mission Briefing

Ever wonder how typing `ls` just... works, without you specifying `/usr/bin/ls` every time? Or how `cd ~` always knows where "home" is? Today you learn about **environment variables** — the invisible settings your shell checks constantly — and `.bashrc`, the file that lets YOU customize how your terminal behaves.

```
⚙️  MISSION: Control Your Shell's Behavior
──────────────────────────────────────────
[ ] Understand what environment variables are
[ ] View and set your own variables
[ ] Understand PATH specifically
[ ] Make custom settings PERMANENT via .bashrc
──────────────────────────────────────────
STATUS: Day 14 — In Progress...
```

---

## ⚡ Quick Theory — The Shell's Hidden Settings

**Environment variables** are named values the shell and programs check constantly. You've actually been using them without realizing:

```bash
$ echo $HOME
/home/raven

$ echo $USER
raven

$ echo $SHELL
/bin/bash
```

**PATH — the most important variable you'll ever deal with:**
```bash
$ echo $PATH
/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
```

This is a colon-separated LIST of folders. When you type `ls`, bash searches through EVERY folder in `PATH`, in order, until it finds a program called `ls`. That's literally how commands get found — no PATH entry, no command recognized ("command not found").

**Temporary vs Permanent — the crucial distinction:**
```bash
export MY_VAR="hello"     # exists ONLY in this terminal session
```
The moment you close this terminal, `MY_VAR` is gone. To make a variable (or ANY shell customization) survive across sessions, it needs to live inside **`~/.bashrc`** — a file that runs automatically every time a new terminal opens.

```
~/.bashrc    → runs every time you open a NEW terminal — this is where
               permanent customizations (variables, aliases, prompt) go
```

🔑 **Why this matters for real work:** setting up a custom tool, a personal script folder, or a shortcut command that "just works" every time you log in — all of it goes through `.bashrc`. This is THE file experienced Linux users heavily customize.

---

## 💻 Let's Get Our Hands Dirty

*(Machine: Kali Linux | User: `raven`)*

### 🔍 Viewing existing environment variables
```bash
$ echo $HOME
/home/raven

$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

$ env | head -5
SHELL=/bin/bash
USER=raven
HOME=/home/raven
```

### 🔧 Setting a temporary variable
```bash
$ export PROJECT_DIR="/home/raven/practice"
$ echo $PROJECT_DIR
/home/raven/practice

$ cd $PROJECT_DIR
$ pwd
/home/raven/practice
```
Close the terminal, reopen it — `$PROJECT_DIR` is gone. Temporary means temporary.

### 📝 Making it PERMANENT via .bashrc
```bash
$ nano ~/.bashrc
```
Scroll to the bottom, add:
```bash
export PROJECT_DIR="/home/raven/practice"
```
Save, exit, then reload WITHOUT restarting the terminal:
```bash
$ source ~/.bashrc
$ echo $PROJECT_DIR
/home/raven/practice
```

### ✨ Adding a simple alias (bonus quality-of-life trick)
```bash
$ echo "alias ll='ls -la'" >> ~/.bashrc
$ source ~/.bashrc
$ ll
drwxr-xr-x  4 raven raven 4096 Aug 27 practice
```

---

## 🧪 Your Turn — Prove You Got This

- [ ] Print your `$HOME`, `$USER`, and `$SHELL` variables
- [ ] Print your `$PATH` and count how many folders are listed (hint: `echo $PATH | tr ':' '\n' | wc -l`)
- [ ] Set a temporary variable, confirm it works, then open a NEW terminal and confirm it's gone
- [ ] Add that same variable to `~/.bashrc` and make it permanent
- [ ] Reload your shell config with `source ~/.bashrc` without closing the terminal
- [ ] Add one custom alias to `~/.bashrc` and test it

---

## 🎯 Mini Challenges (Boss Fights)

> **🥊 Challenge 1 — PATH Detective**
> Write a command that counts how many directories are listed in your `$PATH`.

> **🥊 Challenge 2 — The Missing Command**
> You install a new tool, but running it says "command not found" even though the file definitely exists. What environment variable is the MOST likely cause, and how would you fix it?

> **🥊 Challenge 3 — Make It Stick**
> You just set `export TOOL_HOME="/opt/mytool"` in your terminal, and it works. But tomorrow it's gone. What ONE-LINE fix makes it permanent?

🏆 Solutions drop in Day 15.

---

## 🧩 Quick Brain Check

1. What's the actual difference between setting a variable temporarily vs adding it to `.bashrc`?
2. What does the `PATH` variable actually control?
3. If you edit `.bashrc`, why doesn't the change apply immediately without `source`?
4. What's the difference between `echo $HOME` and `echo HOME` (with vs without `$`)?
5. Why would someone add a custom folder to their `PATH` variable?

*(Reason it out first — discussed in Day 15.)*

---

## 🐛 Gotchas That'll Trip You Up

- Editing `.bashrc` doesn't apply automatically — you either need to `source ~/.bashrc` or open a brand new terminal for changes to take effect.
- Forgetting `export` when setting a variable means child processes (scripts you run) won't be able to see it — plain `VAR=value` stays local to just your current shell.
- Typo-ing a path in `.bashrc` (like a broken `PATH` edit) can seriously break your terminal on next login — always double-check before saving, and know that `bash --noprofile --norc` can get you into a clean shell to fix mistakes.

---

## 🧠 Today's Takeaway

Environment variables are the shell's memory of important settings — `$HOME`, `$USER`, and especially `$PATH` (which decides which commands even get recognized). Anything temporary disappears when the terminal closes; anything that needs to survive goes into `.bashrc`, reloaded with `source`. This is genuinely how people personalize their entire terminal experience.

---

⬅️ [Back to main journal](../README.md) | ➡️ Next up: **Day 15 — Text Processing: grep & sed Basics**
