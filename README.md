# nav-research-engine

**A Domain-Agnostic Research Operating System with Brutal Honesty**

---

## What Is This?

`nav-research-engine` is a **research harness** that helps you research any domain with verifiable, source-backed insights and brutally honest output.

**The core principle**: Save users time and money, even when the truth is harsh.

---

## Quick Start

### Install as Plugin

```bash
/plugin install nav-research-engine@nav
```

### Execute Research

```bash
/nav:research --domain ai "is there market for AI coding assistants?"
```

---

## Research Modes

| Command | When to Use | Time |
|---------|-------------|------|
| `/nav:research --domain x "query"` | Standard research | 10-15 min |
| `/nav:research --domain x --deep "query"` | Deep investigation | 15-30 min |
| `/nav:research --domain x --quick "query"` | Rapid gut-check | 3-5 min |

---

## Supported Domains

Any domain works — specify what you're researching:

| Domain | Use For |
|--------|---------|
| `ai` | AI/ML, models, infrastructure |
| `market` | Market research, competitive analysis |
| `tech` | Technical deep-dives |
| `pmf` | Product-market-fit |
| `bio` | BioTech, healthcare |
| `legal` | Legal, compliance |

---

## What You Get

Every research output includes:

- **Source citations** — `[SRC-001]` for every claim
- **Confidence scores** — 0-100% per finding
- **Verification status** — VERIFIED / CONFLICTING / UNVERIFIED
- **HONEST ASSESSMENT** — Direct truth, no sugarcoating
- **Limitations** — What couldn't be determined

---

## The Brutal Truth Rule

> "It should save users time and money, even when the truth is harsh."

If research shows:
- **No opportunity** → it will say so directly
- **High risks** → it won't minimize them
- **Uncertain viability** → it will flag it clearly

**Better to know the harsh truth than a comfortable lie.**

---

## Architecture

```
nav-research-engine/
├── skills/                    # Skill definitions (AI-readable prompts)
│   ├── research/             # Main research skill
│   └── use-nav/              # Onboarding guide
├── modes/                    # Execution layer (prompt library)
│   ├── _shared.md            # System context, global rules
│   ├── research.md           # Standard research workflow
│   ├── deep-research.md      # Comprehensive investigation
│   └── quick-research.md      # Rapid assessment
├── docs/                      # Architecture specifications
└── runtime/                   # Output contracts, state
```

---

## How It Works

```
/nav:research --domain ai "market for AI coding assistants"
        ↓
1. Discovery      → Find relevant sources
2. Verification   → Cross-reference claims
3. Synthesis      → Build verified insights
4. Output         → Brutally honest report
```

---

## Quality Standards

Every output MUST have:
- Source citations for all claims
- Confidence scores (0-100%)
- Conflicts explicitly flagged
- HONEST ASSESSMENT section
- Limitations clearly stated

---

## Examples

**Market research:**
```
/nav:research --domain market "fintech opportunities 2024"
```

**Technical evaluation:**
```
/nav:research --domain tech --deep "evaluate langchain alternatives"
```

**Quick gut-check:**
```
/nav:research --domain ai --quick "is local AI viable?"
```

---

## Plugin Structure

```
.claude-plugin/
├── plugin.json         # Plugin metadata
└── marketplace.json    # Marketplace manifest

skills/
├── research/          # Research execution skill
└── use-nav/           # Onboarding guide
```

---

## License

MIT

---

## Author

Navdeep Singh
