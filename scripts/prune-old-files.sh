#!/bin/bash
# Prune old persona files to maintain manageable folder sizes
# Based on config.json memory_limits settings

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Default values (can be overridden by config.json)
REPORTS_KEEP_WEEKS=${REPORTS_KEEP_WEEKS:-12}
NOTES_KEEP_WEEKS=${NOTES_KEEP_WEEKS:-8}

REPORTS_DAYS=$((REPORTS_KEEP_WEEKS * 7))
NOTES_DAYS=$((NOTES_KEEP_WEEKS * 7))

echo "=== Pruning Old Persona Files ==="
echo "Keeping reports from last $REPORTS_KEEP_WEEKS weeks"
echo "Keeping notes from last $NOTES_KEEP_WEEKS weeks"
echo ""

cd "$ROOT_DIR"

# Prune old reports
echo "Pruning reports older than $REPORTS_DAYS days..."
find personas/*/reports/ -name "*.md" -type f -mtime +$REPORTS_DAYS 2>/dev/null | while read file; do
    echo "  Removing: $file"
    rm "$file"
done

# Prune old notes
echo "Pruning notes older than $NOTES_DAYS days..."
find personas/*/notes/ -name "*.md" -type f -mtime +$NOTES_DAYS 2>/dev/null | while read file; do
    echo "  Removing: $file"
    rm "$file"
done

# Prune old meeting metrics (keep 6 months)
echo "Pruning meeting files older than 180 days..."
find meetings/weekly/ -name "*.md" -type f -mtime +180 2>/dev/null | while read file; do
    echo "  Archiving: $file"
    mv "$file" meetings/archives/ 2>/dev/null || rm "$file"
done

# Clean up empty archive directories
find personas/*/archive/ -type d -empty -delete 2>/dev/null || true

echo ""
echo "=== Pruning Complete ==="
