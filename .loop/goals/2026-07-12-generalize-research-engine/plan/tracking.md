# Tracking: Generalize nav-research-engine for Multi-Domain Use

> **Owner:** executor subagents. **Update cadence:** after every step. **Commit:** every update.
>
> This is the live ledger. The phase files (e.g. `01-command-discovery.md`) are the static spec. When the two disagree, `tracking.md` is what `/loop` trusts for resume.
>
> The format is a strict checklist. Do not nest deeper than 3 levels. Do not add prose. Do not reorder items — the wave-analyzer walks this file top-to-bottom.

- [ ] **Phase 1: Command Interface + Adaptive Discovery** — see [01-command-discovery.md](./01-command-discovery.md)
  - [ ] Task 1.1: Command Interface with Domain Flag
    - [x] Step 1: Update command skill documentation
    - [x] Step 2: Create input parser script
    - [x] Step 3: Verify parser handles domain extraction
    - [x] Step 4: Verify parser handles missing domain
    - [x] Step 5: Update research shell script
    - [x] Step 6: Commit
    - [x] Step 7: Update tracking.md
  - [x] Task 1.2: Adaptive Discovery Engine
    - [x] Step 1: Define discovery engine behavior
    - [x] Step 2: Document example dialogues
    - [x] Step 3: Verify document completeness
    - [x] Step 4: Commit
    - [x] Step 5: Update tracking.md
- [ ] **Phase 2: Domain Architecture + Knowledge Model Abstraction** — see [02-domain-knowledge.md](./02-domain-knowledge.md)
  - [ ] Task 2.1: Domain Configuration Architecture
    - [x] Step 1: Define domain folder structure
    - [x] Step 2: Document the minimal domain example
    - [x] Step 3: Define domain loading mechanism
    - [x] Step 4: Commit
    - [x] Step 5: Update tracking.md
  - [ ] Task 2.2: Abstract the Knowledge Model
    - [x] Step 1: Identify Web3-specific entities
    - [x] Step 2: Define core entity types
    - [x] Step 3: Update the taxonomy document
    - [x] Step 4: Verify no Web3 specifics remain in core docs
    - [x] Step 5: Commit
    - [x] Step 6: Update tracking.md
- [ ] **Phase 3: Output Contract + Execution Layer** — see [03-output-execution.md](./03-output-execution.md)
  - [ ] Task 3.1: Standardize Output Contract
    - [x] Step 1: Review existing output contract
    - [x] Step 2: Generalize artifact structure
    - [x] Step 3: Verify artifact types are domain-agnostic
    - [x] Step 4: Commit
    - [x] Step 5: Update tracking.md
  - [ ] Task 3.2: Execution Layer Architecture
    - [x] Step 1: Define execution layer responsibilities
    - [x] Step 2: Document subagent/workflow pattern
    - [x] Step 3: Document harness integration
    - [x] Step 4: Verify document completeness
    - [x] Step 5: Commit
    - [x] Step 6: Update tracking.md

## How a Wave Re-Reads This File

When `/loop` restarts (or a task fails and is re-dispatched), the wave-analyzer reads this file. For each task in the current plan:

1. If every step in this task's block is `- [x]`, the task is **done** — skip it.
2. If the first step is `- [ ]` and the rest are also `- [ ]`, the task is **untouched** — dispatch fresh.
3. If the first step is `- [x]` and a later step is `- [ ]`, the task is **partially done** — re-dispatch with the next unchecked step highlighted in the executor's brief.

The executor must therefore flip step checkboxes in order. Skipping ahead is a discipline violation that the wave-analyzer catches and the reviewer subagent flags as `CHANGES`.

## Discipline Rules

- **Never flip a step to `- [x]` without first completing it.** "I'll catch up later" is a pattern that produces false progress and broken resumability.
- **Never edit a phase file from inside `tracking.md` updates.** Phase files are spec. `tracking.md` is state. Keep them separate.
- **Never delete a `- [x]` item.** The audit trail is append-only. If a step needs to be re-done, the executor re-flips it to `- [ ]`, adds a comment in `journal.nav` with the reason, and proceeds.
- **Commit after every step.** `git log` is the second ledger; it survives context loss better than this file does.
