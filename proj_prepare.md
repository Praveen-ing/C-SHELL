# C-SHELL Project Specifications

This document outlines the core requirements, features, and custom commands implemented in the custom Unix shell project.

---

## 1. Command Prompt & Tokenization
- **Custom Prompt**: Displays `<username@system_name:current_directory>`. The home directory (where the shell was launched) is represented by `~`.
- **Execution & Tokenization**: Supports running multiple commands sequentially when separated by `;`. Properly handles extra whitespace and tab characters.

---

## 2. Process Management
- **Foreground Processes**: Standard system commands (e.g., `emacs`, `vi`, `cat`) run in the foreground. The shell blocks and waits for their execution to complete before prompting for new input.
- **Background Processes**: Appending `&` at the end of a command (e.g., `sleep 10 &`) spawns the process as a background job. The shell prints its process ID (PID) immediately and outputs an exit notification once the background process terminates.

---

## 3. Custom Built-in Commands
The project implements custom C versions of standard utilities (no direct system exec wrapper calls for these):
- **`hop` (Directory Navigation)**: A replacement for `cd`. Prints the absolute path of the directory after navigation. Supports:
  - `.` (current directory)
  - `..` (parent directory)
  - `~` (home directory)
  - `-` (previous working directory)
  - Chaining multiple targets in a single call (e.g., `hop dir1 dir2`).
- **`reveal` (Directory Listing)**: A replacement for `ls`. Displays files and folders in alphabetical order. Output is color-coded: **blue** for directories and **green** for executable files. Flags supported:
  - `-a` (show hidden files)
  - `-l` (long listing details: permissions, link count, owner, group, file size, modification time).
- **`log` (Command History)**: A command history management tool. Persistently stores up to the last 15 unique, non-trivial commands in a local `history.txt` file. Supports:
  - `log` (prints the command history)
  - `log purge` (clears the stored history)
  - `log execute <index>` (re-runs the command at the given index).
- **`proclore` (Process Information)**: Explores the `/proc` filesystem and displays details of a process:
  - PID
  - Process Status (`R`/`S`/`D`/`T`/`Z`) with `+` if foreground
  - Process Group
  - Virtual Memory size (`vsize`)
  - Path to the executable binary.
  - *Defaults to the shell's own process if no PID is provided.*
- **`seek` (Search File/Folder)**: Recursively searches directories matching a search query. Flags supported:
  - `-f` (search files only)
  - `-d` (search directories only)
  - `-e` (runs/executes the match if exactly one match is found).

---

## 4. System Job Control
- **`activities`**: Lists all active background jobs spawned by the shell, displaying their PID, command name, and current state (Running or Stopped).
- **`ping <pid> <signal_number>`**: Sends a specified OS signal (like 9 for `SIGKILL`) to a background job by its PID.
- **`fg <pid>`**: Brings a stopped or running background process to the foreground, returning shell control to it.
- **`bg <pid>`**: Resumes a stopped background process, running it in the background.

---

## 5. Advanced Shell Capabilities
- **I/O Redirection**: Redirects standard streams using:
  - `<` (input redirection)
  - `>` (output redirection, overwrite)
  - `>>` (output redirection, append)
  - `2>` (error redirection)
- **Piping (`|`)**: Chains stdout of one command to the stdin of the next (e.g., `cat file.txt | grep "search"`). Piping can be used in combination with I/O redirection.
- **Signal Handling**:
  - `Ctrl + C`: Intercepts `SIGINT`. Interrupts the current foreground process without terminating the shell itself.
  - `Ctrl + Z`: Intercepts `SIGTSTP`. Suspends/stops the active foreground process and moves it to the background jobs list.
  - `Ctrl + D`: Intercepts EOF. Gracefully terminates all active background jobs and exits the shell.
- **`neonate [flags]`**: Periodically queries and outputs the PID of the most recently created system process (from `/proc/loadavg`) until stopped by keypress.
- **`iMan <command>`**: Uses TCP sockets to send an HTTP GET request to `man.he.net` and prints the manual page of a given command to the terminal.
