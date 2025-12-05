# HA-MCP Management System

A persona-driven management system for [ha-mcp](https://github.com/homeassistant-ai/ha-mcp) - the Home Assistant Model Context Protocol server.

## Overview

This repository provides automated weekly reviews of ha-mcp using 10 specialized AI personas, each focusing on different aspects of the project. The system produces a prioritized backlog through simulated stakeholder meetings.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/homeassistant-ai/ha-mcp-mgr.git
cd ha-mcp-mgr

# Run weekly review (requires Claude Code CLI)
./scripts/run-weekly-review.sh

# Or run manually with Claude Code
claude -p "$(cat .claude/commands/weekly-review.md)"
```

## Personas

| Persona | Focus Area |
|---------|------------|
| **Julz** | Main coordinator, final prioritization |
| **Tech Lead** | Code quality, architecture, tech debt |
| **Product Owner** | Features, roadmap, user value |
| **UX Designer** | User experience, discoverability |
| **Simple User** | Basic workflows, onboarding |
| **Advanced User** | Power features, API completeness |
| **SRE** | Reliability, performance, monitoring |
| **Marketing/Comm** | Adoption, metrics, messaging |
| **Security Analyst** | Vulnerabilities, hardening |
| **Community Manager** | Issues, docs, community health |

## Structure

```
ha-mcp-mgr/
├── personas/           # 10 persona folders with self-evolving context
│   └── [persona]/
│       ├── CLAUDE.md   # Persona instructions
│       ├── beliefs.md  # Evolving observations
│       ├── notes/      # Meeting notes
│       └── reports/    # Weekly reports
├── backlog/
│   ├── current.md      # Active backlog
│   └── archive/        # Historical backlogs
├── meetings/
│   └── weekly/         # Meeting notes and metrics
├── scripts/            # Automation scripts
├── .claude/commands/   # Claude Code slash commands
├── templates/          # Report templates
└── ha-mcp/            # Reference copy of ha-mcp
```

## Weekly Process

1. **Metrics Collection**: Gather GitHub, PyPI, Docker stats
2. **Persona Reviews**: Each persona analyzes ha-mcp from their perspective
3. **Coordination Meeting**: Julz synthesizes reports and resolves conflicts
4. **Backlog Update**: Prioritized items added to `backlog/current.md`

## Running Reviews

### Full Weekly Review
```bash
./scripts/run-weekly-review.sh
```

### Single Persona
```bash
./scripts/run-persona.sh tech-lead
```

### Collect Metrics Only
```bash
./scripts/collect-metrics.sh
```

## Priority Levels

| Level | Description |
|-------|-------------|
| **P0** | Critical - security, data loss, breaking bugs |
| **P1** | High - significant user impact, major features |
| **P2** | Medium - improvements, enhancements |
| **P3** | Low - polish, future considerations |

## Self-Evolution

Personas update their own context files:
- `beliefs.md` - Observations and learnings over time
- `CLAUDE.md` - Refined instructions based on experience

This enables the system to improve its analysis quality over successive reviews.

## Configuration

Edit `config.json` to adjust:
- Review frequency (weekly/daily)
- Metrics sources
- Repository references

## Requirements

- [Claude Code CLI](https://github.com/anthropics/claude-code) (`claude` command)
- GitHub CLI (`gh`) - authenticated
- Bash shell

## License

MIT - Same as ha-mcp
