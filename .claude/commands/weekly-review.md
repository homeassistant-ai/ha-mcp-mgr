# Weekly Review Command

You are running the weekly review process for ha-mcp management.

## Instructions

Run this process in order:

### Phase 1: Data Collection

First, gather current metrics:

1. **GitHub Stats** (using gh CLI):
   ```bash
   # Recent commits (last 7 days)
   gh api repos/homeassistant-ai/ha-mcp/commits --jq '.[].commit.message' | head -20

   # Open issues
   gh issue list -R homeassistant-ai/ha-mcp --state open --limit 50

   # Recent PRs
   gh pr list -R homeassistant-ai/ha-mcp --state all --limit 20

   # Releases this week
   gh release list -R homeassistant-ai/ha-mcp --limit 5
   ```

2. **PyPI Stats** (fetch from web):
   - Check https://pepy.tech/project/ha-mcp for download stats

3. **Docker Stats**:
   - Check ghcr.io package stats if available

Save metrics to `meetings/weekly/YYYY-MM-DD-metrics.md`

### Phase 2: Persona Reviews (Run in Parallel)

For EACH persona in `personas/`, run their analysis using sub-agents:

```
claude -p "You are the [PERSONA] persona. Read your instructions from personas/[persona]/CLAUDE.md.
Analyze ha-mcp for the past week.
Review: ha-mcp/ submodule code, recent commits, open issues.
Generate a report following your report format.
Save to personas/[persona]/reports/YYYY-MM-DD.md
Update your beliefs.md with new observations."
```

Run these in parallel for efficiency using the Task tool with subagent_type.

### Phase 3: Coordination Meeting

After all persona reports are complete:

1. Read all reports from `personas/*/reports/YYYY-MM-DD.md`
2. As Julz, synthesize and prioritize
3. Resolve any conflicts between personas
4. Generate unified backlog
5. Save meeting notes to `meetings/weekly/YYYY-MM-DD-meeting.md`
6. Update `backlog/current.md` with new items
7. Archive previous backlog items that are done

### Phase 4: Self-Evolution

Each persona should have updated their `beliefs.md` during Phase 2.
Verify all files are updated.

### Output

When complete, summarize:
- Key findings from each persona
- Top priority items for the week
- Any conflicts resolved
- Next steps

## Date Handling

Use today's date for all file names: `$(date +%Y-%m-%d)`

## Submodule Check

Before starting, ensure ha-mcp submodule is current:
```bash
cd ha-mcp && git pull origin main
```
