# Research Loop Engine

**Document ID**: 02-engine.1
**Domain**: Engine
**Status**: Draft

---

## Purpose

### Why the Loop Exists

The Research Loop Engine is the **heart** of the nav-research-engine. It is the orchestration substrate that transforms a collection of components into an autonomous research system.

Without the loop, the repository is a library. With the loop, it becomes an intelligence.

The loop exists to solve a fundamental problem: research is not a pipeline. It is not a sequence of steps that run once and complete. Research is a **continuous loop of discovery, analysis, planning, and validation** that feeds upon itself—each cycle improving the next.

The loop's purpose is to:

1. **Perpetuate** — Keep research running indefinitely, not execute and terminate
2. **Orchestrate** — Coordinate departments, skills, and knowledge without tight coupling
3. **Remember** — Maintain state across cycles so work is never lost
4. **Observe** — Emit events that allow the entire system to react to state changes
5. **Pause** — Stop safely when human judgment is required, and resume cleanly when judgment is delivered
6. **Improve** — Each cycle should leave the repository in better state than it found it

### Why It Is the Heart

Every other component in the repository exists to serve the loop:

- **Departments** are invoked by the loop
- **Knowledge** is consumed and produced by the loop
- **Quality gates** are enforced by the loop
- **Integrations** are called by the loop
- **Humans** are consulted by the loop

The loop does not know how departments work internally. It only knows:
- What they can consume (inputs)
- What they can produce (outputs)
- When they should be invoked (triggers)
- What conditions they require (dependencies)

This separation is intentional. The loop is a **conductor**, not an orchestra. It coordinates, it does not perform.

---

## Design Philosophy

The loop is governed by six non-negotiable principles:

### 1. Deterministic

Given the same inputs, the same state, and the same configuration, the loop produces the same behavior.

**Implications**:
- The loop does not make decisions based on time, randomness, or implicit state
- All decision logic is explicit, traceable, and auditable
- Inputs are versioned; outputs are deterministic functions of inputs

**Rationale**: Non-deterministic systems are impossible to debug. When research produces an unexpected conclusion, we must be able to reproduce exactly how we got there.

### 2. Modular

The loop is decomposed into explicit, replaceable stages. Each stage has a single responsibility.

**Implications**:
- Stages communicate only through well-defined contracts
- Stages can be swapped, removed, or reordered without changing other stages
- New stages can be inserted without modifying existing stages

**Rationale**: Research methodology evolves. A modular loop survives methodology changes without rewrites.

### 3. Resumable

Any cycle can be interrupted and resumed from exactly where it stopped.

**Implications**:
- State is persisted after every stage completion
- The loop can be stopped mid-execution and restarted without data loss
- Recovery is explicit, not implicit

**Rationale**: Research takes time. Systems fail. Networks drop. Humans need to review. None of these events should destroy work.

### 4. Observable

Every state transition, every decision, and every significant event is visible to the rest of the system.

**Implications**:
- The loop emits events for every meaningful state change
- Logging is structured, not freeform
- Observers can subscribe to specific event types without coupling

**Rationale**: A system that cannot be observed cannot be trusted. Research credibility requires traceability.

### 5. Auditable

Every action taken by the loop can be traced to a human or a system decision with full context.

**Implications**:
- Audit logs are immutable and timestamped
- Every knowledge addition is traceable to its source
- Human checkpoints are logged with reviewer identity

**Rationale**: When the system produces a conclusion, stakeholders must trust it. Audit trails are the foundation of trust.

### 6. Composable

The loop can be configured to run at different granularities—daily, weekly, or on-demand—without changing its structure.

**Implications**:
- The loop exposes a consistent interface regardless of execution frequency
- Sub-cycles can be triggered independently (e.g., run only Discovery)
- Composition is configuration, not code

**Rationale**: Research operates on multiple timescales. Daily triage, weekly synthesis, monthly retrospectives all share the same loop logic.

---

## Inputs

The loop requires the following inputs before it begins. All inputs are explicit, versioned, and retrievable.

### 1. Repository State

The complete state of the repository at loop start:

```
Repository State:
├── knowledge/
│   ├── entities/        # All entity files
│   ├── evidence/       # All evidence chains
│   ├── relationships/  # All relationship records
│   └── signals/        # Current signal inventory
├── missions/
│   ├── active/         # Missions in progress
│   ├── queued/        # Missions waiting
│   └── completed/      # Archived missions
├── state/
│   ├── loop-state.json    # Current engine state
│   ├── mission-state.json # Mission machine state
│   └── checkpoint.json    # Last successful stage
└── config/
    ├── loop-config.yaml   # Loop configuration
    └── thresholds.yaml     # Decision thresholds
```

### 2. Knowledge Graph

The current knowledge graph snapshot:

```
Knowledge Graph:
├── entities: Map<entity_id, Entity>
├── relationships: List<Relationship>
├── lastSyncTimestamp: ISO8601
└── version: string
```

### 3. Mission Queue

The prioritized list of research missions awaiting execution:

```
Mission Queue:
├── pending: List<Mission>      # Not yet started
├── inProgress: List<Mission>   # Currently executing
├── blocked: List<Mission>      # Waiting on dependencies
└── prioritized: List<Mission>  # Sorted by priority score
```

### 4. Signal Inventory

Raw signals collected since the last cycle:

```
Signal Inventory:
├── newSignals: List<Signal>    # Unprocessed
├── staleSignals: List<Signal> # Expired
├── prioritySignals: List<Signal> # High priority
└── lastProcessedTimestamp: ISO8601
```

### 5. Knowledge Gaps

Open knowledge gaps identified by the system:

```
Knowledge Gaps:
├── open: List<Gap>           # Not yet addressed
├── inProgress: List<Gap>     # Gap being filled
├── resolved: List<Gap>       # Recently resolved
└── staleGaps: List<Gap>     # No longer relevant
```

### 6. Configuration

Loop-specific configuration:

```
Configuration:
├── loop:
│   ├── mode: daily | weekly | on-demand
│   ├── stages: List<StageConfig>  # Which stages to run
│   ├── timeBudget: Duration       # Max execution time
│   └── parallelism: number        # Concurrent missions
├── departments:
│   ├── enabled: List<Department>
│   └── timeoutOverrides: Map<Department, Duration>
├── quality:
│   ├── autoApproveThreshold: number
│   ├── humanReviewThreshold: number
│   └── mandatoryReviewTypes: List<EventType>
└── integrations:
    ├── gemini:
    │   ├── enabled: boolean
    │   ├── budgetLimitUSD: number
    │   └── maxConcurrent: number
    └── consumr:
        ├── enabled: boolean
        └── categories: List<string>
```

### 7. Human Feedback

Pending human inputs since the last cycle:

```
Human Feedback:
├── pendingReviews: List<Review>
├── pendingDecisions: List<Decision>
├── completedReviews: List<Review>
└── escalations: List<Escalation>
```

### 8. External Research

Research artifacts from external sources:

```
External Research:
├── geminiReports: List<GeminiReport>
├── consumrStudies: List<ConsumrStudy>
├── webhooks: List<WebhookEvent>
└── scheduledDeliveries: List<ScheduledDelivery>
```

---

## Outputs

After one successful loop execution, the following artifacts must exist. Each output is versioned, timestamped, and traceable.

### 1. Updated Knowledge Base

The knowledge base reflects all additions, modifications, and deletions from this cycle:

```
Knowledge Base Update:
├── added: List<Entity>           # New entities
├── modified: List<EntityUpdate>   # Changed entities
├── deleted: List<EntityId>      # Removed entities
├── version: string               # New KB version
└── checksum: string             # Integrity check
```

### 2. Updated State

The engine state is persisted for resumability:

```
Loop State:
├── lastSuccessfulStage: StageId
├── lastCheckpoint: ISO8601
├── cycleCount: number
├── loopVersion: string
├── executionHistory: List<ExecutionRecord>
└── healthMetrics: HealthMetrics
```

### 3. Mission Updates

Mission queue reflects current state:

```
Mission Updates:
├── created: List<Mission>       # New missions
├── completed: List<Mission>    # Finished missions
├── failed: List<MissionFailure> # Failed missions
├── updated: List<MissionUpdate> # Modified missions
└── nextPriority: number        # Next cycle priority seed
```

### 4. Knowledge Gap Updates

Gap tracking reflects current state:

```
Gap Updates:
├── detected: List<Gap>        # New gaps found
├── progress: List<GapProgress> # Gaps being addressed
├── resolved: List<GapId>      # Gaps filled
└── closed: List<GapId>        # Gaps no longer relevant
```

### 5. Signal Updates

Signal inventory reflects current state:

```
Signal Updates:
├── processed: List<SignalId>   # Signals handled
├── promoted: List<SignalId>   # Signals upgraded to missions
├── archived: List<SignalId>   # Signals expired
└── newSignals: number         # Count for next cycle
```

### 6. Quality Report

Quality metrics for this cycle:

```
Quality Report:
├── gatesPassed: number
├── gatesFailed: number
├── humanReviewsRequired: number
├── humanReviewsCompleted: number
├── confidenceStats: ConfidenceStats
└── qualityScore: number
```

### 7. Execution Log

A complete, auditable record of what happened:

```
Execution Log:
├── events: List<Event>
├── decisions: List<Decision>
├── errors: List<Error>
├── humanInteractions: List<HumanInteraction>
├── stageDurations: Map<StageId, Duration>
└── totalDuration: Duration
```

### 8. Intelligence Artifacts

When triggered (daily or weekly cycles), reports and summaries:

```
Intelligence Artifacts:
├── dailySummary: DailySummary     # Daily cycle output
├── weeklyReport: WeeklyReport     # Weekly cycle output
├── alertDigest: AlertDigest      # Significant findings
└── opportunityRanking: Ranking    # Prioritized opportunities
```

---

## Lifecycle

The loop executes through six stages in sequence. Each stage is a distinct phase with explicit purpose, inputs, outputs, and failure conditions.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            LOOP LIFECYCLE                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   │
│  │  1.     │──▶│  2.     │──▶│  3.     │──▶│  4.     │──▶│  5.     │   │
│  │  WAKE   │   │ DISCOVER│   │ ANALYZE │   │ PLAN    │   │ EXECUTE │   │
│  └─────────┘   └─────────┘   └─────────┘   └─────────┘   └────┬────┘   │
│                                                                  │        │
│                                                            ┌─────────┐   │
│                                                            │  6.     │   │
│                                                            │ VALIDATE│   │
│                                                            └────┬────┘   │
│                                                                 │        │
│    ┌───────────────────────────────────────────────────────────┤        │
│    │                                                           │        │
│    ▼                                                           ▼        │
│  ┌─────────┐                                              ┌─────────┐   │
│  │  PAUSE  │◀─────────────────────────────────────────────│  REST   │   │
│  │(Human)  │                                              │         │   │
│  └─────────┘                                              └─────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### Stage 1: WAKE

**Purpose**: Initialize the loop, verify system readiness, and establish the execution context.

**Inputs**:
- Repository state (from filesystem)
- Configuration (from config/)
- Previous loop state (from state/loop-state.json)
- Pending human feedback (from feedback queue)

**Outputs**:
- Execution context (contextual information for this cycle)
- System health report
- Resumption decision (resume from checkpoint or start fresh)

**Failure Conditions**:
- Repository inaccessible → HALT with repository error
- Configuration invalid → HALT with config error
- Previous state corrupted → Prompt for recovery decision
- External dependencies unreachable → DECIDE: continue without or HALT

**Exit Conditions**:
- All systems verified healthy
- Execution context established
- Resumption point determined

**Dependencies**:
- None (this is always the first stage)

**Expected Side Effects**:
- Loop state updated with new execution ID
- Metrics initialized
- Logging started

---

### Stage 2: DISCOVER

**Purpose**: Detect new signals from all configured data sources and update the signal inventory.

**Inputs**:
- Execution context
- Signal inventory
- Source configurations (from config/integrations/)
- Knowledge graph (for deduplication context)

**Outputs**:
- New signals (collected from sources)
- Updated signal inventory
- Source health report (which sources responded, which failed)
- Deduplication report (new vs. existing signals)

**Failure Conditions**:
- Source unreachable → Log warning, continue with available sources
- Rate limit hit → Pause source, retry with backoff
- Source returns malformed data → Log error, skip source, emit SourceError event

**Exit Conditions**:
- All enabled sources polled (or explicitly skipped)
- New signals classified and scored
- Stale signals archived

**Dependencies**:
- WAKE stage complete

**Expected Side Effects**:
- Events emitted: `SignalsCollected`, `SourcePolled`, `SourceError`
- New signals written to knowledge/signals/

---

### Stage 3: ANALYZE

**Purpose**: Transform signals into enriched insights by cross-referencing with existing knowledge.

**Inputs**:
- New signals from DISCOVER
- Knowledge graph
- Knowledge gaps (from gap tracking)
- Entity schemas (from 02-knowledge/)

**Outputs**:
- Insights (signal + context + evidence)
- Evidence chains (for each insight)
- Gap coverage report (which gaps are addressed by new signals)
- Confidence scores (with rationale)

**Failure Conditions**:
- LLM service unavailable → PAUSE with human notification
- Insight generation fails → Log error, mark signal for retry
- Knowledge graph inconsistency → Log error, emit `KnowledgeConflict` event

**Exit Conditions**:
- All priority signals analyzed (or time budget exhausted)
- Confidence scores assigned to all insights
- Gaps identified for each insight

**Dependencies**:
- DISCOVER stage complete

**Expected Side Effects**:
- Events emitted: `InsightGenerated`, `EvidenceAssembled`, `GapIdentified`, `LLMRequest`
- Insights written to knowledge/insights/
- Evidence chains written to knowledge/evidence/

---

### Stage 4: PLAN

**Purpose**: Decide what to do with insights—create missions, update priorities, and plan execution.

**Inputs**:
- Insights from ANALYZE
- Existing mission queue
- Knowledge gaps
- Configuration (priorities, thresholds)

**Outputs**:
- Mission queue (updated with new missions)
- Execution plan (which missions to run, in what order)
- Resource allocation (which missions can run concurrently)
- Priority scores (for each queued mission)

**Failure Conditions**:
- No valid missions can be created → Log warning, emit `PlanningFailure` event
- Priority calculation fails → Use default priority, log error
- Resource conflict → Defer lower-priority mission

**Exit Conditions**:
- Mission queue updated
- Execution plan generated
- All high-priority items assigned

**Dependencies**:
- ANALYZE stage complete

**Expected Side Effects**:
- Events emitted: `MissionCreated`, `MissionPrioritized`, `PlanGenerated`
- New missions written to missions/active/
- Plan written to state/execution-plan.json

---

### Stage 5: EXECUTE

**Purpose**: Run the highest-priority missions according to the execution plan.

**Inputs**:
- Execution plan from PLAN
- Department configurations
- Available resources (parallelism limits, time budget)
- Mission definitions

**Outputs**:
- Mission results (for each completed mission)
- Mission failures (for each failed mission)
- Resource utilization report
- Generated artifacts (Gemini prompts, Consumr requests, research outputs)

**Failure Conditions**:
- Mission execution fails → Retry once, then mark failed
- Time budget exhausted → Pause remaining missions, emit `ExecutionPaused` event
- Resource exhaustion → Reduce parallelism, continue

**Exit Conditions**:
- All planned missions executed (success or fail)
- Time budget exhausted
- Human checkpoint reached (see Human Checkpoints section)

**Dependencies**:
- PLAN stage complete

**Expected Side Effects**:
- Events emitted: `MissionStarted`, `MissionCompleted`, `MissionFailed`, `ArtifactGenerated`
- Mission results written to missions/completed/
- Artifacts written to artifacts/

---

### Stage 6: VALIDATE

**Purpose**: Verify all outputs meet quality standards before incorporation into the knowledge base.

**Inputs**:
- Mission results from EXECUTE
- Quality gates (from 04-quality/)
- Evidence chains
- Existing knowledge (for consistency checking)

**Outputs**:
- Validated knowledge (ready for incorporation)
- Rejected artifacts (with rationale)
- Human review queue (items requiring human judgment)
- Quality report

**Failure Conditions**:
- Quality gate fails → Route to human review queue
- Consistency check fails → Emit `KnowledgeConflict` event, require resolution
- Evidence insufficient → Lower confidence, require human review

**Exit Conditions**:
- All artifacts validated or queued for human review
- Quality report generated

**Dependencies**:
- EXECUTE stage complete

**Expected Side Effects**:
- Events emitted: `ValidationPassed`, `ValidationFailed`, `HumanReviewRequested`
- Validated knowledge staged for incorporation
- Human review items queued

---

### Stage 7: REST

**Purpose**: Incorporate validated knowledge, update state, generate reports, and prepare for the next cycle.

**Inputs**:
- Validated knowledge from VALIDATE
- Loop state
- Report configuration

**Outputs**:
- Updated knowledge base (knowledge incorporated)
- Loop state (persisted for next cycle)
- Intelligence reports (if triggered)
- Metrics snapshot

**Failure Conditions**:
- Incorporation fails → Rollback staged changes, emit `IncorporationFailed` event
- Report generation fails → Log warning, continue without report

**Exit Conditions**:
- Knowledge base updated
- State persisted
- Reports generated (if scheduled)
- Metrics recorded

**Dependencies**:
- VALIDATE stage complete

**Expected Side Effects**:
- Events emitted: `KnowledgeIncorporated`, `LoopCompleted`, `ReportGenerated`
- Knowledge base committed to repository
- Loop state written to state/loop-state.json
- Reports written to reports/

---

## State Management

The loop must remember where it stopped, why it stopped, and how to resume. State management is the mechanism that makes the loop resumable.

### State Structure

```yaml
loop_state:
  version: "1.0"
  execution_id: "uuid"
  status: IDLE | RUNNING | PAUSED | WAITING | COMPLETED | FAILED
  
  # Execution tracking
  started_at: ISO8601
  last_checkpoint: ISO8601
  last_successful_stage: StageId
  stage_history: List<StageRecord>
  
  # Resume information
  resume_from: StageId          # Which stage to resume
  staged_changes: List<Change> # Changes not yet committed
  pending_events: List<Event>   # Events not yet processed
  
  # Health
  consecutive_failures: number
  last_successful_cycle: ISO8601
  health_score: number
  
  # Metrics
  cycles_completed: number
  missions_completed: number
  knowledge_added: number
```

### Checkpoint Strategy

The loop checkpoints after every stage completion:

```
After Stage N Completes:
1. Write staged changes to state/staged/
2. Update loop_state.json with:
   - last_successful_stage = N
   - last_checkpoint = now
   - stage_history += [Stage N result]
3. Write checkpoint marker to state/checkpoint.json
4. Emit event: CheckpointReached(stage=N)
```

### Recovery Strategy

On wake, the loop checks for interrupted execution:

```
On Wake:
1. Read loop_state.json
2. If status == RUNNING:
   a. Check checkpoint marker exists
   b. If checkpoint valid → resume_from = last_successful_stage + 1
   c. If checkpoint invalid → prompt for recovery decision
3. If status == PAUSED:
   a. Check pending human input
   b. If input complete → resume
   c. If input pending → remain paused
4. If status == IDLE or COMPLETED:
   a. Start fresh cycle
```

### State Persistence

| What | Where | When | Format |
|------|-------|------|--------|
| Loop state | `state/loop-state.json` | After every stage | JSON |
| Checkpoint | `state/checkpoint.json` | After every stage | JSON |
| Staged changes | `state/staged/` | Continuously | Per-entity JSON |
| Execution log | `state/logs/` | Continuously | JSONL |
| Metrics | `state/metrics/` | After completion | JSON |

---

## Event Model

The loop communicates internally using an event-driven architecture. Events are the communication mechanism between stages, departments, and observers.

### Event Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           EVENT ARCHITECTURE                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐        │
│   │ Stage 1 │────▶│ Stage 2 │────▶│ Stage 3 │────▶│ Stage 4 │        │
│   └────┬────┘     └────┬────┘     └────┬────┘     └────┬────┘        │
│        │                │                │                │               │
│        │ Events         │ Events         │ Events         │ Events        │
│        ▼                ▼                ▼                ▼               │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │                      EVENT BUS                                     │   │
│   │   ┌─────────────────────────────────────────────────────────┐     │   │
│   │   │  Subscribers can react to events without tight coupling │     │   │
│   │   └─────────────────────────────────────────────────────────┘     │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│         ┌──────────────────────────┼──────────────────────────┐           │
│         │                          │                          │           │
│         ▼                          ▼                          ▼           │
│   ┌───────────┐            ┌───────────┐            ┌───────────┐      │
│   │ Observers │            │  Actors   │            │  Loggers  │      │
│   │(Dashboard)│            │(Department│            │(Audit Log)│      │
│   └───────────┘            │ Callbacks)│            └───────────┘      │
│                           └───────────┘                                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Event Types

#### Core Loop Events

| Event | Emitted When | Payload |
|-------|-------------|---------|
| `LoopStarted` | Cycle begins | `{executionId, mode, config}` |
| `StageStarted` | Stage begins | `{stageId, inputs}` |
| `StageCompleted` | Stage ends | `{stageId, outputs, duration}` |
| `StageFailed` | Stage errors | `{stageId, error, canRetry}` |
| `CheckpointReached` | Checkpoint written | `{stageId, checkpointId}` |
| `LoopCompleted` | Cycle ends | `{executionId, summary}` |
| `LoopFailed` | Cycle errors | `{executionId, error, stage}` |

#### Knowledge Events

| Event | Emitted When | Payload |
|-------|-------------|---------|
| `SignalDetected` | New signal found | `{signalId, source, priority}` |
| `InsightGenerated` | Insight created | `{insightId, confidence, gaps}` |
| `EvidenceAssembled` | Evidence chain built | `{evidenceId, strength}` |
| `KnowledgeAdded` | Knowledge incorporated | `{entityId, version}` |
| `KnowledgeUpdated` | Knowledge modified | `{entityId, oldVersion, newVersion}` |
| `KnowledgeConflict` | Conflict detected | `{entityId, conflicts}` |
| `GapDetected` | Knowledge gap found | `{gapId, type, severity}` |
| `GapResolved` | Gap filled | `{gapId, resolution}` |

#### Mission Events

| Event | Emitted When | Payload |
|-------|-------------|---------|
| `MissionCreated` | Mission generated | `{missionId, priority, type}` |
| `MissionStarted` | Mission execution begins | `{missionId, assignedTo}` |
| `MissionCompleted` | Mission succeeds | `{missionId, results}` |
| `MissionFailed` | Mission fails | `{missionId, error, canRetry}` |
| `MissionBlocked` | Mission waits on dependency | `{missionId, dependency}` |

#### Human Interaction Events

| Event | Emitted When | Payload |
|-------|-------------|---------|
| `HumanReviewRequested` | Review queued | `{itemId, type, priority, deadline}` |
| `HumanReviewCompleted` | Review delivered | `{itemId, decision, reviewer}` |
| `HumanDecisionRequired` | Decision needed | `{contextId, options, deadline}` |
| `HumanEscalation` | Issue escalated | `{escalationId, reason, priority}` |

#### Quality Events

| Event | Emitted When | Payload |
|-------|-------------|---------|
| `QualityGatePassed` | Gate passed | `{gateId, itemId}` |
| `QualityGateFailed` | Gate failed | `{gateId, itemId, reason}` |
| `ValidationRequested` | Validation triggered | `{itemId, type}` |
| `ValidationPassed` | Validation success | `{itemId}` |
| `ValidationFailed` | Validation failure | `{itemId, reasons}` |

### Event Flow

Events flow through the system in this sequence:

```
1. STAGE EMITS EVENT
   Stage completes work → emits event with result payload

2. EVENT BUS RECEIVES
   Event published to bus → bus routes to subscribers

3. SUBSCRIBERS NOTIFIED
   All subscribers receive event (filtered by subscription)

4. REACTIONS TRIGGERED
   Subscribers execute their reaction logic:
   - Observers: Update dashboards
   - Actors: Trigger downstream work
   - Loggers: Write to audit log

5. NEW EVENTS EMITTED
   Reactions may emit new events → loop continues
```

### Event Schema

Every event follows this schema:

```yaml
event:
  id: uuid                    # Unique event ID
  type: EventType             # Event type identifier
  version: string              # Schema version
  timestamp: ISO8601          # When event occurred
  
  source:
    emitter: string           # Who emitted this event
    executionId: string       # Which execution
    stageId: StageId          # Which stage
  
  payload: object             # Event-specific data
  
  metadata:
    correlationId: string     # For tracing related events
    causationId: string       # Event that caused this one
    tracing: TracingContext    # Distributed tracing info
```

---

## Human Checkpoints

The loop must stop when human judgment is required. These are the **human checkpoints**—explicit suspension points where the loop pauses and waits for human input.

### Checkpoint Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         HUMAN CHECKPOINT                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Loop executes normally                                                    │
│         │                                                                   │
│         ▼                                                                   │
│   ┌─────────────┐                                                          │
│   │ Checkpoint  │                                                          │
│   │ Condition?  │                                                          │
│   └──────┬──────┘                                                          │
│          │                                                                   │
│          ├── Yes ──▶ Loop pauses, emits HumanReviewRequested              │
│          │                  │                                             │
│          │                  ▼                                             │
│          │            ┌─────────────┐                                     │
│          │            │   Human    │                                     │
│          │            │   Reviews │                                     │
│          │            │   Work    │                                     │
│          │            └──────┬──────┘                                     │
│          │                   │                                            │
│          │                   │ Completes                                  │
│          │                   ▼                                            │
│          │            ┌─────────────┐                                     │
│          │            │   Resume   │                                     │
│          │            │  Decision  │                                     │
│          │            └──────┬──────┘                                     │
│          │                   │                                            │
│          └── No ────────────▶│                                            │
│                               │                                            │
│                               ▼                                            │
│                       Loop continues                                        │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Checkpoint Triggers

The loop pauses for human review when any of these conditions are true:

| Trigger | Condition | Priority | SLA |
|---------|-----------|----------|-----|
| **Confidence Below Threshold** | `confidence < quality.humanReviewThreshold` | Medium | 24h |
| **Knowledge Conflict** | `count(contradicting_entities) > 0` | High | 4h |
| **High-Impact Finding** | `impact > thresholds.highImpact` | High | 4h |
| **Novel Conclusion** | `entity.type is NEW_CATEGORY` | Medium | 24h |
| **Mission Failure** | `mission.failure.retryCount >= 2` | Medium | 24h |
| **Quality Gate Failure** | `gate.failed == true` | High | 4h |
| **Stakeholder Request** | `human.feedback.requested == true` | Variable | As requested |
| **Validation Failure** | `validation.passed == false` | High | 4h |
| **System Error** | `error.severity >= SEV-2` | Critical | 1h |

### Checkpoint Workflow

For each human checkpoint, this workflow executes:

```
1. PAUSE
   Loop state → PAUSED
   Emit: HumanReviewRequested(item, type, priority, deadline)
   Notify: Assigned reviewers

2. QUEUE
   Item added to review queue
   Reviewer dashboard updated
   SLA timer started

3. REVIEW
   Human reviews item
   Human makes decision (approve / reject / modify / escalate)
   Human provides rationale

4. DECIDE
   Decision recorded in audit log
   Loop state → RESUMING
   Staged changes updated based on decision

5. RESUME
   Emit: HumanReviewCompleted(item, decision, reviewer)
   Continue from checkpoint
```

### Checkpoint Types

#### Type 1: Pre-Execution Approval

**Purpose**: Human approves missions before execution begins.

**When Triggered**:
- Mission is P1 priority
- Mission involves new methodology
- Mission has resource allocation above threshold

**Decision Options**:
- **Approve**: Proceed with execution
- **Modify**: Proceed with modifications
- **Reject**: Do not execute, archive mission
- **Defer**: Do not execute now, re-evaluate later

---

#### Type 2: Quality Gate Review

**Purpose**: Human validates outputs before knowledge incorporation.

**When Triggered**:
- Confidence score below threshold
- Evidence chain incomplete
- Conclusion contradicts existing knowledge

**Decision Options**:
- **Approve**: Incorporate with current confidence
- **Approve with Confidence Adjustment**: Incorporate with modified confidence
- **Request More Evidence**: Return to Analysis
- **Reject**: Do not incorporate, document rationale

---

#### Type 3: Conflict Resolution

**Purpose**: Human resolves contradictory knowledge.

**When Triggered**:
- New evidence contradicts existing entity
- Two entities claim the same relationship
- Timeline inconsistencies detected

**Decision Options**:
- **Keep Existing**: Discard new evidence, retain existing
- **Replace**: Replace existing with new
- **Merge**: Combine both with updated confidence
- **Escalate**: Request expert review

---

#### Type 4: Mission Failure Review

**Purpose**: Human decides how to handle failed missions.

**When Triggered**:
- Mission failed after max retries
- Mission failed with novel error type
- Mission failed with high-impact implication

**Decision Options**:
- **Retry**: Attempt mission again with modifications
- **Abandon**: Archive mission, document failure
- **Split**: Break mission into smaller pieces
- **Escalate**: Request expert involvement

---

#### Type 5: Scheduled Review

**Purpose**: Periodic human review of system output.

**When Triggered**:
- Weekly cycle complete
- Monthly report ready
- Threshold metrics exceeded

**Decision Options**:
- **Accept**: Report approved for distribution
- **Request Changes**: Report needs modification
- **Hold**: Report paused pending additional information

---

## Error Recovery

The loop must handle errors gracefully. Recovery is explicit, not implicit.

### Recovery Philosophy

> Fail loudly, recover systematically, learn visibly.

The loop distinguishes between:
- **Retryable errors**: Transient failures that may succeed on retry
- **Recoverable errors**: Failures that require human intervention
- **Fatal errors**: Failures that cannot be recovered without systemic change

### Error Handling Matrix

| Error Type | Detection | Response | Recovery |
|-----------|-----------|----------|----------|
| LLM timeout | Stage output missing | Retry with backoff | Pause if persistent |
| Source unavailable | Health check fails | Skip source | Alert if critical |
| Mission fails | Stage output error | Retry mission | Human review |
| Validation fails | Gate check fails | Route to review | Human decision |
| State corrupted | Checksum mismatch | Rollback to checkpoint | Restore from backup |
| Duplicate detected | Deduplication check | Merge or reject | Human decision |
| Dependency missing | Dependency check fails | Block mission | Resolve dependency |

### Recovery Procedures

#### Gemini Report Missing

```
Detection: EXECUTE stage completes but no artifact written

Recovery Steps:
1. Log error with context (missionId, prompt used)
2. Check Gemini service health
3. If service healthy:
   a. Retry mission with same prompt
   b. If retry succeeds → continue
   c. If retry fails → emit MissionFailed, route to human review
4. If service unhealthy:
   a. Pause EXECUTE stage
   b. Emit HumanReviewRequested (critical)
   c. Wait for human decision
```

#### Repository Inconsistent

```
Detection: Checksum mismatch on staged changes

Recovery Steps:
1. Log error, do not commit staged changes
2. Compare current state with last checkpoint
3. Identify which entities are inconsistent
4. For each inconsistent entity:
   a. Restore from checkpoint version
   b. Log restoration
5. If restoration fails:
   a. Restore entire knowledge base from backup
   b. Replay changes since backup
6. Emit RepositoryRestored event
7. Resume from last successful checkpoint
```

#### Duplicate Knowledge Appears

```
Detection: Deduplication check fails during VALIDATE

Recovery Steps:
1. Pause VALIDATE stage
2. Compare duplicate with existing entity
3. Determine if true duplicate or distinct entity
4. If true duplicate:
   a. Merge entities (preserve higher confidence version)
   b. Update all relationship references
   c. Archive old entity with "merged" status
5. If distinct but similar:
   a. Flag for human disambiguation
   b. Emit HumanReviewRequested (disambiguation)
6. Resume after resolution
```

#### Mission Fails

```
Detection: Mission returns error or exceeds retry limit

Recovery Steps:
1. Increment mission failure count
2. If failure count < maxRetries:
   a. Log attempt
   b. Retry mission with same or modified parameters
3. If failure count >= maxRetries:
   a. Emit MissionFailed event
   b. Route to human review
   c. Log failure details
   d. Do not block other missions
4. Continue with remaining missions
5. Emit summary of failures at stage end
```

#### Validation Fails

```
Detection: Quality gate returns failed status

Recovery Steps:
1. Log validation failure with specific gate and reason
2. If gate is mandatory:
   a. Do not proceed to incorporation
   b. Route item to human review
3. If gate is advisory:
   a. Log warning
   b. Proceed with flag set
4. Continue validation of other items
5. At stage end, emit ValidationSummary with all failures
```

#### Research Interrupted

```
Detection: Loop receives interrupt signal or human pause request

Recovery Steps:
1. Complete current atomic operation
2. Write checkpoint for current stage
3. Persist all staged changes
4. Update loop state to PAUSED
5. Emit LoopPaused event with resume point
6. Release resources (LLM connections, file handles)
7. On resume:
   a. Read loop state
   b. Verify staged changes integrity
   c. Resume from checkpoint
   d. Emit LoopResumed event
```

### Error Metrics

| Metric | Target | Alert |
|--------|--------|-------|
| Stage failure rate | < 5% | > 10% |
| Mission failure rate | < 10% | > 20% |
| Recovery success rate | > 90% | < 80% |
| Mean time to recovery | < 15 min | > 30 min |
| Data loss events | 0 | Any |

---

## Extensibility

The loop must be extensible without modification. This is achieved through contracts, not implementations.

### Extension Points

The loop exposes these extension points:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         EXTENSION POINTS                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   1. NEW STAGE                                                             │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Add new stage between existing stages                              │   │
│   │ Requires: Stage contract implementation                           │   │
│   │ Configuration: Add to config.stages                               │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   2. NEW DEPARTMENT                                                        │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Register department with loop                                      │   │
│   │ Requires: Department contract implementation                       │   │
│   │ Configuration: Add to config.departments                           │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   3. NEW EVENT TYPE                                                        │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Emit or subscribe to new event                                    │   │
│   │ Requires: Event follows event schema                              │   │
│   │ No configuration change required                                   │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   4. NEW CHECKPOINT TRIGGER                                                 │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Add new condition for human pause                                 │   │
│   │ Requires: Checkpoint contract implementation                      │   │
│   │ Configuration: Add to config.checkpoints                          │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   5. NEW INTEGRATION                                                        │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Register external service with loop                               │   │
│   │ Requires: Adapter contract implementation                         │   │
│   │ Configuration: Add to config.integrations                        │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Contract Definitions

#### Stage Contract

```yaml
StageContract:
  id: StageId
  name: string
  version: string
  
  input: Schema        # What this stage consumes
  output: Schema       # What this stage produces
  
  dependencies:       # Stages that must complete first
    - StageId
    - StageId
    
  triggers:           # Events that can trigger this stage
    - EventType
    - EventType
    
  emit:               # Events this stage emits
    - EventType
    - EventType
    
  checkpointAfter: boolean   # Whether to checkpoint after this stage
```

#### Department Contract

```yaml
DepartmentContract:
  id: DepartmentId
  name: string
  version: string
  
  skills:             # Capabilities this department provides
    - SkillId
    - SkillId
    
  inputContract:      # What the department accepts
    Schema
    
  outputContract:     # What the department produces
    Schema
    
  requiredBy:         # Stages that invoke this department
    - StageId
```

### Adding a New Department

To add a new department without modifying the loop:

```
1. IMPLEMENT CONTRACT
   Create department implementation following DepartmentContract
   
2. REGISTER
   Add department config to config/departments.yaml
   
3. CONFIGURE STAGES
   Add department invocations to relevant stages
   
4. TEST
   Run loop with new department
   
5. DOCUMENT
   Add department to 01-architecture/departments.md
```

### Adding a New Stage

To add a new stage without modifying existing stages:

```
1. IMPLEMENT CONTRACT
   Create stage implementation following StageContract
   
2. REGISTER
   Add stage to config/stages.yaml with position in sequence
   
3. CONFIGURE
   Set dependencies and triggers
   
4. TEST
   Run loop with new stage
   
5. DOCUMENT
   Update this document (research-loop.md) with new stage
```

### Version Compatibility

The loop maintains backward compatibility through versioning:

```
Compatibility Rules:
- Contracts are versioned (e.g., StageContract v1.0, v1.1)
- Implementations declare which contract versions they support
- Loop rejects implementations that don't meet minimum version
- Breaking changes require new major version
```

---

## Dependencies

This document is the canonical specification of the Research Loop Engine. It is foundational to all other documentation.

- `01-architecture/departments.md` — Departments invoked by the loop
- `01-architecture/state-machine.md` — State transitions
- `03-operations/daily-cycle.md` — Loop execution procedures
- `04-quality/quality-gates.md` — Quality gates invoked in VALIDATE stage
- `06-integration/gemini-contract.md` — LLM integration
- `07-safety/human-oversight.md` — Human checkpoint protocols

## Related Documents

- `02-engine/scheduler.md` — [Future] Scheduling strategy
- `02-engine/monitor.md` — [Future] Monitoring implementation
- `02-engine/adaptor-framework.md` — [Future] How to build adapters

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
