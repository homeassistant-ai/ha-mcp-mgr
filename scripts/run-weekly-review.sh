#!/bin/bash
# Run the full weekly review process using Claude Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$ROOT_DIR"

echo "=== HA-MCP Weekly Review ==="
echo "Date: $(date +%Y-%m-%d)"
echo ""

# Step 1: Update ha-mcp submodule
echo "Step 1: Updating ha-mcp submodule..."
if [ -d "ha-mcp/.git" ]; then
    cd ha-mcp && git pull origin main 2>/dev/null || git pull origin master 2>/dev/null || echo "Submodule update skipped"
    cd ..
else
    echo "Note: ha-mcp directory exists but is not a submodule. Using as-is."
fi

# Step 2: Collect metrics
echo ""
echo "Step 2: Collecting metrics..."
./scripts/collect-metrics.sh

# Step 3: Run Claude Code with weekly review prompt
echo ""
echo "Step 3: Running Claude Code weekly review..."
echo "This will run persona analyses and coordination meeting."
echo ""

# Run claude code with the weekly review command
claude -p "$(cat .claude/commands/weekly-review.md)"

echo ""
echo "=== Weekly Review Complete ==="
