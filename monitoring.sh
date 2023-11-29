#!/bin/bash

# Récupérer les informations système
ARCHITECTURE=$(uname -a)
CPU_PHYSICAL=$(lscpu | grep "Socket(s)" | awk '{print $2}')
VCPU=$(lscpu | grep "CPU(s)" | awk '{print $2}')
MEMORY_USAGE=$(free -m | awk '/Mem:/ {printf "%s/%sMB (%.2f%%)\n", $3, $2, $3/$2*100}')
DISK_USAGE=$(df -h | awk '$NF=="/" {printf "%s/%s (%s)\n", $3, $2, $5}')
CPU_LOAD=$(uptime | awk -F 'average: ' '{print $2}' | cut -d, -f1)
LAST_BOOT=$(who -b | awk '{print $3, $4}')
LVM_USE=$(lvscan | grep ACTIVE | wc -l)
TCP_CONNECTIONS=$(netstat -t | grep ESTABLISHED | wc -l)
USER_LOGGED_IN=$(who | wc -l)
IP_ADDRESS=$(hostname -I | awk '{print $1}')
MAC_ADDRESS=$(ip link show | awk '/ether/ {print $2}')
SUDO_CMD_COUNT=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

# Générer le message de diffusion
BROADCAST_MESSAGE="Broadcast message from root@$(hostname) (tty$(tty | cut -d/ -f3)) ($(date '+%a %b %d %T %Y')):\n"
BROADCAST_MESSAGE+="#Architecture: $ARCHITECTURE\n"
BROADCAST_MESSAGE+="#CPU physical: $CPU_PHYSICAL\n"
BROADCAST_MESSAGE+="#vCPU: $VCPU\n"
BROADCAST_MESSAGE+="#Memory Usage: $MEMORY_USAGE\n"
BROADCAST_MESSAGE+="#Disk Usage: $DISK_USAGE\n"
BROADCAST_MESSAGE+="#CPU load: $CPU_LOAD\n"
BROADCAST_MESSAGE+="#Last boot: $LAST_BOOT\n"
BROADCAST_MESSAGE+="#LVM use: $( [ "$LVM_USE" -gt 0 ] && echo "yes" || echo "no" )\n"
BROADCAST_MESSAGE+="#Connexions TCP: $TCP_CONNECTIONS ESTABLISHED\n"
BROADCAST_MESSAGE+="#User log: $USER_LOGGED_IN\n"
BROADCAST_MESSAGE+="#Network: IP $IP_ADDRESS ($MAC_ADDRESS)\n"
BROADCAST_MESSAGE+="#Sudo: $SUDO_CMD_COUNT cmd"

# Diffuser le message
echo -e "$BROADCAST_MESSAGE" | wall
