# HA-MCP Management System

This repository manages the governance, review, and evolution of [ha-mcp](https://github.com/homeassistant-ai/ha-mcp) - the Home Assistant Model Context Protocol server.

## Overview

The system uses **persona-driven analysis** where specialized AI personas review different aspects of ha-mcp weekly, culminating in a coordinated backlog meeting. Each persona can:
- Access the ha-mcp MCP server for testing
- Use GitHub CLI for issues, PRs, discussions
- Maintain their own evolving deliverables
- Request new tools/capabilities from Julz

## Repository Structure

```
ha-mcp-mgr/
├── CLAUDE.md              # This file - main instructions
├── .mcp.json              # MCP server configuration (ha-mcp)
├── ha-mcp/                # Git submodule (commit = meeting timestamp)
├── personas/              # 10 specialized persona folders
│   └── [persona]/
│       ├── CLAUDE.md      # Self-evolving instructions
│       ├── beliefs.md     # Observations and learnings
│       ├── notes/         # Working notes
│       ├── reports/       # Weekly reports
│       ├── deliverables/  # Active documents
│       └── archive/       # Completed/obsolete items
├── scripts/               # Automation scripts
├── backlog/               # Backlog management
│   ├── current.md         # Active backlog
│   └── archive/           # Historical backlogs
├── meetings/weekly/       # Meeting notes and metrics
├── docs/                  # Documentation
│   ├── TOOLING.md         # Tool reference with examples
│   └── PERSONA-COMMON.md  # Common persona capabilities
├── templates/             # Report templates
└── .claude/commands/      # Claude Code slash commands
```

## Personas

| Persona | Focus | Deliverables |
|---------|-------|--------------|
| **Julz** | Coordinator, final decisions | Backlog strategy, priority framework |
| **Tech Lead** | Code quality, architecture | Architecture docs, tech debt registry |
| **Product Owner** | Features, roadmap | Roadmap, feature requests |
| **UX Designer** | User experience | UX guidelines, error patterns |
| **Home User** | Daily automation use | Workflows, automation patterns |
| **Advanced User** | Power features | API coverage, limitations |
| **SRE** | Reliability, performance | SLOs, incident log |
| **Marketing/Comm** | Adoption, metrics | Metrics dashboard, messaging |
| **Security Analyst** | Vulnerabilities | Security checklist, audits |
| **Community Manager** | Issues, docs | FAQ, issue patterns |

## MCP Server Access

All personas can test ha-mcp via the configured MCP server (`.mcp.json`):
```bash
# Requires environment variables:
export HOMEASSISTANT_URL="https://your-ha-instance:8123"
export HOMEASSISTANT_TOKEN="your_long_lived_token"
```

## Weekly Review Process

### Schedule
Currently weekly on Monday. Frequency configurable in `config.json`.

### Pre-Flight
1. Update ha-mcp submodule to latest commit
2. The submodule commit serves as meeting timestamp

### Phase 1: Data Collection
- GitHub: commits, issues, PRs, discussions
- Distribution: PyPI downloads, Docker pulls
- Metrics saved to `meetings/weekly/YYYY-MM-DD-metrics.md`

### Phase 2: Persona Reviews (Parallel)
Each persona runs independently:
- Analyzes ha-mcp from their perspective
- Tests via MCP server if needed
- Generates report with backlog proposals
- Updates beliefs and deliverables
- Can request new tools/capabilities

### Phase 3: Coordination (Julz)
- Reviews all persona reports
- Asks follow-up questions if needed
- Resolves conflicts between priorities
- Processes persona capability requests
- Produces unified backlog
- Archives meeting notes

### Phase 4: Self-Evolution
All personas update their evolving files.

### Phase 5: Commit and Push
All changes committed and pushed with ha-mcp commit reference.

## Commands

```bash
# Full weekly review
./scripts/run-weekly-review.sh
# or
claude -p "$(cat .claude/commands/weekly-review.md)"

# Single persona
./scripts/run-persona.sh tech-lead

# Metrics only
./scripts/collect-metrics.sh
```

## Julz's Authority

Julz (coordinator) has significant latitude:
- Can ask follow-up questions to any persona
- Can override individual priorities for project benefit
- Approves/rejects persona capability requests
- Creates issues in ha-mcp-mgr for approved requests
- Makes final decisions with documented rationale

## Persona Capability Requests

Personas can request new tools/access:
1. Document in report under "Tool/Capability Needs"
2. Julz reviews during coordination
3. If approved: issue created in ha-mcp-mgr
4. If rejected: documented in meeting notes

## Git Workflow

### Check Other Personas
```bash
git status                              # See all changes
cat personas/tech-lead/reports/*.md    # Read another's reports
```

### Check Your History
```bash
git log --oneline -- personas/[name]/
```

### Meeting History via Submodule
```bash
git submodule status ha-mcp            # Current analyzed commit
git log --oneline -5 -- ha-mcp         # Previous meeting commits
```

## Tooling Reference

See `docs/TOOLING.md` for complete examples:
- GitHub CLI (issues, PRs, discussions, releases)
- Distribution metrics (PyPI, Docker)
- Git workflow commands
- MCP server testing

## Backlog Format

```markdown
## [P1] Item Title
- **Source**: Which persona proposed
- **Category**: feature/bug/tech-debt/docs/security
- **ha-mcp Issue**: #123 (if linked)
- **Status**: pending/in-progress/blocked/done
- **Rationale**: Why this priority
```

## Priority Levels

| Level | Description | Response |
|-------|-------------|----------|
| **P0** | Critical (security, data loss) | Immediate |
| **P1** | High user impact | This week |
| **P2** | Medium improvements | Within 2 weeks |
| **P3** | Low priority polish | When capacity allows |

## Getting Started

```bash
git clone https://github.com/homeassistant-ai/ha-mcp-mgr.git
cd ha-mcp-mgr
git submodule update --init

# Set HA credentials for MCP testing
export HOMEASSISTANT_URL="..."
export HOMEASSISTANT_TOKEN="..."

# Run weekly review
./scripts/run-weekly-review.sh
```
