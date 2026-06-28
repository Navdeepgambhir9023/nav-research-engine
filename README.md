# nav-research-engine

**An Autonomous Research Operating System for Web3 Market Intelligence**

---

## What Is This?

`nav-research-engine` is a **Research Operating System (ROS)** — an autonomous engine for discovering, organizing, validating, and prioritizing business opportunities in the Web3 ecosystem.

The repository itself is the product. The runtime is the operating system that maintains it.

---

## Quick Start

### As a Plugin

```bash
# Install the plugin
/plugin install nav-research-engine@nav

# Execute daily research
/nav:research
```

### In Any Project

```bash
# Clone the repository
git clone https://github.com/Navdeepgambhir9023/nav-research-engine.git

# Open in Claude Code
cd nav-research-engine
claude

# Execute research
/research
```

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         RESEARCH OPERATING SYSTEM                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐              │
│   │ Discovery  │────▶│  Analysis  │────▶│  Planning  │              │
│   │            │     │             │     │            │              │
│   │ Find signals │   │ Transform to │   │ Decide what │              │
│   │ in Web3     │   │ insights     │   │ to research │              │
│   └─────────────┘     └─────────────┘     └──────┬──────┘              │
│                                                   │                       │
│                                                   ▼                       │
│                                          ┌─────────────┐                │
│                                          │ Execution  │                │
│                                          │            │                │
│                                          │ Run LLM    │                │
│                                          │ prompts     │                │
│                                          └──────┬──────┘                │
│                                                 │                         │
│                                                 ▼                         │
│                                          ┌─────────────┐                │
│                                          │ Validation │                │
│                                          │            │                │
│                                          │ Quality    │                │
│                                          │ gates      │                │
│                                          └──────┬──────┘                │
│                                                 │                         │
│                                                 ▼                         │
│                                          ┌─────────────┐                │
│                                          │ Knowledge  │                │
│                                          │   Base     │                │
│                                          │            │                │
│                                          │ Store &    │                │
│                                          │ grow       │                │
│                                          └─────────────┘                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Repository Structure

```
nav-research-engine/
├── .claude-plugin/           # Claude Code plugin manifest
│   ├── plugin.json           # Plugin definition
│   ├── marketplace.json      # Marketplace listing
│   └── skills/
│       └── research/
│           └── SKILL.md       # Research command skill
├── docs/                      # Architecture specifications (source of truth)
│   ├── 00-foundation/       # Vision, principles, glossary
│   ├── 01-architecture/     # System design
│   ├── 02-engine/            # Research Loop Engine, State Manager, Event Bus
│   ├── 03-departments/       # Department contracts
│   ├── 04-knowledge/          # Knowledge model
│   ├── 05-operations/         # Daily/weekly cycles
│   ├── 06quality/            # Quality gates
│   ├── 07-evolution/         # Roadmap, versioning
│   ├── 08-integration/       # External contracts (Gemini, etc.)
│   └── 09-safety/            # Human oversight, recovery
├── runtime/                    # Runtime layer (orchestration)
│   ├── commands/             # Entry points
│   ├── specifications/        # Runtime contracts
│   └── state/                # Execution state
├── knowledge/                # Knowledge base (generated)
│   ├── entities/
│   ├── evidence/
│   └── signals/
└── artifacts/                # Execution outputs (generated)
    └── YYYY-MM-DD/
```

---

## Key Concepts

### Research Loop Engine

The heart of the system. Coordinates departments through a deterministic execution cycle:

```
WAKE → DISCOVER → ANALYZE → PLAN → EXECUTE → VALIDATE → REST
```

### Knowledge Model

Canonical entity types for Web3 research:

- **Protocols** — DeFi protocols, L2s, infrastructure
- **Signals** — Detected observations
- **Evidence** — Verifiable information
- **Claims** — Asserted propositions
- **Insights** — Synthesized understanding
- **Opportunities** — Potential actions
- **Hypotheses** — Testable propositions

### Department System

Five autonomous departments:

| Department | Responsibility |
|------------|----------------|
| Discovery | Find signals in Web3 ecosystem |
| Analysis | Transform signals into insights |
| Planning | Decide what to research |
| Execution | Run research missions |
| Validation | Ensure quality |

### State Management

Execution context is checkpointed for resumability:

- State is transient (execution context)
- Knowledge is permanent (what we know)
- Events are immutable (what happened)

---

## Commands

### `/research` or `/nav:research`

Execute the daily research mission.

**Flow:**
1. Load state from `runtime/state/`
2. Determine or generate mission
3. Generate research prompt
4. Await your research
5. Extract knowledge
6. Validate quality
7. Update knowledge base
8. Generate artifacts
9. Queue tomorrow's mission

---

## Artifacts

Every execution produces:

```
artifacts/YYYY-MM-DD/
├── 01-mission.md              # Mission definition
├── 02-gemini-prompt.md       # Research prompt
├── 03-research-report.md      # Your research
├── 04-knowledge-delta.md     # New entities
├── 05-hypotheses.md          # Generated hypotheses
├── 06-opportunities.md       # Identified opportunities
├── 07-state-update.md        # State changes
├── 08-next-mission.md        # Tomorrow's mission
└── 09-audit-log.md         # Execution log
```

---

## Design Principles

1. **Knowledge First** — The knowledge base is the primary artifact
2. **Evidence Driven** — Every claim is traceable to evidence
3. **Human-in-the-Loop** — Critical decisions require human judgment
4. **Deterministic** — Same inputs → same outputs
5. **Composable** — Departments are independent, replaceable
6. **Repository First** — The repo is the product, not the code

---

## Architecture Documents

| Document | Purpose |
|----------|---------|
| `docs/02-engine/research-loop.md` | Execution orchestration |
| `docs/02-engine/state-manager.md` | Execution context |
| `docs/02-engine/event-bus.md` | Communication model |
| `docs/04-knowledge/knowledge-model.md` | Entity definitions |
| `docs/03-departments/departments.md` | Department contracts |
| `docs/06quality/quality-gates.md` | Quality standards |

---

## Development Status

| Component | Status |
|-----------|--------|
| Architecture | ✅ Complete |
| Runtime | 🚧 In Progress |
| Implementation | ⬜ Pending |
| First Research | ⬜ Pending |

---

## Contributing

1. Read `docs/` to understand the architecture
2. Read `CLAUDE.md` for behavioral constraints
3. Run `/research` to execute missions
4. Update `docs/` via ADR for architectural changes

---

## License

MIT

---

## Author

Navdeep Singh
