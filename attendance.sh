#!/bin/bash

# Database and backup paths
DB_PATH="/home/iccsadmin/ishita/Manual_Attendance/db.sqlite3"
BACKUP_DIR="/home/iccsadmin/Backup_Portal/media/Attendance"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# File names (always overwrite)
DAILY_SUMMARY_CSV="${BACKUP_DIR}/daily_summary.csv"
UPLOADED_FILES_CSV="${BACKUP_DIR}/uploaded_files.csv"
USERS_CSV="${BACKUP_DIR}/users.csv"
TEMP_UPLOADED_CSV="${BACKUP_DIR}/uploaded_files_temp.csv"

echo "------------------------------------------"
echo "Starting SQLite export at $(date +"%Y-%m-%d %H:%M:%S")"
echo "Database: $DB_PATH"
echo "Backup directory: $BACKUP_DIR"
echo

# Export users_dailysummary → daily_summary.csv
echo "Exporting table: users_dailysummary → $DAILY_SUMMARY_CSV"
sqlite3 -header -csv "$DB_PATH" "SELECT * FROM users_dailysummary;" > "$DAILY_SUMMARY_CSV"

# Export users → users.csv
echo "Exporting table: users → $USERS_CSV"
sqlite3 -header -csv "$DB_PATH" "SELECT * FROM users_user;" > "$USERS_CSV"

# Export users_uploadedfile → temporary uploaded_files.csv
echo "Exporting table: users_uploadedfile → $UPLOADED_FILES_CSV"
sqlite3 -header -csv "$DB_PATH" "SELECT * FROM users_uploadedfile;" > "$TEMP_UPLOADED_CSV"

# Add "Approved By" column extracted from file path
echo "Adding 'Approved By' column to uploaded_files.csv"

awk -F',' 'BEGIN {
    OFS=","
}
NR==1 {
    # Add new header
    print $0, "Approved By"
    next
}
{
    approved = ""
    # Find the filename starting with uploads/
    if (match($0, /uploads\/[^,]+/)) {
        fn = substr($0, RSTART, RLENGTH)
        n = split(fn, parts, "_")
        lastpart = parts[n]
        gsub(/\.csv|\.xlsx|\.xls/, "", lastpart)
        if (lastpart ~ /^ATS/) {
            approved = lastpart
        }
    }
    print $0, approved
}' "$TEMP_UPLOADED_CSV" > "$UPLOADED_FILES_CSV"

# Remove temporary file
rm -f "$TEMP_UPLOADED_CSV"

echo
echo "✅ Export completed successfully at $(date +"%Y-%m-%d %H:%M:%S")"
echo "------------------------------------------"
