#!/bin/bash

user=$(whoami)
group=$(id -gn)
date=$(date '+%a %b %d %T %Y')
terminal=$(tty | cut -d/ -f3)

architecture=$(uname -a)
kernel=$(uname -r)

phys_proc=$(lscpu | grep 'Socket(s):' | awk '{print $2}')
virt_proc=$(lscpu | awk '/^CPU\(s\)/ {print $2}')
total_memory=$(free -m | awk '/Mem:/ {print $2}')
used_memory=$(free -m| awk '/Mem:/ {print $3}')
percent_memory=$(free -m | awk '/Mem:/ {printf "%.2f%%", $3/$2*100}')
mb="MB"
total_storage=$(df -h --output=size / | awk 'NR==2 {print $1}')
used_storage=$(df -h --output=used / | awk 'NR==2 {print $1}')
percent_storage=$(df -h --output=pcent / | awk 'NR==2 {print $1}' | tr -d '%')
percent="%"
last_boot=$(uptime -s)
lvm_status=$(sudo lvs > /dev/null 2>&1 && echo "yes" || echo "no")
tcp=$(journalctl _TRANSPORT=kernel | grep -c '')
user_count=$(who | wc -l)
ipv4_address=$(hostname -I)
mac_address=$(ip link show | grep "ether" | awk '{print $2}')
sudo_nb=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
cpu_load=$(top -bn1 | grep '^Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')

# Store each line in a separate variable
line1="Broadcast message from $user@$group ($terminal) ($date):"
line2="#Architecture: $kernel $architecture"
line3="#CPU Physical: $phys_proc"
line4="#vCPU: $virt_proc"
line5="#Memory Usage: $used_memory/$total_memory$mb ($percent_memory)"
line6="#Disk Usage: $used_storage/$total_storage ($percent_storage$percent)"
line7="#CPU load: $cpu_load"
line8="#Last boot: $last_boot"
line9="#LVM use: $lvm_status"
line10="#Connexions TCP: $tcp"
line11="#User log: $user_count"
line12="#Network: $ipv4_address ($mac_address)"
line13="#Sudo: $sudo_nb"

message="$line1\n$line2\n$line3\n$line4\n$line5\n$line6\n$line7\n$line8\n$line9\n$line10\n$line11\n$line12\n$line13"

# Use wall to broadcast the message
echo -e "$message" | wall
