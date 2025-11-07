#!/bin/bash

# Paths
DB_PATH="/home/iccsadmin/ishita/Manual_Attendance/db.sqlite3"
BACKUP_DIR="/home/iccsadmin/Backup_Portal/xyz"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Get current timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "Starting SQLite database export at $TIMESTAMP"
echo "Database: $DB_PATH"
echo "Backup folder: $BACKUP_DIR"
echo

# List all tables
TABLES=$(sqlite3 "$DB_PATH" ".tables")

# Export each table to CSV
for TABLE in $TABLES; do
    CSV_FILE="${BACKUP_DIR}/${TABLE}_${TIMESTAMP}.csv"
    echo "Exporting table: $TABLE → $CSV_FILE"
    sqlite3 -header -csv "$DB_PATH" "SELECT * FROM \"$TABLE\";" > "$CSV_FILE"
done

echo
echo "Backup completed successfully at $(date +"%Y-%m-%d %H:%M:%S")"

