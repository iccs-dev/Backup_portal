#!/bin/bash

# Database and backup paths
DB_PATH="/home/iccsadmin/ishita/APR_Uploads/db.sqlite3"
BACKUP_DIR="/home/iccsadmin/Backup_Portal/media/APR"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# File names (always overwrite)
UPLOADED_FILES_CSV="${BACKUP_DIR}/uploaded_apr.csv"

echo "------------------------------------------"
echo "Starting SQLite export at $(date +"%Y-%m-%d %H:%M:%S")"
echo "Database: $DB_PATH"
echo "Backup directory: $BACKUP_DIR"
echo

# Export users_uploadedfile → uploaded_files.csv
echo "Exporting table: users_uploadedfile → $UPLOADED_FILES_CSV"
sqlite3 -header -csv "$DB_PATH" "SELECT * FROM uploader_uploadedfile;" > "$UPLOADED_FILES_CSV"

echo
echo "✅ Export completed successfully at $(date +"%Y-%m-%d %H:%M:%S")"
echo "------------------------------------------"
