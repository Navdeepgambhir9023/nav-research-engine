# Output Contract

**Document ID**: runtime.3
**Domain**: Runtime
**Status**: Implementation Specification

---

## 1. Purpose

Every execution produces deterministic artifacts.

This contract defines:

1. The exact structure of output artifacts
2. The schema for each artifact
3. Validation rules
4. Naming conventions
5. Relationships between artifacts

**No execution produces arbitrary output.** All artifacts follow this contract.

---

## 2. Artifact Structure

### Directory Structure

```
artifacts/{YYYY-MM-DD}/
├── 01-mission.md              # Mission definition (input)
├── 02-gemini-prompt.md       # Research prompt for LLM
├── 03-research-report.md      # User's research results
├── 04-knowledge-delta.md     # New entities extracted
├── 05-hypotheses.md          # Generated hypotheses
├── 06-opportunities.md        # Identified opportunities
├── 07-state-update.md        # State changes
├── 08-next-mission.md        # Tomorrow's planned mission
├── 09-audit-log.md           # Action log for this execution
└── manifest.yaml             # Artifact manifest
```

### Manifest

Every execution generates a manifest:

```yaml
manifest:
  version: "1.0"
  execution_id: "uuid"
  date: YYYY-MM-DD
  
  artifacts:
    - filename: 01-mission.md
      type: mission
      size: bytes
      checksum: sha256
      validated: boolean
      
    - filename: 02-gemini-prompt.md
      type: prompt
      size: bytes
      checksum: sha256
      validated: boolean
      
    # ... all artifacts
    
  validation:
    all_present: boolean
    all_validated: boolean
    quality_score: number
    
  generated_at: ISO8601
  generated_by: string
```

---

## 3. Artifact Specifications

### 3.1 Mission Definition

**Filename**: `01-mission.md`

**Purpose**: Input artifact defining today's research mission.

**Schema**:

```yaml
mission_definition:
  header:
    mission_id: string
    date: YYYY-MM-DD
    type: discovery | analysis | validation | synthesis
    
  objective: string
  business_goal: string
  
  scope:
    included: List[string]
    excluded: List[string]
    
  inputs:
    - type: string
      id: string
      description: string
      
  expected_outputs:
    - type: string
      artifact: string
      
  success_criteria:
    - criterion: string
      required: boolean
      
  human_checkpoints:
    - type: string
      location: string
      
  specifications:
    - path: string
      reason: string
```

**Validation Rules**:

| Rule | Severity | Message |
|------|---------|---------|
| Required fields present | Error | Missing required field: {field} |
| Valid mission ID format | Error | Invalid mission ID format |
| At least one input | Error | No inputs provided |
| At least one output | Error | No outputs specified |

---

### 3.2 Gemini Research Prompt

**Filename**: `02-gemini-prompt.md`

**Purpose**: Structured prompt for LLM research.

**Schema**:

```yaml
gemini_prompt:
  header:
    mission_id: string
    generated_at: ISO8601
    model: string
    max_tokens: number
    
  system:
    role: string
    context: string
    constraints: List[string]
    
  objective: string
  
  context:
    background: string
    existing_knowledge: string
    knowledge_gaps: List[string]
    
  scope:
    investigate: List[string]
    ignore: List[string]
    
  evidence_requirements:
    minimum_sources: number
    required_source_types: List[string]
    
  output_requirements:
    format: string
    structure: string
    min_length: string
    sections: List[string]
    
  success_criteria:
    - criterion: string
```

**Validation Rules**:

| Rule | Severity | Message |
|------|---------|---------|
| Valid prompt structure | Error | Invalid prompt structure |
| Objective specified | Error | No objective provided |
| Evidence requirements | Warning | No evidence requirements |
| Output format | Error | No output format specified |

---

### 3.3 Research Report

**Filename**: `03-research-report.md`

**Purpose**: User's research results.

**Schema**:

```yaml
research_report:
  header:
    mission_id: string
    date: YYYY-MM-DD
    author: string  # User or "gemini" if LLM-generated
    
  summary: string
  
  findings:
    - finding: string
      evidence: string
      confidence: number
      
  sources:
    - url: string
      type: primary | secondary | tertiary
      accessed_at: ISO8601
      
  gaps_identified:
    - gap: string
      severity: high | medium | low
      
  open_questions:
    - question: string
```

**Validation Rules**:

| Rule | Severity | Message |
|------|---------|---------|
| Sources with URLs | Warning | Source without URL |
| Evidence for claims | Warning | Claim without evidence |
| Minimum length | Warning | Report below minimum length |

---

### 3.4 Knowledge Delta

**Filename**: `04-knowledge-delta.md`

**Purpose**: New entities extracted from research.

**Schema**:

```yaml
knowledge_delta:
  header:
    mission_id: string
    date: YYYY-MM-DD
    
  entities:
    added:
      - id: string
        type: string
        name: string
        properties: object
        evidence: List[string]
        
    updated:
      - id: string
        changes: object
        evidence: List[string]
        
    deprecated:
      - id: string
        reason: string
        
  relationships:
    added:
      - source_id: string
        target_id: string
        type: string
        weight: number
        
  evidence_chains:
    - entity_id: string
      chain:
        - source: string
          type: string
          strength: number
```

**Validation Rules**:

| Rule | Severity | Message |
|------|---------|---------|
| Entity has ID | Error | Entity without ID |
| Entity has type | Error | Entity without type |
| Evidence for claims | Error | Claim without evidence |
| Valid entity references | Error | Invalid entity reference |

---

### 3.5 Hypotheses

**Filename**: `05-hypotheses.md`

**Purpose**: Testable hypotheses generated from research.

**Schema**:

```yaml
hypotheses:
  header:
    mission_id: string
    date: YYYY-MM-DD
    
  hypotheses:
    - id: string
      statement: string
      derived_from: List[string]  # Findings
      
      test_criteria:
        - criterion: string
          evidence_needed: string
          
      confidence: number
      
      priority: P1 | P2 | P3
      
      experiments:
        - name: string
          method: string
          resources_needed: List[string]
```

**Validation Rules**:

| Rule | Severity | Message |
|------|---------|---------|
| Testable criteria | Error | No test criteria defined |
| Evidence chain | Warning | Weak evidence chain |
| Priority assigned | Warning | No priority assigned |

---

### 3.6 Opportunities

**Filename**: `06-opportunities.md`

**Purpose**: Opportunities identified from research.

**Schema**:

```yaml
opportunities:
  header:
    mission_id: string
    date: YYYY-MM-DD
    
  opportunities:
    - id: string
      name: string
      type: market_entry | integration | partnership | investment
      
      problem_addressed:
        - id: string
          description: string
          
      score:
        total: number
        breakdown:
          market_size: number
          feasibility: number
          timing: number
          competition: number
          risk: number
          
      phase: emerging | growing | mature | declining
      
      evidence: List[string]
```

**Validation Rules**:

| Rule | Severity | Message |
|------|---------|---------|
| Problem referenced | Error | Opportunity without problem |
| Score calculated | Error | No score provided |
| Evidence provided | Warning | No evidence for opportunity |

---

### 3.7 State Update

**Filename**: `07-state-update.md`

**Purpose**: State changes from this execution.

**Schema**:

```yaml
state_update:
  header:
    mission_id: string
    date: YYYY-MM-DD
    execution_id: string
    
  loop_state:
    previous:
      status: string
      phase: string
      checkpoint: string
      
    current:
      status: string
      phase: string
      checkpoint: string
      
  mission_state:
    previous:
      id: string
      status: string
      
    current:
      id: string
      status: completed
      
  knowledge_coverage:
    entities_added: number
    entities_updated: number
    coverage_improved: List[string]
    
  quality_metrics:
    gates_passed: number
    gates_failed: number
    quality_score: number
```

**Validation Rules**:

| Rule | Severity | Message |
|------|---------|---------|
| Valid transitions | Error | Invalid state transition |
| Previous state matches | Error | State mismatch |
| Checkpoint created | Error | No checkpoint created |

---

### 3.8 Next Mission

**Filename**: `08-next-mission.md`

**Purpose**: Tomorrow's planned mission.

**Schema**:

```yaml
next_mission:
  header:
    generated_at: ISO8601
    based_on: mission_id
    
  planned_mission:
    objective: string
    business_goal: string
    
    scope:
      included: List[string]
      
    priority: P1 | P2 | P3
      
    dependencies:
      - mission_id: string
        reason: string
        
    estimated_duration: string
    
  knowledge_gaps_addressed:
    - gap_id: string
      description: string
      
  rationale: string
```

**Validation Rules**:

| Rule | Severity | Message |
|------|---------|---------|
| Objective defined | Error | No objective |
| Priority assigned | Error | No priority |
| Dependencies identified | Warning | No dependencies |

---

### 3.9 Audit Log

**Filename**: `09-audit-log.md`

**Purpose**: Complete action log for this execution.

**Schema**:

```yaml
audit_log:
  header:
    execution_id: string
    mission_id: string
    date: YYYY-MM-DD
    
  actions:
    - timestamp: ISO8601
      action: string
      actor: string
      details: object
      
  events:
    - timestamp: ISO8601
      event: string
      category: string
      
  decisions:
    - timestamp: ISO8601
      decision: string
      rationale: string
      decided_by: string
      
  errors:
    - timestamp: ISO8601
      error: string
      severity: string
      recovered: boolean
      
  checkpoints:
    - timestamp: ISO8601
      checkpoint_id: string
      location: string
```

**Validation Rules**:

| Rule | Severity | Message |
|------|---------|---------|
| Timestamps ordered | Error | Out-of-order timestamps |
| All actions logged | Error | Missing action |
| No gaps in timeline | Warning | Timeline gap detected |

---

## 4. Artifact Relationships

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        ARTIFACT DEPENDENCIES                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   01-mission.md ──┬──▶ 02-gemini-prompt.md                             │
│                    │         │                                            │
│                    │         ▼                                            │
│                    │    03-research-report.md                             │
│                    │         │                                            │
│                    │         ├──▶ 04-knowledge-delta.md                  │
│                    │         │         │                                    │
│                    │         │         ├──▶ 05-hypotheses.md                │
│                    │         │         │                                    │
│                    │         │         └──▶ 06-opportunities.md             │
│                    │         │                                            │
│                    │         ▼                                            │
│                    └───▶ 07-state-update.md                               │
│                              │                                             │
│                              ├──▶ 08-next-mission.md                       │
│                              │                                             │
│                              └──▶ 09-audit-log.md                          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Validation Pipeline

### Phase 1: Schema Validation

Each artifact is validated against its schema.

```
For each artifact:
  1. Load artifact
  2. Parse YAML frontmatter (if present)
  3. Validate against schema
  4. If invalid → error, halt
  5. If valid → continue
```

### Phase 2: Cross-Artifact Validation

Artifacts are validated against each other.

```
After schema validation:
  1. Verify artifact dependencies
  2. Verify entity references
  3. Verify temporal consistency
  4. If invalid → error, halt
  5. If valid → continue
```

### Phase 3: Quality Validation

Artifacts are validated against quality gates.

```
After cross-artifact validation:
  1. Check evidence requirements
  2. Check minimum outputs
  3. Check success criteria
  4. If failed → warning or halt (per configuration)
```

---

## 6. Naming Conventions

### Filenames

| Artifact | Pattern | Example |
|----------|---------|---------|
| Mission | `{NN}-{name}.md` | `01-mission.md` |
| Knowledge | `{NN}-{name}.md` | `04-knowledge-delta.md` |

### Directory Names

| Directory | Pattern | Example |
|-----------|---------|---------|
| Execution | `YYYY-MM-DD` | `2026-06-29` |
| Mission | `mission-{id}` | `mission-2026-06-29-001` |

### Entity IDs

| Entity | Pattern | Example |
|--------|---------|---------|
| Entity | `{type}-{slug}` | `protocol-uniswap-v3` |
| Signal | `signal-{uuid}` | `signal-a1b2c3d4` |
| Mission | `mission-{date}-{seq}` | `mission-2026-06-29-001` |

---

## 7. Checksum Verification

Every artifact includes a SHA-256 checksum in the manifest:

```yaml
artifacts:
  - filename: 03-research-report.md
    checksum: sha256:abc123...
```

The runtime verifies checksums after artifact generation to ensure integrity.

---

## 8. Retention Policy

| Artifact | Retention | Reason |
|----------|---------|--------|
| All artifacts | 90 days | Recent reference |
| Mission artifacts | 1 year | Audit trail |
| Knowledge deltas | Indefinite | Permanent knowledge |
| Audit logs | Indefinite | Compliance |

---

## 9. Error Handling

### Artifact Missing

```
If required artifact missing:
  1. Log error
  2. Do not proceed
  3. Report missing artifact
  4. Await correction
```

### Artifact Invalid

```
If artifact fails validation:
  1. Log validation errors
  2. Do not proceed
  3. Report specific failures
  4. Await correction
```

### Artifact Checksum Mismatch

```
If checksum mismatch:
  1. Log error
  2. Do not proceed
  3. Regenerate artifact
  4. Verify new checksum
```

---

## 10. Artifact Access

Artifacts are accessible via:

| Path | Access |
|------|--------|
| `artifacts/YYYY-MM-DD/` | Today's artifacts |
| `artifacts/YYYY-MM-DD/{artifact}` | Specific artifact |
| `artifacts/latest/` | Symlink to most recent |

---

## Dependencies

- `runtime/specifications/runtime-specification.md` — Runtime orchestration
- `runtime/specifications/mission-contract.md` — Mission definition
- `docs/04-knowledge/entity-schemas.md` — Entity validation
- `docs/06quality/quality-gates.md` — Quality validation

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial specification |
