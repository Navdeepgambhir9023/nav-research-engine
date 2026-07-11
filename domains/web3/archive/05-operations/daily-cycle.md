# Daily Cycle

**Document ID**: 03.1
**Domain**: Operations
**Status**: Draft

---

## Purpose

Documents the daily autonomous research loop—how the ROS executes its core function each day. Ensures consistent, repeatable execution and provides the foundation for automated operation.

## Audience

- Operations team (for execution)
- Engineers (for automation)
- QA (for validation)

## Cycle Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              DAILY CYCLE                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌───────┐   ┌───────┐   ┌───────┐   ┌───────┐   ┌───────┐   ┌───────┐│
│  │ 06:00 │──▶│ 06:15 │──▶│ 08:00 │──▶│ 10:00 │──▶│ 14:00 │──▶│ 16:00 ││
│  │ Wake  │   │ Disc. │   │ Anal. │   │ Plan  │   │ Exec  │   │ Valid ││
│  └───────┘   └───────┘   └───────┘   └───────┘   └───────┘   └───────┘│
│      │                                                                    │
│      │         ┌─────────────────────────────────────────────────┐      │
│      │         │               KNOWLEDGE BASE                     │      │
│      │         │  Entities  │  Graph  │  Evidence  │  Missions   │      │
│      │         └─────────────────────────────────────────────────┘      │
│      │                                                                │      │
│      ▼                                                                ▼      │
│  ┌───────┐                                                        ┌───────┐│
│  │ Daily │◀───────────────────────────────────────────────────────│Daily  ││
│  │Report │                                                        │Status ││
│  └───────┘                                                        └───────┘│
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Phase Definitions

### Phase 0: Wake (06:00 - 06:15)

**Purpose**: Initialize the system and verify operational readiness.

**Actions**:
1. Check system state (should be IDLE)
2. Verify knowledge base accessibility
3. Check for any pending human reviews from previous day
4. Verify external API connections
5. Load any queued missions from previous cycles
6. Log system readiness

**Exit Criteria**:
- All systems operational
- Knowledge base accessible
- External dependencies reachable

**Escalation**:
- If systems not ready: Run failure recovery (`failure-recovery.md`)
- If human reviews pending: Alert operations team

---

### Phase 1: Discovery (06:15 - 08:00)

**Purpose**: Find new signals from monitored sources.

**Actions**:
1. Poll Web3 data sources:
   - On-chain activity (TVL, volume, new deployments)
   - Governance activity (proposals, votes)
   - Social signals (trending topics, sentiment)
   - News feeds (protocol news, regulatory updates)

2. Poll external integrations:
   - Consumr.ai for new consumer studies
   - Gemini for any pending research outputs

3. Process new signals:
   - Deduplicate against existing signals
   - Classify by type and priority
   - Calculate initial confidence scores
   - Store with provenance

4. Update signal inventory:
   - Mark stale signals
   - Archive expired signals
   - Generate discovery report

**Exit Criteria**:
- All monitored sources polled
- New signals classified and stored
- Discovery metrics logged

**Time Budget**: ~105 minutes (can be extended if sources are slow)

---

### Phase 2: Analysis (08:00 - 10:00)

**Purpose**: Enrich signals into insights.

**Actions**:
1. Select signals for analysis:
   - Priority signals (high/critical)
   - Signals from previous analysis needing refresh
   - Signals approaching expiration

2. For each signal:
   - Research background context
   - Cross-reference with knowledge base
   - Identify related entities
   - Build evidence chain
   - Generate confidence score
   - Form preliminary insights

3. Generate insights:
   - Synthesize findings
   - Identify implications
   - Detect knowledge gaps
   - Generate hypotheses

4. Quality check:
   - Verify evidence chains complete
   - Flag weak evidence for human review
   - Store enriched insights

**Exit Criteria**:
- All priority signals analyzed
- Insights generated with confidence scores
- Knowledge gaps identified

**Time Budget**: ~120 minutes

---

### Phase 3: Planning (10:00 - 10:30)

**Purpose**: Decide what to research today.

**Actions**:
1. Review insights from Analysis phase
2. Score opportunities (if insights indicate opportunities)
3. Generate daily research plan:
   - Prioritize missions
   - Allocate resources
   - Set time budgets
   - Identify dependencies

4. Create/update missions:
   - New missions from insights
   - Update existing mission priorities
   - Queue missions for execution

5. Generate daily plan document:
   - Mission list with priorities
   - Resource assignments
   - Expected outcomes
   - Risk factors

**Exit Criteria**:
- Daily plan generated
- Missions queued for execution
- Plan submitted for human review (if required)

**Time Budget**: ~30 minutes

---

### Phase 4: Execution (10:00 - 14:00)

**Purpose**: Execute the highest priority missions.

**Actions**:
1. Select top priority mission
2. Generate research prompts (using Gemini)
3. Execute research task
4. Collect outputs
5. Validate initial quality
6. Route to Validation

**Note**: Execution runs concurrently with Planning phase completion. Planning outputs flow into Execution as they complete.

**Parallel Execution**:
- Up to 3 missions can run concurrently
- Missions prioritized by score and resource availability
- Failed missions are retried once before moving to next

**Exit Criteria**:
- All planned missions executed OR
- Time budget exhausted

**Time Budget**: ~240 minutes

---

### Phase 5: Validation (14:00 - 16:00)

**Purpose**: Quality check all outputs before incorporation.

**Actions**:
1. Collect outputs from Execution phase
2. Run quality gates:
   - Evidence completeness check
   - Confidence score verification
   - Schema compliance check
   - Consistency with existing knowledge

3. Route to human review:
   - Low confidence items
   - Contradictory findings
   - High-impact conclusions

4. Approve valid outputs
5. Incorporate into knowledge base
6. Archive rejected items with rationale

**Exit Criteria**:
- All outputs reviewed
- Validated knowledge incorporated
- Human reviews submitted

**Time Budget**: ~120 minutes

---

### Phase 6: Report (16:00 - 16:30)

**Purpose**: Generate daily summary.

**Actions**:
1. Compile daily metrics:
   - Signals processed
   - Insights generated
   - Missions completed
   - Knowledge added
   - Human reviews needed

2. Generate daily report:
   - Executive summary
   - Key findings
   - Mission status
   - Knowledge base growth
   - Issues and alerts

3. Update dashboards
4. Schedule next cycle
5. Transition to IDLE state

**Time Budget**: ~30 minutes

---

## Daily Cycle Metrics

| Metric | Target | Alert Threshold |
|--------|--------|-----------------|
| Signals processed | >100 | <50 |
| Insights generated | >10 | <5 |
| Missions completed | >3 | <1 |
| Knowledge incorporated | >5 items | <2 |
| Cycle completion rate | 100% | <80% |
| Human review queue | <10 items | >20 items |

---

## Dependencies

- `state-machine.md` — System states and transitions
- `component-contracts.md` — Interfaces between phases
- `mission-lifecycle.md` — Mission execution details
- `runbook.md` — Step-by-step procedures

## Related Documents

- `weekly-cycle.md` — Weekly aggregation
- `failure-recovery.md` — Error handling
- `07-safety/human-oversight.md` — Human review protocols

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
