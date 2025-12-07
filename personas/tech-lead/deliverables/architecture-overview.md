# ha-mcp Architecture Overview

*Last updated: Pending first analysis*

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   Claude Desktop/Code                        │
└─────────────────────────┬───────────────────────────────────┘
                          │ MCP Protocol (stdio)
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                    ha-mcp Server                             │
│                   (FastMCP framework)                        │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────┐   │
│  │                 Tool Registry (~88 tools)             │   │
│  │  Light │ Climate │ Sensor │ Automation │ Scene │ ... │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────┬───────────────────────────────────┘
                          │ REST + WebSocket
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                   Home Assistant API                         │
└─────────────────────────────────────────────────────────────┘
```

## Key Components

| Component | Technology | Notes |
|-----------|------------|-------|
| Framework | FastMCP | Python MCP server framework |
| Language | Python 3.13+ | Modern Python features |
| Package Mgr | UV | Fast dependency management |
| Linting | ruff, black | Code quality |
| Types | mypy strict | Type safety |
| Testing | pytest | With testcontainers |

## Tool Categories

*To be populated after first analysis*

| Category | Count | Coverage |
|----------|-------|----------|
| TBD | - | - |

## Dependencies

*Key dependencies to be documented*

## Technical Debt

See `tech-debt-registry.md` for tracked items.

---
*Updated by Tech Lead during weekly reviews*
