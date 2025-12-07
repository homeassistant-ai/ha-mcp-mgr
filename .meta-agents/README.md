# Meta-Agents: HA-MCP Management System Architecture

This folder documents the architecture and design decisions behind the ha-mcp-mgr system - a persona-driven AI management framework for open source project governance.

## What We Built

A **multi-agent governance system** that uses Claude Code to simulate a team of specialized stakeholders reviewing and steering an open source project (ha-mcp).

### Core Concept

Instead of a single AI reviewing a project, we created **11 distinct personas** with:
- Specialized focus areas
- Evolving beliefs and learnings
- Persistent deliverables
- Cross-persona visibility
- Coordinated decision-making

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    Weekly Review Process                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌─────────────┐                                                │
│  │  ha-mcp     │◄── Git submodule (commit = meeting timestamp)  │
│  │  (source)   │                                                │
│  └──────┬──────┘                                                │
│         │                                                        │
│         ▼                                                        │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              Phase 1: Data Collection                     │   │
│  │  • GitHub API (issues, PRs, discussions, commits)        │   │
│  │  • Distribution metrics (PyPI, Docker)                   │   │
│  │  • MCP server testing (UAT environment)                  │   │
│  └──────────────────────────────────────────────────────────┘   │
│         │                                                        │
│         ▼                                                        │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              Phase 2: Parallel Persona Analysis           │   │
│  │                                                           │   │
│  │   ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐       │   │
│  │   │Tech Lead│ │Product  │ │   UX    │ │  Home   │       │   │
│  │   │         │ │Owner    │ │Designer │ │  User   │       │   │
│  │   └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘       │   │
│  │        │           │           │           │             │   │
│  │   ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐       │   │
│  │   │Advanced │ │   SRE   │ │Marketing│ │Security │       │   │
│  │   │  User   │ │         │ │  Comm   │ │Analyst  │       │   │
│  │   └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘       │   │
│  │        │           │           │           │             │   │
│  │   ┌─────────┐ ┌─────────┐                               │   │
│  │   │Community│ │Retrospe-│                               │   │
│  │   │Manager  │ │ctive    │                               │   │
│  │   └────┬────┘ └────┬────┘                               │   │
│  │        │           │                                     │   │
│  └────────┼───────────┼─────────────────────────────────────┘   │
│           │           │                                          │
│           ▼           ▼                                          │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              Phase 3: Coordination (Julz)                 │   │
│  │  • Review all persona reports                            │   │
│  │  • Ask follow-up questions                               │   │
│  │  • Resolve conflicts                                     │   │
│  │  • Process capability requests                           │   │
│  │  • Prioritize backlog                                    │   │
│  │  • Link to ha-mcp issues                                 │   │
│  └──────────────────────────────────────────────────────────┘   │
│         │                                                        │
│         ▼                                                        │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              Phase 4: Self-Evolution                      │   │
│  │  • Update beliefs.md with learnings                      │   │
│  │  • Refine deliverables                                   │   │
│  │  • Update cross-meeting context                          │   │
│  └──────────────────────────────────────────────────────────┘   │
│         │                                                        │
│         ▼                                                        │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │              Phase 5: Commit & Push                       │   │
│  │  • Stage all changes                                     │   │
│  │  • Commit with ha-mcp reference                          │   │
│  │  • Push to remote                                        │   │
│  │  • Trigger dashboard update                              │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Design Principles

### 1. Separation of Concerns
Each persona has a distinct focus area, preventing any single perspective from dominating:
- Technical vs Product vs User perspectives
- Internal vs External concerns
- Short-term vs Long-term thinking

### 2. Self-Evolution
Personas learn and adapt over time:
- `beliefs.md` tracks observations and learnings
- `CLAUDE.md` can be refined based on experience
- Deliverables evolve with each cycle

### 3. Context Preservation
Multiple mechanisms prevent context loss:
- Git history for all persona folders
- Submodule commit as meeting timestamp
- `meetings/context.md` for cross-meeting memory
- Deliverables as persistent knowledge

### 4. Transparency
All decisions and reasoning are documented:
- Meeting notes capture discussions
- Backlog items include rationale
- Conflicts and resolutions recorded

### 5. Actionable Output
Everything drives toward concrete outcomes:
- Prioritized backlog (P0-P3)
- Linked to real GitHub issues
- Assigned for accountability

## Persona Design

### Structure
Each persona folder contains:
```
personas/[name]/
├── CLAUDE.md      # Instructions (self-evolving)
├── beliefs.md     # Observations and learnings
├── deliverables/  # Active documents they maintain
├── archive/       # Completed/obsolete items
├── notes/         # Working notes
└── reports/       # Weekly reports
```

### Persona Roster

| Persona | Archetype | Key Question |
|---------|-----------|--------------|
| Julz | Project Lead | "What's best for the project overall?" |
| Tech Lead | Engineer | "Is the code maintainable and sound?" |
| Product Owner | Business | "Does this deliver user value?" |
| UX Designer | Designer | "Is this easy to use?" |
| Home User | Casual User | "Can I do everyday tasks easily?" |
| Advanced User | Power User | "Can I do complex workflows?" |
| SRE | Operations | "Is this reliable and observable?" |
| Marketing/Comm | Growth | "How do we reach more users?" |
| Security Analyst | Security | "Is this safe?" |
| Community Manager | Community | "Is the community healthy?" |
| Retrospective | Meta | "Is this process working?" |

### Capability Requests
Personas can request new tools/access:
1. Document need in report
2. Julz reviews and approves/rejects
3. If approved, issue created (assigned for notification)
4. Request tracked in mgr repo

## Key Innovations

### 1. MCP Server Integration
Personas can actually test ha-mcp functionality:
- UAT environment for safe testing
- Real tool execution, not just code review
- Practical usability validation

### 2. Issue Linking
Backlog items connect to real ha-mcp issues:
- Search existing issues before creating
- Auto-assignment for notifications
- Bidirectional traceability

### 3. Memory Management
Prevents unbounded growth:
- Auto-pruning of old files
- Configurable retention periods
- Archive vs delete decisions

### 4. Metrics Dashboard
Visual representation of project health:
- GitHub Pages deployment
- Auto-updated after meetings
- Historical tracking

### 5. Retrospective Persona
Meta-level process improvement:
- Reviews management system effectiveness
- Tracks decision quality over time
- Proposes process changes

## File Reference

### Configuration
- `config.json` - System settings (schedule, limits, personas)
- `.mcp.json` - MCP server configuration

### Scripts
- `first-meeting.sh` - Bootstrap for initial run
- `run-weekly-review.sh` - Regular weekly process
- `run-persona.sh` - Single persona analysis
- `collect-metrics.sh` - Gather metrics only
- `generate-dashboard.sh` - Update GitHub Pages
- `prune-old-files.sh` - Memory management
- `link-issues.sh` - Issue search/creation

### Commands
- `.claude/commands/weekly-review.md` - Full review instructions
- `.claude/commands/persona-review.md` - Single persona
- `.claude/commands/backlog-meeting.md` - Coordination only

### Persistent State
- `backlog/current.md` - Active backlog
- `meetings/context.md` - Cross-meeting memory
- `personas/*/beliefs.md` - Per-persona learnings
- `personas/*/deliverables/` - Per-persona documents

## Usage Patterns

### First Run
```bash
./scripts/first-meeting.sh
```
Comprehensive bootstrap that establishes all baselines.

### Weekly Cycle
```bash
./scripts/run-weekly-review.sh
```
Standard review process.

### Ad-hoc Analysis
```bash
./scripts/run-persona.sh tech-lead
```
Run specific persona for targeted analysis.

## Extension Points

### Adding a Persona
1. Create folder: `personas/new-persona/`
2. Add `CLAUDE.md` with instructions
3. Add `beliefs.md` with initial beliefs
4. Create subdirs: `notes/`, `reports/`, `deliverables/`, `archive/`
5. Add to `config.json` personas list
6. Update weekly review command

### Adding Metrics
1. Update `scripts/collect-metrics.sh`
2. Update `scripts/generate-dashboard.sh`
3. Add to `docs/TOOLING.md`

### Changing Schedule
Edit `config.json`:
```json
"schedule": {
  "frequency": "daily",  // or "weekly", "twice-weekly"
  "day": "monday"
}
```

## Lessons Learned

### What Works Well
- Parallel persona execution (speed)
- Structured report formats (consistency)
- Git-based persistence (traceability)
- MCP testing (practical validation)

### Potential Improvements
- More sophisticated conflict resolution
- Automated trend detection in beliefs
- Cross-persona collaboration during analysis
- Integration with project management tools

## Related Concepts

- **Multi-agent systems**: Multiple AI agents with different roles
- **Governance frameworks**: Structured decision-making processes
- **DevOps**: Automated, repeatable processes
- **Knowledge management**: Preserving organizational memory
