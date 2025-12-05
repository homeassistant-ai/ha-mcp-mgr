# Backlog Meeting Command

Run the coordination meeting to produce the weekly backlog.

## Prerequisites

All persona reports should exist for today's date:
`personas/*/reports/YYYY-MM-DD.md`

## Instructions

### As Julz (Coordinator)

Read Julz's instructions from `personas/julz/CLAUDE.md`.

### Step 1: Gather All Reports

Read all persona reports from today:
```
personas/tech-lead/reports/YYYY-MM-DD.md
personas/product-owner/reports/YYYY-MM-DD.md
personas/ux-designer/reports/YYYY-MM-DD.md
personas/simple-user/reports/YYYY-MM-DD.md
personas/advanced-user/reports/YYYY-MM-DD.md
personas/sre/reports/YYYY-MM-DD.md
personas/marketing-comm/reports/YYYY-MM-DD.md
personas/security-analyst/reports/YYYY-MM-DD.md
personas/community-manager/reports/YYYY-MM-DD.md
```

### Step 2: Extract Proposed Items

From each report, extract:
- Proposed backlog items
- Priority suggestions
- Rationale

### Step 3: Identify Conflicts

Look for:
- Conflicting priorities (e.g., Tech Lead wants refactor, Product Owner wants features)
- Overlapping items that can be combined
- Dependencies between items

### Step 4: Prioritize

Apply Julz's prioritization framework:
- **P0**: Security issues, breaking bugs, data loss risks
- **P1**: High user impact, major features, reliability issues
- **P2**: Improvements, UX enhancements, documentation
- **P3**: Polish, future considerations, nice-to-haves

Consider:
- User impact (simple + advanced users)
- Technical feasibility (tech lead)
- Business value (product owner)
- Risk (security, SRE)
- Community health (community manager)

### Step 5: Produce Backlog

Update `backlog/current.md` with the prioritized list.

Format each item:
```markdown
## [P1] Item Title
- **Source**: Which persona(s) proposed
- **Category**: feature/bug/tech-debt/docs/security
- **ha-mcp Issue**: #123 (if linked)
- **Status**: pending
- **Rationale**: Why this priority
- **Notes**: Additional context
```

### Step 6: Archive Completed

Move any items marked `done` from current backlog to `backlog/archive/YYYY-MM-DD.md`

### Step 7: Meeting Notes

Save meeting notes to `meetings/weekly/YYYY-MM-DD-meeting.md`:
```markdown
# Weekly Meeting - YYYY-MM-DD

## Attendees (Personas)
- All 10 personas participated

## Key Findings by Persona
### Tech Lead
- ...

### Product Owner
- ...

[etc.]

## Conflicts Resolved
- [Conflict 1]: Resolution and rationale

## Final Backlog
[Summary of items by priority]

## Action Items
- ...

## Next Week Focus
- ...
```

### Step 8: Update Julz's Beliefs

Update `personas/julz/beliefs.md` with:
- Decisions made and rationale
- Prediction tracking
- Patterns observed

## Output

Provide summary:
- Meeting completed successfully
- Number of backlog items by priority
- Key decisions made
- Any unresolved issues
