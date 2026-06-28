---
name: research
description: "Execute the daily Web3 research mission. Orchestrates discovery, analysis, and validation using the Research Operating System architecture."
metadata:
  version: "1"
  tags: "research, web3, knowledge, autonomous"
  entrypoints: "/research", "/nav:research"
  author: "nav-research-engine"
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
┌─────────────────────────────────────────────────────────────────────────────┐
│                         /research EXECUTION                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   1. LOAD STATE                                                          │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ • Read runtime/state/loop-state.json                                 │  │
│   │ • Check for pending missions in runtime/missions/pending/            │  │
│   │ • Verify state integrity                                            │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼                                        │
│   2. DETERMINE MISSION                                                 │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ • If pending mission exists → Load it                               │  │
│   │ • If paused → Report checkpoint, await resume                       │  │
│   │ • If idle → Generate mission per docs/05-operations/daily-cycle.md │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼                                        │
│   3. LOAD SPECIFICATIONS                                               │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ Based on mission type, load required specs:                          │  │
│   │ • Discovery mission → Load discovery specs                         │  │
│   │ • Analysis mission → Load analysis specs                           │  │
│   │ • Validation mission → Load validation specs                       │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼                                        │
│   4. GENERATE PROMPT                                                  │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ Generate Gemini research prompt per docs/08-integration/             │  │
│   │ gemini-contract.md                                                │  │
│   │ Output to: artifacts/{date}/02-gemini-prompt.md                   │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼                                        │
│   5. PAUSE — HUMAN RESEARCH                                           │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ • Present mission to user                                          │  │
│   │ • Display Gemini prompt                                            │  │
│   │ • Await research completion                                        │  │
│   │ • User provides results in artifacts/{date}/03-research-report.md  │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼                                        │
│   6. EXTRACT KNOWLEDGE                                                │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ Parse research per docs/04-knowledge/knowledge-model.md             │  │
│   │ Extract entities, relationships, evidence                           │  │
│   │ Output to: artifacts/{date}/04-knowledge-delta.md                 │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼                                        │
│   7. VALIDATE                                                         │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ Apply quality gates per docs/06quality/quality-gates.md           │  │
│   │ Route failures to human review                                     │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼                                        │
│   8. UPDATE KNOWLEDGE BASE                                            │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ Write validated entities to knowledge/                               │  │
│   │ Update relationships in knowledge/relationships/                    │  │
│   │ Archive evidence in knowledge/evidence/                            │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼                                        │
│   9. GENERATE ARTIFACTS                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ • 05-hypotheses.md                                                │  │
│   │ • 06-opportunities.md                                             │  │
│   │ • 07-state-update.md                                             │  │
│   │ • 08-next-mission.md                                             │  │
│   │ • 09-audit-log.md                                                │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼                                        │
│   10. UPDATE STATE                                                    │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │ • Write checkpoint to runtime/state/checkpoints/                   │  │
│   │ • Update loop-state.json status = COMPLETED                       │  │
│   │ • Queue tomorrow's mission                                        │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Artifact Output Structure

Every execution produces:

```
artifacts/{YYYY-MM-DD}/
├── 01-mission.md              # Mission definition
├── 02-gemini-prompt.md       # Research prompt
├── 03-research-report.md      # User's research
├── 04-knowledge-delta.md     # New entities
├── 05-hypotheses.md          # Generated hypotheses
├── 06-opportunities.md        # Identified opportunities
├── 07-state-update.md        # State changes
├── 08-next-mission.md        # Tomorrow's mission
├── 09-audit-log.md           # Execution log
└── manifest.yaml              # Artifact manifest
```

## Knowledge Entity Types

Per `docs/04-knowledge/knowledge-model.md`, extract these entities:

| Entity | Description | Required Fields |
|--------|-------------|----------------|
| Protocol | Web3 protocol (Uniswap, Aave, etc.) | name, category, ecosystem |
| Signal | Detected observation | type, source, content |
| Evidence | Supporting information | source, strength, content |
| Claim | Asserted proposition | statement, evidence, confidence |
| Insight | Synthesized understanding | summary, claims, confidence |
| Opportunity | Potential action | problem, solution, score |
| Hypothesis | Testable proposition | statement, test_criteria |
| Trend | Pattern of change | direction, strength, timeframe |

## Quality Gates

Before incorporating knowledge, verify:

| Gate | Check | Failure Action |
|------|-------|---------------|
| Evidence | Claim has supporting evidence | Request more evidence |
| Confidence | Confidence ≥ 0.7 for decisions | Lower confidence or reject |
| Source | Evidence has verifiable source | Flag for review |
| Consistency | No contradictions with existing knowledge | Route to conflict resolution |

## Command Options

### `/research` or `/nav:research`

Execute today's mission from scratch.

### `/research --resume`

Resume a paused execution.

### `/research --mission <id>`

Execute a specific mission by ID.

## Anti-Patterns

**DO NOT:**
- Execute research without a defined mission
- Skip quality gates for "efficiency"
- Generate arbitrary output formats
- Duplicate architecture contents in prompts
- Store state outside `runtime/state/`

**ALWAYS:**
- Load specifications lazily (only what the mission needs)
- Generate deterministic artifacts (same inputs → same structure)
- Checkpoint state after significant operations
- Route through quality gates

## Resume Protocol

If execution is paused at checkpoint:

1. Read checkpoint ID from `runtime/state/checkpoints/latest/`
2. Restore state from checkpoint
3. Present user with:
   - What was completed
   - What remains
   - Expected outputs
4. Await research results
5. Resume from checkpoint

## Output Validation

Before completing, verify:

```
✓ All 9 artifacts generated
✓ Artifact schemas valid
✓ Quality gates passed
✓ State checkpointed
✓ Next mission queued
```

## Quick Reference

| Question | Answer |
|----------|--------|
| Where is the architecture? | `docs/` |
| Where is state? | `runtime/state/` |
| Where is output? | `artifacts/YYYY-MM-DD/` |
| Where is knowledge? | `knowledge/` |
| What can I add? | Entities, evidence, insights, opportunities |

---

**Ready to execute.** State your research objective or run `/research` to begin with today's mission.
