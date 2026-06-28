# Event Bus

**Document ID**: 02-engine.3
**Domain**: Engine
**Status**: Draft

---

## 1. Purpose

### Why the Research Operating System Requires an Event Bus

The Research Operating System is not a monolithic application. It is a collection of autonomous departments that execute research capabilities. These departments must communicate without coupling to each other.

**The Problem of Direct Communication**

Without an Event Bus, departments would communicate directly:

```
Discovery → Analysis (direct call)
Analysis → Planning (direct call)
Planning → Execution (direct call)
Execution → Validation (direct call)
```

This creates coupling:

- Discovery must know how to reach Analysis
- Analysis must be running when Discovery finishes
- If Analysis changes its interface, Discovery must change
- Testing Discovery requires a working Analysis
- Adding a new department requires modifying all existing departments

**The Solution: Events**

With an Event Bus, departments communicate through events:

```
Discovery publishes: SignalsDetected
Event Bus routes to: Analysis (subscribed)
Discovery does not know who consumes SignalsDetected
```

This decouples:

- Discovery does not know who processes signals
- Analysis does not know who generates signals
- Departments can be added, removed, or replaced without modifying others
- Testing is isolated: Discovery can be tested with mock subscribers

**What the Event Bus Solves**

1. **Temporal decoupling**: Publisher and subscriber need not be active simultaneously
2. **Spatial decoupling**: Publisher and subscriber need not know each other's location
3. **Synchronous decoupling**: Publisher need not wait for subscriber to process
4. **Version decoupling**: Publisher and subscriber can evolve independently
5. **Failure decoupling**: Subscriber failure does not affect publisher

---

## 2. Event Philosophy

Events are governed by these principles:

### Immutable

An event, once published, cannot be modified or deleted.

**Implications**:
- Events are append-only records
- Corrections are published as new events, not modifications
- Event history is preserved indefinitely
- Event content is immutable; metadata may be added

**Rationale**: Immutable events enable reliable audit trails, replay, and debugging. If events could be modified, the system's history would be unreliable.

### Append-Only

Events are never updated; only new events are added.

**Implications**:
- Event log is a permanent, append-only sequence
- Corrections use compensation events (e.g., `SignalRetracted`)
- No "latest state" semantics; subscribers derive current state from events

**Rationale**: Append-only semantics simplifies concurrency, enables replay, and guarantees event ordering.

### Observable

All significant system behavior is visible through events.

**Implications**:
- Every state change is published as an event
- Observers can subscribe to any event type
- Events provide full system visibility without internal access

**Rationale**: Observable systems can be monitored, debugged, and audited. Hidden behavior is untrustworthy behavior.

### Replayable

Events can be replayed to reconstruct past state or reproduce behavior.

**Implications**:
- Events contain all context needed for replay
- Event ordering is preserved
- Replay is deterministic (same events → same result)

**Rationale**: Replay enables debugging, testing, recovery, and post-mortem analysis.

### Timestamped

Every event has a precise creation timestamp.

**Implications**:
- Events are totally ordered by timestamp
- Temporal queries are precise
- Latency is measurable

**Rationale**: Timestamps enable ordering, latency analysis, and temporal queries.

### Deterministic

Given the same event sequence, the system produces the same behavior.

**Implications**:
- Events contain no randomness
- Event processing is a pure function of event content
- Replay always produces identical results

**Rationale**: Determinism enables reliable replay, debugging, and testing.

### Decoupled

Publishers and subscribers have no direct knowledge of each other.

**Implications**:
- Publishers do not know subscriber identities
- Subscribers do not know publisher identities
- New publishers or subscribers can be added without modifying existing ones
- Publishers and subscribers can evolve independently

**Rationale**: Decoupling is the fundamental goal of the Event Bus. It enables modularity, extensibility, and independent evolution.

---

## 3. Event Lifecycle

Every event moves through a defined lifecycle from creation to archival.

### Lifecycle Stages

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           EVENT LIFECYCLE                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────┐                                                        │
│   │ CREATED │  Event constructed by producer                              │
│   └────┬────┘                                                        │
│        │                                                                  │
│        ▼                                                                  │
│   ┌─────────┐                                                        │
│   │PUBLISHED│  Event submitted to Event Bus                               │
│   └────┬────┘                                                        │
│        │                                                                  │
│        ▼                                                                  │
│   ┌─────────┐                                                        │
│   │ OBSERVED│  Event delivered to subscriber                            │
│   └────┬────┘                                                        │
│        │                                                                  │
│        ▼                                                                  │
│   ┌─────────┐                                                        │
│   │ HANDLED │  Subscriber processed event                              │
│   └────┬────┘                                                        │
│        │                                                                  │
│        ▼                                                                  │
│   ┌─────────┐                                                        │
│   │ARCHIVED │  Event persisted for replay/audit                        │
│   └─────────┘                                                        │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Transition: CREATED

**Purpose**: Event is constructed by the producer.

**Actions**:
```
1. Generate unique event ID
2. Record producer identity
3. Record creation timestamp
4. Populate event content
5. Validate event schema
```

**State Changes**:
- Event exists in producer's memory
- No other component can see event yet

**Exit Condition**: Event is fully constructed and valid.

---

### Transition: PUBLISHED

**Purpose**: Event is submitted to the Event Bus for distribution.

**Actions**:
```
1. Validate event against bus schema
2. Assign sequence number
3. Persist event to event log
4. Distribute event to subscribers
5. Emit acknowledgment to producer
```

**State Changes**:
- Event is in the event log
- Event is visible to subscribers

**Exit Condition**: Event is confirmed in event log and distribution initiated.

---

### Transition: OBSERVED

**Purpose**: Event is delivered to a subscriber.

**Actions**:
```
1. Match event to subscriber's subscriptions
2. Deliver event to subscriber
3. Record observation timestamp
4. Update subscriber's event pointer
```

**State Changes**:
- Subscriber has received event
- Subscriber has not yet processed event

**Exit Condition**: Subscriber acknowledges receipt.

---

### Transition: HANDLED

**Purpose**: Subscriber processes the event.

**Actions**:
```
1. Execute event handler
2. Update subscriber state if needed
3. Publish any resulting events
4. Record handling result (success/failure)
```

**State Changes**:
- Subscriber state updated
- New events may be published
- Handling result recorded

**Exit Condition**: Handler completes (success or failure).

---

### Transition: ARCHIVED

**Purpose**: Event is retained for long-term replay and audit.

**Actions**:
```
1. Verify event integrity
2. Move event to archive storage
3. Update archive index
4. Retain according to retention policy
```

**State Changes**:
- Event moved to cold storage
- Event remains queryable

**Exit Condition**: Event is archived and accessible.

---

## 4. Event Categories

Events are organized into categories. Each category groups events by purpose and domain.

### Category: Engine Events

**Purpose**: Events emitted by the Research Loop Engine during execution.

**Events**:
```
LoopStarted
  - Engine begins a new cycle
  - Payload: cycle_id, mode, configuration

PhaseStarted
  - Engine enters a new phase
  - Payload: cycle_id, phase, timestamp

PhaseCompleted
  - Engine completes a phase
  - Payload: cycle_id, phase, duration, outputs

StageStarted
  - Engine enters a new stage
  - Payload: cycle_id, stage, inputs

StageCompleted
  - Engine completes a stage
  - Payload: cycle_id, stage, duration, outputs

CheckpointCreated
  - State checkpoint written
  - Payload: checkpoint_id, cycle_id, state_snapshot

LoopCompleted
  - Engine completes a cycle successfully
  - Payload: cycle_id, summary, metrics

LoopFailed
  - Engine encounters unrecoverable error
  - Payload: cycle_id, error, failed_stage

LoopPaused
  - Engine pauses waiting for human or dependency
  - Payload: cycle_id, reason, checkpoint_id

LoopResumed
  - Engine resumes from pause
  - Payload: cycle_id, checkpoint_id, wait_duration
```

---

### Category: Mission Events

**Purpose**: Events related to research mission lifecycle.

**Events**:
```
MissionCreated
  - New mission generated
  - Payload: mission_id, type, priority, created_by

MissionApproved
  - Mission approved for execution
  - Payload: mission_id, approved_by, conditions

MissionStarted
  - Mission execution begins
  - Payload: mission_id, assigned_to, start_time

MissionProgressed
  - Mission makes progress
  - Payload: mission_id, progress, checkpoint

MissionCompleted
  - Mission completes successfully
  - Payload: mission_id, duration, outputs

MissionFailed
  - Mission fails
  - Payload: mission_id, error, can_retry

MissionBlocked
  - Mission waits on dependency
  - Payload: mission_id, dependency, blocked_reason

MissionCancelled
  - Mission cancelled
  - Payload: mission_id, cancelled_by, reason

MissionPrioritized
  - Mission priority changes
  - Payload: mission_id, old_priority, new_priority
```

---

### Category: Knowledge Events

**Purpose**: Events related to knowledge creation and modification.

**Events**:
```
SignalDetected
  - New signal discovered
  - Payload: signal_id, type, source, priority

SignalClassified
  - Signal classification assigned
  - Payload: signal_id, classification, confidence

SignalProcessed
  - Signal enriched with context
  - Payload: signal_id, enriched_by, context

SignalArchived
  - Signal expired or superseded
  - Payload: signal_id, reason

InsightGenerated
  - New insight created
  - Payload: insight_id, derived_from, confidence

InsightRefined
  - Existing insight updated
  - Payload: insight_id, changes, updated_by

InsightValidated
  - Insight passes validation
  - Payload: insight_id, validated_by

HypothesisCreated
  - New hypothesis formed
  - Payload: hypothesis_id, derived_from, test_criteria

HypothesisStatusChanged
  - Hypothesis status transitions
  - Payload: hypothesis_id, old_status, new_status

KnowledgeIncorporated
  - Knowledge added to knowledge base
  - Payload: entity_id, entity_type, version

KnowledgeUpdated
  - Existing knowledge modified
  - Payload: entity_id, old_version, new_version

KnowledgeConflict
  - Contradictory knowledge detected
  - Payload: entity_ids, conflict_type, evidence

GapDetected
  - New knowledge gap identified
  - Payload: gap_id, type, severity, affected_entities

GapResolved
  - Knowledge gap filled
  - Payload: gap_id, resolution, filled_by
```

---

### Category: Department Events

**Purpose**: Events emitted by departments during execution.

**Events**:
```
DepartmentInitialized
  - Department ready for cycle
  - Payload: department_id, cycle_id

DepartmentStarted
  - Department begins work
  - Payload: department_id, work_items

DepartmentCompleted
  - Department finishes work
  - Payload: department_id, outputs, duration

DepartmentFailed
  - Department encounters error
  - Payload: department_id, error, can_retry

DepartmentWaiting
  - Department blocked waiting
  - Payload: department_id, waiting_on, reason
```

---

### Category: Quality Events

**Purpose**: Events related to quality gates and validation.

**Events**:
```
QualityGateTriggered
  - Quality gate invoked
  - Payload: gate_id, item_id, item_type

QualityGatePassed
  - Item passes quality gate
  - Payload: gate_id, item_id, metrics

QualityGateFailed
  - Item fails quality gate
  - Payload: gate_id, item_id, failure_reason

ValidationRequested
  - Item queued for validation
  - Payload: item_id, item_type, priority

ValidationCompleted
  - Validation finished
  - Payload: item_id, result, validated_by

ValidationFailed
  - Validation encounters error
  - Payload: item_id, error, retry_count

ConfidenceRecalculated
  - Confidence score updated
  - Payload: entity_id, old_confidence, new_confidence
```

---

### Category: Human Events

**Purpose**: Events related to human interaction and review.

**Events**:
```
HumanReviewRequested
  - Human review needed
  - Payload: review_id, item_id, type, priority, deadline

HumanReviewAssigned
  - Review assigned to reviewer
  - Payload: review_id, reviewer_id, assigned_at

HumanReviewCompleted
  - Human completes review
  - Payload: review_id, decision, rationale, completed_at

HumanReviewExpired
  - Review deadline passed
  - Payload: review_id, deadline, expired_at

HumanEscalation
  - Issue escalated for attention
  - Payload: escalation_id, reason, priority, escalated_to

HumanDecisionRequired
  - Decision needed from human
  - Payload: decision_id, options, deadline
```

---

### Category: Validation Events

**Purpose**: Events related to evidence and consistency validation.

**Events**:
```
EvidenceAssembled
  - Evidence chain constructed
  - Payload: evidence_id, claims, strength

EvidenceStrengthened
  - Evidence chain improved
  - Payload: evidence_id, added_sources, new_strength

EvidenceChallenged
  - Evidence questioned
  - Payload: evidence_id, challenge, challenger

EvidenceAccepted
  - Evidence confirmed valid
  - Payload: evidence_id, accepted_by

ConsistencyCheckStarted
  - Consistency validation begins
  - Payload: entity_id, check_type

ConsistencyViolation
  - Consistency violation detected
  - Payload: entity_id, violations, severity
```

---

### Category: Integration Events

**Purpose**: Events related to external system integrations.

**Events**:
```
SourcePolled
  - External source queried
  - Payload: source_id, source_type, results_count

SourceError
  - External source error
  - Payload: source_id, error, can_retry

LLMRequestSent
  - LLM request submitted
  - Payload: request_id, model, prompt_type

LLMResponseReceived
  - LLM response received
  - Payload: request_id, duration, tokens_used

LLMRequestFailed
  - LLM request failed
  - Payload: request_id, error, retry_count

ExternalDataReceived
  - Data received from external system
  - Payload: source, data_type, record_count
```

---

### Category: System Events

**Purpose**: Events related to system-level concerns.

**Events**:
```
SystemHealthChanged
  - System health status changes
  - Payload: old_status, new_status, affected_components

ErrorOccurred
  - System error detected
  - Payload: error_id, error_type, severity, context

RecoveryStarted
  - System recovery begins
  - Payload: recovery_id, trigger, checkpoint_id

RecoveryCompleted
  - System recovery finished
  - Payload: recovery_id, duration, result

ConfigurationChanged
  - System configuration updated
  - Payload: config_key, old_value, new_value

ServiceStarted
  - Service component starts
  - Payload: service_id, version

ServiceStopped
  - Service component stops
  - Payload: service_id, reason
```

---

## 5. Event Contract

Every event conforms to this conceptual contract. The contract defines the minimal structure all events share.

### Contract Fields

#### Identity

```
event_id: UUID
  - Globally unique identifier
  - Generated by producer
  - Immutable once assigned
```

**Purpose**: Every event has a unique identifier for tracking, correlation, and deduplication.

---

#### Producer

```
producer:
  - department: DepartmentId    # Which department
  - component: ComponentId      # Which component
  - instance: InstanceId       # Which instance (for scaling)
```

**Purpose**: Identifies the source of the event for accountability and debugging.

---

#### Timestamp

```
timestamp:
  - created: ISO8601          # When event was created
  - published: ISO8601       # When event was published to bus
  - observed: ISO8601         # When event was delivered (per subscriber)
```

**Purpose**: Enables ordering, latency measurement, and temporal queries.

---

#### Category

```
category: EventCategory
  - engine                    # Engine lifecycle
  - mission                  # Mission lifecycle
  - knowledge                # Knowledge events
  - department               # Department events
  - quality                  # Quality events
  - human                    # Human interaction
  - validation               # Validation events
  - integration              # External integrations
  - system                    # System events
```

**Purpose**: Groups events by domain for subscription filtering.

---

#### Type

```
type: EventType
  - String identifier within category
  - e.g., "MissionCreated", "SignalDetected"
  - Immutable
```

**Purpose**: Identifies the specific event type for handler routing.

---

#### Payload

```
payload:
  - Schema-defined structure
  - Type-specific data
  - May be empty for marker events
```

**Purpose**: Contains the event-specific data subscribers need to process the event.

---

#### Priority

```
priority: Priority
  - critical: Immediate processing required
  - high: Process before normal priority
  - normal: Standard processing
  - low: Process when capacity available
```

**Purpose**: Enables processing order when events queue.

---

#### Correlation

```
correlation:
  - correlation_id: UUID      # Groups related events
  - parent_id: UUID          # Parent event (for causal chains)
```

**Purpose**: Links related events for tracing and grouping.

---

#### Causation

```
causation:
  - caused_by: UUID           # Event that caused this one
  - purpose: string          # Why this event was created
```

**Purpose**: Tracks causal chains between events.

---

#### Status

```
status: EventStatus
  - published: Event submitted to bus
  - delivered: Event delivered to subscriber
  - processed: Subscriber handled event
  - failed: Subscriber failed to process
  - dead_lettered: Event moved to error queue
```

**Purpose**: Tracks event lifecycle through the system.

---

#### Lifecycle

```
lifecycle:
  - created_at: ISO8601      # When event was created
  - expires_at: ISO8601      # When event should be discarded (optional)
  - retention: Duration      # How long to keep in archive
```

**Purpose**: Manages event lifecycle and retention.

---

#### Retry Semantics

```
retry:
  - max_attempts: number      # Maximum retry count
  - backoff: BackoffStrategy  # Retry delay strategy
  - on: EventType[]          # Event types that trigger retry
```

**Purpose**: Defines how failed events are retried.

---

#### Audit Metadata

```
audit:
  - sequence: number         # Total order sequence number
  - checksum: string         # Content integrity hash
  - partition: string       # Partition for ordering
```

**Purpose**: Enables audit trails and integrity verification.

---

## 6. Publishers and Subscribers

### Publishers

Every component that produces events is a publisher:

| Publisher | Events Published | Frequency |
|-----------|-----------------|-----------|
| **Research Loop Engine** | LoopStarted, PhaseStarted, CheckpointCreated, etc. | Per cycle/phase |
| **Discovery Department** | SignalDetected, SignalClassified, SourcePolled, etc. | Per signal |
| **Analysis Department** | InsightGenerated, EvidenceAssembled, GapDetected, etc. | Per insight |
| **Planning Department** | MissionCreated, MissionPrioritized, etc. | Per mission |
| **Execution Department** | MissionStarted, MissionCompleted, LLMRequestSent, etc. | Per mission step |
| **Validation Department** | QualityGatePassed, ValidationCompleted, etc. | Per validation |
| **Human Reviewers** | HumanReviewCompleted, HumanDecisionRequired, etc. | Per review |
| **External Integrations** | SourcePolled, SourceError, ExternalDataReceived, etc. | Per integration |

### Subscribers

Every component that reacts to events is a subscriber:

| Subscriber | Events Subscribed | Action |
|-----------|-------------------|--------|
| **Analysis Department** | SignalsDetected, SignalClassified | Process signals |
| **Planning Department** | InsightGenerated, GapDetected | Create missions |
| **Execution Department** | MissionCreated, MissionPrioritized | Execute missions |
| **Validation Department** | MissionCompleted, InsightGenerated | Validate outputs |
| **Discovery Department** | GapResolved, KnowledgeConflict | Update coverage |
| **State Manager** | All events | Update state |
| **Audit Logger** | All events | Record for audit |
| **Dashboard** | Selected events | Update display |

### Departments That Must Never Communicate Directly

The Event Bus enforces this separation:

```
Discovery ──X──→ Analysis          (MUST use: SignalsDetected)
Analysis ──X──→ Planning        (MUST use: InsightGenerated)
Planning ──X──→ Execution       (MUST use: MissionCreated)
Execution ──X──→ Validation     (MUST use: MissionCompleted)
```

Direct calls are architecturally prohibited. All communication must flow through the Event Bus.

### Enforcing Loose Coupling

The Event Bus enforces loose coupling through:

1. **Anonymous publishing**: Publishers do not know subscriber identities
2. **Topic-based routing**: Events are routed by type, not destination
3. **Schema contracts**: Publishers and subscribers agree on payload structure, not implementation
4. **Asynchronous delivery**: Publishers do not wait for subscribers
5. **Failure isolation**: Subscriber failures do not affect publishers

---

## 7. Event Ordering

### Ordering Guarantees

The Event Bus provides these ordering guarantees:

**Within a Partition**: Events published to the same partition are delivered in publication order.

**Across Partitions**: Events across different partitions may be delivered out of order.

**Per-Correlation-ID**: Events with the same correlation ID are delivered in publication order.

### Ordering Semantics

```
Scenario: Events A, B, C published in sequence

Guaranteed:
  A delivered before B
  B delivered before C
  
Not Guaranteed:
  A, B, C delivered simultaneously (they won't be)
  A processed before B (subscriber-dependent)
```

### Idempotency

Subscribers must be idempotent. Events may be delivered more than once due to:

- Network retries
- Subscriber crashes before acknowledgment
- At-least-once delivery semantics

**Subscriber Requirement**: Processing the same event twice must produce the same result as processing it once.

### Duplicate Events

When duplicates occur:

```
1. Detect: Event ID already processed
2. Check: Is this a true duplicate or a new event with same ID?
   - Same ID + same content → skip (true duplicate)
   - Same ID + different content → log error (ID collision)
3. Acknowledge: Acknowledge duplicate to prevent redelivery
```

### Late Events

Events may arrive after subsequent events due to:

- Network delays
- Subscriber restart
- Replay from archive

**Handling**:
- Subscribers track last-processed sequence
- Late events are held until ordering window closes
- If window expires, late event is processed with warning

### Cancelled Events

Events cannot be cancelled once published.

**Alternative**: Publish a compensation event:

```
Original: SignalDetected(signal_id="sig-123")
Compensation: SignalRetracted(signal_id="sig-123", reason="false_positive")
```

Subscribers process both events; the retraction cancels the original effect.

### Replay Behavior

Events can be replayed from any point in the event history:

```
Replay from sequence 1000:
1. Load events from sequence 1000 onwards
2. For each event:
   - Find subscribed handlers
   - Execute handlers
   - Record results
3. State converges to same result as original processing
```

Replay is deterministic because:
- Events are immutable
- Event processing is a pure function
- Ordering is preserved

### Out-of-Order Handling

When events arrive out of order:

```
Expected: A, B, C
Received: A, C, B

Options:
1. Hold C until B arrives (ordering window)
2. Process C, then B (may cause inconsistency)
3. Reject C (strict ordering)

Default: Option 1 with configurable window
```

---

## 8. Failure Handling

### When an Event Cannot Be Processed

```
Scenario: Subscriber fails to process event

Handling:
1. Record failure status on event
2. Retry according to retry policy
3. If retries exhausted → move to dead letter queue
4. Emit FailureEvent for monitoring
5. Alert operations team
```

### When a Subscriber Fails

```
Scenario: Subscriber process crashes

Handling:
1. Detect subscriber failure (heartbeat timeout)
2. Mark subscriber as unhealthy
3. Events continue queueing
4. When subscriber recovers:
   - Resume from last acknowledged event
   - Process queued events in order
```

### When an Event Is Duplicated

```
Scenario: Same event delivered multiple times

Handling:
1. Detect duplicate (event_id seen before)
2. Verify content matches (detect ID collision)
3. If duplicate → acknowledge without reprocessing
4. If collision → log error, alert operations
```

### When an Event Arrives Too Late

```
Scenario: Event arrives after subsequent events were processed

Handling:
1. Detect late arrival (sequence gap)
2. Hold late event in buffer
3. If within ordering window:
   - Wait for missing events
   - Process in correct order
4. If window expired:
   - Process late event with warning
   - Emit LateEventAlert
   - Allow subscriber to handle
```

### When a Department Ignores an Event

```
Scenario: Department should react to event but doesn't

Handling:
1. Monitor expected reactions (e.g., MissionCreated → MissionStarted)
2. If reaction missing after threshold:
   - Emit MissingReactionAlert
   - Route to operations for investigation
3. Pattern may indicate:
   - Bug in subscriber
   - Configuration error
   - Missing subscription
```

### When an Event Chain Becomes Inconsistent

```
Scenario: Events create contradictory state

Detection:
1. Consistency check detects violation
2. Emit KnowledgeConflict event
3. Route to Validation department
4. Validation resolves conflict
5. Emit resolution event (e.g., KnowledgeUpdated)
6. Subscribers reconcile state
```

### Failure Recovery Matrix

| Failure Type | Detection | Recovery | Notification |
|-------------|----------|----------|--------------|
| Processing failure | Status = failed | Retry or dead-letter | Alert |
| Subscriber crash | Heartbeat timeout | Resume from last ack | Alert |
| Duplicate delivery | Event ID seen | Skip duplicate | None |
| Late event | Sequence gap | Hold or process with warning | Warning |
| Missing reaction | Expected event not received | Alert operations | Alert |
| Chain inconsistency | Consistency check | Validation resolves | Alert |

---

## 9. Relationship to State

Events, State, Knowledge, Departments, and the Engine have distinct but interconnected roles.

### The Four Questions

Every component answers one question:

| Component | Answers | Example |
|-----------|---------|---------|
| **Knowledge** | "What do we know?" | "Curve Finance TVL increased 50%" |
| **State** | "What is happening now?" | "Mission 3 is 65% complete" |
| **Events** | "What happened?" | "MissionCompleted(mission-003)" |
| **Engine** | "What should happen next?" | Orchestrates based on events |

### Visualizing the Relationships

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         KNOWLEDGE vs STATE vs EVENTS                      │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   KNOWLEDGE                                                              │
│   "What we know about reality"                                          │
│                                                                             │
│   • Permanent accumulation                                               │
│   • Evidence-backed                                                      │
│   • Owned by departments                                                 │
│   • Grows over time                                                     │
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │ Example: "Uniswap V4 launched with concentrated liquidity"     │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                                    ▲                                       │
│                                    │ Compliments                            │
│                                    ▼                                       │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │ EVENTS                                                        │   │
│   │ "What happened in the system"                                 │   │
│   │                                                               │   │
│   │ • Immutable records                                           │   │
│   │ • Append-only                                                 │   │
│   │ • Owned by emitters                                           │   │
│   │ • Audit trail                                                 │   │
│   │                                                               │   │
│   │ Example: "Event Loop: LoopStarted(cycle=001)"                │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                                    ▲                                       │
│                                    │ Informs                                │
│                                    ▼                                       │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │ STATE                                                         │   │
│   │ "What we need to continue working"                           │   │
│   │                                                               │   │
│   │ • Transient (reset each cycle)                               │   │
│   │ • Checkpoint-based                                           │   │
│   │ • Owned by engine                                            │   │
│   │ • Recovery enabler                                            │   │
│   │                                                               │   │
│   │ Example: "ExecutionState: phase=analyze, mission=003"        │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### How They Interrelate

**Events → State**: State changes are triggered by events. The State Manager subscribes to relevant events and updates state accordingly.

```
Event: MissionCompleted(mission_id=003)
State: MissionState.status = "completed"
```

**Events → Knowledge**: Knowledge changes are triggered by events. The Validation department subscribes to events that create knowledge and enforces quality gates.

```
Event: InsightGenerated(insight_id=042)
Knowledge: After validation, insight is incorporated
```

**State → Events**: State transitions emit events. When state changes, events are published to record the change.

```
State transition: MissionState: pending → in_progress
Event published: MissionStarted(mission_id=003)
```

**Knowledge → Events**: Knowledge creation emits events. When departments add to the knowledge base, events record the addition.

```
Knowledge added: Protocol(Uniswap V4)
Event published: KnowledgeIncorporated(entity_id=...)
```

### The Core Architectural Separation

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     ARCHITECTURAL SEPARATION                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ENGINE                                                                  │
│   "Orchestrates what happens next"                                      │
│                                                                             │
│   Owns: Execution flow, state, scheduling                               │
│   Uses: Events (to observe), State (to decide)                          │
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │                                                                 │   │
│   │   DEPARTMENTS                                                     │   │
│   │   "Perform capabilities"                                         │   │
│   │                                                                 │   │
│   │   Own: Skills, knowledge creation                                │   │
│   │   Use: Events (to communicate), State (for context)            │   │
│   │                                                                 │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │                                                                 │   │
│   │   KNOWLEDGE                                                       │   │
│   │   "Stores what we know"                                        │   │
│   │                                                                 │   │
│   │   Own: Entities, relationships, evidence                        │   │
│   │   Grows: Through validated events                                │   │
│   │                                                                 │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │                                                                 │   │
│   │   STATE                                                           │   │
│   │   "Stores what we need to continue"                             │   │
│   │                                                                 │   │
│   │   Own: Execution context, checkpoints, pending work              │   │
│   │   Resets: Each cycle                                            │   │
│   │                                                                 │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────┐   │
│   │                                                                 │   │
│   │   EVENTS                                                          │   │
│   │   "Records what happened"                                       │   │
│   │                                                                 │   │
│   │   Own: Immutable records, audit trail                           │   │
│   │   Enables: Decoupling, replay, observability                    │   │
│   │                                                                 │   │
│   └─────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 10. Extensibility

New event categories, types, and schemas can be added without modifying the Event Bus itself.

### Adding New Event Categories

New categories are added by declaration:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ADDING NEW EVENT CATEGORY                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Step 1: Declare Category                                               │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │ Add to EventCategory enum:                                          │ │
│   │   category: new_category                                           │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│   Step 2: Define Events                                                 │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │ Define event types in category:                                     │ │
│   │   NewEventType1                                                  │ │
│   │   NewEventType2                                                  │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│   Step 3: Implement Publishers                                          │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │ Producers publish new events following contract:                  │ │
│   │   - Required fields                                              │ │
│   │   - Payload schema                                               │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│   Step 4: Implement Subscribers                                         │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │ Subscribers subscribe to new event types:                          │ │
│   │   - Subscribe(EventType.NEW_TYPE)                                 │ │
│   │   - Implement handler                                             │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                             │
│   Step 5: Document                                                    │
│   ┌───────────────────────────────────────────────────────────────────┐ │
│   │ Add to event taxonomy:                                            │ │
│   │   - Category purpose                                              │ │
│   │   - Event types and payloads                                     │ │
│   │   - Publisher and subscriber expectations                         │ │
│   └───────────────────────────────────────────────────────────────────┘ │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Example: Adding "Compliance" Event Category

Suppose we need a new category for compliance events:

```
1. Declare Category
   category: "compliance"

2. Define Events
   CompliancePolicyViolation
   ComplianceAuditStarted
   ComplianceAuditCompleted
   ComplianceReportGenerated

3. Implement Publishers
   Compliance Department publishes:
   - CompliancePolicyViolation(policy_id, severity, details)
   - ComplianceAuditCompleted(audit_id, result, findings)

4. Implement Subscribers
   Legal Department subscribes:
   - CompliancePolicyViolation (review violations)
   - ComplianceAuditCompleted (review results)

5. Document
   Add to event taxonomy:
   - Category: "compliance"
   - Purpose: "Events related to regulatory compliance"
   - Events: [as defined above]
```

### Backward Compatibility

New events are backward compatible:

- Existing publishers and subscribers are unaffected
- New events are optional for all existing components
- Subscribers can ignore events they don't understand
- Publishers can emit new events without coordination

### Breaking Changes

These changes are breaking and require version coordination:

- Removing required fields from existing events
- Changing event type semantics
- Changing required vs optional payload fields

These changes require:
- Version bump for affected event types
- Migration period with both old and new events
- Deprecation timeline for old format

---

## Architectural Rule

Every future implementation in nav-research-engine must satisfy this constraint:

```
The Engine orchestrates.
Departments own capabilities.
Skills perform work.
Knowledge stores reality.
State stores execution context.
Events communicate change.
```

**Any implementation that violates this separation is architecturally invalid.**

---

## Dependencies

This document defines the Event Bus that enables all other architectural components to communicate.

- `02-engine/research-loop.md` — Engine that orchestrates via events
- `02-engine/state-manager.md` — State that events update
- `03-departments/departments.md` — Departments that publish and subscribe
- `04-knowledge/knowledge-model.md` — Knowledge that events create

## Related Documents

- `02-engine/scheduler.md` — [Future] Scheduling based on event triggers
- `02-engine/retry-engine.md` — [Future] Retry logic for failed events
- `02-engine/audit-logger.md` — [Future] Audit trail from events

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |

---

## Capabilities Unlocked

The Event Bus enables these implementation capabilities:

### Core Capabilities

| Capability | Why It Requires Event Bus |
|------------|------------------------|
| **Autonomous Departments** | Departments communicate without direct coupling |
| **Skill Orchestration** | Skills are triggered by events, not direct calls |
| **Parallel Execution** | Multiple departments work concurrently via events |
| **Async Integrations** | External systems communicate via events |
| **Plugin System** | Plugins subscribe to events without core modification |
| **Audit Timeline** | Events provide complete, immutable history |

### Observability Capabilities

| Capability | Why It Requires Event Bus |
|------------|------------------------|
| **Live Dashboard** | Events stream to display in real-time |
| **Analytics** | Events provide data for analysis |
| **Monitoring** | System behavior visible through events |
| **Alerting** | Anomaly detection based on event patterns |
| **Tracing** | Events enable distributed request tracing |

### Operational Capabilities

| Capability | Why It Requires Event Bus |
|------------|------------------------|
| **Notification System** | Human-facing notifications triggered by events |
| **Retry Engine** | Failed event delivery triggers retry logic |
| **Event Replay** | Historical events enable reproduction |
| **Distributed Execution** | Multiple nodes coordinate via event log |
| **Recovery** | Events enable state reconstruction |

### Future Architecture Documents Enabled

| Document | Depends On |
|----------|-----------|
| `02-engine/scheduler.md` | Events trigger scheduled execution |
| `02-engine/retry-engine.md` | Failed events trigger retry logic |
| `02-engine/audit-logger.md` | Events provide audit trail |
| `02-engine/metrics-collector.md` | Events provide metrics data |
| `02-engine/tracing-system.md` | Events provide distributed tracing |
| `02-engine/alerting-system.md` | Events trigger alerts |
| `02-engine/notification-broker.md` | Events trigger human notifications |
| `02-engine/plugin-manager.md` | Plugins subscribe to events |
| `02-engine/multi-node-coordinator.md` | Nodes coordinate via event log |
