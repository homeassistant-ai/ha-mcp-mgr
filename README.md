# HA-MCP Management System

A persona-driven management system for [ha-mcp](https://github.com/homeassistant-ai/ha-mcp) - the Home Assistant Model Context Protocol server.

## Overview

This repository provides automated weekly reviews of ha-mcp using 10 specialized AI personas, each focusing on different aspects of the project. The system produces a prioritized backlog through simulated stakeholder meetings.

**Key Features:**
- MCP server access for testing ha-mcp functionality
- Self-evolving personas with deliverables and beliefs
- Comprehensive GitHub integration (issues, PRs, discussions)
- Persona capability request workflow
- Auto-commit and push at meeting end
- Submodule commit tracking for meeting history

## Quick Start

```bash
# Clone the repository
git clone https://github.com/homeassistant-ai/ha-mcp-mgr.git
cd ha-mcp-mgr
git submodule update --init

# Set HA credentials for MCP testing
export HOMEASSISTANT_URL="https://your-ha:8123"
export HOMEASSISTANT_TOKEN="your_token"

# Run weekly review
./scripts/run-weekly-review.sh
```

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

## Structure

```
ha-mcp-mgr/
├── .mcp.json           # MCP server config (ha-mcp)
├── personas/           # 10 persona folders with self-evolving context
│   └── [persona]/
│       ├── CLAUDE.md   # Persona instructions
│       ├── beliefs.md  # Evolving observations
│       ├── deliverables/  # Active documents
│       ├── archive/    # Completed items
│       ├── notes/      # Meeting notes
│       └── reports/    # Weekly reports
├── backlog/
│   ├── current.md      # Active backlog
│   └── archive/        # Historical backlogs
├── meetings/weekly/    # Meeting notes and metrics
├── docs/
│   ├── TOOLING.md      # Tool reference with examples
│   └── PERSONA-COMMON.md  # Common capabilities
├── scripts/            # Automation scripts
├── .claude/commands/   # Claude Code slash commands
└── ha-mcp/             # Submodule (commit = meeting timestamp)
```

## Weekly Process

1. **Pre-Flight**: Update ha-mcp submodule (commit = meeting timestamp)
2. **Metrics**: Collect GitHub, PyPI, Docker stats
3. **Persona Reviews**: All 9 personas analyze ha-mcp in parallel
4. **Coordination**: Julz synthesizes, resolves conflicts, asks follow-ups
5. **Backlog**: Prioritized items added to `backlog/current.md`
6. **Commit & Push**: All changes committed with ha-mcp commit reference

## Running Reviews

```bash
# Full weekly review
./scripts/run-weekly-review.sh

# Single persona
./scripts/run-persona.sh tech-lead

# Collect metrics only
./scripts/collect-metrics.sh
```

## Persona Capabilities

Each persona can:
- **Test ha-mcp** via the configured MCP server
- **Check GitHub** for issues, PRs, discussions
- **See other personas** via git status
- **Track their history** via git log
- **Request new tools** by documenting in reports (Julz approves)

## Priority Levels

| Level | Description |
|-------|-------------|
| **P0** | Critical - security, data loss, breaking bugs |
| **P1** | High - significant user impact, major features |
| **P2** | Medium - improvements, enhancements |
| **P3** | Low - polish, future considerations |

## Julz's Authority

The Julz coordinator has significant latitude:
- Ask follow-up questions to any persona
- Override individual priorities for project benefit
- Approve/reject persona capability requests
- Make final decisions with documented rationale

## Self-Evolution

Personas update their own context files:
- `beliefs.md` - Observations and learnings over time
- `CLAUDE.md` - Refined instructions based on experience
- `deliverables/` - Active documents, archived when complete

## MCP Server Testing

Configure HA credentials:
```bash
export HOMEASSISTANT_URL="https://your-ha:8123"
export HOMEASSISTANT_TOKEN="your_long_lived_token"
```

Personas can then test ha-mcp tools like:
- `ha_search_entities`, `ha_call_service`
- `ha_create_automation`, `ha_control_device`
- All 88 ha-mcp tools

## Requirements

- [Claude Code CLI](https://github.com/anthropics/claude-code) (`claude` command)
- GitHub CLI (`gh`) - authenticated
- Bash shell
- Home Assistant instance (for MCP testing)

## License

MIT - Same as ha-mcp
