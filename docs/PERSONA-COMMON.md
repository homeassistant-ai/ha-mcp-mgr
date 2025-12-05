# Common Persona Capabilities

This document describes capabilities common to all personas.

## Tools Available

See `docs/TOOLING.md` for complete reference.

### Key Tools
- **GitHub CLI (gh)**: Issues, PRs, discussions, releases, commits
- **MCP Server**: ha-mcp connected via `.mcp.json` for testing
- **Web Search**: Research and competitive analysis
- **Git**: Version history, collaboration

## MCP Server Testing

All personas can use the ha-mcp MCP server to test functionality:

```bash
# Server configured in .mcp.json
# Requires HOMEASSISTANT_URL and HOMEASSISTANT_TOKEN env vars
```

Available for testing:
- Entity discovery and control
- Automation creation and management
- Service calls
- State queries
- And all 88 ha-mcp tools

## Git Workflow

### Check Your History
```bash
git log --oneline -- personas/[your-name]/
```

### See What Others Are Doing
```bash
git status
git diff --stat
```

### Check Meeting History
```bash
# Submodule commit = point in ha-mcp history when meeting occurred
git submodule status ha-mcp
git log --oneline -5 -- ha-mcp
```

## Deliverables System

Each persona maintains deliverables in their folder:

```
personas/[name]/
├── CLAUDE.md       # Your instructions (self-evolving)
├── beliefs.md      # Observations and learnings
├── notes/          # Working notes
├── reports/        # Weekly reports
├── deliverables/   # Active documents you maintain
└── archive/        # Completed or obsolete items
```

### Deliverable Lifecycle
1. Create new deliverable in `deliverables/`
2. Update it over time as you learn
3. When obsolete or completed, move to `archive/`
4. Reference in reports and meetings

## Requesting New Capabilities

If you need something to do your job better:

1. Document in your report under "Tool/Capability Needs"
2. Include:
   - What you need
   - Why you need it
   - What's currently blocked
3. Julz will review and either:
   - Approve and create an issue in ha-mcp-mgr
   - Reject with explanation

### Examples of Requests
- "Need access to a test HA instance for automation testing"
- "Need a tool to compare ha-mcp with competitor X"
- "Need metrics dashboard for tracking adoption"

## Self-Evolution

After each review cycle, update:

1. **beliefs.md**
   - New observations
   - Confirmed/refuted predictions
   - Patterns discovered

2. **CLAUDE.md** (if needed)
   - Refined focus areas
   - Updated responsibilities
   - New deliverables

3. **Deliverables**
   - Update active documents
   - Archive completed items
   - Create new as needed

## Collaboration

### Check Other Personas
```bash
# See all persona folders
ls personas/

# Read another's beliefs
cat personas/tech-lead/beliefs.md

# See their recent reports
ls personas/product-owner/reports/
```

### Cross-Persona References
When your work relates to another persona's domain:
- Reference their findings: "As tech-lead noted in their report..."
- Propose joint items: "This needs both UX and tech input"
- Flag conflicts: "This conflicts with product-owner's priority X"

## Report Format

All reports should include:

1. **Summary** - Quick overview
2. **Key Observations** - What you found
3. **Concerns** - Issues or risks
4. **Proposed Backlog Items** - Prioritized suggestions
5. **Tool/Capability Needs** - What you need (for Julz)
6. **Deliverable Updates** - What you changed

## Meeting Participation

Weekly process:
1. Generate your report before coordination
2. Update your deliverables
3. Julz reviews all reports
4. Julz may ask follow-up questions
5. Final backlog produced
6. All changes committed and pushed
