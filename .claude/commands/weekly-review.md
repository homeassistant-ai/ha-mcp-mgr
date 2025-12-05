# Weekly Review Command

You are running the weekly review process for ha-mcp management.

## Pre-Flight: Submodule Update

Before starting, update ha-mcp submodule to latest and record the commit:

```bash
cd ha-mcp && git fetch origin && git checkout origin/main && cd ..
git add ha-mcp

# Record the commit we're analyzing
HAMCP_COMMIT=$(git -C ha-mcp rev-parse --short HEAD)
echo "Analyzing ha-mcp at commit: $HAMCP_COMMIT"
```

This commit serves as a timestamp marking what code version this meeting analyzed.

## Phase 1: Data Collection

Gather comprehensive metrics using the tools in `docs/TOOLING.md`:

### 1. GitHub Repository Stats
```bash
# Repo overview
gh api repos/homeassistant-ai/ha-mcp --jq '{stars: .stargazers_count, forks: .forks_count, watchers: .subscribers_count, open_issues: .open_issues_count}'

# Recent commits (last 7 days)
gh api "repos/homeassistant-ai/ha-mcp/commits?since=$(date -d '7 days ago' +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -v-7d +%Y-%m-%dT%H:%M:%SZ)" --jq '.[].commit.message' | head -30
```

### 2. Issues (Open and Active)
```bash
# Open issues
gh issue list -R homeassistant-ai/ha-mcp --state open --limit 50 --json number,title,labels,createdAt

# Recently closed issues
gh issue list -R homeassistant-ai/ha-mcp --state closed --limit 20 --json number,title,closedAt
```

### 3. Pull Requests
```bash
# Open PRs
gh pr list -R homeassistant-ai/ha-mcp --state open --json number,title,author

# Recently merged PRs
gh pr list -R homeassistant-ai/ha-mcp --state merged --limit 20 --json number,title,mergedAt
```

### 4. Discussions
```bash
gh api graphql -f query='query { repository(owner:"homeassistant-ai", name:"ha-mcp") { discussions(first:20, orderBy:{field:CREATED_AT, direction:DESC}) { nodes { number title category{name} createdAt comments{totalCount} } } } }' --jq '.data.repository.discussions.nodes[]'
```

### 5. Releases
```bash
gh release list -R homeassistant-ai/ha-mcp --limit 5
```

### 6. Distribution Metrics
- PyPI: Check https://pepy.tech/project/ha-mcp
- Docker: Check ghcr.io package stats

Save all metrics to `meetings/weekly/$(date +%Y-%m-%d)-metrics.md`

## Phase 2: Persona Reviews (Parallel)

Run ALL persona analyses in parallel using the Task tool.

For EACH persona, spawn a sub-agent:

```
Task: "[persona-name] weekly review"
Prompt: "You are the [PERSONA] persona for ha-mcp.

Read your full instructions from: personas/[name]/CLAUDE.md
Read your current beliefs from: personas/[name]/beliefs.md
Review your current deliverables in: personas/[name]/deliverables/

Analyze ha-mcp for the past week:
- Review code in ha-mcp/ directory
- Check recent commits, issues, PRs, discussions
- Use the MCP server if you need to test functionality
- Focus on your domain-specific concerns

Generate your weekly report following your report format.
Include a 'Tool/Capability Needs' section if you need anything.

Save report to: personas/[name]/reports/$(date +%Y-%m-%d).md
Update your beliefs.md with new observations.
Update any deliverables that need changes.

Return a summary of your findings and proposed backlog items."
```

Personas to run (in parallel):
1. tech-lead
2. product-owner
3. ux-designer
4. simple-user (now "Home User")
5. advanced-user
6. sre
7. marketing-comm
8. security-analyst
9. community-manager

## Phase 3: Coordination Meeting (As Julz)

Read Julz's instructions from `personas/julz/CLAUDE.md`.

### 3.1 Collect All Reports
Read all persona reports from `personas/*/reports/$(date +%Y-%m-%d).md`

### 3.2 Review and Synthesize
- Extract proposed backlog items from each report
- Identify conflicts between persona priorities
- Note any tool/capability requests from personas

### 3.3 Ask Follow-Up Questions
If any report is unclear or needs more detail:
- Ask the specific persona for clarification
- Request additional analysis if needed
- Challenge assumptions where appropriate

### 3.4 Process Persona Requests
For each tool/capability need:
- If approved, create issue in ha-mcp-mgr:
  ```bash
  gh issue create -R homeassistant-ai/ha-mcp-mgr \
    --title "[Persona Need] Description" \
    --body "Requested by: [persona]\nJustification: ...\nApproved by Julz" \
    --label "persona-request"
  ```
- If rejected, document why in meeting notes

### 3.5 Prioritize and Finalize
Apply prioritization framework:
- P0: Critical security/reliability issues
- P1: High user impact, major features
- P2: Medium improvements
- P3: Low priority polish

### 3.6 Update Backlog
Update `backlog/current.md`:
- Add new prioritized items
- Mark completed items as done
- Archive done items to `backlog/archive/$(date +%Y-%m-%d).md`

### 3.7 Meeting Notes
Save to `meetings/weekly/$(date +%Y-%m-%d)-meeting.md`:
- Metrics summary
- Key findings per persona
- Conflicts and resolutions
- Final backlog
- Persona requests processed
- Action items

## Phase 4: Self-Evolution

Verify all personas updated their files:
- beliefs.md updated with new observations
- Deliverables updated or archived as needed
- CLAUDE.md refined if necessary

Update Julz's beliefs.md with:
- Decisions made and their rationale
- Patterns observed
- Process improvements

## Phase 5: Commit and Push

After all updates are complete:

```bash
# Stage all changes
git add -A

# Commit with ha-mcp reference
git commit -m "docs: weekly meeting $(date +%Y-%m-%d)

Backlog updated, persona reports archived.
ha-mcp analyzed at: $(git -C ha-mcp rev-parse --short HEAD)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Push to remote
git push origin master
```

## Output Summary

When complete, provide:
1. ha-mcp commit analyzed
2. Key findings from each persona (1-2 lines each)
3. Top priority backlog items
4. Conflicts resolved
5. Persona requests processed
6. Commit hash of meeting

## Reference

- Full tooling docs: `docs/TOOLING.md`
- Common persona capabilities: `docs/PERSONA-COMMON.md`
- Current backlog: `backlog/current.md`
