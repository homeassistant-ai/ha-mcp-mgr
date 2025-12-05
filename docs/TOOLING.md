# Tooling Reference

This document provides examples of all tools available to personas for analysis and testing.

## GitHub CLI (gh)

The `gh` CLI is authenticated and ready to use.

### Repository Stats
```bash
# Get repo overview
gh api repos/homeassistant-ai/ha-mcp --jq '{stars: .stargazers_count, forks: .forks_count, watchers: .subscribers_count, open_issues: .open_issues_count}'

# Get repo traffic (requires push access)
gh api repos/homeassistant-ai/ha-mcp/traffic/views
```

### Issues
```bash
# List open issues
gh issue list -R homeassistant-ai/ha-mcp --state open --limit 50

# List issues with labels
gh issue list -R homeassistant-ai/ha-mcp --label "bug" --state open

# Get issue details
gh issue view 123 -R homeassistant-ai/ha-mcp

# List issues created in last 7 days
gh issue list -R homeassistant-ai/ha-mcp --state all --json number,title,state,createdAt,labels --jq '[.[] | select(.createdAt > (now - 7*24*60*60 | strftime("%Y-%m-%dT%H:%M:%SZ")))]'

# Search issues by keyword
gh issue list -R homeassistant-ai/ha-mcp --search "authentication"

# Get issue comments
gh api repos/homeassistant-ai/ha-mcp/issues/123/comments --jq '.[].body'
```

### Pull Requests
```bash
# List open PRs
gh pr list -R homeassistant-ai/ha-mcp --state open

# List recently merged PRs
gh pr list -R homeassistant-ai/ha-mcp --state merged --limit 20

# Get PR details with files changed
gh pr view 123 -R homeassistant-ai/ha-mcp --json files,additions,deletions

# Get PR review comments
gh api repos/homeassistant-ai/ha-mcp/pulls/123/comments

# List PR checks status
gh pr checks 123 -R homeassistant-ai/ha-mcp
```

### Discussions
```bash
# List discussions (requires GraphQL)
gh api graphql -f query='
query {
  repository(owner: "homeassistant-ai", name: "ha-mcp") {
    discussions(first: 20) {
      nodes {
        number
        title
        category { name }
        createdAt
        comments { totalCount }
      }
    }
  }
}' --jq '.data.repository.discussions.nodes[]'

# Get specific discussion
gh api graphql -f query='
query($number: Int!) {
  repository(owner: "homeassistant-ai", name: "ha-mcp") {
    discussion(number: $number) {
      title
      body
      comments(first: 50) {
        nodes { body author { login } }
      }
    }
  }
}' -F number=1
```

### Releases
```bash
# List releases
gh release list -R homeassistant-ai/ha-mcp --limit 10

# Get latest release details
gh release view -R homeassistant-ai/ha-mcp --json tagName,publishedAt,body

# Get release assets
gh release view v4.14.0 -R homeassistant-ai/ha-mcp --json assets
```

### Commits
```bash
# Recent commits
gh api repos/homeassistant-ai/ha-mcp/commits --jq '.[0:20] | .[].commit.message'

# Commits in last 7 days
gh api "repos/homeassistant-ai/ha-mcp/commits?since=$(date -d '7 days ago' +%Y-%m-%dT%H:%M:%SZ)" --jq '.[].commit.message'

# Commits by author
gh api repos/homeassistant-ai/ha-mcp/commits --jq '[.[] | select(.author.login == "julienld")]'

# Compare commits between releases
gh api repos/homeassistant-ai/ha-mcp/compare/v4.13.0...v4.14.0 --jq '.commits[].commit.message'
```

### Actions/Workflows
```bash
# List recent workflow runs
gh run list -R homeassistant-ai/ha-mcp --limit 10

# Get workflow run details
gh run view 12345 -R homeassistant-ai/ha-mcp

# List failed runs
gh run list -R homeassistant-ai/ha-mcp --status failure --limit 10
```

## Distribution Metrics

### PyPI Downloads
```bash
# Using pepy.tech API (unofficial but works)
curl -s "https://api.pepy.tech/api/v2/projects/ha-mcp" | jq '{total: .total_downloads, recent: .downloads}'

# Or check web: https://pepy.tech/project/ha-mcp

# PyPI package info
curl -s "https://pypi.org/pypi/ha-mcp/json" | jq '{version: .info.version, requires_python: .info.requires_python}'
```

### Docker Image Stats
```bash
# Get package versions from ghcr.io (requires auth)
gh api /orgs/homeassistant-ai/packages/container/ha-mcp/versions --jq '.[0:5]'

# Check Docker image tags
curl -s "https://ghcr.io/v2/homeassistant-ai/ha-mcp/tags/list" 2>/dev/null || echo "May require authentication"
```

### GitHub Traffic (if accessible)
```bash
# Views (requires push access)
gh api repos/homeassistant-ai/ha-mcp/traffic/views

# Clones (requires push access)
gh api repos/homeassistant-ai/ha-mcp/traffic/clones

# Referrers
gh api repos/homeassistant-ai/ha-mcp/traffic/popular/referrers
```

## MCP Server Testing

Personas have access to the ha-mcp MCP server for testing. The server is configured in `.mcp.json`.

### Available Tools (88 total)
When Claude Code is running with the MCP server connected, you can use tools like:
- `ha_search_entities` - Find entities by name
- `ha_get_entity_state` - Get entity state and attributes
- `ha_call_service` - Execute HA services
- `ha_control_device` - Control devices with verification
- `ha_create_automation` - Create automations
- `ha_evaluate_template` - Test Jinja2 templates
- And 80+ more...

### Testing Approach
```markdown
# In your analysis, you can request to test specific scenarios:

"Test: Can I turn on a light using natural language?"
- Use ha_search_entities to find lights
- Use ha_call_service or ha_control_device to toggle

"Test: Create a simple automation"
- Use ha_create_automation with a basic trigger/action
```

## Web Search

Use web search to find:
- Recent mentions of ha-mcp
- Home Assistant community discussions
- MCP ecosystem news
- Competitor analysis

## Creating Issues in mgr Repo

Personas can request new tools or capabilities by proposing issues:

```bash
# Julz reviews and creates approved issues
gh issue create -R homeassistant-ai/ha-mcp-mgr \
  --title "[Persona Request] Need access to X" \
  --body "Requested by: tech-lead\nReason: ...\nApproved by Julz: Yes" \
  --label "persona-request"
```

## Git Commands for Personas

### Check What Others Are Doing
```bash
# See all recent changes
git status

# See changes in specific persona folder
git diff personas/tech-lead/

# See uncommitted changes across all personas
git diff --stat
```

### View Your Own History
```bash
# Your folder's commit history
git log --oneline -- personas/[your-name]/

# Changes in your last report
git show HEAD -- personas/[your-name]/reports/

# Diff between meetings
git diff HEAD~5 -- personas/[your-name]/
```

### Check Meeting History via Submodule
```bash
# Current ha-mcp commit (what meeting was based on)
git submodule status ha-mcp

# When submodule was last updated
git log --oneline -1 -- ha-mcp
```

## File Operations

### Read Files
```bash
# Use the Read tool for any file
# Read specific line ranges for large files
```

### Search Code
```bash
# Use Grep for pattern matching
# Use Glob for file discovery
```

## Environment Variables

Required for MCP testing:
- `HOMEASSISTANT_URL` - Your HA instance URL
- `HOMEASSISTANT_TOKEN` - Long-lived access token

Set these in your environment before running reviews with MCP testing.
