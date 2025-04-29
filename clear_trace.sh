#!/bin/bash

# Script: Full System Trace Cleaner (Root-Aware)
# Description: Clears bash history, caches, system logs, kernel logs, and rotates journal.

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "🔒 This script needs root privileges. Trying with sudo..."
  sudo bash "$0" "$@"
  exit
fi

echo "🚀 Starting full system cleanup as root..."

# Clear bash history for root user
history -c
history -w
unset HISTFILE


# Clear cache
rm -rf /root/.cache/* 2>/dev/null
rm -rf ~/.cache/* 2>/dev/null

# Clear recently used files
rm -f ~/.local/share/recently-used.xbel 2>/dev/null
rm -f /root/.local/share/recently-used.xbel 2>/dev/null

# Clear dmesg logs
dmesg -C

# Rotate and vacuum journal logs
journalctl --rotate
journalctl --vacuum-time=1s

# Truncate important log files
truncate -s 0 /var/log/syslog
truncate -s 0 /var/log/auth.log
truncate -s 0 /var/log/kern.log
truncate -s 0 /var/log/dmesg
truncate -s 0 /var/log/boot.log
truncate -s 0 /var/log/messages
truncate -s 0 /var/log/apt/history.log

# Truncate rotated and archived logs
truncate -s 0 /var/log/syslog.1
truncate -s 0 /var/log/auth.log.*

# Extra cleanup for any hidden rotated logs
find /var/log -name "*.gz" -type f -delete
find /var/log -name "*.1" -type f -delete
find /var/log -name "*.old" -type f -delete

# Final bash history clear (safe redundancy)
history -c
history -w

echo "🧹 Cleanup done. A system restart is recommended for complete kernel memory wipe."

# Verification step
echo "🔍 Verifying cleanup..."
if ([ ! -s ~/.bash_history ] && [ ! "$(ls -A ~/.cache/)" ] && ! dmesg | grep -q '.' && ! grep -q '.' /var/log/syslog); then
    echo "✅ No traces found."
else
    echo "⚠️  Some traces might still exist! (Check manually)"
fi

echo "✅ Script completed."



# # Step 1: Clear in-memory history
# history -c

# # Step 2: Overwrite the .bash_history file
# > ~/.bash_history

# # Step 3: (Optional but recommended) Force save empty history to file
# history -w


# echo "ls -la" >> ~/.bash_history
# echo "cd /home/omkar" >> ~/.bash_history
# echo "pwd" >> ~/.bash_history
# echo "cat ~/.bash_history" >> ~/.bash_history
# echo "echo 'Hello, World!'" >> ~/.bash_history
# echo "mkdir test_directory" >> ~/.bash_history
# echo "touch test_file.txt" >> ~/.bash_history
# echo "echo 'Sample data' > test_file.txt" >> ~/.bash_history
# echo "cat test_file.txt" >> ~/.bash_history
# echo "ls test_directory" >> ~/.bash_history
# echo "rm -rf test_directory" >> ~/.bash_history
# echo "rm -f test_file.txt" >> ~/.bash_history
# echo "cp /etc/passwd /tmp" >> ~/.bash_history
# echo "mv /tmp/passwd /tmp/passwd.bak" >> ~/.bash_history
# echo "echo 'This is a test file' > /tmp/test_file" >> ~/.bash_history
# echo "cat /tmp/test_file" >> ~/.bash_history
# echo "find /home -name '*.txt'" >> ~/.bash_history
# echo "grep 'bash' ~/.bash_history" >> ~/.bash_history
# echo "history" >> ~/.bash_history
# echo "sudo apt-get update" >> ~/.bash_history
# echo "sudo apt-get install vim" >> ~/.bash_history
# echo "sudo apt-get remove vim" >> ~/.bash_history
# echo "top" >> ~/.bash_history
# echo "ps aux" >> ~/.bash_history
# echo "df -h" >> ~/.bash_history
# echo "free -m" >> ~/.bash_history
# echo "whoami" >> ~/.bash_history
# echo "hostname" >> ~/.bash_history
# echo "date" >> ~/.bash_history
# echo "uptime" >> ~/.bash_history
# echo "echo $SHELL" >> ~/.bash_history
# echo "lsblk" >> ~/.bash_history
# echo "sudo systemctl restart apache2" >> ~/.bash_history
# echo "sudo systemctl stop apache2" >> ~/.bash_history
# echo "sudo systemctl start apache2" >> ~/.bash_history
# echo "dmesg" >> ~/.bash_history
# echo "journalctl" >> ~/.bash_history
# echo "shutdown now" >> ~/.bash_history

# # GCC commands for compiling C code
# echo "gcc -o my_program my_program.c" >> ~/.bash_history
# echo "gcc -Wall my_program.c -o my_program" >> ~/.bash_history
# echo "gcc my_program.c -o my_program -lm" >> ~/.bash_history
# echo "gcc my_program.c -o my_program -g" >> ~/.bash_history
# echo "./my_program" >> ~/.bash_history

# # G++ commands for compiling C++ code
# echo "g++ -o my_program my_program.cpp" >> ~/.bash_history
# echo "g++ -Wall my_program.cpp -o my_program" >> ~/.bash_history
# echo "g++ my_program.cpp -o my_program -std=c++11" >> ~/.bash_history
# echo "g++ my_program.cpp -o my_program -g" >> ~/.bash_history
# echo "./my_program" >> ~/.bash_history

# # Python commands
# echo "python3 my_script.py" >> ~/.bash_history
# echo "python3 -m venv myenv" >> ~/.bash_history
# echo "source myenv/bin/activate" >> ~/.bash_history
# echo "pip install requests" >> ~/.bash_history
# echo "python3 -m http.server" >> ~/.bash_history

# # CMSDS (assuming it's a command-line tool, replace with your specific tool usage)
# echo "cmsds run --input data.csv --output results.json" >> ~/.bash_history
# echo "cmsds analyze --file analysis.csv" >> ~/.bash_history
# echo "cmsds process --data input_data.txt" >> ~/.bash_history

# # Shell Scripting Commands (sh)
# echo "echo 'Shell Script Started'" >> ~/.bash_history
# echo "sh my_script.sh" >> ~/.bash_history
# echo "chmod +x my_script.sh" >> ~/.bash_history
# echo "./my_script.sh" >> ~/.bash_history
# echo "cat my_script.sh" >> ~/.bash_history
# echo "echo 'Running a shell script'" >> ~/.bash_history
# echo "echo 'This is a test' >> my_script.sh" >> ~/.bash_history
# echo "sh -c 'echo Hello from sub-shell'" >> ~/.bash_history
# echo "sh -x my_script.sh" >> ~/.bash_history
# echo "sh -c 'ls -la'" >> ~/.bash_history
