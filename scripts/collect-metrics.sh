#!/bin/bash
# Collect metrics for ha-mcp weekly review

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DATE=$(date +%Y-%m-%d)
OUTPUT_FILE="$ROOT_DIR/meetings/weekly/$DATE-metrics.md"

echo "# Metrics Collection - $DATE" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# GitHub Stats
echo "## GitHub Statistics" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Repository Stats" >> "$OUTPUT_FILE"
gh api repos/homeassistant-ai/ha-mcp --jq '{stars: .stargazers_count, forks: .forks_count, watchers: .subscribers_count, open_issues: .open_issues_count}' >> "$OUTPUT_FILE" 2>/dev/null || echo "Error fetching repo stats" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Recent Commits (Last 7 days)" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
gh api "repos/homeassistant-ai/ha-mcp/commits?since=$(date -d '7 days ago' +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -v-7d +%Y-%m-%dT%H:%M:%SZ)" --jq '.[].commit.message' 2>/dev/null | head -30 >> "$OUTPUT_FILE" || echo "Error fetching commits" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Open Issues" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
gh issue list -R homeassistant-ai/ha-mcp --state open --limit 20 --json number,title,labels --jq '.[] | "- #\(.number): \(.title)"' >> "$OUTPUT_FILE" 2>/dev/null || echo "Error fetching issues" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Recent Pull Requests" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
gh pr list -R homeassistant-ai/ha-mcp --state all --limit 10 --json number,title,state --jq '.[] | "- #\(.number) [\(.state)]: \(.title)"' >> "$OUTPUT_FILE" 2>/dev/null || echo "Error fetching PRs" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "### Recent Releases" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
gh release list -R homeassistant-ai/ha-mcp --limit 5 >> "$OUTPUT_FILE" 2>/dev/null || echo "Error fetching releases" >> "$OUTPUT_FILE"
echo '```' >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# PyPI Stats placeholder
echo "## PyPI Statistics" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "Check manually at: https://pepy.tech/project/ha-mcp" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Docker Stats placeholder
echo "## Docker Statistics" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "Image: ghcr.io/homeassistant-ai/ha-mcp" >> "$OUTPUT_FILE"
echo "Check GitHub Packages for pull counts." >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "Metrics saved to: $OUTPUT_FILE"
