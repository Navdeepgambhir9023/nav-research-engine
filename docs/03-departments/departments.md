# Department System

**Document ID**: 04-departments.1
**Domain**: Departments
**Status**: Draft

---

## 1. Why Departments Exist

### The Problem with Workflows

The Research Operating System could be designed as a collection of workflows—linear sequences of steps that execute from start to finish. This is how most automation systems are built.

Workflows have a fatal flaw: they are rigid. They encode assumptions about:

- What work needs to be done
- In what order it should be done
- Who is responsible for each step
- What success looks like

When any of these assumptions change—and in research, they change constantly—the workflow must be rewritten.

### The Solution: Departments

Departments are autonomous business capabilities. They are inspired by how large organizations are structured: each department owns a functional area, has a clear mandate, and collaborates with other departments through defined interfaces.

The key difference from workflows:

| Aspect | Workflows | Departments |
|--------|-----------|-------------|
| **Structure** | Linear sequence | Autonomous capability |
| **Coupling** | Tight (step calls step) | Loose (via events) |
| **Change** | Rework entire sequence | Modify one department |
| **Ownership** | Shared or unclear | Single, clear owner |
| **Testing** | End-to-end only | Isolated unit tests |
| **Reasoning** | "What happens?" | "Who is responsible?" |

### Architectural Advantages

**1. Separation of Concerns**

Each department has one reason to change. Discovery changes when signal detection methodology changes. Analysis changes when insight generation methodology changes. They do not change for the same reasons.

**2. Independent Evolution**

Departments can evolve independently. Discovery can adopt a new data source without changing how Analysis works. Analysis can change its LLM provider without Discovery knowing.

**3. Parallel Execution**

The engine can invoke multiple departments concurrently. Discovery can be running while Analysis is processing previous results. Departments are designed for this independence.

**4. Fault Isolation**

When Discovery fails, Analysis continues. A failure in one department does not cascade to others. The engine handles failures at the department level, not the step level.

**5. Clear Ownership**

Every capability has exactly one owner. When something goes wrong with signal detection, Discovery is accountable. When insight quality degrades, Analysis is accountable. No finger-pointing, no shared responsibility.

**6. Composable Capabilities**

New departments can be assembled from existing ones. A new "Competitive Intelligence" department can use signals from Discovery, insights from Analysis, and validation from Validation without modifying any of them.

### How Departments Reduce Coupling

**Coupling** is the degree to which one component depends on another. High coupling means changes ripple through the system. Low coupling means changes are contained.

Departments reduce coupling through:

1. **Event-driven communication** — Departments communicate through events, not direct calls. Discovery does not call Analysis; Discovery emits `SignalsCollected` and Analysis subscribes to it.

2. **Contract-based interfaces** — Departments expose typed interfaces for inputs and outputs. Changes to internal implementation do not affect consumers.

3. **Shared knowledge, not shared state** — Departments read and write to the knowledge base, not to each other's memory. This decouples them temporally.

4. **Dependency declaration** — Each department declares its dependencies. The engine ensures dependencies are satisfied before invoking a department.

### How Departments Improve Extensibility

Adding a new capability to a workflow-based system requires modifying the workflow. Adding a new department requires:

1. Implementing the department contract
2. Registering the department with the engine
3. Declaring dependencies and emissions
4. Adding to configuration

The existing departments do not change. The engine does not change. The new department simply plugs in.

---

## 2. Department Contract

Every department implements the same canonical contract. This contract defines what all departments must provide, regardless of their internal implementation.

### Contract Schema

```yaml
DepartmentContract:
  # Identity
  id: DepartmentId          # Unique identifier (e.g., "discovery")
  name: string             # Human-readable name
  version: string          # Contract version (semver)
  
  # Purpose
  purpose: string          # Why this department exists
  ownership: string        # What this department owns
  
  # Capabilities
  skills: List<SkillRef>   # Skills this department can perform
  specializations: List<Specialization>  # Specific focus areas
  
  # Interface
  input:
    schema: Schema         # JSON Schema of valid inputs
    required: List<InputType>  # Required input types
    optional: List<InputType>   # Optional input types
    
  output:
    schema: Schema         # JSON Schema of valid outputs
    produced: List<OutputType>  # Output types this department produces
    
  # Events
  events:
    emits: List<EventType>    # Events this department emits
    consumes: List<EventType>  # Events this department responds to
    
  # Dependencies
  dependencies:
    requires: List<DepartmentId>  # Departments that must run before
    optional: List<DepartmentId>   # Departments that may run before
    conflicts: List<DepartmentId>  # Departments that cannot run concurrently
    
  # Quality
  quality:
    gates: List<QualityGateRef>   # Quality gates this department enforces
    metrics: List<MetricDef>      # Metrics this department tracks
    
  # Failure handling
  failure:
    recoverable: boolean          # Can this department recover from failures?
    retryPolicy: RetryPolicy      # How to retry on failure
    escalationPath: string        # Where to escalate unrecoverable failures
    
  # Governance
  governance:
    owner: string                # Team/person responsible
    contractOwner: string       # Who owns the contract
    deprecationPolicy: string   # How to deprecate this department
```

### Field Definitions

#### Identity

| Field | Type | Description |
|-------|------|-------------|
| `id` | DepartmentId | Unique identifier following pattern: `{name}` (e.g., `discovery`, `analysis`) |
| `name` | string | Human-readable name (e.g., "Discovery Department") |
| `version` | semver | Contract version. Breaking changes require major version bump. |

#### Purpose

| Field | Type | Description |
|-------|------|-------------|
| `purpose` | string | One-paragraph explanation of why this department exists. Answers: "What problem does this department solve?" |
| `ownership` | string | What this department explicitly owns. Answers: "Who is accountable when this fails?" |

#### Capabilities

| Field | Type | Description |
|-------|------|-------------|
| `skills` | List<SkillRef> | References to skills this department can perform. Skills are implemented by the department. |
| `specializations` | List<Specialization> | Specific focus areas within the department's domain. |

#### Interface

| Field | Type | Description |
|-------|------|-------------|
| `input.schema` | Schema | JSON Schema defining valid input structure |
| `input.required` | List<InputType> | Input types this department cannot operate without |
| `input.optional` | List<InputType> | Input types that enhance capability but are not required |
| `output.schema` | Schema | JSON Schema defining valid output structure |
| `output.produced` | List<OutputType> | Output types this department produces |

#### Events

| Field | Type | Description |
|-------|------|-------------|
| `events.emits` | List<EventType> | Events this department publishes. See Event Model. |
| `events.consumes` | List<EventType> | Events this department subscribes to and reacts to. |

#### Dependencies

| Field | Type | Description |
|-------|------|-------------|
| `dependencies.requires` | List<DepartmentId> | Departments that must have completed before this department runs |
| `dependencies.optional` | List<DepartmentId> | Departments that enhance this department if available |
| `dependencies.conflicts` | List<DepartmentId> | Departments that cannot run concurrently with this one |

#### Quality

| Field | Type | Description |
|-------|------|-------------|
| `quality.gates` | List<QualityGateRef> | References to quality gates this department enforces on its outputs |
| `quality.metrics` | List<MetricDef> | Metrics this department tracks to measure its effectiveness |

#### Failure Handling

| Field | Type | Description |
|-------|------|-------------|
| `failure.recoverable` | boolean | Whether the department can recover from failures internally |
| `failure.retryPolicy` | RetryPolicy | How the engine should retry on failure |
| `failure.escalationPath` | string | Where to send unresolved failures |

#### Governance

| Field | Type | Description |
|-------|------|-------------|
| `governance.owner` | string | Team or person accountable for this department's operation |
| `governance.contractOwner` | string | Team or person who owns the contract interface |
| `governance.deprecationPolicy` | string | How this department will be deprecated when replaced |

### Input Types

Departments consume input types, not specific data:

```yaml
InputTypes:
  - signal_inventory     # Raw signals from Discovery
  - knowledge_graph       # Current knowledge state
  - mission_queue        # Research missions to execute
  - knowledge_gaps       # Identified gaps in knowledge
  - human_feedback       # Pending human reviews and decisions
  - external_research     # Research from external sources
  - configuration        # Department-specific configuration
  - execution_context    # Current execution state
```

### Output Types

Departments produce output types:

```yaml
OutputTypes:
  - enriched_signals      # Signals with context
  - insights            # Synthesized insights
  - evidence_chains     # Evidence supporting conclusions
  - missions            # Research missions
  - validated_knowledge  # Knowledge passing quality gates
  - quality_report      # Quality metrics for this cycle
  - gap_updates         # Gap detection results
  - execution_log       # Detailed execution records
```

### Event Types

Events are defined in `02-engine/research-loop.md`. Departments emit and consume these events. The canonical list is:

```yaml
# Loop Events
LoopStarted, StageStarted, StageCompleted, StageFailed, CheckpointReached
LoopCompleted, LoopFailed

# Knowledge Events
SignalDetected, InsightGenerated, EvidenceAssembled
KnowledgeAdded, KnowledgeUpdated, KnowledgeConflict
GapDetected, GapResolved

# Mission Events
MissionCreated, MissionStarted, MissionCompleted, MissionFailed, MissionBlocked

# Human Interaction Events
HumanReviewRequested, HumanReviewCompleted, HumanDecisionRequired, HumanEscalation

# Quality Events
QualityGatePassed, QualityGateFailed, ValidationRequested, ValidationPassed, ValidationFailed
```

---

## 3. Department Lifecycle

Each department participates in the engine's execution cycle. This section describes how.

### Lifecycle Phases

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         DEPARTMENT LIFECYCLE                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐     │
│   │  WAKE  │──▶│ RECEIVE │──▶│ EXECUTE │──▶│ EMIT    │──▶│ REPORT  │     │
│   │        │   │        │   │        │   │ EVENTS  │   │        │     │
│   └─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘     │
│                                                                             │
│         │               │               │               │               │
│         ▼               ▼               ▼               ▼               ▼     │
│   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐   ┌─────────┐     │
│   │  INIT  │   │ VALIDATE│   │ QUALITY │   │ COMMIT  │   │METRICS  │     │
│   │        │   │ INPUT   │   │  GATES  │   │ OUTPUTS │   │         │     │
│   └─────────┘   └─────────┘   └─────────┘   └─────────┘   └─────────┘     │
│                                                                             │
└────────────────────────────────────────────────────────────────────���────────┘
```

### Phase 1: WAKE

**Purpose**: Initialize the department for this execution cycle.

**Actions**:
```
1. Read configuration for this cycle
2. Load required skills
3. Initialize internal state
4. Check for any pending work from previous cycle (resume support)
5. Emit: DepartmentInitialized
```

**Inputs**:
- Department configuration
- Execution context (cycle ID, mode, etc.)
- Previous internal state (if resuming)

**Outputs**:
- Department ready state
- Loaded skills
- Pending work items (if any)

**Failure Conditions**:
- Configuration invalid → FAIL, escalate
- Skill load failure → FAIL, escalate
- State corruption → PROMPT: resume from checkpoint or abort

**Exit Condition**: Department initialized, skills loaded, ready to receive work.

---

### Phase 2: RECEIVE

**Purpose**: Accept work items and validate readiness.

**Actions**:
```
1. Subscribe to input event channel
2. Receive work items from engine
3. Validate input types match required inputs
4. Check dependencies are satisfied
5. Queue work items for execution
```

**Inputs**:
- Work items from engine (signals, missions, etc.)
- Input validation schemas
- Dependency status

**Outputs**:
- Validated work queue
- Missing inputs (if any)

**Failure Conditions**:
- Required input missing → BLOCK, request from engine
- Input validation failure → REJECT, log invalid input
- Dependency not satisfied → BLOCK, wait for dependency

**Exit Condition**: Work queue populated, all inputs validated.

---

### Phase 3: EXECUTE

**Purpose**: Perform the department's core work.

**Actions**:
```
1. Dequeue work item
2. Select appropriate skill
3. Execute skill with work item
4. Apply quality gates to output
5. If quality gate fails → route to human review
6. If quality gate passes → commit output
7. Repeat until queue empty or time budget exhausted
```

**Inputs**:
- Validated work queue
- Skills
- Quality gates
- Time budget

**Outputs**:
- Department outputs (insights, missions, etc.)
- Quality gate results
- Execution log

**Failure Conditions**:
- Skill execution fails → RETRY (per retry policy)
- Time budget exhausted → STOP, emit partial results
- Quality gate fails → QUEUE for human review

**Exit Condition**: Work queue processed (complete or time-limited), outputs generated.

---

### Phase 4: EMIT EVENTS

**Purpose**: Publish results to the event bus for other departments and observers.

**Actions**:
```
1. Gather all outputs from execution
2. Transform outputs into event payloads
3. Publish events to event bus
4. Wait for event delivery confirmation
5. If delivery fails → RETRY or QUEUE for later
```

**Inputs**:
- Department outputs
- Event schemas

**Outputs**:
- Published events
- Failed event deliveries (queued for retry)

**Failure Conditions**:
- Event bus unavailable → QUEUE events for retry
- Schema validation failure → LOG, skip event
- Retry exhausted → EMIT DepartmentError, escalate

**Exit Condition**: All events published or queued, event bus acknowledges.

---

### Phase 5: REPORT

**Purpose**: Generate execution report and metrics.

**Actions**:
```
1. Collect execution statistics
2. Calculate quality metrics
3. Generate execution report
4. Write metrics to state
5. Emit: DepartmentCompleted or DepartmentFailed
```

**Inputs**:
- Execution statistics
- Quality results
- Internal metrics

**Outputs**:
- Execution report
- Quality metrics
- State updates

**Failure Conditions**:
- Report generation fails → LOG metrics individually, emit partial report
- State write fails → RETRY, escalate if persistent

**Exit Condition**: Report generated, metrics recorded, state updated.

---

## 4. Initial Department Set

For Version 1 of the Research Operating System, we require a minimum set of departments. These are chosen for leverage—not completeness. Each department should provide maximum capability for minimum complexity.

### Department 1: Discovery

**Why It Exists**

Research begins with observation. Before we can analyze, plan, or validate, we must detect signals in the environment. Discovery owns the problem of finding what is happening in the Web3 ecosystem.

**Business Capability**

> The ability to continuously monitor the external environment and surface new signals—opportunities, threats, trends, and data—before they become obvious.

**What Discovery Owns**

- Signal detection methodology
- Data source integration
- Signal classification
- Signal prioritization
- Deduplication logic
- Provenance tracking for signals

**What Discovery Does NOT Own**

- Signal analysis (Analysis)
- Signal storage (Knowledge Base)
- Signal routing (Engine/Planning)
- Signal validation (Validation)

**Primary Skills**

- Source monitoring (continuous polling)
- Signal extraction (structured data → signal)
- Signal classification (type assignment)
- Deduplication (new vs. existing)

**Emits Events**

- `SignalsDetected`
- `SourcePolled`
- `SourceError`
- `SignalClassified`
- `SignalDeduplicated`

**Consumes Events**

- None (Discovery initiates the research cycle)

**Quality Gates**

- Signal completeness (has required fields)
- Source verification (provenance chain intact)
- Classification accuracy (type matches content)

---

### Department 2: Analysis

**Why It Exists**

Raw signals are noise. Before we can act on signals, we must transform them into understanding. Analysis owns the problem of making sense of signals—contextualizing them, building evidence chains, and generating insights.

**Business Capability**

> The ability to transform raw signals into actionable insights by contextualizing them against existing knowledge, assembling evidence, and synthesizing conclusions.

**What Analysis Owns**

- Signal contextualization
- Evidence assembly
- Insight generation
- Confidence scoring
- Gap identification
- LLM integration (for synthesis)

**What Analysis Does NOT Own**

- Signal detection (Discovery)
- Mission planning (Planning)
- Knowledge storage (Knowledge Base)
- Validation (Validation)

**Primary Skills**

- Contextual analysis (signal + knowledge → context)
- Evidence assembly (evidence → evidence chain)
- Insight synthesis (evidence chain → insight)
- Confidence scoring (evidence → confidence)
- Gap detection (missing information identification)

**Emits Events**

- `InsightGenerated`
- `EvidenceAssembled`
- `GapIdentified`
- `ConfidenceScored`
- `LLMRequest`

**Consumes Events**

- `SignalsDetected`
- `SignalClassified`

**Quality Gates**

- Evidence completeness (chain meets minimum threshold)
- Insight coherence (conclusion follows from evidence)
- Confidence justification (score matches evidence strength)

---

### Department 3: Planning

**Why It Exists**

Insights without action are entertainment. Someone must decide what to do with insights—which opportunities to pursue, which gaps to fill, which missions to execute. Planning owns the problem of decision-making.

**Business Capability**

> The ability to decide what to do by scoring opportunities, creating missions, prioritizing work, and generating execution plans.

**What Planning Owns**

- Opportunity scoring methodology
- Mission creation and definition
- Prioritization logic
- Resource allocation
- Execution planning
- Daily/weekly planning

**What Planning Does NOT Own**

- Signal detection (Discovery)
- Insight generation (Analysis)
- Mission execution (Execution)
- Validation (Validation)

**Primary Skills**

- Opportunity scoring (opportunity + criteria → score)
- Mission generation (opportunity → mission)
- Prioritization (missions + criteria → priority order)
- Planning (missions + resources → execution plan)

**Emits Events**

- `MissionCreated`
- `MissionPrioritized`
- `PlanGenerated`
- `OpportunityRanked`
- `ResourceAllocated`

**Consumes Events**

- `InsightGenerated`
- `GapIdentified`
- `MissionCompleted`
- `MissionFailed`

**Quality Gates**

- Mission completeness (has all required fields)
- Priority justification (priority matches criteria)
- Plan feasibility (plan can execute with available resources)

---

### Department 4: Execution

**Why It Exists**

Plans without execution are dreams. Someone must run the missions that Planning creates. Execution owns the problem of doing the research—running LLM prompts, processing results, generating artifacts.

**Business Capability**

> The ability to execute research missions by coordinating skills, invoking integrations, processing results, and generating artifacts.

**What Execution Owns**

- Mission execution
- Skill orchestration
- Integration invocation (Gemini, Consumr.ai)
- Artifact generation
- Result processing
- Resource management (during execution)

**What Execution Does NOT Own**

- Mission creation (Planning)
- Quality validation (Validation)
- Knowledge storage (Knowledge Base)
- Planning (Planning)

**Primary Skills**

- Mission execution (mission → results)
- Prompt generation (mission → Gemini prompt)
- Result processing (raw results → structured output)
- Artifact generation (results → artifacts)

**Emits Events**

- `MissionStarted`
- `MissionCompleted`
- `MissionFailed`
- `ArtifactGenerated`
- `IntegrationInvoked`

**Consumes Events**

- `MissionCreated`
- `MissionPrioritized`
- `ResourceAllocated`

**Quality Gates**

- Execution completion (all objectives addressed)
- Output format (results match expected schema)
- Resource limits (within time/budget constraints)

---

### Department 5: Validation

**Why It Exists**

Quality is not optional. The Research Operating System earns trust through rigorous validation. Validation owns the problem of ensuring that what enters the knowledge base meets our standards.

**Business Capability**

> The ability to verify that outputs meet quality standards, check consistency with existing knowledge, route items for human review, and approve knowledge for incorporation.

**What Validation Owns**

- Quality gate enforcement
- Consistency checking
- Human review coordination
- Approval workflow
- Knowledge incorporation
- Conflict detection

**What Validation Does NOT Own**

- Quality gate design (Quality team defines; Validation enforces)
- Human decisions (humans make them)
- Knowledge storage (Knowledge Base receives)
- Mission execution (Execution runs)

**Primary Skills**

- Gate enforcement (item → pass/fail)
- Consistency checking (item + existing knowledge → conflicts?)
- Conflict resolution coordination (conflicts → human review)
- Approval workflow (item + decision → approval/rejection)

**Emits Events**

- `ValidationPassed`
- `ValidationFailed`
- `HumanReviewRequested`
- `KnowledgeConflict`
- `ItemApproved`
- `ItemRejected`

**Consumes Events**

- `MissionCompleted`
- `InsightGenerated`
- `ArtifactGenerated`
- `HumanReviewCompleted`

**Quality Gates**

- Evidence threshold (confidence meets minimum)
- Consistency check (no contradictions)
- Completeness check (required fields present)
- Source verification (provenance intact)

---

## 5. Department Dependencies

Departments do not call each other. They communicate through contracts, events, shared knowledge, and shared state.

### Communication Patterns

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    DEPARTMENT COMMUNICATION PATTERNS                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Pattern 1: Event-Driven (Primary)                                        │
│   ┌─────────┐         ┌─────────┐         ┌─────────┐                     │
│   │ Dept A │──emits──▶│  Event  │◀──subscribes──│ Dept B │              │
│   │         │         │   Bus   │         │         │                     │
│   └─────────┘         └─────────┘         └─────────┘                     │
│                                                                             │
│   Pattern 2: Knowledge-Based (Secondary)                                   │
│   ┌─────────┐                          ┌─────────────┐                   │
│   │ Dept A │──writes to───────────────▶│  Knowledge  │                   │
│   │         │                          │    Base     │                   │
│   └─────────┘◀──reads from────────────└─────────────┘                   │
│                                               ▲                            │
│                                               │                            │
│   ┌─────────┐                                │                            │
│   │ Dept B  │──writes to─────────────────────┘                            │
│   │         │                                                                │
│   └─────────┘                                                                │
│                                                                             │
│   Pattern 3: State-Based (Tertiary)                                        │
│   ┌─────────┐         ┌─────────┐         ┌─────────┐                     │
│   │ Dept A │──writes──▶│  State  │◀──reads───│ Dept B │                     │
│   │         │         │         │         │         │                     │
│   └─────────┘         └─────────┘         └─────────┘                     │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Why Direct Calls Are Forbidden

**1. Temporal Coupling**

If Discovery calls Analysis directly, Analysis must be running when Discovery finishes. This prevents parallel execution and limits scalability.

**2. Failure Cascade**

If Analysis fails when called by Discovery, Discovery fails. Failure does not isolate. Event-driven architecture prevents this.

**3. Testing Difficulty**

Testing Discovery requires a working Analysis. Testing becomes end-to-end. Event-driven architecture allows isolated testing.

**4. Evolution Difficulty**

If Analysis changes its interface, Discovery must change. Every department becomes coupled to every other department.

**5. Visibility Loss**

Direct calls are invisible to observers. Events are visible. We need to observe the system.

### Dependency Declaration

Each department declares its dependencies:

```yaml
Discovery:
  dependencies:
    requires: []                    # No dependencies; Discovery starts the cycle
    optional: []                   # No optional dependencies
    
Analysis:
  dependencies:
    requires: [discovery]          # Must run after Discovery
    optional: [validation_feedback]  # Enhanced by Validation feedback
    
Planning:
  dependencies:
    requires: [analysis]           # Must run after Analysis
    optional: []
    
Execution:
  dependencies:
    requires: [planning]          # Must run after Planning
    optional: [consumr]            # Enhanced by Consumr studies
    
Validation:
  dependencies:
    requires: [execution]         # Must run after Execution
    optional: [human_review]       # Human reviews when triggered
```

### Event Routing

Events are routed by type, not by destination:

```
Discovery emits: SignalsDetected
  → Event Bus routes to:
    → Analysis (subscribed to SignalsDetected)
    → Observers (subscribed to all)
    → Loggers (subscribed to all)
```

The emitting department does not know who consumes its events. This is loose coupling at its finest.

---

## 6. Department Boundaries

When two departments could perform the same work, we must define ownership. Ambiguity leads to duplicated effort, finger-pointing, and system complexity.

### Boundary Definitions

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         DEPARTMENT BOUNDARIES                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   DISCOVERY                    │  ANALYSIS                                    │
│   ─────────────────────────────│────────────────────────────                 │
│   Owns:                       │  Owns:                                       │
│   • Signal detection          │  • Signal interpretation                    │
│   • Source integration        │  • Evidence assembly                        │
│   • Signal classification     │  • Insight generation                        │
│   • Signal deduplication      │  • Confidence scoring                        │
│                               │  • Gap identification                        │
│   Does NOT own:               │                                             │
│   • What signals mean         │  Does NOT own:                              │
│   • How to use signals        │  • What generated insights mean             │
│   • Signal validation         │  • Whether to act on insights               │
│                               │  • Mission creation                          │
│                               │                                             │
├───────────────────────────────┼─────────────────────────────────────────────┤
│   PLANNING                    │  EXECUTION                                   │
│   ─────────────────────────────│────────────────────────────                 │
│   Owns:                       │  Owns:                                       │
│   • Opportunity scoring        │  • Mission execution                        │
│   • Mission creation           │  • Skill orchestration                      │
│   • Prioritization             │  • Integration invocation                   │
│   • Execution planning         │  • Artifact generation                       │
│   • Resource allocation        │  • Result processing                         │
│                               │                                             │
│   Does NOT own:               │  Does NOT own:                              │
│   • How missions execute       │  • What missions to create                 │
│   • What skills to invoke      │  • What skills to use                      │
│   • Mission quality            │  • Mission planning                         │
│                               │                                             │
├───────────────────────────────┼─────────────────────────────────────────────┤
│   VALIDATION                  │                                             │
│   ─────────────────────────────│                                             │
│   Owns:                       │                                             │
│   • Quality gate enforcement   │                                             │
│   • Consistency checking       │                                             │
│   • Conflict detection         │                                             │
│   • Human review coordination  │                                             │
│   • Approval workflow          │                                             │
│                               │                                             │
│   Does NOT own:               │                                             │
│   • Quality gate design        │                                             │
│   • Human decisions            │                                             │
│   • Mission creation           │                                             │
│                               │                                             │
└───────────────────────────────┴─────────────────────────────────────────────┘
```

### Ownership Rules

| Work Type | Owner | Rationale |
|-----------|-------|----------|
| Finding signals | Discovery | Discovery owns external observation |
| Understanding signals | Analysis | Analysis owns interpretation |
| Deciding action | Planning | Planning owns decision-making |
| Executing action | Execution | Execution owns doing |
| Validating quality | Validation | Validation owns quality |
| Storing knowledge | Knowledge Base | Not a department; infrastructure |
| Designing quality gates | Quality Team | Governance, not execution |
| Making decisions | Humans | Outside system |

### Overlap Resolution

When overlap is detected, these rules apply:

1. **Signal detection vs. analysis**: Discovery detects; Analysis interprets. If Discovery produces interpretation, it oversteps.

2. **Planning vs. execution**: Planning decides what to do; Execution does it. If Planning invokes skills, it oversteps.

3. **Execution vs. validation**: Execution generates outputs; Validation judges them. If Execution validates its own outputs, it oversteps.

4. **Validation vs. quality gates**: Validation enforces gates; Quality team designs them. If Validation designs gates, it oversteps.

---

## 7. Extensibility

Departments must be extensible. A new department added two years from now should not require modifying existing departments or the engine.

### Adding a New Department

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ADDING A NEW DEPARTMENT                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Step 1: Implement Contract                                                │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Create department implementation following DepartmentContract         │   │
│   │ • Implement all required interfaces                                 │   │
│   │ • Declare inputs, outputs, events                                 │   │
│   │ • Implement lifecycle methods                                      │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   Step 2: Register with Engine                                             │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Add department to config/departments.yaml                           │   │
│   │ • Declare dependencies                                            │   │
│   │ • Configure quality gates                                         │   │
│   │ • Set metrics                                                     │   │
│   └───────────────────────────────────��───────────────────────────────┘   │
│                                                                             │
│   Step 3: Subscribe to Events                                              │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Register event subscriptions with Event Bus                        │   │
│   │ • Which events trigger this department                             │   │
│   │ • How to handle events                                            │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   Step 4: Test in Isolation                                                │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Run department with mock inputs                                     │   │
│   │ • Verify outputs match schema                                     │   │
│   │ • Verify events emitted correctly                                 │   │
│   │ • Verify quality gates enforced                                    │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   Step 5: Integrate with System                                            │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Run full loop with new department                                   │   │
│   │ • Verify integration with existing departments                     │   │
│   │ • Verify event routing                                             │   │
│   │ • Verify state management                                          │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   Step 6: Document                                                         │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Add department to documentation                                    │   │
│   │ • Contract in departments.md                                      │   │
│   │ • Capabilities in roadmap                                          │   │
│   │ • Integration notes                                                │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Example: Adding "Competitive Intelligence" Department

Suppose we need a new department for competitive intelligence two years from now.

```
1. Implement Contract
   NewDepartment: competitive_intelligence
   Inputs: insights, external_research, knowledge_graph
   Outputs: competitor_profiles, competitive_analysis, threat_assessments
   Events: CompetitorProfileCreated, ThreatIdentified, CompetitiveAdvantageDetected
   Dependencies: requires [analysis]
   
2. Register
   Add to config/departments.yaml
   Configure to run after Analysis
   
3. Subscribe
   Subscribe to InsightGenerated events
   Subscribe to ExternalResearch events
   
4. Test
   Feed mock insights, verify competitor profiles generated
   
5. Integrate
   Run full loop, verify Competitive Intelligence outputs flow to Planning
   
6. Document
   Add to departments.md
```

**Existing departments do not change. The engine does not change. Competitive Intelligence plugs in.**

### Contract Versioning

When a department's interface must change:

```
Versioning Rules:
- Minor changes (add optional field): Increment minor version
- Major changes (remove field, change behavior): Increment major version
- Departments declare supported contract versions
- Engine rejects departments with incompatible major versions
- Deprecation: Old version runs until new version is stable
```

---

## 8. Governance

Departments must evolve under governance. Without governance, contracts drift, ownership blurs, and the system fragments.

### Evolution Principles

**1. Contract Stability**

Contracts should be stable. Changes should be rare and deliberate. Each change has a cost: existing implementations must update.

**2. Backward Compatibility**

When possible, new versions should be backward compatible. Add optional fields, don't remove required ones. Deprecate before removing.

**3. Clear Ownership**

Every contract has an owner. The owner is responsible for:
- Maintaining the contract
- Reviewing changes
- Approving implementations
- Deprecating when necessary

**4. Version Transparency**

All implementations should declare their contract version. The engine should log mismatches.

### Breaking Changes

A breaking change is anything that requires existing implementations to change:

- Removing a required field
- Changing a field type
- Changing event semantics
- Adding a required dependency
- Changing quality gate requirements

**Breaking Change Process**:
```
1. Propose change with rationale
2. Assess impact on existing implementations
3. If breaking:
   a. Create new contract version
   b. Set deprecation timeline (minimum 2 cycles)
   c. Notify all department owners
   d. Implement new version
   e. Run in parallel during transition
   f. Remove old version after transition
```

### Responsibility Transfer

When a department's ownership must transfer:

```
Transfer Process:
1. Document current state (contract, implementations, dependencies)
2. Identify new owner
3. New owner reviews and accepts
4. Update contract governance fields
5. Update documentation
6. Announce transfer to all stakeholders
7. Transition period (1 cycle minimum)
8. Old owner releases ownership
```

### Department Deprecation

When a department is replaced:

```
Deprecation Process:
1. Create new department (see Extensibility)
2. Run both in parallel (1+ cycles)
3. Compare outputs for equivalence
4. Deprecate old department:
   a. Mark as deprecated in registry
   b. Remove from default configurations
   c. Continue running for explicit requests only
5. After transition period:
   a. Remove from registry
   b. Archive implementation
   c. Update documentation
```

### Conflict Resolution

When departments disagree on ownership:

```
Resolution Process:
1. Escalate to Architecture Lead
2. Document both positions
3. Evaluate based on:
   - Original design intent
   - Current usage patterns
   - Future extensibility
   - Effort to change
4. Make decision with rationale
5. Update affected contracts
6. Communicate change to all owners
```

---

## Dependencies

This document defines the department system that implements the architectural vision in `01-architecture/departments.md`.

- `01-architecture/departments.md` — High-level department design
- `02-engine/research-loop.md` — Engine orchestration that invokes departments
- `04-quality/quality-gates.md` — Quality gates departments enforce

## Related Documents

- `04-departments/contracts/` — [Future] Individual department contracts
- `04-departments/governance/` — [Future] Governance procedures

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
