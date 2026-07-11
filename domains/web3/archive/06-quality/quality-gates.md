# Quality Gates

**Document ID**: 04.1
**Domain**: Quality
**Status**: Draft

---

## Purpose

Defines the checkpoints that all knowledge must pass before being accepted into the knowledge base. Ensures that only verified, evidence-backed information enters the system.

## Audience

- Validation department (for execution)
- Researchers (for submission)
- QA (for verification)

## Quality Gate Philosophy

Quality gates are:
- **Mandatory**: No exceptions
- **Automated where possible**: Human review for judgment calls
- **Documented**: Every decision is logged
- **Appeallable**: Decisions can be challenged

---

## Gate Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            QUALITY GATE PIPELINE                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐              │
│   │ INPUT   │───▶│ GATE 1  │───▶│ GATE 2  │───▶│ GATE 3  │              │
│   │ REVIEW  │    │ Schema  │    │Evidence │    │Human    │              │
│   │         │    │Compliant│    │Check   │    │Review   │              │
│   └─────────┘    └─────────┘    └─────────┘    └────┬────┘              │
│                                                       │                    │
│                                                       ▼                    │
│   ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐              │
│   │ REJECT  │◀───│ GATE 4  │◀───│ GATE 5  │◀───│ GATE 6  │              │
│   │         │    │Consist. │    │Confid.  │    │Final    │              │
│   │         │    │Check    │    │Pass     │    │Approval │              │
│   └─────────┘    └─────────┘    └─────────┘    └────┬────┘              │
│                                                       │                    │
│                                                       ▼                    │
│                                               ┌─────────────┐              │
│                                               │ VALIDATED  │              │
│                                               │ KNOWLEDGE  │              │
│                                               └─────────────┘              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Gate Definitions

### Gate 1: Schema Compliance

**Purpose**: Ensure all required fields are present and correctly formatted.

**When**: Before any processing begins.

**Checks**:
```
□ All required fields present
□ All optional fields valid if present
□ Data types correct
□ Format validation (dates, URLs, etc.)
□ Enum values valid
□ ID uniqueness verified
```

**Failure Actions**:
- Reject with specific field errors
- Request resubmission with corrections

**Automation**: Fully automated

---

### Gate 2: Evidence Check

**Purpose**: Verify that claims are backed by sufficient evidence.

**When**: After schema validation, before processing.

**Evidence Requirements by Confidence Level**:

| Target Confidence | Minimum Evidence | Evidence Types Allowed |
|------------------|------------------|----------------------|
| 0.90 - 1.00 | 3+ sources | Primary only |
| 0.70 - 0.89 | 2+ sources | Primary or secondary |
| 0.50 - 0.69 | 1+ source | Any verified |
| 0.20 - 0.49 | Inference documented | Any |
| < 0.20 | Label as speculation | Any |

**Checks**:
```
□ Evidence sources provided
□ Source URLs/formats valid
□ Evidence directly supports claim
□ No conflicting evidence ignored
□ Evidence retrieval timestamps present
```

**Failure Actions**:
- Request additional evidence
- Lower confidence score to match evidence
- Mark as requiring human review

**Automation**: Partially automated (some checks require judgment)

---

### Gate 3: Human Review

**Purpose**: Human judgment on claims requiring expertise or judgment.

**When**: After automated evidence check.

**Triggers for Human Review**:
```
□ Confidence score < 0.70
□ Claim contradicts existing knowledge
□ Novel or unusual finding
□ High-stakes conclusion
□ Multiple conflicting evidence
□ Source reliability uncertain
□ Requested by submitter
```

**Review Criteria**:
```
□ Is the reasoning sound?
□ Are there alternative interpretations?
□ Is the confidence appropriate?
□ Are there missing considerations?
□ Is additional research needed?
```

**Review Outcomes**:
- **Approved**: Proceed to next gate
- **Rejected**: Return with feedback
- **Conditionally Approved**: Approved with modifications
- **Escalated**: Refer to expert

**Automation**: Human-only

---

### Gate 4: Consistency Check

**Purpose**: Verify the new knowledge doesn't contradict existing knowledge.

**When**: After human review, before final approval.

**Checks**:
```
□ No direct contradictions with existing entities
□ No conflicts with established relationships
□ Timeline consistency verified
□ Classification consistency (similar entities similar categories)
□ Confidence score consistent with similar entities
```

**Conflict Resolution**:
1. New evidence vs. old evidence: Prefer stronger evidence
2. Equal evidence: Flag for human review
3. Same entity: Merge or update
4. Different entities: Verify no overlap

**Failure Actions**:
- Merge with existing entity if duplicate
- Update existing entity if correction
- Create contradiction record if genuinely different view
- Escalate to human review if unresolved

**Automation**: Mostly automated (flagged cases human-reviewed)

---

### Gate 5: Confidence Pass

**Purpose**: Ensure the confidence score meets minimum threshold for incorporation.

**Minimum Thresholds**:

| Entity Type | Minimum Confidence | Rationale |
|-------------|-------------------|-----------|
| Protocol | 0.70 | Core data, high impact |
| Person | 0.75 | Identity critical |
| Organization | 0.70 | Attribution important |
| Opportunity | 0.60 | Worth exploring even with uncertainty |
| Trend | 0.65 | Market signals |
| Evidence | 0.80 | Supporting claims |

**Checks**:
```
□ Confidence score >= threshold for entity type
□ Confidence calculation documented
□ Factors contributing to confidence listed
□ Low confidence appropriately justified
```

**Failure Actions**:
- Return to submitter for more evidence
- Lower entity status to "draft"
- Create as unverified until evidence improves

**Automation**: Fully automated

---

### Gate 6: Final Approval

**Purpose**: Final validation before incorporation.

**When**: After all other gates passed.

**Final Checks**:
```
□ All gates passed
□ No pending issues from previous gates
□ Provenance chain complete
□ Related entities linked
□ Ready for knowledge base incorporation
```

**Approval Types**:
- **Full Approval**: Incorporated immediately
- **Provisional Approval**: Incorporated with flag for monitoring
- **Conditional Approval**: Incorporated with expiration date

**Automation**: Automated with human override capability

---

## Gate Metrics

| Gate | Pass Rate Target | Review Time Target | Failure Rate Target |
|------|-----------------|-------------------|-------------------|
| Gate 1: Schema | >98% | <1 min | <2% |
| Gate 2: Evidence | >85% | <5 min | <15% |
| Gate 3: Human | >70% | <30 min | <30% |
| Gate 4: Consistency | >95% | <2 min | <5% |
| Gate 5: Confidence | >90% | <1 min | <10% |
| Gate 6: Final | >99% | <30 sec | <1% |

---

## Quality Gate Bypass

**Emergency Bypass**:
- Requires explicit human approval
- Documented with reason
- Auto-flagged for post-facto review
- Time-limited

**Permanent Bypass**:
- Requires senior human reviewer approval
- Only for specific entity types
- Reviewed quarterly

---

## Dependencies

- `evidence-model.md` — Evidence standards
- `mission-lifecycle.md` — Mission quality gates
- `scoring-model.md` — Confidence scoring

## Related Documents

- `gap-detection.md` — Identifying quality gaps
- `evidence-model.md` — Detailed evidence requirements

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
