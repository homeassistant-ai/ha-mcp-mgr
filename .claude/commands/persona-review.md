# Single Persona Review Command

Run a review as a specific persona.

## Usage

This command expects a `--persona` argument specifying which persona to run.

Example: `claude -p "$(cat .claude/commands/persona-review.md)" -- --persona tech-lead`

## Instructions

### Setup

1. Identify the persona from the argument (default to listing available if not specified)
2. Read the persona's `CLAUDE.md` from `personas/[persona]/CLAUDE.md`
3. Read their current `beliefs.md`
4. Read any previous reports for context

### Data Gathering

1. **Code Analysis** (for technical personas):
   - Review recent commits in ha-mcp/
   - Check for new files or significant changes
   - Look for patterns relevant to the persona's focus

2. **Issue Analysis**:
   ```bash
   gh issue list -R homeassistant-ai/ha-mcp --state all --limit 30 --json number,title,state,labels,createdAt
   ```

3. **PR Analysis**:
   ```bash
   gh pr list -R homeassistant-ai/ha-mcp --state all --limit 20 --json number,title,state,mergedAt
   ```

4. **Persona-Specific Analysis**:
   - Tech Lead: Code quality, architecture changes
   - Product Owner: Feature requests, user value
   - UX Designer: Tool usability, error messages
   - Simple User: Basic workflow testing
   - Advanced User: API completeness, edge cases
   - SRE: CI/CD health, reliability
   - Marketing: Metrics, messaging
   - Security: Dependencies, vulnerabilities
   - Community: Issue response, documentation

### Report Generation

Generate a report following the persona's report format from their `CLAUDE.md`.

Save to: `personas/[persona]/reports/$(date +%Y-%m-%d).md`

### Self-Evolution

Update `personas/[persona]/beliefs.md` with:
- New observations
- Confirmed or refuted beliefs
- Predictions and their outcomes
- Adjustments to focus areas

### Meeting Notes

Save any detailed analysis notes to `personas/[persona]/notes/$(date +%Y-%m-%d).md`

## Output

Return a summary of:
- Key findings
- Proposed backlog items with priorities
- Belief updates made
- Any concerns or blockers
