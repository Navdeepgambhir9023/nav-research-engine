# Departments

**Document ID**: 01.2
**Domain**: Architecture
**Status**: Draft

---

## Purpose

Maps the four functional areas (departments) of the ROS, their responsibilities, boundaries, and how they interact. Prevents overlap and gaps by ensuring each department has a clear mandate.

## Audience

- Architects (for system design)
- Contributors (for understanding where to add functionality)
- Reviewers (for validating scope boundaries)

## Department Overview

The ROS is organized into four departments, each responsible for a phase of the research lifecycle:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│    ┌───────────┐    ┌───────────┐    ┌───────────┐    ┌───────────┐       │
│    │ DISCOVERY │───▶│ ANALYSIS  │───▶│ PLANNING  │───▶│VALIDATION │       │
│    │           │    │           │    │           │    │           │       │
│    │ Find new  │    │ Make sense│    │ Decide    │    │ Verify &  │       │
│    │ signals   │    │ of signals│    │ what to do│    │ incorporate│      │
│    └───────────┘    └───────────┘    └───────────┘    └─────┬─────┘       │
│            │              │              │                  │             │
│            │              │              │                  │             │
│            │              │              │                  ▼             │
│            │              │              │         ┌───────────────┐      │
│            │              │              │         │  KNOWLEDGE    │      │
│            │              │              │         │    BASE       │      │
│            │              │              │         └───────────────┘      │
│            │              │              │                  ▲             │
│            │              │              │                  │             │
│            └──────────────┴──────────────┴──────────────────┘             │
│                           (Feedback Loop)                                  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Department 1: Discovery

### Mandate

> Find and surface signals—new opportunities, trends, protocols, and threats—before they become obvious to competitors.

### Responsibilities

1. **Signal Detection**
   - Monitor Web3 data sources for new activity
   - Detect emerging patterns and anomalies
   - Identify new protocols, projects, and initiatives

2. **Source Ingestion**
   - Ingest data from Web3 APIs (DeFi, NFTs, DAOs, infrastructure)
   - Process data from Consumr.ai consumer studies
   - Aggregate alternative data (social, news, forums)

3. **Signal Classification**
   - Tag signals by type (opportunity, threat, trend, data)
   - Flag signals for immediate attention or batch processing
   - Maintain signal inventory with provenance

### Boundaries

- **Discovery owns**: Signal detection logic, source adapters, classification taxonomy
- **Discovery does NOT own**: Analysis of what signals mean, planning of responses

### Key Outputs

- Raw signals (to Analysis)
- Source provenance records (to Knowledge Base)
- Detection metrics (to Operations)

---

## Department 2: Analysis

### Mandate

> Transform signals into understanding—contextualizing raw data into meaningful insights with evidence chains.

### Responsibilities

1. **Signal Enrichment**
   - Research background on detected signals
   - Identify related entities and prior knowledge
   - Cross-reference with existing knowledge base

2. **Evidence Assembly**
   - Build evidence chains from multiple sources
   - Assess evidence strength and reliability
   - Generate confidence scores with rationale

3. **Insight Generation**
   - Synthesize findings into structured insights
   - Identify implications and potential impacts
   - Generate hypotheses for validation

4. **Gap Identification**
   - Detect missing information needed for confident conclusions
   - Flag areas requiring additional research
   - Surface conflicting evidence

### Boundaries

- **Analysis owns**: Insight generation logic, evidence construction, gap detection
- **Analysis does NOT own**: Decision-making on what to pursue, final validation

### Key Outputs

- Enriched insights (to Planning)
- Knowledge gaps (to Planning)
- Evidence chains (to Knowledge Base)

---

## Department 3: Planning

### Mandate

> Decide what to do—prioritizing research missions and allocating attention based on opportunity value and strategic alignment.

### Responsibilities

1. **Opportunity Scoring**
   - Apply scoring model to opportunities
   - Rank by expected value and feasibility
   - Factor in strategic priorities and resource constraints

2. **Mission Creation**
   - Generate research missions to address gaps
   - Define mission objectives, scope, and acceptance criteria
   - Assign priority and resource estimates

3. **Resource Allocation**
   - Balance attention across opportunities
   - Plan daily and weekly research activities
   - Manage research pipeline and queue

4. **Autonomous Planning**
   - Generate daily research plans
   - Adapt plans based on new signals
   - Escalate high-priority items for human attention

### Boundaries

- **Planning owns**: Prioritization logic, mission creation, resource allocation
- **Planning does NOT own**: Final validation, human approval decisions

### Key Outputs

- Prioritized mission queue (to Operations)
- Daily research plans (to Operations)
- Opportunity rankings (to Intelligence Reports)

---

## Department 4: Validation

### Mandate

> Verify and protect—ensuring all knowledge entering the knowledge base meets quality standards and all outputs are trustworthy.

### Responsibilities

1. **Quality Gate Enforcement**
   - Verify evidence completeness and strength
   - Check compliance with schema requirements
   - Validate confidence score justifications

2. **Consistency Checking**
   - Detect contradictions with existing knowledge
   - Resolve conflicts through escalation or additional research
   - Maintain knowledge base integrity

3. **Human Review Coordination**
   - Route items for human review per HITL protocols
   - Collect and integrate human feedback
   - Track review status and decisions

4. **Knowledge Incorporation**
   - Approve and merge validated knowledge
   - Update knowledge graph relationships
   - Archive rejected items with rationale

### Boundaries

- **Validation owns**: Quality gate logic, consistency checking, approval workflows
- **Validation does NOT own**: Human judgment (humans do this), source data (providers do this)

### Key Outputs

- Validated knowledge (to Knowledge Base)
- Rejection notices with rationale (to originating department)
- Human review queue (to Human Interface)

---

## Department Interactions

### Primary Flow

```
Discovery ──▶ Analysis ──▶ Planning ──▶ Validation ──▶ Knowledge Base
    │             │            │            │
    └─────────────┴────────────┴────────────┘
                    (Feedback Loop)
```

### Feedback Paths

1. **Validation → Discovery**: "New sources needed" signals
2. **Validation → Analysis**: "Evidence gaps" feedback
3. **Validation → Planning**: "Priority adjustments" based on rejections
4. **Knowledge Base → All Departments**: Read access to accumulated knowledge

### Contract Interfaces

Each department exposes a contract for communication:

| From | To | Contract |
|------|-----|----------|
| Discovery | Analysis | Signal envelope with provenance |
| Analysis | Planning | Insight package with confidence |
| Planning | Validation | Mission proposal with resources |
| Validation | Knowledge | Validated entity with evidence |

## Dependencies

- `vision.md` — Defines the system these departments serve
- `principles.md` — Design principles that shaped department boundaries
- `stakeholders.md` — Maps users who interact with departments

## Related Documents

- `state-machine.md` — How departments coordinate through system states
- `component-contracts.md` — Technical interfaces between departments
- `data-flows.md` — How data moves between departments
- `03-operations/mission-lifecycle.md` — How missions flow through departments

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
