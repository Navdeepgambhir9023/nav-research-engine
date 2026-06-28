# State Machine

**Document ID**: 01.3
**Domain**: Architecture
**Status**: Draft

---

## Purpose

Defines the valid states of the ROS and the transitions between them. Ensures deterministic behavior and provides a framework for understanding system progress.

## Audience

- Engineers (for implementation)
- Operations (for understanding system behavior)
- QA (for testing state transitions)

## Overview

The ROS operates as a state machine with two interacting layers:

1. **System State**: Overall operational mode of the ROS
2. **Mission States**: State of individual research missions within the system

---

## System States

```
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│  IDLE   │────▶│ RUNNING │────▶│ WAITING │────▶│   DONE  │
│         │     │         │     │         │     │         │
└─────────┘     └─────────┘     └─────────┘     └─────────┘
     ▲              │               │               │
     │              │               │               │
     │              ▼               ▼               ▼
     │         ┌─────────┐     ┌─────────┐     ┌─────────┐
     └─────────│ ERROR   │◀────│ PAUSED  │────▶│ARCHIVED │
               │         │     │         │     │         │
               └─────────┘     └─────────┘     └─────────┘
```

### State Definitions

| State | Description | Entry Condition | Exit Condition |
|-------|-------------|-----------------|----------------|
| `IDLE` | System is ready, no active work | System initialized; previous cycle complete | Work scheduled |
| `RUNNING` | Actively executing research cycle | Daily cycle triggered | Cycle complete or error |
| `WAITING` | Blocked on external dependency | Waiting for LLM, human review, or API | Dependency resolved |
| `PAUSED` | Temporarily suspended | Manual pause; maintenance | Manual resume |
| `ERROR` | Encountered an unrecoverable condition | Fatal error during execution | Error resolved; manual reset |
| `DONE` | Successfully completed current cycle | All cycle objectives achieved | System returns to IDLE |
| `ARCHIVED` | Historical state, no longer active | Manual archive; retention policy | Never exits |

### State Transitions

| From | To | Trigger |
|------|-----|---------|
| `IDLE` | `RUNNING` | Scheduled time; manual trigger |
| `RUNNING` | `WAITING` | External dependency required |
| `RUNNING` | `DONE` | All objectives met |
| `RUNNING` | `ERROR` | Unrecoverable error |
| `WAITING` | `RUNNING` | Dependency satisfied |
| `WAITING` | `ERROR` | Dependency failed |
| `PAUSED` | `RUNNING` | Manual resume |
| `PAUSED` | `ARCHIVED` | Manual archive |
| `ERROR` | `IDLE` | Manual reset after review |
| `DONE` | `IDLE` | Post-cycle processing complete |
| `DONE` | `ARCHIVED` | Retention policy |

---

## Mission States

Each research mission transitions through its own state machine:

```
┌───────────┐    ┌───────────┐    ┌───────────┐    ┌───────────┐
│ PROPOSED  │───▶│ APPROVED  │───▶│ IN_PROGRESS│───▶│ REVIEW    │
│           │    │           │    │           │    │           │
└───────────┘    └───────────┘    └───────────┘    └─────┬─────┘
       │              │               │                  │
       │              │               │                  ▼
       │              │               │           ┌───────────┐
       │              │               │           │ COMPLETED │
       │              │               │           └───────────┘
       │              │               │                  │
       ▼              ▼               ▼                  ▼
┌───────────┐    ┌───────────┐    ┌───────────┐    ┌───────────┐
│ REJECTED  │    │  QUEUED   │    │ BLOCKED   │    │ VALIDATED │
│           │    │           │    │           │    │           │
└───────────┘    └───────────┘    └───────────┘    └───────────┘
       │              │               │
       │              │               │
       └──────────────┴───────────────┘
                      │
                      ▼
               ┌───────────┐
               ��  FAILED   │
               └───────────┘
```

### Mission State Definitions

| State | Description | Valid Transitions |
|-------|-------------|-------------------|
| `PROPOSED` | Created by Planning, awaiting approval | APPROVED, REJECTED |
| `APPROVED` | Accepted by Validation, ready for queue | QUEUED |
| `QUEUED` | Waiting for execution resources | IN_PROGRESS, BLOCKED |
| `IN_PROGRESS` | Actively being researched | REVIEW, BLOCKED, FAILED |
| `BLOCKED` | Waiting on dependency or human input | QUEUED, FAILED |
| `REVIEW` | Completed, awaiting quality gate review | COMPLETED, VALIDATED, FAILED |
| `COMPLETED` | Passed review, outputs ready | VALIDATED |
| `VALIDATED` | Incorporated into knowledge base | (terminal) |
| `REJECTED` | Did not pass approval | (terminal) |
| `FAILED` | Execution failed unrecoverably | (terminal) |

### Quality Gate Integration

```
┌──────────────────────────────────────────────────────────────────┐
│                     QUALITY GATE CHECKPOINTS                      │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Gate 1: Proposal     ──▶ Review mission objectives and scope   │
│                           Before: PROPOSED → APPROVED            │
│                                                                  │
│  Gate 2: Execution     ──▶ Verify sufficient evidence gathered  │
│                           Before: IN_PROGRESS → REVIEW          │
│                                                                  │
│  Gate 3: Validation    ──▶ Confirm evidence strength meets      │
│                           threshold before knowledge entry       │
│                           Before: COMPLETED → VALIDATED         │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## Daily Cycle States

The daily research cycle operates within the system state machine:

```
┌────────────────────────────────────────────────────────────────────────┐
│                          DAILY CYCLE SEQUENCE                         │
├────────────────────────────────────────────────────────────────────────┤
│                                                                        │
│  ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐   ┌─────┐ │
│  │Start│──▶│Disc.│──▶│Anal.│──▶│Plan │──▶│Exec │──▶│Valid│──▶│Report│ │
│  └─────┘   └─────┘   └─────┘   └─────┘   └─────┘   └─────┘   └─────┘ │
│                                                                        │
│  Start:      Initialize daily cycle                                    │
│  Disc:       Discovery department processes signals                    │
│  Anal:       Analysis department enriches signals                      │
│  Plan:       Planning department creates/adjusts missions              │
│  Exec:       Execute highest priority missions                         │
│  Valid:      Validation department reviews outputs                     │
│  Report:     Generate daily summary                                    │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

### Cycle State Tracking

| Phase | System State | Expected Duration | Exit Criteria |
|-------|--------------|-------------------|---------------|
| Start | RUNNING | < 1 min | All systems initialized |
| Discovery | RUNNING | < 30 min | All active sources polled |
| Analysis | RUNNING | < 2 hours | All new signals processed |
| Planning | RUNNING | < 30 min | Daily plan finalized |
| Execution | RUNNING | Variable | Missions complete or time limit |
| Validation | RUNNING | < 1 hour | All outputs reviewed |
| Report | RUNNING | < 30 min | Daily report generated |

---

## Error Recovery States

```
┌─────────────────────────────────────────────────────────────────────┐
│                         ERROR HANDLING FLOW                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   Normal Execution                                                   │
│         │                                                            │
│         ▼                                                            │
│   ┌──────────┐                                                       │
│   │  Step   │─────── success ───────▶ Next Step                     │
│   └──────────┘                                                       │
│         │                                                            │
│         │ error                                                      │
│         ▼                                                            │
│   ┌──────────────────┐                                              │
│   │ Classify Error    │                                              │
│   └────────┬─────────┘                                              │
│            │                                                         │
│     ┌──────┴──────┐                                                 │
���     │             │                                                 │
│     ▼             ▼                                                 │
│ ┌────────┐   ┌────────────┐                                         │
│ │Retryabl│   │ Fatal      │                                         │
│ │Error   │   │ Error      │                                         │
│ └───┬────┘   └─────┬──────┘                                         │
│     │              │                                                 │
│     ▼              ▼                                                 │
│ ┌────────┐   ┌──────────┐                                           │
│ │Retry N │   │ ERROR    │                                           │
│ │Times   │   │ State    │                                           │
│ └───┬────┘   └──────────┘                                           │
│     │                                                              │
│     ▼                                                              │
│ ┌────────┐                                                         │
│ │Success?│─── yes ──▶ Resume Normal                                │
│ └────┬───┘                                                         │
│      │ no                                                         │
│      ▼                                                             │
│ ┌──────────┐                                                       │
│ │ WAITING │ (if recoverable)                                       │
│ └──────────┘                                                       │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Error Classification

| Error Type | Examples | Recovery Action |
|------------|---------|----------------|
| Transient | Network timeout, rate limit | Retry with backoff |
| Recoverable | Missing optional data | Continue with fallback |
| Blocked | Required external dependency | Move to WAITING |
| Fatal | Data corruption, invalid state | ERROR state, human review |

---

## Dependencies

- `departments.md` — Departments that own state transitions
- `03-operations/daily-cycle.md` — Cycle that drives state changes
- `03-operations/mission-lifecycle.md` — Mission state machine

## Related Documents

- `component-contracts.md` — Interfaces that trigger transitions
- `data-flows.md` — Data movement during transitions
- `03-operations/failure-recovery.md` — Recovery procedures
- `07-safety/error-taxonomy.md` — Error classification

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
