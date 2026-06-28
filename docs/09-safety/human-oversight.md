# Human Oversight

**Document ID**: 07.1
**Domain**: Safety
**Status**: Draft

---

## Purpose

Defines protocols for human review and intervention. Satisfies the "human-in-the-loop" principle and prevents autonomy failures by ensuring humans remain informed decision-makers.

## Audience

- Operations team (for review procedures)
- Architects (for system design)
- Leadership (for governance)

## Human-in-the-Loop Philosophy

> The ROS surfaces evidence and generates insights, but humans make decisions. The system serves human judgment, not replaces it.

Key principles:
1. **Informed consent**: Humans know what they're approving
2. **Meaningful review**: Review has actual influence
3. **Clear accountability**: Decisions are traceable to humans
4. **Escalation paths**: Humans can override any system decision

---

## Review Points

### Review Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    HUMAN-IN-THE-LOOP ARCHITECTURE                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   System Decision                                                           │
│         │                                                                   │
│         ▼                                                                   │
│   ┌─────────────┐                                                         │
│   │ Auto-OK?  │── No ──▶ Human Review Queue                               │
│   └──────┬─────┘         │                                                 │
│          │ Yes            │                                                 │
│          ▼                ▼                                                 │
│   ┌─────────────┐   ┌─────────────┐                                       │
│   │  Execute   │   │  Pending   │                                       │
│   │  (System)  │   │  Review   │                                       │
│   └─────────────┘   └──────┬──────┘                                       │
│                            │                                                │
│                   ┌────────┴────────┐                                      │
│                   │                 │                                      │
│                   ▼                 ▼                                      │
│            ┌─────────────┐   ┌─────────────┐                              │
│            │  Approved   │   │  Rejected   │                              │
│            │   (Human)  │   │   (Human)  │                              │
│            └─────────────┘   └─────────────┘                              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Review Types

### Type 1: Pre-Execution Review

**Purpose**: Approve missions before execution.

**When**: High-impact missions, novel approaches, significant resource allocation.

**Criteria**:
```
□ Mission priority >= P1
□ Novel approach or untested methodology
□ Resource allocation > threshold
□ Affects strategic decisions
□ Requested by submitter
```

**SLA**: 24 hours from submission

---

### Type 2: Quality Gate Review

**Purpose**: Validate outputs before incorporation.

**When**: Passed automated gates, needs human judgment.

**Criteria**:
```
□ Automated confidence < 0.70
□ Conflicting evidence detected
□ Novel conclusion reached
□ High-impact finding
□ Contradicts existing knowledge
```

**SLA**: 4 hours from submission

---

### Type 3: Escalation Review

**Purpose**: Handle system-identified issues.

**When**: System detects anomaly or uncertainty.

**Criteria**:
```
□ System confidence < 0.50
□ Multiple conflicting signals
□ Critical decision required
□ System state error
□ External event detected
```

**SLA**: 1 hour from escalation

---

### Type 4: Periodic Review

**Purpose**: Ongoing oversight of system behavior.

**When**: Scheduled, not triggered by events.

**Frequency**:
- Daily: Quick status check
- Weekly: Quality metrics review
- Monthly: Comprehensive system review

**Scope**:
```
□ Review system metrics
□ Audit recent decisions
□ Check for drift
□ Adjust thresholds
□ Update priorities
```

---

## Review Workflow

### Standard Review Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          REVIEW WORKFLOW                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   1. SUBMIT                                                                 │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ System queues item for review                                          │  │
│   │ Includes: item details, context, supporting evidence, recommendations │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                         │
│                                    ▼                                         │
│   2. NOTIFY                                                                 │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ • Assign to reviewer (based on expertise)                              │  │
│   │ • Send notification with priority and SLA                             │  │
│   │ • Add to review dashboard                                            │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                         │
│                                    ▼                                         │
│   3. REVIEW                                                                 │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ Reviewer examines:                                                     │  │
│   │ • Evidence quality                                                     │  │
│   │ • Reasoning soundness                                                 │  │
│   │ • Alternative considerations                                          │  │
│   │ • System recommendation                                               │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                         │
│                                    ▼                                         │
│   4. DECIDE                                                                 │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ Options:                                                              │  │
│   │ • Approve (proceed with system recommendation)                        │  │
│   │ • Approve with modifications                                          │  │
│   │ • Reject (provide rationale)                                           │  │
│   │ • Escalate (request expert review)                                    │  │
│   │ • Defer (need more information)                                       │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                         │
│                                    ▼                                         │
│   5. DOCUMENT                                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ • Record decision and rationale                                        │  │
│   │ • Update system based on decision                                     │  │
│   │ • Flag for learning if decision differs from system                   │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Review Dashboard

### Dashboard Information

Reviewers see:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          REVIEW DASHBOARD                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Pending Reviews: 5                                                       │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │ Priority │ Type       │ Submitted │ SLA       │ Assignee │ Action   │  │
│  ├─────────────────────────────────────────────────────────────────────┤  │
│  │ P1       │ Quality   │ 2h ago   │ 2h left   │ [User]   │ [Review] │  │
│  │ P2       │ Escalate  │ 1h ago   │ 0h left   │ [User]   │ [Review] │  │
│  │ P2       │ Pre-Exec  │ 4h ago   │ 20h left  │ [User]   │ [Review] │  │
│  │ P3       │ Quality   │ 6h ago   │ 18h left  │ [User]   │ [Review] │  │
│  │ P3       │ Escalate  │ 12h ago  │ 12h left  │ [User]   │ [Review] │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
│  Metrics (Last 7 Days)                                                     │
│  ┌──────────────────────────────────────────────────���──────────────────┐  │
│  │ Reviews completed: 45    Avg time: 2.3h    SLA compliance: 94%     │  │
│  │ Approvals: 38 (84%)     Rejections: 7 (16%)    Escalations: 3      │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Escalation Paths

### Escalation Levels

| Level | Trigger | Escalates To | SLA |
|-------|---------|--------------|-----|
| **L1** | Standard review needed | Assigned reviewer | 24h |
| **L2** | SLA at risk | Review lead | 4h |
| **L3** | Critical decision | Senior analyst | 1h |
| **L4** | System failure | Lead researcher | 30 min |

### Escalation Triggers

```
□ SLA breach imminent
□ High-stakes decision
□ Conflict between reviewers
□ Novel situation
□ System recommendation clearly wrong
□ External event requires immediate action
```

---

## Override Authority

### Override Matrix

| Decision Type | Can Override | Requires Documentation |
|--------------|--------------|----------------------|
| Mission approval | Lead Researcher | Yes |
| Knowledge rejection | Lead Researcher | Yes |
| Scoring adjustment | Senior Analyst | Yes |
| System parameter change | Lead Researcher, Ops Lead | Yes |
| Emergency shutdown | Any reviewer | Post-factum |

### Override Process

```
1. Identify override needed
2. Document reasoning
3. Implement override
4. Notify stakeholders
5. Review override (within 48h)
6. Update system if appropriate
```

---

## Review Metrics

| Metric | Target | Alert |
|--------|--------|-------|
| Review completion rate | >95% | <90% |
| SLA compliance | >95% | <90% |
| Avg review time | <4 hours | >8 hours |
| Override rate | <10% | >20% |
| Escalation rate | <5% | >10% |

---

## Training and Calibration

### Reviewer Training

Required for all reviewers:
```
□ Understanding of ROS principles
□ Evidence evaluation methodology
□ Confidence scoring approach
□ Review interface training
□ Calibration exercise (annual)
```

### Calibration Process

Quarterly calibration:
1. Review sample cases with known correct answers
2. Compare reviewer decisions against gold standard
3. Identify drift and address in training
4. Update guidelines if needed

---

## Dependencies

- `state-machine.md` — Review triggers
- `mission-lifecycle.md` — Mission reviews
- `scoring-model.md` — Score adjustments

## Related Documents

- `07-safety/error-taxonomy.md` — Error escalation
- `03-operations/runbook.md` — Review procedures
- `07-safety/audit-logging.md` — Decision logging

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
