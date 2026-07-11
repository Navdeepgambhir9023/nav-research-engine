# Gap Detection

**Document ID**: 04.4
**Domain**: Quality
**Status**: Draft

---

## Purpose

Defines the criteria and methods for identifying knowledge gaps—areas where the knowledge base lacks sufficient information. Enables the autonomous detection of areas needing research.

## Audience

- Analysis department (for gap identification)
- Planning department (for gap prioritization)
- Researchers (for understanding requirements)

## Gap Philosophy

> A well-identified gap is half-filled. The other half requires evidence.

Key principles:
1. **Specificity**: Gaps must be concrete, not vague
2. **Measurability**: Progress toward filling gaps must be trackable
3. **Prioritization**: Not all gaps are equal; rank by impact
4. **Traceability**: Link gaps to decisions they affect

---

## Gap Types

### Coverage Gaps

**Definition**: Topics or entities not present in the knowledge base.

**Detection**:
```
□ Entity not found when expected
□ Topic has no related entities
□ Category has no members
□ Geographic region not covered
```

**Example**:
> "We have no information about Layer 3 protocols despite significant activity in this space."

---

### Depth Gaps

**Definition**: Existing knowledge is insufficient for confident decisions.

**Detection**:
```
□ Confidence score below threshold
□ Key properties missing
□ Relationships not mapped
□ Evidence chain incomplete
```

**Example**:
> "We know Uniswap exists (coverage) but lack data on V4 specifications, governance structure, and competitive positioning (depth)."

---

### Currency Gaps

**Definition**: Knowledge is outdated and may no longer be accurate.

**Detection**:
```
□ Last updated > threshold (30 days for fast-moving, 90 days for stable)
□ Significant events not reflected
□ Contradicted by newer sources
□ Stale flag triggered
```

**Example**:
> "TVL data is 45 days old; significant market movements may have occurred."

---

### Consistency Gaps

**Definition**: Contradictory information exists without resolution.

**Detection**:
```
□ Multiple entities claim same relationship
□ Timeline conflicts detected
□ Conflicting evidence chains
□ Duplicate entities detected
```

**Example**:
> "Two sources disagree on Uniswap's founding date; resolution needed."

---

### Completeness Gaps

**Definition**: Required dimensions or fields are missing.

**Detection**:
```
□ Mandatory fields empty
□ Required relationships absent
□ Missing supporting evidence
□ Schema validation failures
```

**Example**:
> "Protocol entity is missing: launch date, token address, team information."

---

## Gap Detection Methods

### Automated Detection

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      AUTOMATED GAP DETECTION                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Continuous Monitoring                                                     │
│   ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐       │
│   │ Coverage│  │ Depth   │  │Currency │  │Consist. │  │Complet. │       │
│   │ Monitor │  │ Monitor │  │ Monitor │  │ Monitor │  │ Monitor │       │
│   └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘       │
│        │            │            │            │            │              │
│        ▼            ▼            ▼            ▼            ▼              │
│   ┌─────────────────────────────────────────────────────────────────┐    │
│   │                     GAP AGGREGATOR                                │    │
│   │   • Deduplicate across monitors                                   │    │
│   │   • Calculate impact scores                                      │    │
│   │   • Assign to categories                                         │    │
│   └─────────────────────────────────────────────────────────────────┘    │
│                                │                                           │
│                                ▼                                           │
│   ┌─────────────────────────────────────────────────────────────────┐    │
│   │                     GAP REGISTRY                                 │    │
│   └─────────────────────────────────────────────────────────────────┘    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Monitor Definitions

#### Coverage Monitor

```yaml
monitor: coverage
frequency: daily
checks:
  - name: expected_entity_missing
    description: Expected entity not in knowledge base
    trigger: referenced but not found
    
  - name: category_empty
    description: Category with no members
    trigger: category has zero entities
    
  - name: geographic_gap
    description: Region not covered
    trigger: reference to uncovered region
```

#### Depth Monitor

```yaml
monitor: depth
frequency: continuous
checks:
  - name: low_confidence_entity
    description: Entity confidence below threshold
    trigger: confidence < 0.70
    
  - name: incomplete_relationships
    description: Entity missing expected relationships
    trigger: relationship_count < expected_minimum
    
  - name: weak_evidence_chain
    description: Evidence chain below strength threshold
    trigger: evidence_strength < 0.60
```

#### Currency Monitor

```yaml
monitor: currency
frequency: hourly
checks:
  - name: stale_entity
    description: Entity not updated within threshold
    trigger: last_updated > staleness_threshold
    
  - name: contradicted_by_fresh
    description: Fresh source contradicts existing knowledge
    trigger: new_source conflicts with old_data
    
  - name: event_not_reflected
    description: Significant event not in knowledge base
    trigger: major_event detected but not linked
```

---

## Gap Properties

Each gap has the following properties:

```yaml
gap:
  id: string                    # UUID
  type: enum                   # coverage | depth | currency | consistency | completeness
  category: string              # Protocol, Person, Event, etc.
  subject: string               # What is missing
  
  # Description
  title: string                # Short title
  description: string           # Detailed description
  impact: string                # Why this gap matters
  
  # Assessment
  severity: enum                # critical | high | medium | low
  priority: number              # 1-100
  affected_decisions: [string]  # What decisions this affects
  
  # Requirements
  required_evidence: string     # What evidence would fill this gap
  evidence_threshold: number    # Minimum evidence needed
  success_criteria: [string]     # How we know gap is filled
  
  # Tracking
  status: enum                  # open | in_progress | resolved | wont_fix
  created_at: datetime
  updated_at: datetime
  resolved_at: datetime         # If resolved
  resolution: string            # How it was resolved
  
  # Relationships
  triggers: [string]            # What detected this gap
  related_gaps: [string]        # Related gaps
  filled_by: [string]           # Missions that address this gap
```

---

## Gap Severity Classification

| Severity | Definition | Response Time | Example |
|----------|------------|---------------|---------|
| **Critical** | Blocks key decision | Immediate | "No data on major protocol we plan to integrate with" |
| **High** | Significantly impairs decisions | < 24 hours | "Protocol has <50% confidence, affects strategic planning" |
| **Medium** | Partially impairs decisions | < 1 week | "Missing non-critical properties on entity" |
| **Low** | Minor impact | < 1 month | "Minor inconsistency in timestamps" |

---

## Gap Impact Assessment

### Impact Factors

| Factor | Weight | Description |
|--------|--------|-------------|
| Decision Frequency | 30% | How often does this gap affect decisions? |
| Decision Importance | 30% | How critical are affected decisions? |
| Coverage Gap | 20% | How large is the missing information? |
| Urgency | 20% | How time-sensitive is filling this gap? |

### Impact Calculation

```
Impact Score = (Decision_Frequency × 0.3) + 
               (Decision_Importance × 0.3) + 
               (Coverage_Gap × 0.2) + 
               (Urgency × 0.2)
```

---

## Gap Prioritization

### Priority Matrix

```
                    HIGH IMPACT
                         │
                         │
    ┌────────────────────┼────────────────────┐
    │                    │                    │
    │   PRIORITY 1       │   PRIORITY 2       │
    │   (Do First)       │   (Schedule)       │
    │                    │                    │
LOW ─────────────────────┼───────────────────── HIGH
URGENCY                 │                URGENCY
    │                    │                    │
    │   PRIORITY 3       │   PRIORITY 4       │
    │   (Delegate)       │   (Monitor)        │
    │                    │                    │
    └────────────────────┼────────────────────┘
                         │
                         │
                    LOW IMPACT
```

### Priority Levels

| Priority | Description | Action |
|----------|-------------|--------|
| **P1** | Critical gap, high urgency | Create mission immediately |
| **P2** | Important gap, moderate urgency | Include in next planning cycle |
| **P3** | Useful gap, low urgency | Include when resources available |
| **P4** | Nice to have | Address when convenient |

---

## Gap to Mission Conversion

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      GAP → MISSION WORKFLOW                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────┐                                                               │
│   │ GAP     │  1. Gap identified by monitor                                  │
│   │ DETECTED│                                                               │
│   └────┬────┘                                                               │
│        │                                                                    │
│        ▼                                                                    │
│   ┌─────────┐    Gap is P1/P2?    ┌─────────────┐                         │
│   │ PRIORITY│────────────────────▶│ CREATE      │                         │
│   │ ASSESS  │    No               │ MISSION?    │                         │
│   └────┬────┘◀────────────────────│             │                         │
│        │         Yes              └──────┬──────┘                         │
│        │                                │                                 │
│        │                                ▼                                 │
│        │                         ┌─────────────┐                           │
│        │                         │ GENERATE    │                           │
│        │                         │ MISSION     │                           │
│        │                         └──────┬──────┘                           │
│        │                                │                                  │
│        ▼                                ▼                                  │
│   ┌─────────┐                   ┌─────────────┐                            │
│   │ QUEUE   │◀──────────────────│ LINK MISSION│                            │
│   │ FOR     │   Mission created │ TO GAP      │                            │
│   │ REVIEW  │                   └─────────────┘                            │
│   └────┬────┘                                                               │
│        │                                                                    │
│        ▼                                                                    │
│   ┌─────────┐                                                               │
│   │ SCHEDULE│  Mission queued for execution                                  │
│   │ IN PLAN │                                                               │
│   └─────────┘                                                               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Dependencies

- `mission-lifecycle.md` — Mission creation from gaps
- `scoring-model.md` — Gap prioritization
- `daily-cycle.md` — Gap detection in daily operations

## Related Documents

- `evidence-model.md` — Evidence requirements
- `quality-gates.md` — Quality gates that detect gaps

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
