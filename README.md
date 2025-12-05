# HA-MCP Management System

A persona-driven management system for [ha-mcp](https://github.com/homeassistant-ai/ha-mcp) - the Home Assistant Model Context Protocol server.

## Overview

This repository provides automated weekly reviews of ha-mcp using **11 specialized AI personas**, each focusing on different aspects of the project. The system produces a prioritized backlog through simulated stakeholder meetings.

**Key Features:**
- UAT test environment for safe testing (ha-mcp-uat-server.qc-h.net)
- MCP server access for testing ha-mcp functionality
- Self-evolving personas with deliverables and beliefs
- GitHub Pages metrics dashboard
- Comprehensive GitHub integration (issues, PRs, discussions)
- Issue linking to ha-mcp with auto-assignment
- Cross-meeting context preservation
- Auto memory pruning for old files
- Auto-commit and push at meeting end

## Quick Start

```bash
# Clone the repository
git clone https://github.com/homeassistant-ai/ha-mcp-mgr.git
cd ha-mcp-mgr
git submodule update --init

# First-time setup (comprehensive bootstrap)
./scripts/first-meeting.sh

# Or for subsequent weekly reviews
./scripts/run-weekly-review.sh
```

## Dashboard

View the metrics dashboard at: **https://homeassistant-ai.github.io/ha-mcp-mgr/**

Regenerate manually: `./scripts/generate-dashboard.sh`

## Personas

| Persona | Focus Area | Key Deliverables |
|---------|------------|------------------|
| **Julz** | Coordinator, final decisions | Priority framework |
| **Tech Lead** | Code quality, architecture | Tech debt registry |
| **Product Owner** | Features, roadmap | Roadmap, feature requests |
| **UX Designer** | User experience | UX guidelines |
| **Home User** | Daily automation use | Workflow patterns |
| **Advanced User** | Power features | API coverage |
| **SRE** | Reliability, performance | SLOs, incident log |
| **Marketing/Comm** | Adoption, metrics | Metrics dashboard |
| **Security Analyst** | Vulnerabilities | Security checklist |
| **Community Manager** | Issues, docs | FAQ, issue patterns |
| **Retrospective** | Process improvement | Decision tracking |

## Structure

```
ha-mcp-mgr/
├── .mcp.json              # MCP server config (UAT + custom)
├── config.json            # System configuration
├── personas/              # 11 persona folders
│   └── [persona]/
│       ├── CLAUDE.md      # Persona instructions
│       ├── beliefs.md     # Evolving observations
│       ├── deliverables/  # Active documents
│       ├── archive/       # Completed items
│       ├── notes/         # Working notes
│       └── reports/       # Weekly reports
├── backlog/
│   ├── current.md         # Active backlog
│   └── archive/           # Historical backlogs
├── meetings/
│   ├── weekly/            # Meeting notes and metrics
│   └── context.md         # Cross-meeting context
├── docs/
│   ├── dashboard/         # GitHub Pages dashboard
│   ├── TOOLING.md         # Tool reference
│   └── PERSONA-COMMON.md  # Common capabilities
├── scripts/               # Automation scripts
├── .github/workflows/     # GitHub Actions
└── ha-mcp/                # Submodule (commit = meeting timestamp)
```

## Scripts

```bash
# First-time comprehensive analysis
./scripts/first-meeting.sh

# Weekly review (subsequent meetings)
./scripts/run-weekly-review.sh

# Single persona analysis
./scripts/run-persona.sh tech-lead

# Collect metrics only
./scripts/collect-metrics.sh

# Generate/update dashboard
./scripts/generate-dashboard.sh

# Prune old persona files
./scripts/prune-old-files.sh

# Link/search issues
./scripts/link-issues.sh search "keyword"
./scripts/link-issues.sh create-mgr "Title" "Body" "label"
```

## Test Environment

UAT environment available for safe testing:
- **URL**: https://ha-mcp-uat-server.qc-h.net
- **Token**: `demo` (gets replaced with real token)

Configured in `.mcp.json` as `ha-mcp-uat`.

## Weekly Process

1. **Pre-Flight**: Update ha-mcp submodule (commit = meeting timestamp)
2. **Metrics**: Collect GitHub, PyPI, Docker stats
3. **Persona Reviews**: All 10 personas analyze ha-mcp in parallel
4. **Coordination**: Julz synthesizes, resolves conflicts, asks follow-ups
5. **Retrospective**: Process health check
6. **Backlog**: Prioritized items with issue linking
7. **Context**: Update cross-meeting context
8. **Dashboard**: Regenerate metrics
9. **Commit & Push**: All changes with ha-mcp commit reference

## Issue Management

### Auto-Assignment
All created issues are assigned to `julienld` for email notification.

### Issue Linking
```bash
# Search existing ha-mcp issues
./scripts/link-issues.sh search "authentication"

# Create linked issue
./scripts/link-issues.sh create-hamcp "Feature title" "Body" "enhancement"
```

## Memory Management

Automatic pruning of old files (configurable in `config.json`):
- Reports: Keep 12 weeks
- Notes: Keep 8 weeks
- Meeting files: Archive after 6 months

## GitHub Actions

- **dashboard.yml**: Auto-update dashboard on meeting commits
- **weekly-review.yml**: Monday reminder issue (assigned to julienld)

## Priority Levels

| Level | Description |
|-------|-------------|
| **P0** | Critical - security, data loss, breaking bugs |
| **P1** | High - significant user impact, major features |
| **P2** | Medium - improvements, enhancements |
| **P3** | Low - polish, future considerations |

## Requirements

- [Claude Code CLI](https://github.com/anthropics/claude-code) (`claude` command)
- GitHub CLI (`gh`) - authenticated
- Bash shell

## License

MIT - Same as ha-mcp
