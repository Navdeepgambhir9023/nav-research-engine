# /research Command

**Entry Point**: Execute the daily research mission

---

## Purpose

`/research` is the sole entry point for executing research in the nav-research-engine.

It invokes the runtime layer to orchestrate the architecture specifications.

---

## Command Signature

```bash
/research [--mission <mission-id>] [--resume] [--force]
```

| Flag | Purpose |
|------|---------|
| `--mission <id>` | Execute a specific mission by ID |
| `--resume` | Resume a paused execution |
| `--force` | Force restart even if execution is pending |

---

## Behavior

### When Called Without Arguments

1. Check for pending/paused execution
2. If paused → prompt to resume
3. If idle → generate and execute today's mission
4. If running → report current status

### When Called With `--resume`

1. Verify execution is paused
2. Restore state from last checkpoint
3. Prompt user for research results
4. Resume execution

### When Called With `--mission <id>`

1. Load specified mission
2. Execute regardless of current state
3. Complete before returning

---

## Entry Point Wrapper

This command is the entry point. It does NOT contain business logic.

It only:

1. Validates the command
2. Invokes the runtime orchestrator
3. Routes user input to the appropriate phase

---

## Runtime Orchestration

The command delegates to:

```
runtime/orchestrator.sh
```

Which orchestrates:

1. State loading
2. Mission determination
3. Specification loading
4. Artifact generation
5. Pause/resume handling

---

## Usage Examples

```bash
# Execute today's research mission
/research

# Resume a paused execution
/research --resume

# Execute a specific mission
/research --mission mission-2026-06-29-001

# Force restart
/research --force
```

---

## Error Handling

| Error | Response |
|-------|---------|
| No mission available | Generate new mission |
| Execution already running | Report status, prompt to wait |
| State corrupted | Attempt rollback, prompt user |
| Specification missing | Abort with clear error |

---

## Next Steps After Command

The command outputs:

1. Current mission definition
2. Today's research prompt (for Gemini)
3. Instructions for resuming with results

---

## Anti-Patterns

This command MUST NOT:

- Execute research directly
- Skip quality gates
- Generate arbitrary output
- Store state outside runtime/state/
