# nav-research-engine

**Research Operating System for Web3 Market Intelligence**

---

## Identity

This repository is a **Research Operating System (ROS)** — an autonomous engine for discovering, organizing, validating, and prioritizing business opportunities in the Web3 ecosystem.

The repository itself is the product. The runtime is the operating system that maintains it.

---

## Source of Truth

All behavioral specifications live in `docs/`.

**The architecture documents are NOT documentation. They are executable specifications.**

When behavior conflicts with implementation, the specification wins.

When the specification is wrong, update it through the proper ADR process — never by working around it.

---

## Entry Points

The primary entry point is the **`/research`** command (also available as `/nav:research` when installed as a plugin).

| Command | Purpose |
|---------|---------|
| `/research` | Execute the daily research mission |
| `/nav:research` | Same as `/research` (plugin invocation) |

**Plugin Installation:**
```bash
/plugin install nav-research-engine@nav
```
After installation, use `/nav:research` to invoke the Research OS.

Commands are the only entry points. Do not execute research through arbitrary prompts.

---

## Runtime Orchestration

The runtime layer (`runtime/`) orchestrates the architecture.

It does NOT perform research. It coordinates:

1. State loading — Where did we stop?
2. Mission determination — What should happen next?
3. Specification loading — Which architecture specs are required?
4. Artifact generation — What should be produced?
5. State checkpointing — How do we resume?

The runtime never contains business logic. Business logic lives in:
- `docs/04-knowledge/` — What knowledge exists
- `docs/03-departments/` — Who owns what capability
- `docs/06quality/` — How quality is measured

---

## Behavioral Constraints

### MUST

- Load specifications lazily — only what the current mission requires
- Generate deterministic artifacts — same inputs → same outputs
- Checkpoint state after every significant operation
- Generate exactly the artifact structure defined in `runtime/specifications/output-contract.md`
- Route all communication through the Event Bus model (even if not yet implemented)
- Record every action in the audit trail

### MUST NOT

- Duplicate architecture document contents in prompts or output
- Skip quality gates for convenience
- Generate arbitrary output formats
- Store state outside `runtime/state/`
- Execute research without a defined mission
- Bypass the command layer

### NEVER

- Override architectural decisions without an ADR
- Replace specifications with "improved" versions inline
- Skip human checkpoints for "efficiency"

---

## Repository Structure

```
nav-research-engine/
├── docs/                    # Architecture specifications (source of truth)
│   ├── 00-foundation/       # Vision, principles, glossary
│   ├── 01-architecture/     # System design
│   ├── 02-engine/          # Research Loop Engine, State Manager, Event Bus
│   ├── 03-departments/      # Department contracts
│   ├── 04-knowledge/        # Knowledge model
│   ├── 05-operations/        # Daily/weekly cycles
│   ├── 06quality/           # Quality gates, evidence
│   ├── 07-evolution/        # Roadmap, versioning
│   ├── 08-integration/       # External contracts
│   └── 09-safety/           # Human oversight, recovery
├── runtime/                 # Runtime layer (orchestration only)
│   ├── commands/            # Entry point commands
│   ├── specifications/       # Runtime specs (this is orchestration, not architecture)
│   ├── state/              # Execution state
│   └── missions/            # Mission definitions
├── knowledge/               # Knowledge base (generated)
│   ├── entities/
│   ├── evidence/
│   ├── signals/
│   └── insights/
└── artifacts/              # Execution outputs (generated)
    └── YYYY-MM-DD/
```

---

## First Execution Protocol

When `/research` is invoked:

1. **Load State** → Read `runtime/state/loop-state.json`
2. **Determine Mission** → Read `runtime/missions/` for pending missions
3. **Load Specifications** → Lazily load only required architecture docs
4. **Generate Prompt** → Create Gemini research prompt per `08-integration/gemini-contract.md`
5. **Pause** → Await human research completion
6. **Resume** → User provides research results
7. **Extract Knowledge** → Parse results into entities per `04-knowledge/knowledge-model.md`
8. **Update State** → Write checkpoint per `02-engine/state-manager.md`
9. **Generate Artifacts** → Produce output per `runtime/specifications/output-contract.md`
10. **Plan Next Mission** → Queue tomorrow's work per `05-operations/daily-cycle.md`

---

## Architecture Contract Enforcement

The runtime enforces architectural boundaries:

| Layer | Responsibility | DO NOT |
|-------|---------------|--------|
| `docs/` | Behavioral specifications | Modify during execution |
| `runtime/` | Orchestration | Contain business logic |
| `knowledge/` | Research outputs | Accept unvalidated claims |
| `artifacts/` | Execution records | Modify after generation |

---

## Commands

### `/research`

**Entry Point**: Execute the daily research mission.

Do not run arbitrary research. Always use this command.

---

## Skills

This project uses Claude skills for specialized capabilities:

- `/skills` — List available skills
- Skills are defined per capability area
- Skills must reference architecture specifications, not duplicate them

---

## State Persistence

Execution state is stored in `runtime/state/`:

- `loop-state.json` — Current execution state
- `missions/` — Mission queue and status
- `checkpoints/` — Recovery points

Never store state in memory across sessions.

---

## Knowledge Validation

All knowledge entering `knowledge/` must pass quality gates defined in `docs/06quality/quality-gates.md`.

No exceptions.

---

## Quick Reference

| Question | Answer |
|----------|--------|
| Where is the architecture? | `docs/` |
| Where do I start? | `runtime/commands/research.sh` |
| How do I add a capability? | Create ADR in `docs/01-architecture/decisions/` |
| How do I report research? | Add to `knowledge/` via quality gates |
| Where is output? | `artifacts/YYYY-MM-DD/` |

---

## Anti-Patterns to Avoid

1. **Direct LLM calls without mission** — Always route through `/research`
2. **Copy-pasting architecture** — Reference specifications, don't duplicate them
3. **Arbitrary output formats** — Follow `runtime/specifications/output-contract.md`
4. **State in memory** — Checkpoint to `runtime/state/` after every operation
5. **Skipping quality gates** — Validation is non-negotiable
