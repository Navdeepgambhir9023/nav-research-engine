# Mission Lifecycle

**Document ID**: 03.3
**Domain**: Operations
**Status**: Draft

---

## Purpose

Describes how research missions are created, executed, tracked, and closed. Manages the research pipeline systematically from identification to incorporation.

## Audience

- Operations team (for execution)
- Planners (for mission creation)
- Analysts (for research execution)

## Mission Definition

A **Mission** is a discrete unit of research work with:
- Clear objectives
- Defined scope
- Acceptance criteria
- Resource estimates
- Priority ranking

---

## Lifecycle State Machine

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           MISSION LIFECYCLE                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐         │
│    │ PROPOSED │───▶│ APPROVED │───▶│ QUEUED   │───▶│PLANNING  │         │
│    └──────────┘    └──────────┘    └──────────┘    └────┬─────┘         │
│         │                │               │               │                │
│         │ Reject         │               │               ▼                │
│         │                │               │         ┌──────────┐         │
│         ▼                ▼               │         │BLOCKED   │         │
│    ┌──────────┐    ┌──────────┐         │         └──────────┘         │
│    │ REJECTED │    │ QUEUED   │◀────────┘               │                │
│    └──────────┘    └──────────┘                         │                │
│                                                     Unblock              │
│    ┌────────────────────────────────────────────────────┘                │
│    │                                                                     │
│    ▼                                                                     │
│    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐         │
│    │IN_PROG.  │───▶│ REVIEW   │───▶│COMPLETED │───▶│VALIDATED│         │
│    └──────────┘    └──────────┘    └──────────┘    └──────────┘         │
│         │                │                                           (terminal)
│         │                 │ Reject                                       │
│         │                 ▼                                              │
│         │            ┌──────────┐                                       │
│         └───────────▶│  FAILED  │                                       │
│                      └──────────┘                                       │
│                                                                            │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## State Definitions

### PROPOSED

**Description**: Mission created, awaiting approval.

**Entry**: Created by Planning department from insights or gap detection.

**Required Fields**:
- Title and description
- Objectives (list)
- Scope boundaries
- Expected duration
- Required capabilities

**Exit Criteria**:
- Objectives are clear and testable
- Scope is bounded
- Resources are estimated
- Passed initial validation

**Exit To**:
- `APPROVED`: Meets criteria
- `REJECTED`: Does not meet criteria

---

### APPROVED

**Description**: Mission accepted, ready to enter queue.

**Entry**: Passed proposal review.

**Actions**:
- Assign priority score
- Check resource availability
- Identify dependencies
- Create initial checkpoints

**Exit Criteria**:
- Priority assigned
- Dependencies identified
- Resources available (or waiting)

**Exit To**:
- `QUEUED`: Resources available
- `BLOCKED`: Waiting on dependencies

---

### QUEUED

**Description**: Waiting for execution resources.

**Entry**: Approved, waiting for slot.

**Actions**:
- Monitor resource availability
- Update queue position based on priority
- Check for dependency resolution

**Exit Criteria**:
- Execution resources available
- All dependencies resolved

**Exit To**:
- `IN_PROGRESS`: Ready to execute

---

### BLOCKED

**Description**: Waiting on dependency or input.

**Entry**: Dependencies not available.

**Resolution Triggers**:
- Dependency completed
- Required input received
- Human override

**Exit To**:
- `QUEUED`: Dependency resolved
- `FAILED`: Dependency failed permanently

---

### IN_PROGRESS

**Description**: Actively being researched.

**Entry**: Resources allocated, execution started.

**Checkpoints**:
```
Milestone 1: Research Plan Complete
    ↓
Milestone 2: Data Collection Complete
    ↓
Milestone 3: Analysis Complete
    ↓
Milestone 4: Draft Report Complete
```

**Progress Tracking**:
- Checkpoints completed
- Time elapsed vs estimate
- Blockers identified

**Exit Criteria**:
- All objectives addressed
- All acceptance criteria met
- Draft report generated

**Exit To**:
- `REVIEW`: Ready for quality check
- `BLOCKED`: Blocker encountered
- `FAILED`: Unrecoverable error

---

### REVIEW

**Description**: Awaiting quality gate review.

**Entry**: Research completed.

**Quality Gate Checks**:
1. Evidence completeness
2. Conclusion validity
3. Schema compliance
4. Consistency check

**Exit Criteria**:
- All quality gates passed
- Minor issues documented

**Exit To**:
- `COMPLETED`: Passed review
- `FAILED`: Major quality issues

---

### COMPLETED

**Description**: Passed review, outputs ready.

**Entry**: Quality gates passed.

**Outputs**:
- Research report
- Evidence chains
- New entities (if applicable)
- Recommendations

**Actions**:
- Notify stakeholders
- Archive research materials
- Update knowledge base with derived knowledge

**Exit Criteria**:
- Stakeholders notified
- Materials archived
- Knowledge base updated

**Exit To**:
- `VALIDATED`: Incorporated into knowledge base

---

### VALIDATED

**Description**: Incorporated into knowledge base.

**Entry**: Outputs accepted.

**Actions**:
- Merge into knowledge graph
- Update entity relationships
- Close mission record

**Terminal State**: Mission complete.

---

### REJECTED

**Description**: Mission proposal rejected.

**Entry**: Proposal review failed.

**Reasons**:
- Out of scope
- Insufficient value
- Duplicate of existing mission
- Resource constraints

**Terminal State**: Mission not executed.

---

### FAILED

**Description**: Mission execution failed.

**Entry**: Execution or review failed.

**Reasons**:
- Execution error
- Quality gates failed
- Dependency failed
- Time limit exceeded

**Actions**:
- Document failure reason
- Log lessons learned
- Create follow-up if appropriate

**Terminal State**: Mission unsuccessful.

---

## Mission Creation Process

### Trigger Sources

| Trigger | Description | Priority |
|---------|-------------|----------|
| Gap Detection | Knowledge gap identified | High |
| Opportunity Signal | Opportunity detected | High |
| Stakeholder Request | Explicit request | Medium |
| Scheduled Review | Periodic deep-dive | Medium |
| Trend Alert | Emerging trend needs analysis | High |
| Quality Gap | Evidence weakness found | Medium |

### Mission Template

```markdown
# Mission: [Title]

**Mission ID**: [UUID]
**Status**: [Current Status]
**Created**: [Date]

## Objectives
1. [Objective 1]
2. [Objective 2]
3. [Objective 3]

## Scope
### In Scope
- [Item 1]
- [Item 2]

### Out of Scope
- [Item 1]
- [Item 2]

## Acceptance Criteria
- [ ] [Criteria 1]
- [ ] [Criteria 2]
- [ ] [Criteria 3]

## Resources
- Estimated Duration: [X hours/days]
- Required Capabilities: [List]
- Priority: [P1/P2/P3]

## Dependencies
- [Dependency 1]
- [Dependency 2]

## Checkpoints
- [ ] Milestone 1
- [ ] Milestone 2
- [ ] Milestone 3

## Results
[To be filled upon completion]

## Notes
[Additional information]
```

---

## Mission Metrics

| Metric | Target | Alert |
|--------|--------|-------|
| Completion rate | >90% | <80% |
| Average duration | Within 20% of estimate | >50% over |
| Quality pass rate | >95% | <90% |
| Queue wait time | <24 hours | >48 hours |

---

## Dependencies

- `state-machine.md` — Mission states
- `daily-cycle.md` — Daily execution
- `quality-gates.md` — Quality gate criteria

## Related Documents

- `daily-cycle.md` — Mission execution in context
- `runbook.md` — Step-by-step procedures
- `failure-recovery.md` — Error handling

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
