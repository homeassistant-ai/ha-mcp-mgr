#!/bin/bash
# Run a single persona review

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

if [ -z "$1" ]; then
    echo "Usage: $0 <persona-name>"
    echo ""
    echo "Available personas:"
    ls -1 "$ROOT_DIR/personas/"
    exit 1
fi

PERSONA="$1"

if [ ! -d "$ROOT_DIR/personas/$PERSONA" ]; then
    echo "Error: Persona '$PERSONA' not found."
    echo ""
    echo "Available personas:"
    ls -1 "$ROOT_DIR/personas/"
    exit 1
fi

cd "$ROOT_DIR"

echo "=== Running $PERSONA Review ==="
echo "Date: $(date +%Y-%m-%d)"
echo ""

# Build the prompt
PROMPT="You are the $PERSONA persona for ha-mcp management.

Read your instructions from: personas/$PERSONA/CLAUDE.md
Read your current beliefs from: personas/$PERSONA/beliefs.md

Analyze the ha-mcp project:
- Review code in ha-mcp/ directory
- Check recent commits and issues using gh CLI
- Focus on your domain-specific concerns

Generate your weekly report following your report format.
Save to: personas/$PERSONA/reports/$(date +%Y-%m-%d).md

Update your beliefs.md with new observations.

Return a summary of your findings and proposed backlog items."

claude -p "$PROMPT"

echo ""
echo "=== $PERSONA Review Complete ==="
