#!/bin/bash
# Generate metrics dashboard for GitHub Pages

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DASHBOARD_DIR="$ROOT_DIR/docs/dashboard"
DATE=$(date +%Y-%m-%d)

echo "=== Generating Metrics Dashboard ==="

mkdir -p "$DASHBOARD_DIR"

# Collect current metrics
echo "Collecting metrics..."

# GitHub stats
STARS=$(gh api repos/homeassistant-ai/ha-mcp --jq '.stargazers_count' 2>/dev/null || echo "N/A")
FORKS=$(gh api repos/homeassistant-ai/ha-mcp --jq '.forks_count' 2>/dev/null || echo "N/A")
OPEN_ISSUES=$(gh api repos/homeassistant-ai/ha-mcp --jq '.open_issues_count' 2>/dev/null || echo "N/A")
LATEST_RELEASE=$(gh release view -R homeassistant-ai/ha-mcp --json tagName --jq '.tagName' 2>/dev/null || echo "N/A")

# Recent activity
COMMITS_WEEK=$(gh api "repos/homeassistant-ai/ha-mcp/commits?since=$(date -d '7 days ago' +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -v-7d +%Y-%m-%dT%H:%M:%SZ)" --jq 'length' 2>/dev/null || echo "N/A")
PRS_MERGED_WEEK=$(gh pr list -R homeassistant-ai/ha-mcp --state merged --json mergedAt --jq "[.[] | select(.mergedAt > \"$(date -d '7 days ago' +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -v-7d +%Y-%m-%dT%H:%M:%SZ)\")] | length" 2>/dev/null || echo "N/A")

# Backlog stats
BACKLOG_P0=$(grep -c "^\#\# \[P0\]" "$ROOT_DIR/backlog/current.md" 2>/dev/null || echo "0")
BACKLOG_P1=$(grep -c "^\#\# \[P1\]" "$ROOT_DIR/backlog/current.md" 2>/dev/null || echo "0")
BACKLOG_P2=$(grep -c "^\#\# \[P2\]" "$ROOT_DIR/backlog/current.md" 2>/dev/null || echo "0")
BACKLOG_P3=$(grep -c "^\#\# \[P3\]" "$ROOT_DIR/backlog/current.md" 2>/dev/null || echo "0")

# Generate index.html
cat > "$DASHBOARD_DIR/index.html" << 'HEADER'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HA-MCP Dashboard</title>
    <style>
        :root {
            --bg-color: #0d1117;
            --card-bg: #161b22;
            --text-color: #c9d1d9;
            --accent-color: #58a6ff;
            --success-color: #3fb950;
            --warning-color: #d29922;
            --danger-color: #f85149;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 20px;
        }
        .container { max-width: 1200px; margin: 0 auto; }
        h1 { color: var(--accent-color); border-bottom: 1px solid #30363d; padding-bottom: 10px; }
        h2 { color: var(--text-color); margin-top: 30px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
        .card {
            background: var(--card-bg);
            border-radius: 8px;
            padding: 20px;
            border: 1px solid #30363d;
        }
        .card h3 { margin: 0 0 10px 0; color: #8b949e; font-size: 14px; text-transform: uppercase; }
        .card .value { font-size: 36px; font-weight: bold; color: var(--accent-color); }
        .card.success .value { color: var(--success-color); }
        .card.warning .value { color: var(--warning-color); }
        .card.danger .value { color: var(--danger-color); }
        .backlog-bar { display: flex; height: 20px; border-radius: 4px; overflow: hidden; margin: 10px 0; }
        .backlog-bar .p0 { background: var(--danger-color); }
        .backlog-bar .p1 { background: var(--warning-color); }
        .backlog-bar .p2 { background: var(--accent-color); }
        .backlog-bar .p3 { background: #8b949e; }
        .legend { display: flex; gap: 15px; flex-wrap: wrap; }
        .legend span { display: flex; align-items: center; gap: 5px; }
        .legend .dot { width: 12px; height: 12px; border-radius: 50%; }
        .updated { text-align: center; color: #8b949e; margin-top: 40px; font-size: 14px; }
        a { color: var(--accent-color); }
    </style>
</head>
<body>
    <div class="container">
        <h1>HA-MCP Dashboard</h1>
        <p>Management metrics for <a href="https://github.com/homeassistant-ai/ha-mcp">ha-mcp</a></p>

        <h2>Repository Health</h2>
        <div class="grid">
HEADER

cat >> "$DASHBOARD_DIR/index.html" << EOF
            <div class="card success">
                <h3>GitHub Stars</h3>
                <div class="value">$STARS</div>
            </div>
            <div class="card">
                <h3>Forks</h3>
                <div class="value">$FORKS</div>
            </div>
            <div class="card">
                <h3>Open Issues</h3>
                <div class="value">$OPEN_ISSUES</div>
            </div>
            <div class="card success">
                <h3>Latest Release</h3>
                <div class="value">$LATEST_RELEASE</div>
            </div>
        </div>

        <h2>Weekly Activity</h2>
        <div class="grid">
            <div class="card">
                <h3>Commits (7d)</h3>
                <div class="value">$COMMITS_WEEK</div>
            </div>
            <div class="card">
                <h3>PRs Merged (7d)</h3>
                <div class="value">$PRS_MERGED_WEEK</div>
            </div>
        </div>

        <h2>Management Backlog</h2>
        <div class="card">
            <h3>Items by Priority</h3>
            <div class="backlog-bar">
                <div class="p0" style="flex: $BACKLOG_P0;"></div>
                <div class="p1" style="flex: $BACKLOG_P1;"></div>
                <div class="p2" style="flex: $BACKLOG_P2;"></div>
                <div class="p3" style="flex: $BACKLOG_P3;"></div>
            </div>
            <div class="legend">
                <span><div class="dot" style="background: var(--danger-color);"></div> P0: $BACKLOG_P0</span>
                <span><div class="dot" style="background: var(--warning-color);"></div> P1: $BACKLOG_P1</span>
                <span><div class="dot" style="background: var(--accent-color);"></div> P2: $BACKLOG_P2</span>
                <span><div class="dot" style="background: #8b949e;"></div> P3: $BACKLOG_P3</span>
            </div>
        </div>

        <h2>Links</h2>
        <div class="grid">
            <div class="card">
                <h3>PyPI Stats</h3>
                <a href="https://pepy.tech/project/ha-mcp" target="_blank">View Downloads →</a>
            </div>
            <div class="card">
                <h3>Docker Image</h3>
                <a href="https://github.com/homeassistant-ai/ha-mcp/pkgs/container/ha-mcp" target="_blank">View Packages →</a>
            </div>
            <div class="card">
                <h3>Current Backlog</h3>
                <a href="https://github.com/homeassistant-ai/ha-mcp-mgr/blob/master/backlog/current.md" target="_blank">View Backlog →</a>
            </div>
        </div>

        <p class="updated">Last updated: $DATE</p>
    </div>
</body>
</html>
EOF

# Append metrics to history file
HISTORY_FILE="$DASHBOARD_DIR/metrics-history.csv"
if [ ! -f "$HISTORY_FILE" ]; then
    echo "date,stars,forks,open_issues,commits_week,prs_merged_week,backlog_total" > "$HISTORY_FILE"
fi

BACKLOG_TOTAL=$((BACKLOG_P0 + BACKLOG_P1 + BACKLOG_P2 + BACKLOG_P3))
echo "$DATE,$STARS,$FORKS,$OPEN_ISSUES,$COMMITS_WEEK,$PRS_MERGED_WEEK,$BACKLOG_TOTAL" >> "$HISTORY_FILE"

echo ""
echo "Dashboard generated at: $DASHBOARD_DIR/index.html"
echo "Metrics appended to: $HISTORY_FILE"
echo ""
echo "=== Dashboard Generation Complete ==="
