# Backlog Management

This directory contains the ha-mcp management backlog.

## Files

- `current.md` - The active backlog for the current/upcoming week
- `archive/` - Historical backlogs organized by date

## Priority Levels

| Priority | Description | Response Time |
|----------|-------------|---------------|
| **P0** | Critical - security issues, breaking bugs, data loss | Immediate |
| **P1** | High - significant user impact, major features | This week |
| **P2** | Medium - improvements, nice-to-haves | Within 2 weeks |
| **P3** | Low - polish, future considerations | When capacity allows |

## Backlog Item Format

```markdown
### [P1] Item Title
- **Source**: Which persona(s) proposed
- **Category**: feature/bug/tech-debt/docs/security/process/meta
- **ha-mcp Issue**: #123 (if linked)
- **Status**: pending/in-progress/blocked/done
- **Rationale**: Why this priority
- **Notes**: Additional context
```

## Categories

- **feature**: New functionality
- **bug**: Something broken
- **tech-debt**: Code quality, refactoring
- **docs**: Documentation improvements
- **security**: Security-related items
- **process**: Management process improvements
- **meta**: Management system itself

## Weekly Process

1. Persona reviews propose items
2. Coordination meeting prioritizes
3. `current.md` is updated
4. Completed items move to archive
5. Incomplete items carry forward

## Archive Naming

Archives use date format: `YYYY-MM-DD.md`

Each archive contains:
- Items completed that week
- Items that were deprioritized with rationale
- Metrics at time of archival
