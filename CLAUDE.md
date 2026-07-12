# nav-research-engine

**Domain-Agnostic Research Operating System with Brutal Honesty**

---

## Identity

This repository is a **Research Operating System** — a prompt library that guides AI harnesses to execute verifiable, honest research across any domain.

**Core principle**: Save users time and money, even when the truth is harsh.

---

## Source of Truth

| File | Purpose |
|------|---------|
| `modes/*.md` | AI-readable execution prompts |
| `skills/*/SKILL.md` | Skill definitions |
| `docs/01-architecture/` | Architecture context |

**Execution order**: `modes/_shared.md` → mode file → architecture docs (for context)

---

## Entry Point

```
/nav:research --domain <domain> <query>
```

**Examples:**
```
/nav:research --domain ai "market for AI coding assistants"
/nav:research --domain market --deep "fintech opportunities"
/nav:research --domain tech --quick "is Rust replacing C++?"
```

---

## Research Modes

| Mode | When to Use |
|------|-------------|
| Standard (default) | General research, 10-15 min |
| `--deep` | Comprehensive investigation, 15-30 min |
| `--quick` | Rapid gut-check, 3-5 min |

---

## Execution Workflow

When `/nav:research` is invoked:

1. **Read `modes/_shared.md`** — System context, global rules
2. **Read appropriate mode** — `research.md`, `deep-research.md`, or `quick-research.md`
3. **Discovery** — Find sources via WebSearch
4. **Verification** — Cross-reference claims, assign confidence
5. **Synthesis** — Build findings with evidence chains
6. **Output** — Follow `runtime/specifications/brutal-output-template.md`

---

## Quality Standards

Every research output MUST have:

- `[SRC-XXX]` citations for all claims
- Confidence scores (0-100%) per finding
- Conflicts explicitly flagged
- HONEST ASSESSMENT section
- Limitations clearly stated

---

## Confidence Scale

| Score | Level | Meaning |
|-------|-------|---------|
| 90-100% | HIGH | Verified, recent, multiple sources |
| 70-89% | MEDIUM | Supported, minor gaps |
| 50-69% | LOW | Plausible, unverified |
| 0-49% | UNCERTAIN | Speculation or contradictory |

---

## Repository Structure

```
nav-research-engine/
├── skills/                    # Skill definitions
│   ├── research/             # Main research skill
│   └── use-nav/              # Onboarding guide
├── modes/                    # Prompt library (execution layer)
│   ├── _shared.md           # System context, global rules
│   ├── research.md          # Standard research workflow
│   ├── deep-research.md      # Comprehensive investigation
│   └── quick-research.md     # Rapid assessment
├── docs/                     # Architecture specifications
│   └── 01-architecture/      # Design context
├── runtime/                  # Output contracts
│   └── specifications/       # Output templates
└── .claude-plugin/          # Plugin manifest
```

---

## Behavioral Constraints

### MUST

- Cite sources for all claims
- Score confidence honestly (don't oversell)
- Flag conflicts explicitly
- State limitations upfront
- Generate HONEST ASSESSMENT (even if negative)

### MUST NOT

- Fabricate data
- Skip quality gates
- Hide negative findings
- Overstate confidence
- Skip source citations

---

## Anti-Patterns

1. **Skip citations** → Every claim needs `[SRC-XXX]`
2. **Fabricate confidence** → Score honestly (0-100%)
3. **Hide conflicts** → Report disagreements between sources
4. **Sugarcoat** → HONEST ASSESSMENT must be direct
5. **Skip limitations** → Always state what couldn't be determined

---

## Integration with Nav Framework

This research engine integrates with the Nav workflow:

| Command | Purpose |
|---------|---------|
| `/nav:brainstorm` | Clarify research direction |
| `/nav:goal` | Define scope and success criteria |
| `/nav:plan` | Plan research execution |
| `/nav:research` | Execute research (this system) |
| `/nav:verify` | Verify findings |

---

## The Brutal Truth Rule

> "It should save users time and money, even when the truth is harsh."

If research shows:
- **No opportunity** → say so directly
- **High risks** → don't minimize them
- **Uncertain viability** → flag it clearly

**Better to know the harsh truth than a comfortable lie.**
