#!/bin/bash

# Database and backup paths
DB_PATH="/home/iccsadmin/ishita/Meta_Uploads/db.sqlite3"
BACKUP_DIR="/home/iccsadmin/Backup_Portal/media/Meta_Uploads"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# File names (always overwrite)
UPLOADED_FILES_CSV="${BACKUP_DIR}/meta_uploaded_files.csv"
USERS_CSV="${BACKUP_DIR}/meta_users.csv"

echo "------------------------------------------"
echo "Starting SQLite export at $(date +"%Y-%m-%d %H:%M:%S")"
echo "Database: $DB_PATH"
echo "Backup directory: $BACKUP_DIR"
echo

# Export users → users.csv
echo "Exporting table: auth_user → $USERS_CSV"
sqlite3 -header -csv "$DB_PATH" "SELECT * FROM auth_user;" > "$USERS_CSV"

# Export uploader_uploadstatus → temporary uploaded_files.csv
echo "Exporting table: uploader_uploadstatus → $UPLOADED_FILES_CSV"
sqlite3 -header -csv "$DB_PATH" "SELECT * FROM uploader_uploadstatus;" > "$UPLOADED_FILES_CSV"

echo
echo "✅ Export completed successfully at $(date +"%Y-%m-%d %H:%M:%S")"
echo "------------------------------------------"
