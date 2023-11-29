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
user=$(who | wc -l)
ipv4_address=$(hostname -I)
mac_address=$(ip link show | grep "ether" | awk '{print $2}')
sudo_nb=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
cpu_load=$(top -bn1 | grep '^Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')

echo -e	"Broadcast message from $user@$group ($terminal) ($date):\n"
echo -e "\t#Architecture: $kernel $architecture"
echo -e "\t#CPU Physical: $phys_proc"
echo -e "\t#vCPU: $virt_proc"
echo -e "\t#Memory Usage: $used_memory/$total_memory$mb ($percent_memory)"
echo -e "\t#Disk Usage: $used_storage/$total_storage ($percent_storage$percent)"
echo -e "\t#CPU load: $cpu_load"
echo -e "\t#Last boot: $last_boot"
echo -e "\t#LVM use: $lvm_status"
echo -e "\t#Connexions TCP: $tcp"
echo -e "\t#User log: $user"
echo -e "\t#Network: $ipv4_address ($mac_address)"
echo -e "\t#Sudo: $sudo_nb"
