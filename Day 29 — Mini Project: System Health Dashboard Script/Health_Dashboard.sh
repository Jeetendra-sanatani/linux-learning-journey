#!/bin/bash
# health_dashboard.sh — System Health Dashboard
# Day 29 mini project — Linux Learning Journey

divider() { printf '=%.0s' {1..50}; echo; }

system_info() {
    echo "SYSTEM INFORMATION"
    divider
    echo "Hostname: $(hostname)"
    echo "Kernel:   $(uname -r)"
    echo "Uptime:   $(uptime -p)"
}

memory_check() {
    echo "MEMORY USAGE"
    divider
    free -h
}

disk_check() {
    echo "DISK USAGE"
    divider
    df -h / /home 2>/dev/null
}

top_processes() {
    echo "TOP 5 PROCESSES BY MEMORY"
    divider
    ps aux --sort=-%mem | head -6
}

network_info() {
    echo "NETWORK INFO"
    divider
    hostname -I
    echo "Listening ports:"
    ss -tuln | grep LISTEN
}

security_check() {
    echo "SECURITY CHECK"
    divider

    echo "Failed login attempts:"
    sudo journalctl --no-pager | grep -Ei 'failed password|authentication failure' | wc -l

    echo ""
    echo "SUID files:"
    sudo find / -type f -perm -4000 2>/dev/null | wc -l

    echo ""
    echo "Firewall status:"
    sudo ufw status | head -1
}

main() {
    echo "SYSTEM HEALTH DASHBOARD — $(date)"
    divider

    system_info
    echo ""

    memory_check
    echo ""

    disk_check
    echo ""

    top_processes
    echo ""

    network_info
    echo ""

    security_check
}

main
