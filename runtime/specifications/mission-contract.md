# Mission Contract

**Document ID**: runtime.2
**Domain**: Runtime
**Status**: Implementation Specification

---

## 1. Purpose

Every execution begins with exactly one mission.

A mission is a self-contained unit of research work with:

- Clear objectives
- Defined inputs
- Expected outputs
- Success criteria
- Human checkpoints
- Completion rules

The mission contract ensures every research action is intentional, traceable, and complete.

---

## 2. Mission Schema

### Required Fields

```yaml
mission:
  # Identity
  id: MissionId                    # UUID, unique identifier
  name: string                     # Human-readable name
  
  # Classification
  type: MissionType               # discovery | analysis | validation | synthesis
  priority: Priority              # P1 | P2 | P3 | P4
  status: MissionStatus            # proposed | approved | queued | in_progress | paused | completed | failed
  
  # Definition
  objective: string               # What this mission aims to achieve
  business_goal: string           # Why this mission matters
  
  # Scope
  scope:
    included: List[string]        # Topics in scope
    excluded: List[string]        # Topics out of scope
    constraints: List[string]      # Limitations
  
  # Inputs
  inputs:
    required: List[InputSpec]     # Required inputs
    optional: List[InputSpec]     # Optional inputs
  
  # Outputs
  outputs:
    expected: List[OutputSpec]    # Expected outputs
    minimum: List[OutputSpec]     # Minimum viable outputs
  
  # Success Criteria
  success_criteria:
    - criterion: string
      definition: string
      required: boolean
  
  # Checkpoints
  checkpoints:
    - id: CheckpointId
      type: CheckpointType        # human_review | quality_gate | pause
      location: string            # When in execution
      required: boolean
  
  # Specifications
  specifications:
    required: List[SpecRef]      # Architecture specs to load
    optional: List[SpecRef]       # Architecture specs to consider
  
  # Lifecycle
  lifecycle:
    created_at: ISO8601
    created_by: string
    updated_at: ISO8601
    completed_at: ISO8601 | null
  
  # Completion
  completion:
    result: ResultType           # success | partial | failed
    criteria_met: List[string]   # Which criteria were met
    next_mission_rules: List[Rule]  # Rules for generating next mission
```

---

## 3. Mission Types

### Discovery

Research to find new signals or opportunities.

```yaml
type: discovery

Example Objectives:
- "Discover emerging Layer 2 protocols with growing TVL"
- "Find DeFi protocols targeting emerging markets"
- "Identify new NFT marketplace opportunities"
```

### Analysis

Research to understand or validate existing knowledge.

```yaml
type: analysis

Example Objectives:
- "Analyze Uniswap V4 competitive positioning"
- "Validate hypothesis: users prefer single-chain DEX"
- "Assess risk profile of new stablecoin protocol"
```

### Validation

Research to verify or challenge existing conclusions.

```yaml
type: validation

Example Objectives:
- "Validate confidence score for Curve Finance analysis"
- "Verify evidence chain for DeFi summer thesis"
- "Challenge assumption: L2 adoption rate will accelerate"
```

### Synthesis

Research to combine multiple findings into insights.

```yaml
type: synthesis

Example Objectives:
- "Synthesize findings into opportunity ranking"
- "Generate hypotheses from signal cluster"
- "Create strategic recommendations from evidence"
```

---

## 4. Mission States

```
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│PROPOSED │────▶│ APPROVED│────▶│  QUEUED │────▶│IN_PROGRESS│
└─────────┘     └─────────┘     └─────────┘     └────┬──────┘
    │               │               │                  │
    │ reject        │               │                  │
    ▼               ▼               ▼                  ▼
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│ REJECTED│     │  QUEUED │     │ BLOCKED │◀────│  PAUSED │
└─────────┘     └─────────┘     └─────────┘     └────┬─────┘
                                                           │
                        ┌───────────────────────────────────┘
                        │
                        ▼
┌─────────┐     ┌─────────┐     ┌─────────┐
│COMPLETED│◀────│ RESUMED │◀────│IN_PROGRESS│
└─────────┘     └─────────┘     └─────────┘
    │
    │ failed
    ▼
┌─────────┐
│ FAILED  │
└─────────┘
```

| State | Description |
|-------|-------------|
| `proposed` | Mission created, awaiting approval |
| `approved` | Mission approved, ready to queue |
| `queued` | Waiting for execution resources |
| `in_progress` | Actively being executed |
| `paused` | Paused at checkpoint |
| `blocked` | Waiting on dependency |
| `completed` | Successfully completed |
| `failed` | Failed with error |

---

## 5. Mission Generation

### Automatic Generation

Missions are automatically generated from:

1. **Knowledge Gaps** — From `knowledge/gaps/`
2. **Pending Signals** — From `knowledge/signals/`
3. **Scheduled Deep Dives** — From `missions/scheduled/`
4. **Human Request** — Explicitly requested by user

### Generation Rules

```yaml
generation:
  trigger: GapDetected | SignalIdentified | ScheduledDue | HumanRequest
  
  priority_calculation:
    - gap_severity: weight=0.4
    - signal_strength: weight=0.3
    - business_impact: weight=0.2
    - resource_availability: weight=0.1
  
  scope_rules:
    - max_scope_size: 3 topics
    - max_duration: 4 hours
    - require_business_goal: true
```

### Mission ID Format

```
mission-{YYYY-MM-DD}-{sequence}
mission-2026-06-29-001
mission-2026-06-29-002
```

---

## 6. Input Specifications

### Required Inputs

Every mission specifies required inputs:

```yaml
inputs:
  required:
    - type: knowledge_gap
      id: gap-id-123
      description: "Missing analysis of zkSync ecosystem"
      
    - type: signal
      id: signal-id-456
      description: "zkSync TVL increased 50% this week"
      
    - type: specification
      id: spec-knowledge-model
      path: docs/04-knowledge/knowledge-model.md
```

### Input Validation

Before execution begins:

```
1. Verify all required inputs exist
2. Verify inputs meet minimum quality threshold
3. If inputs missing → generate or abort
4. If inputs below threshold → flag for human review
```

---

## 7. Output Specifications

### Expected Outputs

Every mission specifies expected outputs:

```yaml
outputs:
  expected:
    - type: knowledge_delta
      artifact: 04-knowledge-delta.md
      schema: Entity Schemas
      
    - type: research_report
      artifact: 03-research-report.md
      min_length: 500 words
      
    - type: hypothesis
      artifact: 05-hypotheses.md
      min_count: 1
      max_count: 5
      
    - type: opportunity
      artifact: 06-opportunities.md
      optional: true
```

### Minimum Viable Outputs

The minimum outputs required for mission completion:

```yaml
outputs:
  minimum:
    - research_report       # Always required
    - knowledge_delta      # Always required
```

---

## 8. Success Criteria

### Criteria Definition

Each success criterion has:

```yaml
criterion:
  id: CriterionId
  description: string          # What this criterion measures
  definition: string          # How to measure it
  required: boolean           # Must be met for success
  weight: number              # Contribution to overall score
  evidence_required: List[Spec]  # What evidence proves this criterion
```

### Criterion Examples

```yaml
criterion:
  - id: evidence_quality
    description: "Research is backed by verifiable evidence"
    definition: "All claims cite sources with URLs"
    required: true
    weight: 0.3
    
  - id: scope_covered
    description: "All in-scope topics addressed"
    definition: "Each topic in scope has corresponding section"
    required: true
    weight: 0.25
    
  - id: hypotheses_generated
    description: "Actionable hypotheses generated"
    definition: "At least one hypothesis with testable criteria"
    required: false
    weight: 0.15
```

---

## 9. Human Checkpoints

### Checkpoint Types

| Type | Purpose | User Action |
|------|---------|------------|
| `human_review` | Quality validation | Review and approve/reject |
| `quality_gate` | Automatic quality check | Provide missing evidence |
| `pause` | Await external input | Wait for research completion |

### Checkpoint Definition

```yaml
checkpoints:
  - id: checkpoint-001
    type: human_review
    location: after_outputs       # When in execution
    description: "Review research quality"
    required: true
    timeout: 24 hours
    
  - id: checkpoint-002
    type: quality_gate
    location: after_extraction
    description: "Validate evidence strength"
    required: true
    threshold: 0.7
```

---

## 10. Required Specifications

### Specification References

Each mission declares which architecture specifications it requires:

```yaml
specifications:
  required:
    - id: spec-engine-state
      path: docs/02-engine/state-manager.md
      reason: "State checkpointing"
      
    - id: spec-knowledge-model
      path: docs/04-knowledge/knowledge-model.md
      reason: "Knowledge extraction"
      
    - id: spec-quality-gates
      path: docs/06quality/quality-gates.md
      reason: "Output validation"
      
  optional:
    - id: spec-evidence-model
      path: docs/06quality/evidence-model.md
      reason: "Evidence assessment"
```

### Lazy Loading

The runtime loads only the required specifications for each mission, per the specification loading strategy.

---

## 11. Completion Rules

### Success

A mission is successful when:

```
ALL(required_success_criteria) == true
AND
ALL(required_outputs).exist()
```

### Partial Success

A mission has partial success when:

```
SOME(required_success_criteria) == true
AND
required_outputs.exist()
```

### Failure

A mission fails when:

```
ANY(required_success_criteria) == false AND NOT recoverable
OR
required_outputs.missing()
```

---

## 12. Next Mission Rules

After completion, the mission generates rules for the next mission:

```yaml
completion:
  result: success
  
  next_mission_rules:
    - rule: continue_topic
      condition: "Additional questions raised"
      action: "Generate follow-up mission"
      
    - rule: related_gap
      condition: "Related gap identified"
      action: "Queue related gap mission"
      
    - rule: opportunity_confirmed
      condition: "Opportunity score > 70"
      action: "Generate validation mission"
```

---

## 13. Mission Artifact

Every mission is stored as:

```
runtime/missions/{mission-id}/
├── mission.yaml              # Mission definition
├── state.yaml               # Current state
├── inputs/                  # Input artifacts
├── outputs/                 # Output artifacts
├── checkpoints/             # Checkpoint records
└── audit.yaml              # Mission audit log
```

---

## 14. Mission Contract Enforcement

The runtime enforces:

1. **Exactly one active mission** — Only one mission executes at a time
2. **Required inputs before execution** — Cannot start without inputs
3. **Checkpoint at pause points** — Must checkpoint before pause
4. **Artifacts per output spec** — Must produce specified outputs
5. **Criteria for completion** — Cannot complete without criteria met

---

## Dependencies

- `02-engine/state-manager.md` — Checkpoint behavior
- `05-operations/mission-lifecycle.md` — Mission state machine
- `04-knowledge/knowledge-model.md` — Knowledge extraction
- `06quality/quality-gates.md` — Output validation

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial specification |
