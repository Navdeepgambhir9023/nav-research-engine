# nav-research-engine

**A Domain-Agnostic Research Orchestration Harness**

---

## What Is This?

`nav-research-engine` is a **Research Orchestration Harness** that helps researchers discover, organize, validate, and prioritize insights across any domain (AI, BioTech, Market Research, PMF Analysis, etc.) — with a human researcher performing the actual research.

The harness provides:
- **Adaptive Discovery** — Clarifies vague research queries through intelligent questioning
- **Multi-Domain Support** — Works across any vertical with domain-specific configurations
- **Subagent Orchestration** — Coordinates Claude Code, Gemini CLI, Codex for research execution
- **Standardized Outputs** — Consistent artifact formats regardless of domain

---

## Quick Start

### As a Plugin

```bash
# Install the plugin
/plugin install nav-research-engine@nav

# Execute research (requires --domain flag)
/nav:research --domain ai "find PMF for LLM applications"
```

### In Any Project

```bash
# Clone the repository
git clone https://github.com/Navdeepgambhir9023/nav-research-engine.git

# Open in Claude Code
cd nav-research-engine
claude

# Execute research
/nav:research --domain <domain> "<query>"
```

---

## Usage

### Command Syntax

```bash
/nav:research --domain <domain> <query>
```

**Examples:**
```bash
/nav:research --domain ai "find PMF for LLM applications"
/nav:research --domain market "analyze competitive landscape for SaaS"
/nav:research --domain pmf "validate problem statement for X"
/nav:research --domain tech "research AI agent frameworks"
```

**Available Domains:**
- `ai` — Artificial Intelligence & Machine Learning
- `market` — Market Research & Competitive Analysis
- `pmf` — Product-Market Fit Analysis
- `tech` — Technology Research

If no `--domain` is provided, the system will ask clarifying questions.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    NAV-RESEARCH-ENGINE HARNESS                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐              │
│   │  Discovery │────▶│  Analysis │────▶│  Planning │              │
│   │            │     │           │     │            │              │
│   │ Adaptive   │     │ Transform  │     │ Prioritize │              │
│   │ Questions  │     │ to Insights│     │ Research   │              │
│   └─────────────┘     └─────────────┘     └──────┬──────┘              │
│                                                   │                       │
│                                                   ▼                       │
│                                          ┌─────────────┐                │
│                                          │ Execution  │                │
│                                          │            │                │
│                                          │ Subagent  │                │
│                                          │ Workflows │                │
│                                          └──────┬──────┘                │
│                                                 │                         │
│                                                 ▼                         │
│                                          ┌─────────────┐                │
│                                          │ Validation │                │
│                                          │            │                │
│                                          │ Quality    │                │
│                                          │ Gates      │                │
│                                          └─────────────┘                │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Repository Structure

```
nav-research-engine/
├── CLAUDE.md                     # Core behavior and constraints
├── README.md                     # This file
├── .claude-plugin/               # Plugin manifest
│   ├── plugin.json
│   └── commands/research.md
├── docs/                         # Architecture specifications
│   ├── 00-foundation/           # Vision, principles, glossary
│   ├── 01-architecture/         # System design
│   ├── 02-engine/               # State management, event bus
│   ├── 04-knowledge/            # Knowledge model, taxonomy
│   └── 09-safety/              # Human oversight, safeguards
├── runtime/                      # Runtime layer (orchestration)
│   ├── commands/                 # Entry points
│   │   ├── parse-input.sh      # Domain flag parsing
│   │   ├── research.sh          # Research orchestration
│   │   └── discovery.md         # Adaptive questioning
│   ├── specifications/          # Runtime contracts
│   └── state/                   # Execution state
└── .loop/                       # Goal system
```

---

## Key Concepts

### Adaptive Discovery

The system asks clarifying questions when your query is vague:

```
User: /nav:research "help me understand my market"
System: What is your product/service? Who is your target user?
User: [provides context]
System: What specific aspect of the market do you want to understand?
User: [clarifies]
System: [executes research with full context]
```

### Domain Configuration

Each domain has its own configuration with:
- Domain-specific entity types
- Taxonomy hierarchies
- Research templates
- Quality standards

### Execution Layer

The harness orchestrates research using:
- **Subagents** — Parallel research tasks
- **Workflows** — Coordinated multi-step research
- **Quality Gates** — Validation checkpoints

---

## Design Principles

1. **Knowledge First** — The knowledge base is the primary artifact
2. **Evidence Driven** — Every claim is traceable to evidence
3. **Human-in-the-Loop** — Critical decisions require human judgment
4. **Deterministic** — Same inputs → same outputs
5. **Composable** — Components are independent, replaceable
6. **Domain-Agnostic** — Works across any vertical

---

## Architecture Documents

| Document | Purpose |
|----------|---------|
| `docs/01-architecture/domain-config.md` | Domain configuration structure |
| `docs/01-architecture/execution-layer.md` | Subagent orchestration |
| `docs/02-engine/state-manager.md` | Execution context |
| `docs/02-engine/event-bus.md` | Communication model |
| `docs/04-knowledge/knowledge-model.md` | Entity definitions |
| `docs/04-knowledge/taxonomy.md` | Classification hierarchy |

---

## License

MIT

---

## Author

Navdeep Singh
