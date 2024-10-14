
#!/bin/bash

# Variables
SOURCE_DIR="/path/to/source/directory"
DESTINATION_DIR="/path/to/destination/directory"
LOG_FILE="/path/to/logfile.log"

# Remote server info (if applicable)
REMOTE_USER="username"
REMOTE_SERVER="remote.server.com"
REMOTE_PATH="/path/on/remote/server"

# Backup function
backup_directory() {
    TIMESTAMP=$(date +"%Y%m%d%H%M%S")
    BACKUP_FILE="backup_$TIMESTAMP.tar.gz"

    # Create backup archive
    tar -czf "$DESTINATION_DIR/$BACKUP_FILE" -C "$SOURCE_DIR" .

    # Check if backup was successful
    if [ $? -eq 0 ]; then
        echo "Backup successful: $BACKUP_FILE" | tee -a $LOG_FILE
    else
        echo "Backup failed" | tee -a $LOG_FILE
        exit 1
    fi

    # Optionally copy to a remote server
    if [ "$REMOTE_SERVER" != "" ]; then
        scp "$DESTINATION_DIR/$BACKUP_FILE" "$REMOTE_USER@$REMOTE_SERVER:$REMOTE_PATH"
        if [ $? -eq 0 ]; then
            echo "Backup copied to remote server successfully" | tee -a $LOG_FILE
        else
            echo "Failed to copy backup to remote server" | tee -a $LOG_FILE
        fi
    fi
}

# Run the backup function
backup_directory
