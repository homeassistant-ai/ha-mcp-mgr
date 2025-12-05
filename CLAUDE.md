# HA-MCP Management System

This repository manages the governance, review, and evolution of [ha-mcp](https://github.com/homeassistant-ai/ha-mcp) - the Home Assistant Model Context Protocol server.

## Overview

The system uses **persona-driven analysis** where specialized AI personas review different aspects of ha-mcp weekly, culminating in a coordinated backlog meeting.

## Repository Structure

```
ha-mcp-mgr/
├── CLAUDE.md              # This file - main instructions
├── ha-mcp/                # Git submodule of ha-mcp for reference
├── personas/              # 10 specialized persona folders
│   ├── julz/              # Main coordinator
│   ├── tech-lead/
│   ├── product-owner/
│   ├── ux-designer/
│   ├── simple-user/
│   ├── advanced-user/
│   ├── sre/
│   ├── marketing-comm/
│   ├── security-analyst/
│   └── community-manager/
├── scripts/               # Automation scripts
├── backlog/               # Backlog management
│   ├── current.md         # Current week's backlog
│   └── archive/           # Historical backlogs
├── meetings/              # Meeting notes
│   ├── weekly/            # Weekly meeting summaries
│   └── archives/          # Archived meetings
└── .claude/commands/      # Slash commands for automation
```

## Personas

Each persona has a specialized focus and maintains their own:
- `CLAUDE.md` - Self-evolving instructions and context
- `beliefs.md` - Observations, beliefs, and learnings
- `notes/` - Meeting notes and analysis
- `reports/` - Weekly reports

### Persona Roster

| Persona | Focus | Priority View |
|---------|-------|---------------|
| **Julz** | Main coordinator, final arbitration | Balance all perspectives |
| **Tech Lead** | Code quality, architecture, tech debt | Maintainability, scalability |
| **Product Owner** | Features, roadmap, user value | Business value, priorities |
| **UX Designer** | User experience, discoverability | Usability, friction reduction |
| **Simple User** | Basic use cases, onboarding | Simplicity, getting started |
| **Advanced User** | Power features, edge cases | Flexibility, advanced workflows |
| **SRE** | Reliability, monitoring, performance | Uptime, observability |
| **Marketing/Comm** | Communication, adoption | Growth, visibility |
| **Security Analyst** | Security review, vulnerabilities | Safety, hardening |
| **Community Manager** | Issues, community health, docs | Community engagement |

## Weekly Review Process

### Schedule (Currently: Weekly on Monday)
Frequency can be increased via `config.json`.

### Phase 1: Data Collection
Each persona independently analyzes ha-mcp:
- New commits/features since last review
- Active issues and PRs
- Distribution metrics (PyPI, Docker, GitHub)
- Domain-specific concerns

### Phase 2: Persona Reports
Each persona generates a report covering:
- Observations from their perspective
- Concerns and risks identified
- Proposed backlog items with priority
- Updates to their beliefs

### Phase 3: Coordination Meeting
Julz coordinates:
- Reviews all persona reports
- Resolves conflicts and priorities
- Produces unified backlog for the week
- Archives meeting notes

## Commands

### Running Weekly Review
```bash
# Full weekly review (all personas + coordination)
claude -p "$(cat .claude/commands/weekly-review.md)"

# Single persona analysis
claude -p "$(cat .claude/commands/persona-review.md)" -- --persona tech-lead

# Backlog meeting only (after persona reports exist)
claude -p "$(cat .claude/commands/backlog-meeting.md)"
```

### Manual Triggers
```bash
# Collect metrics only
./scripts/collect-metrics.sh

# Generate distribution stats
./scripts/distribution-stats.sh
```

## Configuration

Edit `config.json` to adjust:
- Review frequency (weekly/daily)
- Metrics sources
- Persona weights in prioritization
- GitHub repository references

## Self-Evolution Protocol

Personas update their own `CLAUDE.md` and `beliefs.md` files based on:
1. Patterns observed across reviews
2. Accuracy of previous predictions
3. Learnings from backlog outcomes
4. Feedback from other personas

## Backlog Management

### Current Backlog: `backlog/current.md`
- Items prioritized P0-P3
- Assigned to relevant personas for tracking
- Updated weekly after coordination meeting

### Backlog Item Format
```markdown
## [P1] Item Title
- **Source**: Which persona proposed
- **Category**: feature/bug/tech-debt/docs/security
- **ha-mcp Issue**: #123 (if linked)
- **Status**: pending/in-progress/blocked/done
- **Notes**: Additional context
```

## Getting Started

1. Clone this repo
2. Ensure ha-mcp submodule is initialized: `git submodule update --init`
3. Run weekly review: `claude -p "$(cat .claude/commands/weekly-review.md)"`

## Metrics Tracked

### Development
- Commits per week
- PRs opened/merged
- Issues opened/closed
- Release frequency
- Test coverage

### Distribution
- PyPI downloads (weekly/monthly)
- Docker pulls (ghcr.io)
- GitHub stars/forks
- Add-on installations (if available)

### Quality
- Open issues count
- Average issue age
- PR review time
- CI/CD pass rate

## Integration with ha-mcp

This repo references ha-mcp via:
- Git submodule for code analysis
- GitHub API for issues/PRs
- PyPI API for download stats
- GitHub Container Registry for Docker stats
