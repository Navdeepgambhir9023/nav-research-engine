# Weekly Cycle

**Document ID**: 03.2
**Domain**: Operations
**Status**: Draft

---

## Purpose

Documents the weekly review and intelligence report generation cycle. Bridges daily execution to strategic review and provides stakeholders with consolidated insights.

## Audience

- Analysts (for review)
- Leadership (for consumption)
- Operations (for execution)

## Cycle Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                             WEEKLY CYCLE                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Monday                                                             Friday  │
│  ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐   │
│  │ 7d  │──▶│Weekly│──▶│Trend │──▶│Opport│──▶│Report│──▶│Prior│──▶│Exec │
│  │Agg. │   │Review│   │ Anal │   │ Rnk  │   │Draft │   │Next │   │Summ ││
│  └─────┘   └─────┘   └─────┘   └─────┘   └─────┘   └─────┘   └─────┘   │
│     │                                                                        │
│     ▼                                                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    WEEKLY INTELLIGENCE REPORT                        │   │
│  │  • Executive Summary                                                 │   │
│  │  • Key Findings (3-5)                                               │   │
│  │  • Opportunity Rankings                                             │   │
│  │  • Trend Analysis                                                   │   │
│  │  • Recommended Actions                                              │   │
│  │  • Knowledge Base Growth                                            │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Phase Definitions

### Phase 1: 7-Day Aggregation (Monday)

**Purpose**: Compile all daily outputs into weekly aggregates.

**Actions**:
1. Aggregate daily metrics:
   - Total signals processed
   - Total insights generated
   - Total missions completed
   - Knowledge base growth
   - Human review statistics

2. Compile daily reports:
   - Merge daily findings
   - Identify recurring themes
   - Flag items needing attention

3. Update weekly dashboards:
   - Volume trends
   - Quality metrics
   - Resource utilization

**Output**: Weekly Metrics Summary

---

### Phase 2: Weekly Review (Monday - Tuesday)

**Purpose**: Human review of the week's output.

**Actions**:
1. Review aggregated insights:
   - Identify key findings
   - Validate conclusions
   - Provide additional context

2. Assess mission outcomes:
   - Review completed missions
   - Evaluate research quality
   - Identify gaps

3. Update knowledge base:
   - Incorporate human corrections
   - Resolve conflicts
   - Update confidence scores

4. Document lessons learned:
   - What worked well
   - What needs improvement
   - Resource allocation effectiveness

**Output**: Reviewed and validated weekly data

---

### Phase 3: Trend Analysis (Wednesday)

**Purpose**: Identify patterns across the week.

**Actions**:
1. Trend detection:
   - Compare to previous weeks
   - Identify emerging patterns
   - Detect anomalies

2. Cross-signal analysis:
   - Correlate signals across sources
   - Identify converging evidence
   - Detect contradictory signals

3. Temporal analysis:
   - Day-of-week patterns
   - Time-to-insight metrics
   - Confidence drift over time

4. Generate trend report:
   - Rising trends
   - Declining trends
   - Stable elements
   - Emerging opportunities

**Output**: Trend Analysis Report

---

### Phase 4: Opportunity Ranking (Thursday)

**Purpose**: Consolidate and rank all opportunities.

**Actions**:
1. Collect opportunities:
   - From daily insights
   - From completed missions
   - From external inputs

2. Score opportunities:
   - Apply scoring model
   - Factor in trend data
   - Consider strategic alignment

3. Generate rankings:
   - Top 10 opportunities
   - By category
   - By timeframe
   - By risk level

4. Update opportunity pipeline:
   - Close completed opportunities
   - Archive rejected opportunities
   - Queue new opportunities

**Output**: Ranked Opportunity List

---

### Phase 5: Report Drafting (Thursday - Friday)

**Purpose**: Create the weekly intelligence report.

**Report Structure**:

```markdown
# Weekly Intelligence Report
**Week of [DATE]**

## Executive Summary
[2-3 paragraph overview of key findings]

## Key Findings
1. [Finding 1 with evidence]
2. [Finding 2 with evidence]
3. [Finding 3 with evidence]

## Opportunity Rankings
1. [Opportunity] - Score: XX/100
2. [Opportunity] - Score: XX/100
...

## Trend Analysis
### Rising
- [Trend 1]
- [Trend 2]

### Declining
- [Trend 1]
- [Trend 2]

## Knowledge Base Growth
- Entities added: XX
- Relationships: XX
- Evidence chains: XX

## Recommended Actions
1. [Action 1]
2. [Action 2]
3. [Action 3]

## Appendix
- Detailed metrics
- Source references
```

**Output**: Weekly Intelligence Report (Draft)

---

### Phase 6: Prioritize Next Week (Friday)

**Purpose**: Set up the next week's execution.

**Actions**:
1. Review current queue:
   - Pending missions
   - High-priority gaps
   - Stakeholder requests

2. Plan next week:
   - Resource allocation
   - Mission priorities
   - Focus areas

3. Update runbooks:
   - Incorporate improvements
   - Document changes

4. Brief stakeholders:
   - Send weekly report
   - Schedule review meeting
   - Collect feedback

---

## Weekly Metrics

| Metric | Description | Target |
|--------|-------------|--------|
| Insights generated | Total insights from week | >50 |
| Opportunities identified | New opportunities | >10 |
| Missions completed | Research missions done | >10 |
| Knowledge growth | New entities + relationships | >50 |
| Report quality | Stakeholder satisfaction | >80% |
| Cycle adherence | Planned vs actual execution | >90% |

---

## Dependencies

- `daily-cycle.md` — Daily execution that feeds weekly
- `scoring-model.md` — Opportunity scoring
- `evidence-model.md` — Evidence standards

## Related Documents

- `daily-cycle.md` — Daily operations
- `03-operations/mission-lifecycle.md` — Mission handling
- `runbook.md` — Execution procedures

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
