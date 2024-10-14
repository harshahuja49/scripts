
#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

# Function to check CPU usage
check_cpu() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
        echo "Alert: CPU usage is at ${CPU_USAGE}%"
    fi
}

# Function to check Memory usage
check_memory() {
    MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
        echo "Alert: Memory usage is at ${MEM_USAGE}%"
    fi
}

# Function to check Disk usage
check_disk() {
    DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
    if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
        echo "Alert: Disk usage is at ${DISK_USAGE}%"
    fi
}

# Function to check running processes
check_processes() {
    RUNNING_PROCESSES=$(ps -ef | wc -l)
    echo "Running processes: $RUNNING_PROCESSES"
}

# Run checks
check_cpu
check_memory
check_disk
check_processes
