#!/bin/bash
# Bootstrap script for the first meeting
# Runs comprehensive analysis to populate all persona beliefs with real data

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
DATE=$(date +%Y-%m-%d)

cd "$ROOT_DIR"

echo "=============================================="
echo "  HA-MCP Management System - First Meeting"
echo "=============================================="
echo ""
echo "Date: $DATE"
echo ""
echo "This bootstrap will:"
echo "  1. Update ha-mcp submodule"
echo "  2. Collect comprehensive baseline metrics"
echo "  3. Generate initial dashboard"
echo "  4. Run all persona analyses (first time)"
echo "  5. Run coordination meeting"
echo "  6. Establish baseline context"
echo "  7. Commit and push"
echo ""
echo "Press Enter to continue or Ctrl+C to cancel..."
read

# Step 1: Update submodule
echo ""
echo "=== Step 1/7: Updating ha-mcp submodule ==="
cd ha-mcp
git fetch origin
git checkout origin/main 2>/dev/null || git checkout origin/master
HAMCP_COMMIT=$(git rev-parse --short HEAD)
HAMCP_VERSION=$(grep 'version' pyproject.toml | head -1 | cut -d'"' -f2)
cd ..
git add ha-mcp
echo "ha-mcp at commit: $HAMCP_COMMIT (version $HAMCP_VERSION)"

# Step 2: Collect baseline metrics
echo ""
echo "=== Step 2/7: Collecting baseline metrics ==="
./scripts/collect-metrics.sh

# Step 3: Generate dashboard
echo ""
echo "=== Step 3/7: Generating dashboard ==="
./scripts/generate-dashboard.sh

# Step 4 & 5: Run Claude Code for full first meeting
echo ""
echo "=== Step 4-5/7: Running persona analyses and coordination ==="
echo ""
echo "Launching Claude Code with first-meeting instructions..."
echo ""

claude -p "You are running the FIRST MEETING of the ha-mcp management system.

This is a bootstrap meeting to establish baselines for all personas.

## Pre-Context

ha-mcp is at version $HAMCP_VERSION (commit $HAMCP_COMMIT).

The UAT test environment is available at:
- URL: https://ha-mcp-uat-server.qc-h.net
- Token: demo

## Phase 1: Comprehensive Analysis

Run ALL 10 personas in parallel (using Task tool):

For each persona, instruct them to:
1. Read their CLAUDE.md instructions thoroughly
2. Analyze ha-mcp comprehensively (this is their first look)
3. Use the MCP server to test actual functionality
4. Establish baseline observations in beliefs.md
5. Create initial deliverables as appropriate
6. Generate their first report

Personas to analyze:
- tech-lead: Full code quality audit
- product-owner: Feature inventory and roadmap
- ux-designer: Tool usability baseline
- home-user (simple-user folder): Workflow testing
- advanced-user: API coverage assessment
- sre: Reliability and performance baseline
- marketing-comm: Current metrics baseline
- security-analyst: Security posture review
- community-manager: Issue/community health
- retrospective: Process baseline

## Phase 2: First Coordination Meeting

As Julz:
1. Review all first reports
2. Establish baseline priorities
3. Create initial backlog based on findings
4. Update meetings/context.md with baseline context
5. Note any immediate issues or quick wins

## Phase 3: Establish Context

Update meetings/context.md with:
- Current ha-mcp version and state
- Key baseline metrics
- Initial strategic direction
- Immediate focus areas

## Phase 4: Commit and Push

After all updates:
\`\`\`bash
git add -A
git commit -m \"docs: first meeting bootstrap - $DATE

Established baseline for all 10 personas.
ha-mcp analyzed at: $HAMCP_COMMIT (v$HAMCP_VERSION)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>\"

git push origin master
\`\`\`

## Output

Provide comprehensive summary of:
- ha-mcp current state
- Key findings from each persona
- Initial backlog priorities
- Baseline metrics established
- Next steps for regular weekly meetings"

echo ""
echo "=== First Meeting Complete ==="
echo ""
echo "The management system is now bootstrapped."
echo "Future meetings can use: ./scripts/run-weekly-review.sh"
