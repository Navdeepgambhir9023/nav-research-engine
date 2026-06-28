# Runtime Specification

**Document ID**: runtime.1
**Domain**: Runtime
**Status**: Implementation Specification

---

## 1. Overview

The Runtime Layer orchestrates the existing architecture. It does not perform research. It coordinates:

- State loading
- Mission determination
- Specification loading
- Artifact generation
- Checkpoint management
- Human interaction

The runtime is a thin orchestration layer that delegates all business logic to the architecture specifications.

---

## 2. Runtime Responsibilities

### What the Runtime DOES

| Responsibility | Description |
|---------------|-------------|
| **State Management** | Load, update, and checkpoint execution state per `02-engine/state-manager.md` |
| **Mission Orchestration** | Determine, queue, and complete missions per `05-operations/mission-lifecycle.md` |
| **Specification Loading** | Lazily load only required architecture documents |
| **Artifact Generation** | Produce deterministic output per output contract |
| **Human Interaction** | Pause for checkpoints, resume on human input |
| **Audit Trail** | Record all actions for replay and debugging |

### What the Runtime DOES NOT

| Responsibility | Delegated To |
|----------------|---------------|
| Research logic | Analysis Department |
| Quality gates | Validation Department |
| Knowledge representation | Knowledge Model |
| Department behavior | Department Contracts |
| Scheduling | Daily/Weekly cycles |

---

## 3. Startup Sequence

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         RUNTIME STARTUP                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   1. INITIALIZE                                                            │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │ • Set working directory to repository root                          │   │
│   │ • Verify repository structure exists                                │   │
│   │ • Load runtime configuration (runtime/config.yaml)                  │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                       │
│                                    ▼                                       │
│   2. DISCOVER ARCHITECTURE                                               │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │ • Scan docs/ for available specifications                         │   │
│   │ • Build specification index (specifications.csv)                  │   │
│   │ • Verify critical specs are present                              │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                       │
│                                    ▼                                       │
│   3. LOAD STATE                                                         │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │ • Read runtime/state/loop-state.json                            │   │
│   │ • If no state → initialize fresh state                           │   │
│   │ • Verify state integrity                                         │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                       │
│                                    ▼                                       │
│   4. DETERMINE MISSION                                                 │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │ • Check missions/pending/ for queued missions                     │   │
│   │ • If no pending → generate from daily-cycle                      │   │
│   │ • Load mission specification                                    │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                       │
│                                    ▼                                       │
│   5. READY                                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │ • Report mission to user                                         │   │
│   │ • Await command to proceed                                       │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 4. State Loading

### State Files

| File | Purpose | Loaded When |
|------|---------|------------|
| `runtime/state/loop-state.json` | Current execution state | Always |
| `runtime/state/missions.json` | Mission queue | Mission determination |
| `runtime/state/checkpoints/` | Recovery points | If previous run was interrupted |
| `runtime/state/audit-log.jsonl` | Action history | Always (append) |

### State Schema

```yaml
loop_state:
  version: "1.0"
  execution_id: "uuid"
  status: IDLE | RUNNING | PAUSED | COMPLETED | FAILED
  
  cycle:
    number: number
    date: YYYY-MM-DD
    started_at: ISO8601
    
  mission:
    current: MissionId | null
    queue_depth: number
    
  checkpoint:
    last: CheckpointId | null
    sequence: number
    
  health:
    last_successful: ISO8601
    consecutive_failures: number
```

---

## 5. Specification Loading Strategy

### Loading Principles

1. **Lazy Loading** — Load specs only when needed
2. **Caching** — Keep loaded specs in memory for session duration
3. **Isolation** — Each specification is independent
4. **Versioning** — Track which spec version is loaded

### Specification Categories

| Category | Path Pattern | Loaded For |
|---------|-------------|------------|
| Foundation | `docs/00-foundation/*.md` | All executions |
| Engine | `docs/02-engine/*.md` | Execution orchestration |
| Departments | `docs/03-departments/*.md` | Mission execution |
| Knowledge | `docs/04-knowledge/*.md` | Knowledge extraction |
| Operations | `docs/05-operations/*.md` | Mission planning |
| Quality | `docs/06quality/*.md` | Output validation |
| Integration | `docs/08-integration/*.md` | External system calls |

### Specification Index

The runtime maintains `runtime/specifications/index.csv`:

```csv
spec_id,path,category,loaded_at,version
spec-foundation-001,docs/00-foundation/vision.md,foundation,NULL,v0.1.0
spec-engine-001,docs/02-engine/research-loop.md,engine,2026-06-29T06:00:00Z,v0.1.0
...
```

### When Specifications Are Loaded

| Phase | Specifications Loaded |
|-------|---------------------|
| Startup | Foundation, Engine (State Manager) |
| Mission Determination | Operations (Daily Cycle) |
| Specification Loading | Mission-specific requirements |
| Artifact Generation | Output Contract |
| Knowledge Extraction | Knowledge Model, Quality Gates |

---

## 6. Mission Planning

### Mission Generation

When no pending mission exists, generate from daily cycle:

```
1. Read docs/05-operations/daily-cycle.md
2. Determine today's research priorities:
   - Open knowledge gaps (from knowledge/gaps/)
   - Pending signals (from knowledge/signals/)
   - Scheduled deep dives (from missions/scheduled/)
3. Create mission per mission contract
4. Write to runtime/missions/pending/{mission_id}.json
5. Update runtime/state/missions.json
```

### Mission Queue

Missions are prioritized by:

1. **Priority score** (from Planning department scoring)
2. **Dependency order** (dependencies run first)
3. **Resource availability** (parallel execution slots)

---

## 7. Execution Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         RUNTIME EXECUTION                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────┐                                                        │
│   │   START   │  User invokes /research                                  │
│   └──────┬─────┘                                                        │
│          │                                                                  │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │ LOAD STATE │  Read loop-state.json                                  │
│   └──────┬─────┘                                                        │
│          │                                                                  │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │ DETERMINE  │  Read current mission                                  │
│   │  MISSION   │                                                        │
│   └──────┬─────┘                                                        │
│          │                                                                  │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │   LOAD     │  Load required specifications                          │
│   │SPECS       │  (lazy loading)                                        │
│   └──────┬─────┘                                                        │
│          │                                                                  │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │  EXECUTE   │  Generate artifacts per output contract                 │
│   │  RUNTIME   │  (prompt generation)                                    │
│   └──────┬─────┘                                                        │
│          │                                                                  │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │   PAUSE    │  Await human research                                 │
│   │            │  (checkpoint created)                                    │
│   └──────┬─────┘                                                        │
│          │                                                                  │
│          │  User performs research, provides results                       │
│          │                                                                  │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │   RESUME   │  User resumes execution                                │
│   └──────┬─────┘                                                        │
│          │                                                                  │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │   EXTRACT  │  Parse results per knowledge model                      │
│   │ KNOWLEDGE  │                                                        │
│   └──────┬─────┘                                                        │
│          │                                                                  │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │ VALIDATE   │  Apply quality gates                                    │
│   │            │                                                        │
│   └──────┬─────┘                                                        │
│          │                                                                  │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │  UPDATE    │  Write knowledge to knowledge/                           │
│   │ KNOWLEDGE  │  Update state                                           │
│   └──────┬─────┘                                                        │
│          │                                                                  │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │  GENERATE  │  Write artifacts to artifacts/                         │
│   │ ARTIFACTS  │                                                        │
│   └──────┬─────┘                                                        │
│          │                                                                  │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │   PLAN     │  Queue tomorrow's mission                              │
│   │   NEXT     │                                                        │
│   └──────┬─────┘                                                        │
│          │                                                                  │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │  CHECKPOINT │  Save final state                                    │
│   └──────┬─────┘                                                        │
│          │                                                                  │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │    EXIT    │  Execution complete                                      │
│   └─────────────┘                                                        │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 8. Artifact Generation

### Output Structure

Every execution produces:

```
artifacts/{YYYY-MM-DD}/
├── 01-mission.md              # Mission definition
├── 02-gemini-prompt.md       # Research prompt for LLM
├── 03-research-report.md      # User's research results
├── 04-knowledge-delta.md     # New entities extracted
├── 05-hypotheses.md          # Generated hypotheses
├── 06-opportunities.md        # Identified opportunities
├── 07-state-update.md        # State changes
├── 08-next-mission.md         # Tomorrow's planned mission
└── 09-audit-log.md           # Action log for this execution
```

### Artifact Contract

Each artifact follows a defined contract:

| Artifact | Schema | Validation |
|----------|--------|-----------|
| `01-mission.md` | Mission Contract | Required fields present |
| `02-gemini-prompt.md` | Gemini Contract | Valid prompt structure |
| `03-research-report.md` | Knowledge Model | Evidence standards |
| `04-knowledge-delta.md` | Entity Schemas | Schema validation |
| `05-hypotheses.md` | Knowledge Model | Testable criteria |
| `06-opportunities.md` | Scoring Model | Required scores |
| `07-state-update.md` | State Schema | Valid transitions |
| `08-next-mission.md` | Mission Contract | Consistent with cycle |
| `09-audit-log.md` | Audit Schema | Complete actions |

---

## 9. Checkpoint Behavior

### When Checkpoints Are Created

| Event | Checkpoint Created |
|-------|------------------|
| Before pause for human input | ✓ |
| After specification loading | ✓ |
| After knowledge extraction | ✓ |
| After quality validation | ✓ |
| After state update | ✓ |

### Checkpoint Files

```
runtime/state/checkpoints/
├── {checkpoint_id}/
│   ├── loop-state.json
│   ├── mission.json
│   ├── loaded-specs.json
│   └── timestamp.txt
└── latest -> {checkpoint_id}/  # Symlink to latest
```

### Recovery

On restart after interruption:

```
1. Read runtime/state/loop-state.json
2. If status == PAUSED:
   a. Read checkpoint from checkpoints/latest/
   b. Restore state from checkpoint
   c. Resume from pause point
3. If status == COMPLETED:
   a. Report completion
   b. Await next command
4. If status == FAILED:
   a. Read last checkpoint
   b. Attempt recovery or prompt user
```

---

## 10. Pause/Resume Behavior

### Pause Points

The runtime pauses at:

| Pause Point | Reason | User Action |
|------------|--------|------------|
| `EXECUTE_RUNTIME` | Await research | Perform research, provide results |
| `HUMAN_CHECKPOINT` | Quality review | Complete review |
| `VALIDATION_FAIL` | Quality gate failed | Provide missing evidence |

### Resume

On resume:

```
1. User provides input (research results, review decision, etc.)
2. Runtime reads input from artifacts/YYYY-MM-DD/03-research-report.md
3. Runtime validates input format
4. Runtime continues to next phase
5. State is updated
```

---

## 11. Shutdown Sequence

```
1. Verify all phases complete
2. Generate final checkpoint
3. Write completion timestamp
4. Update loop-state.json status = COMPLETED
5. Append to audit-log.jsonl
6. Release resources
7. Report completion
```

---

## 12. Error Handling

### Error Categories

| Category | Response |
|----------|---------|
| State corruption | Rollback to previous checkpoint |
| Specification missing | Abort with clear error |
| Quality gate failure | Route to human review |
| Human input invalid | Prompt for correction |
| Knowledge conflict | Route to conflict resolution |

### Error Recovery

All errors follow `docs/09-safety/failure-recovery.md`:

```
1. Log error with full context
2. Attempt automatic recovery (if recoverable)
3. If automatic recovery fails:
   a. Create error artifact
   b. Rollback to last checkpoint
   c. Report error to user
   d. Await user decision
```

---

## 13. Runtime Principles

| Principle | Implementation |
|-----------|----------------|
| **Deterministic** | Same mission + same specs → same artifacts |
| **Composable** | Commands chain, missions queue |
| **Observable** | Audit log records every action |
| **Auditable** | All actions in audit-log.jsonl |
| **Restartable** | State persisted, checkpoint recoverable |
| **Interruptible** | Checkpoint before pause |
| **Resumable** | State restored from checkpoint |
| **Extensible** | New commands in runtime/commands/ |
| **Repository-first** | All state in runtime/state/ |
| **Human-in-the-loop** | Pause at checkpoints |
| **Knowledge-driven** | Missions from knowledge gaps |
| **Evidence-first** | Quality gates validate all output |

---

## 14. Configuration

Runtime configuration in `runtime/config.yaml`:

```yaml
runtime:
  version: "1.0"
  
paths:
  state: runtime/state/
  missions: runtime/missions/
  artifacts: artifacts/
  knowledge: knowledge/
  
execution:
  checkpoint_interval: 5  # phases between checkpoints
  max_retries: 3
  pause_on_quality_fail: true
  
quality:
  enforce_gates: true
  require_evidence: true
  human_review_threshold: 0.7

integration:
  gemini:
    enabled: true
    max_tokens: 8192
```

---

## Dependencies

This specification orchestrates the following architecture documents:

- `02-engine/research-loop.md` — Execution lifecycle
- `02-engine/state-manager.md` — State management
- `03-departments/departments.md` — Department contracts
- `04-knowledge/knowledge-model.md` — Knowledge representation
- `05-operations/daily-cycle.md` — Daily execution
- `06quality/quality-gates.md` — Quality enforcement
- `08-integration/gemini-contract.md` — Prompt generation

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial specification |
