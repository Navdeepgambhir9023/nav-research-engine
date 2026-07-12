name: use-nav
description: "Quick-start guide for nav-research-engine. Learn how to execute domain-agnostic research with brutal honesty."
metadata:
  version: "1"
  tags: "onboarding,quickstart,research"
  entrypoints: "/nav"
  author: "nav-research-engine"
---

# Nav Research Engine — Quick Start

**A domain-agnostic Research Operating System with brutal honesty.**

---

## What Is This?

Nav Research Engine is a research harness that helps you:
- Research any domain (AI, market, tech, bio, legal, etc.)
- Get verifiable, source-backed insights
- Receive honest assessments (even when harsh)
- Make better decisions with confidence scores

---

## Core Command

```
/nav:research --domain <domain> <query>
```

**Example:**
```
/nav:research --domain ai "is there market for AI coding assistants"
```

---

## Research Modes

| Command | Use When |
|---------|----------|
| `/nav:research --domain ai "query"` | Standard research (10-15 min) |
| `/nav:research --domain x --deep "query"` | Deep investigation (15-30 min) |
| `/nav:research --domain x --quick "query"` | Rapid gut-check (3-5 min) |

---

## Supported Domains

| Domain | Use For |
|--------|---------|
| `ai` | AI/ML, models, infrastructure |
| `market` | Market research, competitive analysis |
| `tech` | Technical deep-dives |
| `pmf` | Product-market-fit |
| `bio` | BioTech, healthcare |
| `legal` | Legal, compliance |

Any domain works — just specify what you're researching.

---

## How It Works

```
/nav:research --domain ai "market for AI coding assistants"
        ↓
1. Discovery — Find relevant sources
2. Verification — Cross-reference claims
3. Synthesis — Build verified insights
4. Output — Brutally honest report
```

---

## What You Get

Every research output includes:

- **Source citations** — `[SRC-001]` for every claim
- **Confidence scores** — 0-100% per finding
- **Verification status** — VERIFIED / CONFLICTING / UNVERIFIED
- **HONEST ASSESSMENT** — Direct truth, no sugarcoating
- **Limitations** — What couldn't be determined

---

## Quality Standards

Every research output MUST:
- Cite sources for all claims
- Score confidence honestly
- Flag conflicting sources
- State limitations upfront
- Be direct (no fluff)

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
/nav:research --domain ai --quick "is local AI viable for production?"
```

---

## Architecture

The system uses a prompt library pattern:

| Directory | Purpose |
|-----------|---------|
| `modes/` | AI-readable execution prompts |
| `docs/` | Architecture specifications |
| `runtime/` | Output contracts, state |

Read `modes/_shared.md` for global rules.

---

## Research with Nav Framework

Nav Research Engine integrates with the Nav workflow:

| Command | Purpose |
|---------|---------|
| `/nav:brainstorm` | Clarify research direction |
| `/nav:goal` | Define scope and success |
| `/nav:plan` | Plan research execution |
| `/nav:research` | Execute research |
| `/nav:verify` | Verify findings |

---

## The Brutal Truth Rule

> "Save users time and money, even when the truth is harsh."

If research shows:
- No opportunity → it will say so
- High risks → it won't minimize them
- Uncertain viability → it will flag it

**Better to know the harsh truth than a comfortable lie.**

---

## Next Steps

1. Try: `/nav:research --domain ai "quick test query"`
2. Read: `modes/_shared.md` for system rules
3. Read: `modes/research.md` for full workflow
4. Explore: `docs/01-architecture/` for design
