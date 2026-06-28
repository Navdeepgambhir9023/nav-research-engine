# Research Operating System Documentation

This directory contains the complete architectural documentation for the nav-research-engine project.

## Repository Structure

```
nav-research-engine/
├── CLAUDE.md                 # Runtime entry point (commands, constraints)
├── docs/                     # Architecture specifications (source of truth)
├── runtime/                  # Runtime layer (orchestration)
├── knowledge/                # Knowledge base (generated)
└── artifacts/               # Execution outputs (generated)
```

## Architecture Documentation (docs/)

```
docs/
├── 00-foundation/          # Stable, foundational content
├── 01-architecture/       # System design (multiple views)
├── 02-engine/             # Research Loop Engine, State Manager, Event Bus
├── 03-departments/        # Department contracts and governance
├── 04-knowledge/           # Knowledge representation
├── 05-operations/          # Execution procedures
├── 06quality/              # Evidence and validation
├── 07evolution/          # Roadmap and versioning
├── 08-integration/         # External system contracts
└── 09-safety/             # Human oversight and safeguards
```

## Domain Overview

### 00-foundation (Foundational)

Philosophy and definitions that all other documentation depends upon.

| Document | Purpose |
|----------|---------|
| `vision.md` | What the ROS is and is not |
| `principles.md` | Non-negotiable design axioms |
| `glossary.md` | Canonical definitions of terms |
| `stakeholders.md` | Who uses the system and how |

### 01-architecture (System Design)

Multiple views of the system's architecture.

| Document | Purpose |
|----------|---------|
| `system-context.md` | System in its environment |
| `departments.md` | Functional areas and responsibilities |
| `state-machine.md` | Valid states and transitions |
| `component-contracts.md` | Interfaces between components |
| `data-flows.md` | Information flow through system |
| `adr-index.md` | Architecture decision records index |

### 02-engine (Research Loop Engine)

The heart of the system—the orchestration engine that coordinates all research activities.

| Document | Purpose |
|----------|---------|
| `research-loop.md` | Canonical specification of the Research Loop Engine |
| `state-manager.md` | Execution context management |
| `event-bus.md` | Communication backbone |

### 03-departments (Department System)

The autonomous business capabilities that own functional areas of responsibility.

| Document | Purpose |
|----------|---------|
| `departments.md` | Department contracts, lifecycle, and governance |

### 04-knowledge (Knowledge Representation)

How knowledge is represented and stored.

| Document | Purpose |
|----------|---------|
| `knowledge-model.md` | Mental model of knowledge |
| `entity-schemas.md` | JSON Schema definitions |
| `taxonomy.md` | Classification hierarchy |
| `graph-schema.md` | Knowledge graph structure |

### 05-operations (Execution Procedures)

How the system runs day-to-day.

| Document | Purpose |
|----------|---------|
| `daily-cycle.md` | Daily research loop |
| `weekly-cycle.md` | Weekly review cycle |
| `mission-lifecycle.md` | Research mission management |
| `runbook.md` | Step-by-step checklists |
| `failure-recovery.md` | Error recovery procedures |

### 06-quality (Trust and Validation)

Standards for evidence and quality.

| Document | Purpose |
|----------|---------|
| `quality-gates.md` | Quality checkpoints |
| `evidence-model.md` | Evidence standards |
| `scoring-model.md` | Opportunity scoring methodology |
| `gap-detection.md` | Identifying knowledge gaps |

### 07-evolution (Growth Tracking)

How the system improves over time.

| Document | Purpose |
|----------|---------|
| `roadmap.md` | Capability roadmap |
| `changelog.md` | Change history |
| `version-strategy.md` | Versioning approach |

### 08-integration (External Contracts)

Contracts for external systems.

| Document | Purpose |
|----------|---------|
| `integration-overview.md` | Map of all integrations |
| `gemini-contract.md` | Gemini LLM integration |
| `consumr-ai-contract.md` | Consumr.ai integration |
| `web3-apis.md` | Web3 data sources |

### 09-safety (Risk Mitigation)

Human oversight and safety systems.

| Document | Purpose |
|----------|---------|
| `human-oversight.md` | Human review protocols |
| `error-taxonomy.md` | Failure mode classification |
| `rollback-procedures.md` | Recovery procedures |
| `audit-logging.md` | Logging and accountability |

## Runtime Layer (runtime/)

The runtime layer orchestrates the architecture specifications.

```
runtime/
├── commands/
│   └── research.sh            # /research entry point
├── specifications/
│   ├── runtime-specification.md  # Orchestration logic
│   ├── mission-contract.md      # Mission schema
│   ├── output-contract.md       # Artifact contracts
│   └── index.csv             # Architecture spec index
├── state/
│   └── loop-state.json       # Execution state
└── missions/
    └── pending/              # Queued missions
```

## Document Status

All architecture documents are considered **stable** and are the source of truth for behavior.

Runtime specifications are **implementation specifications** that orchestrate the architecture.

## Reading Order

For new contributors, recommended reading order:

1. **Start with Foundation**
   - `docs/00-foundation/vision.md`
   - `docs/00-foundation/principles.md`
   - `docs/00-foundation/glossary.md`

2. **Understand the Engine**
   - `docs/02-engine/research-loop.md` (start here for implementers)

3. **Understand Departments**
   - `docs/03-departments/departments.md`

4. **Review Operations**
   - `docs/05-operations/daily-cycle.md`

5. **Explore Quality**
   - `docs/06quality/quality-gates.md`

6. **Check Roadmap**
   - `docs/07evolution/roadmap.md`

## Document Conventions

- All documents follow a standard header format
- Each document includes its purpose, audience, dependencies
- Change history is tracked at the bottom of each document
- References to other documents use relative links

## Contributing

When modifying documentation:

1. Update document status (Draft → Review → Approved)
2. Add entry to change history
3. Update affected documents' dependencies section
4. Request review from relevant stakeholders

## Version

Architecture version: **0.1.0**
Runtime version: **1.0.0**
Date: 2026-06-29
