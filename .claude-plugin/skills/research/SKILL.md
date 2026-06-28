---
name: research
description: Execute the daily Web3 research mission. Orchestrates discovery, analysis, and validation using the Research Operating System architecture.
---

# Research Operating System — Daily Mission

## Pre-Flight Check

Before beginning, verify the architecture is loaded:

1. **Verify repository structure** — Check that `docs/` contains the architecture specifications
2. **Read CLAUDE.md** — The runtime entry point defines behavioral constraints
3. **Check state** — Read `runtime/state/loop-state.json` for pending work

## Architecture Contract

This skill orchestrates the architecture, not replaces it. The architecture documents in `docs/` are the **source of truth**:

| Architecture Layer | Location | Loaded When |
|-------------------|----------|-------------|
| Research Loop Engine | `docs/02-engine/research-loop.md` | Always |
| State Manager | `docs/02-engine/state-manager.md` | State operations |
| Event Bus | `docs/02-engine/event-bus.md` | Communication |
| Knowledge Model | `docs/04-knowledge/knowledge-model.md` | Knowledge extraction |
| Department System | `docs/03-departments/departments.md` | Capability orchestration |
| Quality Gates | `docs/06quality/quality-gates.md` | Validation |

## Execution Flow

```
/research EXECUTION
───────────────────

1. LOAD STATE
   • Read runtime/state/loop-state.json
   • Check for pending missions
   • Verify state integrity

2. DETERMINE MISSION
   • Load pending mission OR
   • Generate from daily-cycle.md

3. LOAD SPECIFICATIONS
   • Load required specs based on mission type

4. GENERATE PROMPT
   • Generate Gemini prompt
   • Output to artifacts/{date}/02-gemini-prompt.md

5. PAUSE — HUMAN RESEARCH
   • Await research completion
   • User provides results

6. EXTRACT KNOWLEDGE
   • Parse per knowledge-model.md
   • Output to artifacts/{date}/04-knowledge-delta.md

7. VALIDATE
   • Apply quality gates
   • Route failures to review

8. UPDATE KNOWLEDGE BASE
   • Write validated entities

9. GENERATE ARTIFACTS
   • Hypotheses, opportunities, state update, next mission

10. UPDATE STATE
    • Checkpoint
    • Queue tomorrow's mission
```

## Artifact Output Structure

Every execution produces:

```
artifacts/{YYYY-MM-DD}/
├── 01-mission.md              # Mission definition
├── 02-gemini-prompt.md       # Research prompt
├── 03-research-report.md      # User's research
├── 04-knowledge-delta.md      # New entities
├── 05-hypotheses.md           # Generated hypotheses
├── 06-opportunities.md        # Identified opportunities
├── 07-state-update.md         # State changes
├── 08-next-mission.md         # Tomorrow's mission
├── 09-audit-log.md            # Execution log
└── manifest.yaml              # Artifact manifest
```

## Knowledge Entity Types

Per `docs/04-knowledge/knowledge-model.md`:

| Entity | Description |
|--------|-------------|
| Protocol | Web3 protocol (Uniswap, Aave, etc.) |
| Signal | Detected observation |
| Evidence | Supporting information |
| Claim | Asserted proposition |
| Insight | Synthesized understanding |
| Opportunity | Potential action |
| Hypothesis | Testable proposition |
| Trend | Pattern of change |

## Quality Gates

Before incorporating knowledge, verify:

| Gate | Check | Failure Action |
|------|-------|---------------|
| Evidence | Claim has supporting evidence | Request more evidence |
| Confidence | Confidence ≥ 0.7 for decisions | Lower or reject |
| Source | Evidence has verifiable source | Flag for review |
| Consistency | No contradictions | Route to resolution |

## Command Options

- `/research` — Execute today's mission
- `/research --resume` — Resume paused execution
- `/research --mission <id>` — Execute specific mission

## Anti-Patterns

**DO NOT:**
- Execute research without a defined mission
- Skip quality gates
- Generate arbitrary output formats
- Duplicate architecture contents in prompts
- Store state outside `runtime/state/`

**ALWAYS:**
- Load specifications lazily
- Generate deterministic artifacts
- Checkpoint state after operations
- Route through quality gates

## Resume Protocol

If paused:
1. Read checkpoint from `runtime/state/checkpoints/latest/`
2. Restore state
3. Present user with completion status
4. Await research results
5. Resume from checkpoint

---

**Ready to execute.** State your research objective or run `/research` to begin.
