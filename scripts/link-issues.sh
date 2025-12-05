#!/bin/bash
# Link backlog items to existing ha-mcp issues and create new ones if needed

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== Issue Linking Tool ==="
echo ""

# Search for matching issue in ha-mcp
search_issue() {
    local query="$1"
    gh issue list -R homeassistant-ai/ha-mcp --state all --search "$query" --json number,title,state --jq '.[] | "#\(.number) [\(.state)]: \(.title)"' | head -5
}

# Create issue in ha-mcp-mgr with assignment
create_mgr_issue() {
    local title="$1"
    local body="$2"
    local labels="$3"

    gh issue create -R homeassistant-ai/ha-mcp-mgr \
        --title "$title" \
        --body "$body" \
        --label "$labels" \
        --assignee "julienld"

    echo "Issue created and assigned to julienld (email notification sent)"
}

# Create issue in ha-mcp with assignment
create_hamcp_issue() {
    local title="$1"
    local body="$2"
    local labels="$3"

    gh issue create -R homeassistant-ai/ha-mcp \
        --title "$title" \
        --body "$body" \
        --label "$labels" \
        --assignee "julienld"

    echo "Issue created in ha-mcp and assigned to julienld"
}

# Show usage
if [ "$1" == "search" ] && [ -n "$2" ]; then
    echo "Searching ha-mcp issues for: $2"
    echo ""
    search_issue "$2"
elif [ "$1" == "create-mgr" ] && [ -n "$2" ]; then
    echo "Creating issue in ha-mcp-mgr..."
    create_mgr_issue "$2" "${3:-No description}" "${4:-backlog}"
elif [ "$1" == "create-hamcp" ] && [ -n "$2" ]; then
    echo "Creating issue in ha-mcp..."
    create_hamcp_issue "$2" "${3:-No description}" "${4:-enhancement}"
else
    echo "Usage:"
    echo "  $0 search <query>              - Search existing ha-mcp issues"
    echo "  $0 create-mgr <title> [body] [labels]   - Create issue in ha-mcp-mgr"
    echo "  $0 create-hamcp <title> [body] [labels] - Create issue in ha-mcp"
    echo ""
    echo "Examples:"
    echo "  $0 search 'authentication'"
    echo "  $0 create-mgr '[Persona Need] Test environment access' 'Requested by: sre'"
    echo "  $0 create-hamcp '[Feature] Add entity history tool' 'From backlog review'"
fi
