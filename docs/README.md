# nav-research-engine Documentation

This directory contains the architectural documentation for the nav-research-engine project.

## Repository Structure

```
nav-research-engine/
├── CLAUDE.md                 # Core behavior and constraints
├── README.md                 # Project overview
├── docs/                     # Architecture specifications (source of truth)
├── runtime/                  # Runtime layer (orchestration)
├── .claude-plugin/          # Plugin manifest
└── .loop/                   # Goal system
```

## Architecture Documentation (docs/)

```
docs/
├── 00-foundation/          # Stable, foundational content
├── 01-architecture/        # System design
├── 02-engine/               # State management, event bus
├── 04-knowledge/            # Knowledge representation
└── 09-safety/             # Human oversight and safeguards
```

## Documentation Index

### 00-foundation (Foundational)

Philosophy and definitions that all other documentation depends upon.

| Document | Purpose |
|----------|---------|
| `vision.md` | What the system is and is not |
| `principles.md` | Non-negotiable design axioms |
| `glossary.md` | Canonical definitions of terms |
| `stakeholders.md` | Who uses the system and how |

### 01-architecture (System Design)

Multiple views of the system's architecture.

| Document | Purpose |
|----------|---------|
| `system-context.md` | System in its environment |
| `domain-config.md` | Domain configuration structure |
| `execution-layer.md` | Subagent/workflow orchestration |
| `state-machine.md` | Valid states and transitions |
| `component-contracts.md` | Interfaces between components |
| `data-flows.md` | Information flow through system |
| `adr-index.md` | Architecture decision records index |

### 02-engine (Core Engine)

Core system components.

| Document | Purpose |
|----------|---------|
| `state-manager.md` | Execution context management |
| `event-bus.md` | Communication backbone |

### 04-knowledge (Knowledge Representation)

How knowledge is represented and stored.

| Document | Purpose |
|----------|---------|
| `knowledge-model.md` | Mental model of knowledge |
| `taxonomy.md` | Classification hierarchy |

### 09-safety (Risk Mitigation)

Human oversight and safety systems.

| Document | Purpose |
|----------|---------|
| `human-oversight.md` | Human review protocols |
| `error-taxonomy.md` | Failure mode classification |
| `rollback-procedures.md` | Recovery procedures |
| `audit-logging.md` | Logging and accountability |

## Runtime Layer (runtime/)

The runtime layer orchestrates the research process.

```
runtime/
├── commands/
│   ├── parse-input.sh       # Domain flag parsing
│   ├── research.sh           # Research orchestration
│   └── discovery.md         # Adaptive questioning
├── specifications/
│   ├── runtime-specification.md  # Orchestration logic
│   ├── mission-contract.md      # Mission schema
│   └── output-contract.md       # Artifact contracts
└── state/
    └── loop-state.json       # Execution state
```

## Reading Order

For new contributors, recommended reading order:

1. **Start with Foundation**
   - `docs/00-foundation/vision.md`
   - `docs/00-foundation/principles.md`

2. **Understand the Architecture**
   - `docs/01-architecture/system-context.md`
   - `docs/01-architecture/domain-config.md`
   - `docs/01-architecture/execution-layer.md`

3. **Review Knowledge Model**
   - `docs/04-knowledge/knowledge-model.md`
   - `docs/04-knowledge/taxonomy.md`

4. **Check Core Engine**
   - `docs/02-engine/state-manager.md`
   - `docs/02-engine/event-bus.md`

## Document Conventions

- All documents follow a standard header format
- Each document includes its purpose, audience, dependencies
- Change history is tracked at the bottom of each document

## Version

Architecture version: **1.0.0**
Date: 2026-07-12
