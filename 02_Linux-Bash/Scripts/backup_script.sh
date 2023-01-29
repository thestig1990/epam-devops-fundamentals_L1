#!/bin/bash

# This script create a data backup and takes 2 parameters for input:
# $1 - Path to the syncing directory
# $2 - Path to the directory where the copies of the files will be stored

# This part of the script takes user input and displays the list of parameters for input
if [ -z "$1" ]
then
   echo "List of parameters for input:"
   echo "1st param. - Path to the syncing directory"
   echo "2nd param. - Path to the directory where the copies of the files will be stored"
   exit 1
fi

# Arguments Passed
SYNC_DIR="$1"
LOCAL_BACKUP="$2"

# Create a timestamp
TIMESTAMP=$(date +"%Y%m%d%H%M")

# Check if backup directory exists
if [ ! -d $LOCAL_BACKUP ]; then
  echo "Local backup directory does not exist, creating it now"
  mkdir -p $LOCAL_BACKUP
fi

# Create the folder for backup
BACKUP_FOLDER="$LOCAL_BACKUP/backup_$TIMESTAMP"
echo "Creating backup folder: $BACKUP_FOLDER"
mkdir -p $BACKUP_FOLDER
sleep 1

# Copy files and directories from the syncing directory to the backup folder
echo "Backing up data..."
rsync -rv $SYNC_DIR/* $BACKUP_FOLDER --log-file=backup_log.log
sleep 1
echo "Backup complete."

# Set the log file for monitoring the directory on cretion or deleting files
LOG_FILE="$SYNC_DIR/logfile.txt"

# Create log file if it doesn't exist
echo "Creating log file for monitoring the directory: $LOG_FILE"
if [ ! -f $LOG_FILE ]; then
    touch $LOG_FILE
fi

# Monitor the directory on cretion or deleting files
# and add a corresponding entry to the log file indicating
# the time, type of operation and file name
echo "Monitor the directory - $SYNC_DIR on cretion or deleting files"
inotifywait $SYNC_DIR -q -e create -e delete |
 while read path action file; do
  echo "$(date '+%Y%m%d %H:%M:%S') >> $action on ${file} >> $SYNC_DIR/${file}" >> $LOG_FILE
 done