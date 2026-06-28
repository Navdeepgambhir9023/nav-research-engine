# ADR Index

**Document ID**: 01.6
**Domain**: Architecture
**Status**: Draft

---

## Purpose

Provides a navigable index of all Architecture Decision Records (ADRs) created for the ROS. Each ADR captures a significant decision, its context, alternatives considered, and the rationale for the chosen approach.

## Audience

- Architects reviewing system design
- Engineers implementing features
- Contributors understanding why the system is designed a certain way

## What is an ADR?

An Architecture Decision Record documents a significant architectural choice:

- **Significant**: Affects system structure, cross-cutting concerns, or long-term maintainability
- **Context**: The situation that prompted the decision
- **Decision**: What was chosen
- **Alternatives**: What else was considered
- **Consequences**: What happens as a result (positive and negative)

## ADR Format

Each ADR follows this structure:

```markdown
# ADR-[NUMBER]: [Title]

**Status**: [Proposed | Accepted | Deprecated | Superseded]
**Date**: [YYYY-MM-DD]
**Deciders**: [Names of decision makers]

## Context
[Describe the situation and forces at play]

## Decision
[Describe the decision that was made]

## Alternatives Considered
1. [Alternative 1] — [Brief description]
2. [Alternative 2] — [Brief description]
...

## Consequences
### Positive
- [Benefit 1]
- [Benefit 2]

### Negative
- [Downside 1]
- [Downside 2]

## References
- [Link to relevant docs]
- [Related ADRs]
```

## ADR Repository

ADRs are stored in `docs/01-architecture/decisions/` as individual markdown files.

### Naming Convention

```
ADR-[NUMBER]-[short-title].md
```

Example: `ADR-001-knowledge-base-location.md`

---

## Decision Index

| ADR # | Title | Status | Date | Domain |
|-------|-------|--------|------|--------|
| (none yet) | | | | |

### Pending Decisions

The following architectural questions need ADRs:

| Topic | Question | Priority |
|-------|----------|----------|
| Knowledge Base Format | Markdown files, SQLite, or graph database? | High |
| LLM Integration | Direct API calls or framework abstraction? | High |
| State Persistence | File-based, database, or git-native? | Medium |
| Quality Thresholds | How to determine evidence strength thresholds? | Medium |
| Scoring Model | What factors drive opportunity scoring? | Medium |

---

## How to Create an ADR

### When to Create an ADR

Create an ADR when:

1. A decision affects multiple components or departments
2. The decision is difficult to reverse
3. The decision represents a significant trade-off
4. Multiple alternatives were seriously considered
5. The decision deviates from existing patterns

### When NOT to Create an ADR

Do not create an ADR for:

1. Routine implementation decisions
2. Decisions easily reversed
3. Trivial choices with no trade-offs
4. Following established patterns without deviation

### Process

1. **Draft**: Create the ADR file with all sections
2. **Proposed**: Share with stakeholders for review
3. **Discuss**: Gather feedback and alternatives
4. **Decide**: Document the final decision
5. **Accept**: Mark as Accepted and file in the index

### Review Period

- Standard decisions: 3 days
- Significant decisions: 1 week
- Critical decisions: 2 weeks + explicit approval

---

## Superseded and Deprecated ADRs

### Superseded ADRs

An ADR is **Superseded** when a later ADR replaces it:

```
# ADR-003: Original Decision

**Status**: Superseded by [ADR-005]
**Date**: 2024-01-15
**Superseded by**: ADR-005
```

### Deprecated ADRs

An ADR is **Deprecated** when the decision it records is no longer relevant:

```
# ADR-007: Temporary Solution

**Status**: Deprecated (2026-06-29)
**Reason**: No longer applicable after migration to new system
```

---

## Dependencies

- `principles.md` — Design principles that guide decisions
- Individual ADR files in `decisions/` directory

## Related Documents

- `system-context.md` — System boundaries that frame decisions
- `component-contracts.md` — Technical decisions about interfaces
- `05-evolution/changelog.md` — Tracks when ADRs are filed

## Maintenance

This index should be updated whenever:
- A new ADR is created
- An ADR status changes
- An ADR is superseded or deprecated

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
