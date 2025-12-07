# Design Decisions

This document captures the key design decisions made while building the ha-mcp-mgr system.

## Decision 1: Persona-Based Architecture

**Context**: Need a way to review ha-mcp from multiple perspectives without bias.

**Decision**: Create distinct personas with specialized focus areas.

**Rationale**:
- A single reviewer tends to focus on their strengths
- Different stakeholders care about different things
- Separation forces comprehensive coverage
- Conflicts between personas surface trade-offs

**Alternatives Considered**:
- Single comprehensive reviewer → Too much for one perspective
- Checklist-based review → Loses nuance and judgment
- Random sampling → Misses systematic issues

---

## Decision 2: Self-Evolving Personas

**Context**: Personas need to learn from past reviews.

**Decision**: Each persona maintains `beliefs.md` and can update their `CLAUDE.md`.

**Rationale**:
- Static personas would repeat same observations
- Learning enables pattern recognition
- Self-evolution allows system improvement
- Documented beliefs provide transparency

**Trade-offs**:
- Risk of belief drift
- Need for periodic human review
- Storage growth over time

---

## Decision 3: Julz as Coordinator

**Context**: Need someone to synthesize all persona inputs.

**Decision**: Julz persona with authority to make final decisions and ask follow-ups.

**Rationale**:
- Prevents deadlock between personas
- Mirrors real project leadership
- Can resolve conflicts with documented reasoning
- Has latitude to steer direction

**Key Powers**:
- Override individual persona priorities
- Ask follow-up questions
- Approve/reject capability requests
- Set strategic direction

---

## Decision 4: Git Submodule for ha-mcp

**Context**: Need to analyze ha-mcp code and track which version was reviewed.

**Decision**: Include ha-mcp as git submodule; commit pointer serves as meeting timestamp.

**Rationale**:
- Submodule commit = precise point in history
- Can trace back what code each meeting analyzed
- No need to re-clone each time
- Git history shows review progression

**Implementation**:
```bash
# Update before meeting
cd ha-mcp && git checkout origin/main && cd ..
git add ha-mcp  # Records the commit

# Later: what did meeting X analyze?
git show <meeting-commit>:ha-mcp  # Shows submodule pointer
```

---

## Decision 5: UAT Test Environment

**Context**: Personas need to actually test ha-mcp, not just read code.

**Decision**: Configure MCP server pointing to UAT instance (ha-mcp-uat-server.qc-h.net).

**Rationale**:
- Code review misses runtime issues
- Real testing validates usability claims
- UAT environment is safe for experiments
- "demo" token simplifies setup

**Configuration** (`.mcp.json`):
```json
{
  "mcpServers": {
    "ha-mcp-uat": {
      "env": {
        "HOMEASSISTANT_URL": "https://ha-mcp-uat-server.qc-h.net",
        "HOMEASSISTANT_TOKEN": "demo"
      }
    }
  }
}
```

---

## Decision 6: Deliverables System

**Context**: Personas need persistent documents beyond weekly reports.

**Decision**: Each persona maintains `deliverables/` folder with active documents, `archive/` for old ones.

**Rationale**:
- Reports are ephemeral; deliverables persist
- Examples: Tech Lead's architecture doc, Product Owner's roadmap
- Archive prevents folder bloat
- Creates institutional knowledge

**Deliverable Lifecycle**:
1. Create in `deliverables/`
2. Update over multiple cycles
3. When obsolete, move to `archive/`

---

## Decision 7: Cross-Meeting Context

**Context**: Key decisions and patterns get lost between meetings.

**Decision**: Maintain `meetings/context.md` as persistent memory.

**Rationale**:
- Weekly reports are too granular
- Need high-level patterns and decisions
- Prevents re-discussing solved problems
- Enables trend detection

**Contents**:
- Strategic direction
- Recurring patterns
- Major decisions and outcomes
- Items to carry forward

---

## Decision 8: Memory Pruning

**Context**: Reports and notes accumulate indefinitely.

**Decision**: Auto-prune files older than configured thresholds (12 weeks reports, 8 weeks notes).

**Rationale**:
- Unbounded growth causes issues
- Old reports rarely referenced
- Context.md preserves important learnings
- Git history still available if needed

**Configuration** (`config.json`):
```json
"memory_limits": {
  "reports_keep_weeks": 12,
  "notes_keep_weeks": 8,
  "auto_prune": true
}
```

---

## Decision 9: Issue Linking and Attribution

**Context**: Backlog items should connect to real GitHub issues.

**Decision**:
- Search existing issues before creating new ones
- All created issues assigned to julienld
- Auto-assignment triggers email notification

**Rationale**:
- Prevents duplicate issues
- Connects management system to real work
- Assignment ensures human awareness
- Email notification for important items

**Implementation**:
```bash
# Search
./scripts/link-issues.sh search "keyword"

# Create with assignment
gh issue create --assignee "julienld" ...
```

---

## Decision 10: Retrospective Persona

**Context**: The management system itself needs review and improvement.

**Decision**: Add 11th persona focused on process effectiveness.

**Rationale**:
- Meta-level optimization often neglected
- Can detect when personas aren't effective
- Tracks decision quality over time
- Proposes process improvements

**Unique Responsibilities**:
- Reviews past decisions for accuracy
- Monitors persona activity/staleness
- Updates cross-meeting context
- Proposes simplifications

---

## Decision 11: GitHub Pages Dashboard

**Context**: Need visual representation of project health.

**Decision**: Generate HTML dashboard deployed to GitHub Pages.

**Rationale**:
- Quick visual health check
- No external dependencies
- Auto-updated via GitHub Actions
- Historical metrics in CSV

**Metrics Displayed**:
- GitHub stats (stars, forks, issues)
- Weekly activity (commits, PRs)
- Backlog distribution (P0-P3)

---

## Decision 12: First-Meeting Bootstrap

**Context**: First run needs comprehensive analysis, not incremental.

**Decision**: Separate `first-meeting.sh` script for initial bootstrap.

**Rationale**:
- First meeting establishes all baselines
- Subsequent meetings are incremental
- Different prompting for comprehensive vs delta analysis
- Sets up context.md properly

**Differences from Weekly**:
- More thorough initial analysis
- Establishes baseline metrics
- Populates all beliefs from scratch
- Creates initial deliverables

---

## Decision 13: Parallel Persona Execution

**Context**: Running 11 personas sequentially would be slow.

**Decision**: Use Claude Code Task tool to run personas in parallel.

**Rationale**:
- Independence allows parallelization
- Significant time savings (11x faster theoretical)
- Each persona self-contained
- Julz synthesizes at end

**Implementation**:
```markdown
# In weekly-review.md
Run ALL persona analyses in parallel using the Task tool.
```

---

## Decision 14: Structured Report Formats

**Context**: Persona reports need consistency for Julz to synthesize.

**Decision**: Each persona has a defined report format in their CLAUDE.md.

**Rationale**:
- Consistent structure aids comparison
- Required sections ensure coverage
- Julz knows where to find key info
- Templates in `templates/` folder

**Common Sections**:
- Summary
- Key Observations
- Concerns
- Proposed Backlog Items
- Tool/Capability Needs

---

## Anti-Patterns Avoided

### 1. Monolithic Review
❌ One AI doing everything
✅ Specialized personas with focused concerns

### 2. Stateless Analysis
❌ Starting fresh each time
✅ Evolving beliefs and persistent context

### 3. Disconnected Recommendations
❌ Suggestions that go nowhere
✅ Linked to GitHub issues with assignment

### 4. Process Rigidity
❌ Fixed process that can't improve
✅ Retrospective persona for meta-optimization

### 5. Unbounded Growth
❌ Accumulating files forever
✅ Memory pruning with configurable limits
