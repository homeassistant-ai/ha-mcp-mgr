#!/bin/bash
# Run the full weekly review process using Claude Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DATE=$(date +%Y-%m-%d)

cd "$ROOT_DIR"

echo "=== HA-MCP Weekly Review ==="
echo "Date: $DATE"
echo ""

# Step 1: Update ha-mcp submodule
echo "Step 1: Updating ha-mcp submodule..."
cd ha-mcp
git fetch origin
git checkout origin/main 2>/dev/null || git checkout origin/master
HAMCP_COMMIT=$(git rev-parse --short HEAD)
cd ..
git add ha-mcp
echo "ha-mcp at commit: $HAMCP_COMMIT"
echo ""

# Step 2: Collect metrics
echo "Step 2: Collecting metrics..."
./scripts/collect-metrics.sh
echo ""

# Step 3: Run Claude Code with weekly review prompt
echo "Step 3: Running Claude Code weekly review..."
echo "This will run persona analyses and coordination meeting."
echo ""

# Run claude code with the weekly review command
claude -p "$(cat .claude/commands/weekly-review.md)"

echo ""
echo "=== Weekly Review Complete ==="
echo "ha-mcp analyzed at: $HAMCP_COMMIT"
