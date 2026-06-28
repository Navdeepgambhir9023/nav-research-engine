# State Manager

**Document ID**: 02-engine.2
**Domain**: Engine
**Status**: Draft

---

## 1. Purpose

### Why the Engine Requires State

The Research Loop Engine is not a batch processor. It does not run once and complete. It is a continuous orchestration system that executes research cycles indefinitely.

Without state, every cycle would begin in isolation:

- The engine would not know what signals were processed yesterday
- The engine would not know which missions are in progress
- The engine would not know where the previous cycle stopped
- The engine would re-do work already completed
- The engine would lose context mid-execution

State is what makes the engine **persistent across time**.

### Why State Is Different from Knowledge

Knowledge and state serve fundamentally different purposes:

| Aspect | Knowledge | State |
|--------|----------|-------|
| **Purpose** | Represents reality | Represents execution context |
| **Persistence** | Permanent | Transient |
| **Changes** | Accumulates | Overwritten |
| **Ownership** | Departments | Engine |
| **Audience** | All components | Engine primarily |
| **Trust** | Evidence-based | Checkpoint-verified |

**Knowledge** is what the system knows about the world. It accumulates. A claim made today is still true tomorrow (unless contradicted). Knowledge is validated and versioned.

**State** is what the system needs to continue working. It is ephemeral. State from yesterday's cycle may be irrelevant today. State is checkpointed and recoverable.

```
Knowledge: "Curve Finance TVL increased 50%"
State: "Yesterday's cycle processed 847 signals, completed 3 missions, 
         has 2 missions in progress, waiting for 1 human review"
```

### Why State Is Transient While Knowledge Is Permanent

State represents the **in-flight** execution of the research loop. When the loop completes a cycle, most state is discarded:

- Processed signals → incorporated into knowledge or archived
- Completed missions → archived with results
- Intermediate computations → discarded

What persists:

- **Checkpoint data**: Where to resume if interrupted
- **Pending work**: Missions not yet complete
- **Human interactions**: Reviews awaiting decision
- **Execution history**: Audit trail of what happened

This separation ensures:

1. **The knowledge base grows**: Every cycle adds to what the system knows
2. **State remains lean**: Only execution context, not historical data
3. **Recovery is fast**: Checkpoints are small, targeted snapshots
4. **Knowledge is trustworthy**: Evidence-backed, not just execution artifacts

---

## 2. State Philosophy

State is governed by these principles:

### Deterministic

Given the same state and the same inputs, the engine produces the same next state.

**Implications**:
- State transitions are explicit functions, not implicit side effects
- No hidden state variables
- State changes are traceable to events

**Rationale**: Non-deterministic state is impossible to debug or reproduce.

### Resumable

Any interrupted execution can be resumed from the last checkpoint without loss of work.

**Implications**:
- Every significant operation produces a checkpoint
- Checkpoints contain everything needed to continue
- Recovery is automatic, not manual

**Rationale**: Research takes time. Interruptions are inevitable. The engine must survive them.

### Observable

Every state change is visible to observers without coupling to state internals.

**Implications**:
- State changes emit events
- Observers can subscribe to state transitions
- State does not expose mutators directly

**Rationale**: An opaque state machine cannot be trusted or audited.

### Immutable History

State transitions are append-only. The current state is mutable; historical states are immutable.

**Implications**:
- Every state version is preserved
- State can be rolled back to any previous version
- Audit trail is complete

**Rationale**: When things go wrong, we need to understand how we got there.

### Explicit Transitions

State changes only through defined transitions. No direct mutation.

**Implications**:
- Every transition has a pre-condition and post-condition
- Invalid transitions are rejected
- Transitions are atomic

**Rationale**: Implicit transitions create hidden dependencies and race conditions.

### Replayable

The execution history can be replayed to reproduce any past state.

**Implications**:
- All events are stored in order
- Events are self-contained (contain their own context)
- Replay is deterministic

**Rationale**: Debugging and post-mortem require the ability to reproduce failures.

### Recoverable

The system can recover from any failure without data loss.

**Implications**:
- Checkpoints are written before operations
- Recovery is automatic, not manual
- Lost work is minimized

**Rationale**: Research investment must be protected.

---

## 3. Categories of State

State is decomposed into distinct categories. Each category has a clear purpose and owner.

### Execution State

**Purpose**: Tracks the overall progress of the research loop.

**Contains**:
- Current cycle number
- Current phase (wake, discover, analyze, plan, execute, validate, rest)
- Current stage within phase
- Cycle start time
- Expected completion time
- Execution mode (daily, weekly, on-demand)

**Example**:
```
ExecutionState:
  cycle_id: "cycle-2026-06-29-001"
  phase: "execute"
  stage: "mission-3-of-7"
  started_at: "2026-06-29T06:00:00Z"
  mode: "daily"
```

---

### Mission State

**Purpose**: Tracks the status and progress of individual research missions.

**Contains**:
- Mission ID
- Mission status (proposed, approved, queued, in_progress, blocked, completed, failed)
- Priority
- Assigned department
- Progress percentage
- Current checkpoint
- Blocked reason (if applicable)
- Retry count
- Dependencies

**Example**:
```
MissionState:
  mission_id: "mission-2026-06-29-003"
  status: "in_progress"
  priority: 85
  assigned_to: "execution"
  progress: 0.65
  checkpoint: "analysis-complete"
  retry_count: 0
```

---

### Knowledge Coverage State

**Purpose**: Tracks what the knowledge base covers and what gaps exist.

**Contains**:
- Last full coverage scan timestamp
- Coverage by market
- Coverage by segment
- Known gaps (open, in_progress, resolved)
- Staleness indicators (entities not updated in threshold time)
- Confidence distribution

**Example**:
```
CoverageState:
  last_scan: "2026-06-29T06:00:00Z"
  markets_covered: 12
  markets_total: 15
  open_gaps: 23
  stale_entities: 5
  avg_confidence: 0.72
```

---

### Pending Work State

**Purpose**: Tracks work items awaiting processing.

**Contains**:
- Pending signals (not yet processed)
- Pending insights (not yet validated)
- Pending human reviews (awaiting human decision)
- Pending validations (awaiting quality gates)
- Pending experiments (scheduled but not started)

**Example**:
```
PendingWorkState:
  signals: 47
  insights: 12
  human_reviews: 3
  validations: 8
  experiments: 2
```

---

### Human Checkpoint State

**Purpose**: Tracks human interactions required by the loop.

**Contains**:
- Checkpoint ID
- Checkpoint type (pre_execution, quality_review, conflict_resolution, mission_failure, scheduled)
- Priority
- Assigned reviewer
- Deadline
- Status (pending, in_review, approved, rejected, expired)
- Decision and rationale (if completed)

**Example**:
```
HumanCheckpointState:
  checkpoint_id: "review-2026-06-29-001"
  type: "quality_review"
  priority: "high"
  assigned_to: "lead-researcher"
  deadline: "2026-06-29T18:00:00Z"
  status: "pending"
```

---

### Validation Queue State

**Purpose**: Tracks items awaiting quality gate validation.

**Contains**:
- Queue depth by gate type
- Average wait time
- Items by priority
- Items by department of origin
- Recent pass/fail rates

**Example**:
```
ValidationQueueState:
  queue_depth: 8
  avg_wait_minutes: 23
  by_gate:
    evidence: 3
    consistency: 2
    confidence: 2
    completeness: 1
  recent_pass_rate: 0.85
```

---

### Experiment Queue State

**Purpose**: Tracks experiments scheduled or in progress.

**Contains**:
- Scheduled experiments (not started)
- Running experiments (in progress)
- Completed experiments (awaiting analysis)
- Failed experiments (awaiting review)

**Example**:
```
ExperimentQueueState:
  scheduled: 4
  running: 2
  completed: 12
  failed: 1
  resources:
    llm_calls_today: 847
    llm_budget_used: 0.65
```

---

### Research Backlog State

**Purpose**: Tracks the queue of research items to be addressed.

**Contains**:
- Backlog depth
- Items by priority tier (P1, P2, P3, P4)
- Items by category (market, segment, opportunity, threat)
- Estimated effort per item
- Items blocked by dependencies

**Example**:
```
ResearchBacklogState:
  total_items: 156
  by_priority:
    P1: 5
    P2: 23
    P3: 67
    P4: 61
  estimated_hours: 340
  blocked: 12
```

---

### Quality Status State

**Purpose**: Tracks quality metrics across the system.

**Contains**:
- Quality scores by department
- Recent quality trends
- Failed gates by type
- Human review statistics
- Confidence distribution over time

**Example**:
```
QualityStatusState:
  overall_score: 0.87
  by_department:
    discovery: 0.92
    analysis: 0.84
    planning: 0.89
  recent_trend: "improving"
  failed_gates_this_cycle: 2
```

---

### System Health State

**Purpose**: Tracks the operational health of the engine.

**Contains**:
- Health status (healthy, degraded, unhealthy)
- Component health (all integrations, services)
- Recent errors
- Recovery count
- Last successful cycle
- Consecutive failures

**Example**:
```
SystemHealthState:
  status: "healthy"
  components:
    gemini: "healthy"
    consumr: "healthy"
    web3_apis: "healthy"
    knowledge_base: "healthy"
  consecutive_cycles: 15
  last_error: null
```

---

## 4. State Lifecycle

State evolves through a defined lifecycle within each execution cycle.

### Lifecycle Stages

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         STATE LIFECYCLE                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────┐                                                        │
│   │   WAKE  │  Initialize state for this cycle                          │
│   └────┬────┘                                                        │
│        │                                                                   │
│        ▼                                                                   │
│   ┌─────────────┐                                                    │
│   │ LOAD STATE │  Load previous checkpoint + pending work              │
│   └─────┬───────┘                                                    │
│         │                                                                  │
│         ▼                                                                  │
│   ┌─────────────┐                                                    │
│   │   EXECUTE   │  Execute phases, updating state                      │
│   └─────┬───────┘                                                    │
│         │                                                                  │
│         ▼                                                                   │
│   ┌─────────────┐                                                    │
│   │ CHECKPOINT  │  Persist state at safe point                          │
│   └─────┬───────┘                                                    │
│         │                                                                  │
│         ▼                                                                   │
│   ┌─────────────┐    ┌─────────────┐                                 │
│   │   PAUSE    │◀───│   HUMAN    │                                 │
│   └─────┬───────┘    │ INTERACTION │                                 │
│         │             └─────────────┘                                 │
│         │                                                                   │
│         ▼                                                                   │
│   ┌─────────────┐                                                    │
│   │   RESUME   │  Continue from checkpoint                              │
│   └─────┬───────┘                                                    │
│         │                                                                   │
│         ▼                                                                   │
│   ┌─────────────┐                                                    │
│   │  COMPLETE  │  Cycle completed successfully                          │
│   └─────┬───────┘                                                    │
│         │                                                                  │
│         ▼                                                                   │
│   ┌─────────────┐                                                    │
│   │   ARCHIVE   │  Archive cycle state, reset for next                │
│   └─────────────┘                                                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Transition: WAKE

**Purpose**: Initialize state for a new cycle.

**Actions**:
```
1. Create new execution ID
2. Initialize phase to "wake"
3. Create checkpoint marker
4. Load configuration
5. Verify knowledge base accessibility
6. Check for pending human interactions
```

**State Changes**:
- Execution state created with new cycle ID
- Phase set to "wake"
- Timestamp initialized

**Exit Condition**: State initialized, ready to load previous checkpoint.

---

### Transition: LOAD STATE

**Purpose**: Recover context from previous execution.

**Actions**:
```
1. Read last checkpoint
2. Load pending missions
3. Load pending human interactions
4. Load pending validation items
5. Verify state consistency
6. If checkpoint invalid → prompt recovery decision
```

**State Changes**:
- Mission state populated from checkpoint
- Pending work state populated
- Human checkpoint state populated

**Exit Condition**: Previous state loaded, execution can continue.

---

### Transition: EXECUTE

**Purpose**: Execute the cycle phases, updating state continuously.

**Actions**:
```
1. Execute phase (discover, analyze, plan, execute, validate)
2. Update execution state with phase progress
3. Update mission state as missions complete
4. Update pending work state as items process
5. Emit state change events
6. Check for human interaction triggers
```

**State Changes**:
- Execution state: phase advances
- Mission state: missions progress
- Pending work state: items decrease
- Quality state: metrics update

**Exit Condition**: All phases complete or human interaction required.

---

### Transition: CHECKPOINT

**Purpose**: Persist state at a safe point for recovery.

**Actions**:
```
1. Verify current operation is at safe point
2. Capture all state snapshots
3. Write checkpoint to stable storage
4. Verify checkpoint integrity
5. Emit CheckpointCreated event
6. If verification fails → retry or escalate
```

**State Changes**:
- Checkpoint record created with timestamp
- State snapshots written
- Verification hash computed

**Exit Condition**: Checkpoint written and verified.

---

### Transition: PAUSE

**Purpose**: Suspend execution for human interaction or external dependency.

**Actions**:
```
1. Complete current atomic operation
2. Write checkpoint
3. Update execution state to PAUSED
4. Release resources (LLM connections, file handles)
5. Emit LoopPaused event
6. Notify relevant humans
```

**State Changes**:
- Execution state: status = "paused"
- Human checkpoint state: checkpoint created
- Resources released

**Exit Condition**: Execution suspended, checkpoint available.

---

### Transition: RESUME

**Purpose**: Continue execution from paused state.

**Actions**:
```
1. Read current state
2. Verify checkpoint integrity
3. Load pending human decisions
4. Restore resources
5. Update execution state to RESUMING
6. Continue from checkpoint
```

**State Changes**:
- Execution state: status = "running"
- Human checkpoint state: updated with decisions
- Resources restored

**Exit Condition**: Execution resumed, checkpoint cleared.

---

### Transition: COMPLETE

**Purpose**: Conclude the cycle successfully.

**Actions**:
```
1. Verify all objectives met
2. Finalize execution state
3. Generate cycle summary
4. Update knowledge coverage state
5. Update quality status
6. Emit CycleCompleted event
```

**State Changes**:
- Execution state: status = "completed"
- Final metrics recorded
- Knowledge coverage updated

**Exit Condition**: Cycle complete, ready for archive.

---

### Transition: ARCHIVE

**Purpose**: Preserve cycle record, reset for next cycle.

**Actions**:
```
1. Archive execution state with full history
2. Archive completed missions
3. Archive human interaction records
4. Clear transient state
5. Reset pending work for next cycle
6. Retain checkpoints for recovery window
```

**State Changes**:
- Cycle state moved to archive
- Transient state cleared
- Permanent state retained

**Exit Condition**: State archived, fresh state for next cycle.

---

## 5. Checkpoint Model

Checkpoints are the foundation of resumability. They capture enough state to continue execution if interrupted.

### Checkpoint Semantics

A checkpoint is a **point-in-time snapshot** of all state required to resume execution.

**Properties**:
- Atomic: All or nothing
- Consistent: Represents a valid system state
- Complete: Contains everything needed to resume
- Verifiable: Can be checked for integrity

### When Checkpoints Are Created

Checkpoints are created at these points:

| Event | Checkpoint Type | Guarantees |
|-------|-----------------|------------|
| Phase completion | Phase checkpoint | Phase can restart |
| Mission completion | Mission checkpoint | Mission can restart |
| Before human interaction | Pause checkpoint | Human can be awaited |
| Batch operation | Batch checkpoint | Batch can be resumed |
| Time-based | Periodic checkpoint | Recovery window bounded |
| Manual | On-demand | Admin can trigger |

### What Checkpoints Contain

```
Checkpoint:
  id: string                      # Unique checkpoint ID
  created_at: datetime           # When created
  cycle_id: string              # Which cycle
  
  # Execution context
  execution:
    phase: PhaseId
    stage: StageId
    position: string            # Where in stage
    started_at: datetime
    
  # Mission context
  missions:
    active: List[MissionSnapshot]
    pending: List[MissionId]
    blocked: Map[MissionId, BlockReason]
    
  # Human interactions
  human_checkpoints:
    pending: List[CheckpointId]
    decisions: Map[CheckpointId, Decision]
    
  # Pending work
  pending:
    signals: List[SignalId]
    insights: List[InsightId]
    validations: List[ValidationId]
    
  # State snapshots
  snapshots:
    mission_state: StateSnapshot
    pending_work_state: StateSnapshot
    quality_state: StateSnapshot
    
  # Integrity
  checksum: string               # Verification hash
  previous_checkpoint: CheckpointId  # Chain
```

### Recovery Guarantees

**Strong Guarantee**: From any checkpoint, the engine can resume without:
- Re-executing completed work
- Losing any knowledge incorporated
- Missing any pending human decisions

**Weak Guarantee**: From any checkpoint, the engine can resume but may:
- Re-execute the current operation (idempotent)
- Re-submit pending LLM requests (may incur cost)

**Guarantee Level by Checkpoint Type**:

| Checkpoint | Strong | Weak |
|------------|---------|------|
| Phase completion | ✓ | |
| Mission completion | ✓ | |
| Batch checkpoint | | ✓ |
| Time-based | | ✓ |

### Rollback Behavior

If a checkpoint is invalid or corrupted:

```
1. Detect: Checksum mismatch on load
2. Log: Record corruption details
3. Attempt: Previous checkpoint
4. If previous valid: Resume from previous
5. If no valid checkpoint: PROMPT for recovery decision
   - Restore from archive
   - Start fresh (losing in-progress work)
```

### Partial Execution

If execution is interrupted mid-operation:

```
Mission execution interrupted:
1. Operation is idempotent → re-execute
2. Operation writes partial state → rollback partial
3. Operation sends external request → idempotency key prevents duplicate
4. Resume from mission checkpoint → operation re-executes
```

### Interrupted Execution Recovery

```
Interrupted at phase checkpoint:
1. Checkpoint exists and valid
2. Load checkpoint
3. Resume from phase completion point
4. Re-execute current phase stage

Interrupted at stage midpoint:
1. Checkpoint exists
2. Load checkpoint
3. Resume from stage start
4. Stage re-executes (may be wasteful but safe)
```

---

## 6. State Transitions

The engine transitions through defined states. Invalid transitions are rejected.

### State Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         STATE TRANSITIONS                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                         ┌─────────┐                                       │
│                         │  IDLE   │  Ready for next cycle                   │
│                         └────┬────┘                                       │
│                              │ start                                       │
│                              ▼                                             │
│                         ┌─────────┐                                       │
│                         │ RUNNING │  Actively executing                     │
│                         └────┬────┘                                       │
│                              │                                             │
│          ┌───────────────────┼───────────────────┐                     │
│          │                   │                   │                       │
│          ▼                   ▼                   ▼                       │
│    ┌──────────┐       ┌──────────┐       ┌──────────┐              │
│    │WAITING_H │       │WAITING_V │       │PAUSED   │              │
│    │(human)   │       │(validtn) │       │(manual) │              │
│    └────┬─────┘       └────┬─────┘       └────┬─────┘              │
│         │                   │                   │                       │
│         │ resume            │ resume            │ resume               │
│         └───────────────────┴───────────────────┘                     │
│                              │                                             │
│                              ▼                                             │
│                         ┌─────────┐                                       │
│                         │COMPLETED│  Cycle finished                       │
│                         └────┬────┘                                       │
│                              │                                             │
│                              ▼                                             │
│                         ┌─────────┐                                       │
│                         │ARCHIVED │  State preserved                       │
│                         └─────────┘                                       │
│                                                                             │
│                                                                             │
│    ┌──────────┐                                                        │
│    │  FAILED  │◀── Recovery failed                                       │
│    └────┬─────┘                                                        │
│         │                                                               │
│         ▼                                                               │
│    ┌──────────┐                                                        │
│    │RECOVERING│  Attempting automatic recovery                            │
│    └────┬─────┘                                                        │
│         │                                                               │
│         ├──────────────────┐                                           │
│         ▼                  ▼                                           │
│   ┌──────────┐       ┌──────────┐                                    │
│   │ IDLE     │       │ FAILED   │  Manual intervention needed         │
│   │(recovered)│       │(manual)  │                                    │
│   └──────────┘       └──────────┘                                    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### State Definitions

#### IDLE

**Definition**: Engine is ready to begin a new cycle.

**Valid Entry Transitions**:
- From: (initial state)
- Trigger: System initialized or cycle archived

**Valid Exit Transitions**:
- To: RUNNING, trigger: cycle_start

**Behavior**: No active execution. Resources available.

---

#### RUNNING

**Definition**: Engine is actively executing a cycle.

**Valid Entry Transitions**:
- From: IDLE, trigger: cycle_start
- From: WAITING_H, trigger: human_decision_received
- From: WAITING_V, trigger: validation_complete
- From: PAUSED, trigger: resume_command

**Valid Exit Transitions**:
- To: WAITING_H, trigger: human_interaction_required
- To: WAITING_V, trigger: validation_required
- To: PAUSED, trigger: pause_command
- To: COMPLETED, trigger: cycle_complete
- To: FAILED, trigger: unrecoverable_error

**Behavior**: Phases execute in sequence. State updates continuously.

---

#### WAITING_H

**Definition**: Engine is paused waiting for human decision.

**Valid Entry Transitions**:
- From: RUNNING, trigger: human_interaction_required

**Valid Exit Transitions**:
- To: RUNNING, trigger: human_decision_received
- To: PAUSED, trigger: human_timeout (optional)
- To: FAILED, trigger: human_rejected_critical

**Behavior**: Human reviewer notified. Cycle progress suspended.

---

#### WAITING_V

**Definition**: Engine is paused waiting for validation to complete.

**Valid Entry Transitions**:
- From: RUNNING, trigger: validation_required

**Valid Exit Transitions**:
- To: RUNNING, trigger: validation_complete
- To: WAITING_H, trigger: validation_requires_human
- To: FAILED, trigger: validation_failed_critical

**Behavior**: Validation processes. Cycle progress suspended.

---

#### PAUSED

**Definition**: Engine is manually paused.

**Valid Entry Transitions**:
- From: RUNNING, trigger: pause_command
- From: WAITING_H, trigger: human_timeout

**Valid Exit Transitions**:
- To: RUNNING, trigger: resume_command
- To: IDLE, trigger: abort_command

**Behavior**: Execution suspended. State preserved. Resources held.

---

#### COMPLETED

**Definition**: Cycle finished successfully.

**Valid Entry Transitions**:
- From: RUNNING, trigger: cycle_complete

**Valid Exit Transitions**:
- To: IDLE, trigger: (automatic after archive)
- To: ARCHIVED, trigger: archive_complete

**Behavior**: Final state recorded. Metrics collected. Archive initiated.

---

#### FAILED

**Definition**: Unrecoverable error occurred.

**Valid Entry Transitions**:
- From: RUNNING, trigger: unrecoverable_error
- From: WAITING_H, trigger: human_rejected_critical
- From: WAITING_V, trigger: validation_failed_critical
- From: RECOVERING, trigger: recovery_exhausted

**Valid Exit Transitions**:
- To: RECOVERING, trigger: automatic_recovery
- To: IDLE, trigger: manual_reset (after intervention)

**Behavior**: Error recorded. Manual intervention may be required.

---

#### RECOVERING

**Definition**: Automatic recovery in progress.

**Valid Entry Transitions**:
- From: FAILED, trigger: automatic_recovery

**Valid Exit Transitions**:
- To: IDLE, trigger: recovery_succeeded
- To: FAILED, trigger: recovery_exhausted

**Behavior**: System attempts self-healing. Checkpoints consulted.

---

#### ARCHIVED

**Definition**: Cycle state has been preserved for history.

**Valid Entry Transitions**:
- From: COMPLETED, trigger: archive_complete

**Valid Exit Transitions**:
- None (terminal state for cycle)

**Behavior**: State preserved in archive. Cannot be resumed.

---

## 7. Ownership

State management follows clear ownership rules.

### Ownership Matrix

| State Category | Creator | Primary Updater | Readers | Archiver |
|---------------|--------|-----------------|---------|----------|
| **Execution State** | Engine (wake) | Engine (execute) | All components | Engine (archive) |
| **Mission State** | Planning | Execution, Validation | All components | Engine (archive) |
| **Knowledge Coverage** | Engine (init) | Analysis, Validation | All components | — |
| **Pending Work** | Discovery, Analysis | All departments | All components | Engine (clear) |
| **Human Checkpoints** | Engine (detect) | Human (decide) | Engine, Humans | Engine (clear) |
| **Validation Queue** | Engine (enqueue) | Validation | Validation, Humans | Engine (clear) |
| **Experiment Queue** | Planning | Execution | Execution, Planning | Engine (archive) |
| **Research Backlog** | Planning | Planning, Analysis | All components | — |
| **Quality Status** | Engine (init) | Validation | All components | — |
| **System Health** | Engine (init) | Engine (monitor) | All components | — |

### Department Interactions

#### Discovery

**Reads**:
- Pending work state (to know what to process next)
- Research backlog (for context)

**Writes**:
- Pending work state (adds new signals)
- System health state (source health)

---

#### Analysis

**Reads**:
- Pending work state (processes signals)
- Knowledge coverage state (identifies gaps)
- Research backlog (for context)

**Writes**:
- Pending work state (creates insights)
- Knowledge coverage state (updates coverage)
- Quality status state (reports quality metrics)

---

#### Planning

**Reads**:
- All state (informed decision-making)
- Mission state (current missions)
- Research backlog (what needs planning)

**Writes**:
- Mission state (creates missions)
- Experiment queue state (schedules experiments)
- Research backlog state (updates priorities)

---

#### Execution

**Reads**:
- Mission state (gets work to do)
- Experiment queue state (for context)

**Writes**:
- Mission state (updates progress)
- Experiment queue state (updates status)
- Pending work state (clears completed items)

---

#### Validation

**Reads**:
- Validation queue state (gets items to validate)
- Knowledge coverage state (for context)

**Writes**:
- Validation queue state (processes items)
- Quality status state (reports quality)
- Mission state (marks validation missions complete)

---

### Access Control Principles

1. **Engine owns coordination**: The engine writes execution state; no other component may directly modify it.

2. **Departments own their domain**: Each department writes state related to its domain; others read only.

3. **State changes emit events**: Components do not poll state; they subscribe to events.

4. **State is checkpointed before access**: Concurrent access is managed through checkpoints, not locks.

---

## 8. Recovery Model

The system must recover safely from any failure.

### Failure Taxonomy

| Category | Examples | Recovery |
|----------|----------|----------|
| **Transient** | Network blip, rate limit | Automatic retry |
| **Recoverable** | Checkpoint corrupted | Rollback to previous |
| **Blockable** | Dependency unavailable | Wait with timeout |
| **Fatal** | Data corruption | Manual intervention |

### Recovery Scenarios

#### Power Loss

```
Scenario: System loses power mid-execution.

Detection:
- Checkpoint timestamp older than expected
- Process restart detected

Recovery:
1. Load last valid checkpoint
2. Verify checkpoint integrity
3. If valid → resume from checkpoint
4. If invalid → rollback to previous checkpoint
5. Resume execution

Guarantee: At most one phase re-executes.
```

#### Engine Interruption

```
Scenario: Engine process is killed or interrupted.

Detection:
- Process termination detected
- Heartbeat missing

Recovery:
1. Detect process termination
2. Load last checkpoint
3. Verify state consistency
4. Resume from checkpoint

Guarantee: No work lost; may re-execute current operation.
```

#### LLM Research Delayed

```
Scenario: Gemini API is slow or delayed.

Detection:
- Request timeout exceeded
- Slow response detected

Recovery:
1. Check checkpoint before request
2. If timed out → rollback to checkpoint
3. Retry with backoff
4. If persistent → pause, notify human

Guarantee: Research not lost; may retry.
```

#### Human Absent

```
Scenario: Required human reviewer is unavailable.

Detection:
- Checkpoint deadline passed
- No response received

Recovery:
1. First deadline → send reminder
2. Second deadline → escalate to backup
3. Third deadline → pause with warning
4. Extended absence → prompt manual decision

Guarantee: Human can re-engage at any point.
```

#### Repository Inconsistency

```
Scenario: Knowledge base shows inconsistency.

Detection:
- Checksum mismatch
- Schema violation

Recovery:
1. Isolate affected entities
2. Load last consistent checkpoint
3. Restore affected entities from checkpoint
4. Verify restoration
5. Resume with warning

Guarantee: Consistent state restored.
```

#### Duplicate Execution

```
Scenario: Two engine instances start simultaneously.

Detection:
- Lock file missing
- Execution ID collision

Recovery:
1. First instance acquires lock → proceeds
2. Second instance → detects lock → waits or exits
3. If first fails → lock released
4. Second detects lock released → acquires, proceeds

Guarantee: Only one instance executes.
```

#### Partial Completion

```
Scenario: Execution stops after some but before all work complete.

Detection:
- Checkpoint exists
- Pending work not empty

Recovery:
1. Load checkpoint
2. Identify completed vs. pending work
3. Resume execution
4. Skip completed work, continue pending

Guarantee: Completed work preserved; pending work continued.
```

### Recovery Metrics

| Metric | Target | Alert Threshold |
|--------|--------|----------------|
| Recovery success rate | > 99% | < 95% |
| Mean time to recovery | < 5 min | > 15 min |
| Work lost per recovery | < 1 phase | > 1 phase |
| Data corruption events | 0 | Any |

---

## 9. Relationship to Knowledge

State, knowledge, events, departments, and the engine have distinct but interconnected roles.

### Conceptual Boundaries

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    KNOWLEDGE vs. STATE vs. EVENTS                          │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────┐      │
│   │                         KNOWLEDGE                                │      │
│   │                                                                 │      │
│   │   "What we know about the world"                                 │      │
│   │   • Permanent                                                    │      │
│   │   • Evidence-backed                                              │      │
│   │   • Owned by departments                                        │      │
│   │   • Grows over time                                             │      │
│   │                                                                 │      │
│   │   Example: "Curve Finance TVL increased 50%"                     │      │
│   └─────────────────────────────────────────────────────────────────┘      │
│                                    │                                       │
│                                    │ Complements                            │
│                                    ▼                                       │
│   ┌─────────────────────────────────────────────────────────────────┐      │
│   │                          STATE                                  │      │
│   │                                                                 │      │
│   │   "What we need to continue working"                            │      │
│   │   • Transient                                                   │      │
│   │   • Checkpoint-based                                           │      │
│   │   • Owned by engine                                            │      │
│   │   • Reset each cycle                                           │      │
│   │                                                                 │      │
│   │   Example: "Mission 3 is 65% complete"                         │      │
│   └─────────────────────────────────────────────────────────────────┘      │
│                                    │                                       │
│                                    │ Triggers                               │
│                                    ▼                                       │
│   ┌─────────────────────────────────────────────────────────────────┐      │
│   │                         EVENTS                                  │      │
│   │                                                                 │      │
│   │   "What happened in the system"                                  │      │
│   │   • Immutable record                                             │      │
│   │   • Timestamp-based                                             │      │
│   │   • Owned by emitter                                           │      │
│   │   • Persisted for audit                                         │      │
│   │                                                                 │      │
│   │   Example: "MissionCompleted(mission-003)"                        │      │
│   └─────────────────────────────────────────────────────────────────┘      │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### How They Interrelate

**Knowledge and State**:
- State may reference knowledge (e.g., "last entity ID")
- State does not contain knowledge (separated)
- State changes may trigger knowledge updates

**State and Events**:
- State changes emit events
- Events can trigger state changes
- Events are the history of state changes

**Knowledge and Events**:
- Events may create knowledge (e.g., "EvidenceAssembled" creates evidence)
- Knowledge creation emits events
- Events are the audit trail of knowledge changes

### Layered Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SYSTEM LAYERS                                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────┐      │
│   │                     DEPARTMENTS                                  │      │
│   │   Create knowledge, emit events, read state                      │      │
│   └─────────────────────────────────────────────────────────────────┘      │
│                                    ▲                                       │
│                                    │ Read/Write                            │
│                                    ▼                                       │
│   ┌─────────────────────────────────────────────────────────────────┐      │
│   │                      ENGINE                                      │      │
│   │   Orchestrates, manages state, triggers events                  │      │
│   └─────────────────────────────────────────────────────────────────┘      │
│                                    ▲                                       │
│                                    │ Manages                                │
│                                    ▼                                       │
│   ┌─────────────────────────────────────────────────────────────────┐      │
│   │                    STATE MANAGER                                │      │
│   │   Persists state, checkpoints, recovers                          │      │
│   └─────────────────────────────────────────────────────────────────┘      │
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────┐      │
│   │                    KNOWLEDGE BASE                               │      │
│   │   Stores knowledge, validates, queries                            │      │
│   └─────────────────────────────────────────────────────────────────┘      │
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────┐      │
│   │                      EVENT BUS                                    │      │
│   │   Routes events, maintains history                               │      │
│   └─────────────────────────────────────────────────────────────────┘      │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Ownership Summary

| Component | Owned By | Purpose |
|-----------|---------|---------|
| **Knowledge** | Departments | Represents reality |
| **State** | Engine | Enables continuation |
| **Events** | Emitters | Records what happened |
| **Departments** | Teams | Execute capabilities |
| **Engine** | System | Orchestrates |

---

## 10. Extensibility

The state model must evolve without breaking existing functionality.

### Adding New State Categories

New state categories can be added without modifying existing ones:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ADDING NEW STATE CATEGORY                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Step 1: Define Category                                                │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Add to this document:                                               │   │
│   │ • Name and purpose                                                │   │
│   │ • Contains (what data)                                           │   │
│   │ • Owner                                                         │   │
│   │ • Lifecycle                                                     │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   Step 2: Define Interactions                                           │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Add to ownership matrix:                                          │   │
│   │ • Who creates                                                    │   │
│   │ • Who updates                                                    │   │
│   │ • Who reads                                                     │   │
│   │ • Events emitted                                                 │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   Step 3: Define Checkpoint Behavior                                   │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Does new category need:                                           │   │
│   │ • Checkpointing? (persistent across interruptions)               │   │
│   │ • Archiving? (retained after cycle)                             │   │
│   │ • Both?                                                          │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   Step 4: Update Checkpoint Schema                                      │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Add to checkpoint structure:                                      │   │
│   │ • Snapshot of new category                                        │   │
│   │ • Verification hash                                               │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Example: Adding "Resource Budget" State

Suppose we need to track resource budgets:

```
1. Define Category
   ResourceBudget: Tracks consumption of limited resources
   Contains: llm_calls_today, llm_budget_used, api_calls, storage_used
   
2. Define Interactions
   Creator: Engine (initialization)
   Updater: Execution (consumption)
   Readers: All (read-only)
   Events: ResourceBudgetUpdated, ResourceBudgetExceeded
   
3. Define Checkpoint Behavior
   Checkpointed: Yes (persist across interruptions)
   Archived: No (reset each cycle)
   
4. Update Schema
   Add to checkpoint.snapshots
```

### Version Compatibility

The state model uses semantic versioning:

| Change | Version Bump | Compatibility |
|--------|--------------|---------------|
| Add optional category | Minor | Backward compatible |
| Add required field to category | Major | Breaking |
| Change category semantics | Major | Breaking |
| Add relationship | Minor | Backward compatible |
| Remove category | Major | Breaking |

---

## Dependencies

This document defines the state management system that enables the Research Loop Engine to be resumable.

- `02-engine/research-loop.md` — Engine that uses state
- `03-departments/departments.md` — Departments that interact with state
- `06-quality/quality-gates.md` — Quality gates that affect state
- `09-safety/error-taxonomy.md` — Errors that trigger recovery

## Related Documents

- `02-engine/event-bus.md` — [Future] Event routing that state changes trigger
- `02-engine/scheduler.md` — [Future] Scheduling that reads execution state
- `02-engine/retry-engine.md` — [Future] Retry logic that uses checkpoint state

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |

---

## Capabilities Unlocked

The following architectural components are now possible because the State Manager exists:

### Core Capabilities

| Capability | Why It Requires State |
|------------|----------------------|
| **Event Bus** | Events are the observable surface of state changes. Without state, events have no context. |
| **Skill System** | Skills must resume from checkpoints. Without state, skills cannot recover from interruption. |
| **Scheduler** | Scheduler must read execution state to decide what to run next. |
| **Retry Engine** | Retry logic must know what failed and from which checkpoint to retry. |
| **Queue Management** | Queues are state. Managing them requires persistent state. |
| **Autonomous Execution** | Autonomous operation requires the ability to pause and resume without losing context. |
| **Parallel Research** | Parallel execution requires tracking multiple concurrent states. |
| **Long-running Missions** | Missions spanning multiple cycles require checkpointed state. |

### Recovery Capabilities

| Capability | Why It Requires State |
|------------|----------------------|
| **Automatic Recovery** | Recovery requires checkpoints. Without state, nothing to recover. |
| **Rollback** | Rollback requires historical state. Immutable history enables this. |
| **Replay** | Replay requires events + state. Event-driven state provides both. |
| **Audit Trail** | Audit requires knowing what happened when. State transitions provide this. |

### Quality Capabilities

| Capability | Why It Requires State |
|------------|----------------------|
| **Quality Gates** | Gates require tracking validation queue state. |
| **Confidence Tracking** | Confidence distribution is state that evolves over cycles. |
| **Coverage Analysis** | Coverage requires comparing current knowledge against targets (state). |

### Operations Capabilities

| Capability | Why It Requires State |
|------------|----------------------|
| **Human Checkpoints** | Checkpoints are state. Tracking human interactions requires state. |
| **Resource Budgeting** | Budget tracking is state. Enforcing limits requires state. |
| **Mission Dependencies** | Dependency resolution requires mission state. |
| **Priority Management** | Priorities change. Tracking priority evolution requires state. |

### Future Architecture Documents Enabled

| Document | Depends On |
|----------|-----------|
| `02-engine/event-bus.md` | State Manager (state changes emit events) |
| `02-engine/scheduler.md` | State Manager (reads execution state) |
| `02-engine/retry-engine.md` | State Manager (checkpoint-based recovery) |
| `02-engine/queue-manager.md` | State Manager (queue state) |
| `02-engine/mission-coordinator.md` | State Manager (mission state) |
| `02-engine/human-interface.md` | State Manager (checkpoint management) |
| `02-engine/health-monitor.md` | State Manager (health state) |
| `02-engine/audit-logger.md` | State Manager (state transitions as audit) |
