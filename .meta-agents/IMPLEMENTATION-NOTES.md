# Implementation Notes

Technical details about how the ha-mcp-mgr system was built.

## Creation Process

The system was built in a single Claude Code session through iterative refinement:

### Phase 1: Initial Setup
1. Cloned ha-mcp repository for analysis
2. Created ha-mcp-mgr GitHub repository
3. Analyzed ha-mcp structure (88 tools, Python 3.13, FastMCP)

### Phase 2: Core Architecture
1. Designed 10 initial personas
2. Created folder structure for each persona
3. Wrote CLAUDE.md instructions for each
4. Created initial beliefs.md files
5. Set up backlog management

### Phase 3: Automation
1. Created weekly review command
2. Built shell scripts for automation
3. Added slash commands for Claude Code

### Phase 4: Enhancements
Added based on user feedback:
- UAT test environment
- MCP server configuration
- Deliverables system with archiving
- Enhanced Julz with follow-up authority
- Renamed simple-user to home-user
- Git workflow for cross-persona visibility
- Auto-push at meeting end
- Submodule commit tracking

### Phase 5: Advanced Features
- Retrospective persona (11th)
- Memory pruning
- Cross-meeting context
- GitHub Pages dashboard
- Issue linking and attribution
- First-meeting bootstrap
- GitHub Actions workflows

## File Generation Order

```
1. CLAUDE.md (main)
2. config.json
3. personas/*/CLAUDE.md (all 10)
4. personas/*/beliefs.md (all 10)
5. .claude/commands/*.md
6. scripts/*.sh
7. backlog/current.md
8. templates/*.md
9. .mcp.json
10. docs/TOOLING.md
11. docs/PERSONA-COMMON.md
12. personas/retrospective/* (11th persona)
13. meetings/context.md
14. scripts/generate-dashboard.sh
15. scripts/first-meeting.sh
16. scripts/prune-old-files.sh
17. scripts/link-issues.sh
18. .github/workflows/*.yml
19. README.md (final version)
```

## Key Technical Choices

### Shell Scripts vs Python
Chose shell scripts for simplicity:
- No dependencies to install
- Works anywhere with bash
- Easy to read and modify
- Integrates naturally with git/gh

### GitHub CLI (gh) for API
Consistently use `gh` instead of raw API calls:
- Already authenticated
- Handles pagination
- Supports GraphQL for discussions
- Consistent output formatting

### MCP Server via uvx
Used uvx for MCP server execution:
- No local installation needed
- Always gets latest version
- Clean environment
- Works across platforms

### HTML Dashboard (not React/etc)
Simple HTML for dashboard:
- No build step
- Works directly with GitHub Pages
- Easy to understand and modify
- Fast to generate

## Claude Code Patterns Used

### Parallel Task Execution
```markdown
Run ALL persona analyses in parallel using the Task tool.
```
The Task tool spawns sub-agents that run concurrently.

### Self-Referential Instructions
Personas read their own CLAUDE.md:
```markdown
Read your instructions from: personas/[name]/CLAUDE.md
```
Enables self-evolution.

### Git as Database
Using git for persistence:
- Commit history = audit log
- Branches could enable experimentation
- Submodule pointer = timestamp
- Diff shows what changed

### Structured Prompts in Files
Commands stored as markdown files:
```bash
claude -p "$(cat .claude/commands/weekly-review.md)"
```
Enables version control of prompts.

## Error Handling

### Graceful Degradation
Scripts handle missing data:
```bash
STARS=$(gh api ... 2>/dev/null || echo "N/A")
```

### Date Compatibility
Handle both GNU and BSD date:
```bash
date -d '7 days ago' ... 2>/dev/null || date -v-7d ...
```

### Optional Operations
Check before destructive actions:
```bash
find ... 2>/dev/null | while read file; do
    rm "$file"
done
```

## Testing Approach

### UAT Environment
Dedicated test instance prevents production issues:
- URL: ha-mcp-uat-server.qc-h.net
- Token: "demo" (replaced server-side)
- Safe for experiments

### Manual Testing
Scripts can be run individually:
```bash
./scripts/collect-metrics.sh  # Test metrics only
./scripts/generate-dashboard.sh  # Test dashboard only
./scripts/run-persona.sh tech-lead  # Test single persona
```

## Maintenance Considerations

### What Needs Regular Updates
1. ha-mcp submodule (before each meeting)
2. Persona beliefs (during meetings)
3. Context.md (end of meetings)
4. Dashboard (after meetings)

### What Auto-Maintains
1. Report pruning (via prune script)
2. Dashboard updates (via GitHub Actions)
3. Reminder issues (via GitHub Actions)

### What Needs Human Review
1. Persona CLAUDE.md refinements
2. Process changes from Retrospective
3. Priority framework adjustments
4. New persona additions

## Performance Notes

### Parallel Execution
11 personas running in parallel vs sequential:
- Parallel: ~5-10 minutes total
- Sequential: ~30-50 minutes total

### API Rate Limits
GitHub API calls spread across:
- Metrics collection (once)
- Per-persona queries (limited)
- Issue creation (few)

### Storage Growth
With pruning enabled:
- Reports: ~12 weeks × 11 personas × ~10KB = ~1.3MB
- Notes: ~8 weeks × 11 personas × ~5KB = ~0.4MB
- Manageable long-term

## Security Considerations

### Tokens
- UAT token is "demo" (safe, replaced server-side)
- Production tokens via environment variables
- Never committed to repo

### Issue Creation
- All issues assigned to specific user
- Prevents spam/abuse
- Creates accountability

### Repository Access
- gh CLI uses existing authentication
- No additional credentials stored
- Respects user's GitHub permissions

## Debugging Tips

### Check Persona Output
```bash
cat personas/tech-lead/reports/$(date +%Y-%m-%d).md
```

### Verify Submodule State
```bash
git submodule status ha-mcp
```

### Test MCP Connection
```bash
uvx ha-mcp --help  # Verify installation
```

### Review Meeting History
```bash
git log --oneline -- meetings/
git log --oneline -- ha-mcp  # Submodule changes
```
