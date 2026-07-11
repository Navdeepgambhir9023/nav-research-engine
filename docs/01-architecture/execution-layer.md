# Execution Layer

**Document ID**: 01-architecture.6
**Domain**: Architecture
**Status**: Draft

---

## 1. Purpose

The Execution Layer is the orchestration substrate that coordinates subagents and workflows to produce research artifacts. It does not perform research itself—rather, it orchestrates the agents that do.

This document defines:
1. The responsibilities and boundaries of the execution layer
2. The subagent/workflow pattern for research orchestration
3. Harness integration for cross-platform execution
4. The coordination model that enables multi-domain research

---

## 2. Responsibilities

### 2.1 What the Execution Layer Does

The Execution Layer is responsible for:

- **Mission Orchestration**: Determines which subagents to invoke and in what sequence
- **Input Preparation**: Prepares context, domain configuration, and user input for subagents
- **Output Aggregation**: Collects and validates artifacts from subagents
- **State Coordination**: Manages checkpointing and resumability across subagent invocations
- **Harness Abstraction**: Provides a consistent interface across different LLM harnesses (Claude Code, Gemini CLI, Codex)

### 2.2 What the Execution Layer Does NOT Do

The Execution Layer explicitly does not:

- Perform research or analysis (subagents do this)
- Generate domain-specific knowledge (subagents do this)
- Make business decisions (humans do this)
- Store knowledge outside the repository (the knowledge base does this)
- Execute arbitrary code or commands (the shell layer does this)

### 2.3 Inputs

The Execution Layer receives these inputs to begin orchestration:

```yaml
execution_inputs:
  query:
    type: string
    description: The user's research question or task

  domain_config:
    type: DomainConfig
    description: Domain-specific configuration (prompts, templates, entity schemas)

  user_context:
    type: UserContext
    description: User preferences, history, and constraints

  mission_id:
    type: string
    description: Unique identifier for this mission

  available_models:
    type: List[ModelCapability]
    description: Models available in the current harness
```

### 2.4 Outputs

The Execution Layer produces these outputs per the Output Contract:

```yaml
execution_outputs:
  artifacts:
    type: List[Artifact]
    description: Research artifacts per runtime/specifications/output-contract.md

  mission_state:
    type: MissionState
    description: Updated mission status and checkpoint

  execution_log:
    type: ExecutionLog
    description: Audit trail of subagent invocations
```

---

## 3. Subagent Architecture

### 3.1 The Four Subagent Pattern

Research execution follows a four-stage subagent pattern. Each subagent has a distinct role:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        SUBAGENT ORCHESTRATION                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌──────────────┐     ┌──────────────┐     ┌──────────────┐             │
│   │  DISCOVERY   │────▶│   ANALYSIS   │────▶│  VALIDATION  │             │
│   │   Subagent   │     │   Subagent   │     │   Subagent   │             │
│   └──────────────┘     └──────────────┘     └──────┬───────┘             │
│          │                                        │                        │
│          │                                        ▼                        │
│          │                               ┌──────────────┐                  │
│          │                               │  SYNTHESIS   │                  │
│          │                               │   Subagent   │                  │
│          │                               └──────────────┘                  │
│          │                                       │                         │
│          ▼                                       ▼                         │
│   ┌──────────────────────────────────────────────────────────┐             │
│   │                    KNOWLEDGE BASE                        │             │
│   └──────────────────────────────────────────────────────────┘             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Discovery Subagent

**Role**: Find signals and raw information relevant to the research query.

**Responsibilities**:
- Search external data sources for relevant signals
- Collect initial information based on domain configuration
- Deduplicate and classify signals by relevance
- Score signals by priority

**Inputs**:
- Research query
- Domain configuration (data sources, search parameters)
- Existing knowledge context

**Outputs**:
- Signal inventory (List[Signal])
- Source health report
- Priority-sorted signal queue

**Execution Model**:
- May invoke multiple search operations in parallel
- Applies deduplication against existing knowledge
- Emits `SignalsCollected` event

### 3.3 Analysis Subagent

**Role**: Transform signals into enriched insights with evidence chains.

**Responsibilities**:
- Cross-reference signals with existing knowledge
- Build evidence chains for each insight
- Identify knowledge gaps
- Assign confidence scores with rationale

**Inputs**:
- Signal inventory from Discovery
- Knowledge graph snapshot
- Entity schemas for validation
- Knowledge gaps from previous cycles

**Outputs**:
- Insights with evidence chains
- Gap coverage report
- Confidence scores per insight

**Execution Model**:
- Processes signals sequentially or in batches (configurable)
- Validates each insight against entity schemas
- Emits `InsightGenerated` and `EvidenceAssembled` events

### 3.4 Validation Subagent

**Role**: Verify insights meet quality standards before synthesis.

**Responsibilities**:
- Run quality gates on each insight
- Check evidence sufficiency
- Verify consistency with existing knowledge
- Route low-confidence items to human review queue

**Inputs**:
- Insights from Analysis
- Quality gates configuration
- Evidence chains
- Existing knowledge for consistency checking

**Outputs**:
- Validated insights
- Quality report
- Human review queue (if applicable)
- Rejected items with rationale

**Execution Model**:
- Applies all configured quality gates
- Emits `ValidationPassed` or `ValidationFailed` per item
- Routes to human review when confidence below threshold

### 3.5 Synthesis Subagent

**Role**: Produce the final research output artifact.

**Responsibilities**:
- Aggregate validated insights into coherent output
- Generate hypotheses from insights
- Identify opportunities based on research
- Format output per output contract

**Inputs**:
- Validated insights
- Quality report
- Mission definition (objective, scope, success criteria)
- Output contract template

**Outputs**:
- Research report (per output contract section 3.3)
- Hypotheses (per output contract section 3.5)
- Opportunities (per output contract section 3.6)
- Knowledge delta (entities extracted)

**Execution Model**:
- Produces deterministic output from validated inputs
- Follows output contract exactly
- Emits `MissionCompleted` and `ArtifactGenerated` events

---

## 4. Harness Integration

### 4.1 The Harness Abstraction

The Execution Layer is harness-agnostic. It operates through an abstraction layer that adapts to the current LLM harness:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        HARNESS ABSTRACTION LAYER                            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │                    Execution Layer (Platform-Independent)            │  │
│   │                                                                     │  │
│   │   - Mission orchestration                                          │  │
│   │   - Subagent coordination                                          │  │
│   │   - State management                                               │  │
│   │   - Output validation                                             │  │
│   │                                                                     │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                    │                                        │
│                                    ▼                                        │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │                    Harness Adapter (Platform-Specific)              │  │
│   │                                                                     │  │
│   │   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐               │  │
│   │   │  Claude    │  │   Gemini    │  │   Codex     │               │  │
│   │   │  Adapter   │  │   Adapter   │  │   Adapter   │               │  │
│   │   └─────────────┘  └─────────────┘  └─────────────┘               │  │
│   │                                                                     │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4.2 Claude Code Integration

**Entry Point**: `/research` command (also `/nav:research` when installed as plugin)

**Subagent Dispatch**:
- Uses Claude Code's subagent/Worktree capability for parallel execution
- Each subagent runs in an isolated worktree context
- Parent agent coordinates subagent outputs

**Configuration**:
```yaml
harness:
  name: claude-code
  subagent_pattern: worktree
  parallel_execution: true
  max_concurrent_subagents: 4
```

**Adapter Implementation**:
- Detects Claude Code environment via `CLAUDE_PROJECT_DIR`
- Uses `Bash` tool for worktree creation/management
- Uses `TaskCreate`/`TaskUpdate` for subagent coordination

### 4.3 Gemini CLI Integration

**Entry Point**: `gemini research` command pattern

**Workflow Dispatch**:
- Uses Gemini's workflow/multi-turn capability for sequential stages
- Each stage produces output that feeds the next
- Workflow definitions stored in `runtime/harnesses/gemini/`

**Configuration**:
```yaml
harness:
  name: gemini-cli
  workflow_pattern: sequential_stages
  parallel_execution: false
```

**Adapter Implementation**:
- Detects Gemini CLI via `gemini` command availability
- Uses workflow file format for stage definitions
- Coordinates via shared filesystem state

### 4.4 Codex Integration

**Entry Point**: `codex research` command pattern

**Agent Dispatch**:
- Uses Codex's agent/task capability for research delegation
- Main agent spawns child agents for each subagent
- Coordinates via agent message passing

**Configuration**:
```yaml
harness:
  name: codex
  agent_pattern: hierarchical
  parallel_execution: true
  max_child_agents: 4
```

**Adapter Implementation**:
- Detects Codex via `codex` command availability
- Uses agent task creation for subagent invocation
- Coordinates via agent communication protocol

### 4.5 Harness Detection

The Execution Layer detects the current harness at startup:

```bash
detect_harness() {
    if command -v claude &> /dev/null; then
        echo "claude-code"
    elif command -v gemini &> /dev/null; then
        echo "gemini-cli"
    elif command -v codex &> /dev/null; then
        echo "codex"
    else
        echo "unknown"
    fi
}
```

---

## 5. Coordination Model

### 5.1 Sequential Orchestration

The default coordination model runs subagents sequentially:

```
Discovery → Analysis → Validation → Synthesis
```

Each subagent completes fully before the next begins. This ensures:
- Deterministic output (same inputs produce same outputs)
- Clear dependency chains
- Easy debugging and tracing

### 5.2 Parallel Orchestration

For independent research streams, subagents can run in parallel:

```
┌──────────────────┐     ┌──────────────────┐
│  Discovery-A    │     │  Discovery-B    │
└────────┬────────┘     └────────┬────────┘
         │                         │
         ▼                         ▼
┌──────────────────┐     ┌──────────────────┐
│  Analysis-A     │     │  Analysis-B     │
└────────┬────────┘     └────────┬────────┘
         │                         │
         └──────────┬──────────────┘
                    ▼
           ┌─────────────────┐
           │  Synthesis     │
           └─────────────────┘
```

Parallel execution is configured per domain:

```yaml
domain_config:
  orchestration:
    mode: parallel | sequential
    max_parallel: 4
    dependencies:
      - from: Discovery
        to: Analysis
      - from: [Analysis, Validation]
        to: Synthesis
```

### 5.3 State Coordination

Subagents coordinate via shared state files:

```
runtime/state/
├── execution/
│   ├── {mission_id}/
│   │   ├── discovery-signals.json
│   │   ├── analysis-insights.json
│   │   ├── validation-report.json
│   │   └── synthesis-output.json
│   └── checkpoint.json
└── loop-state.json
```

Each subagent:
1. Reads its input from the shared state
2. Writes its output to the shared state
3. Updates the checkpoint

### 5.4 Error Handling

When a subagent fails:

```
1. Log failure with context (subagent, mission_id, error)
2. Check retry policy:
   - If retries remaining → re-invoke subagent
   - If no retries → mark mission as failed
3. Emit SubagentFailed event
4. Await human decision if configured
5. Continue or halt based on decision
```

---

## 6. Multi-Domain Execution

### 6.1 Domain-Specific Adapters

Each domain can have specialized subagent implementations:

```
runtime/domains/{domain}/
├── adapters/
│   ├── discovery-adapter.sh      # Domain-specific discovery
│   ├── analysis-adapter.sh        # Domain-specific analysis
│   └── synthesis-adapter.sh       # Domain-specific synthesis
├── templates/
│   ├── discovery-prompt.md
│   ├── analysis-prompt.md
│   └── synthesis-prompt.md
└── config.yaml
```

### 6.2 Domain Loading

The Execution Layer loads domain configuration at mission start:

```
Load Domain Config:
1. Check for domain config in runtime/domains/{domain}/
2. If exists → use domain-specific adapters and templates
3. If not exists → use default adapters and templates
4. Log which configuration is active
```

### 6.3 Cross-Domain Research

For research spanning multiple domains:

```
1. Parse query to identify domains
2. Create one mission per domain
3. Execute each mission independently
4. Aggregate results in synthesis phase
5. Produce unified output artifact
```

---

## 7. Configuration Reference

### 7.1 Execution Configuration

```yaml
execution:
  mode: sequential | parallel | adaptive
  timeout:
    default: 30m
    per_subagent:
      discovery: 10m
      analysis: 15m
      validation: 5m
      synthesis: 10m
  retry_policy:
    max_retries: 2
    backoff: exponential
  checkpoint_frequency: after_each_subagent
```

### 7.2 Harness Configuration

```yaml
harnesses:
  claude-code:
    worktree_dir: .claude/worktrees
    max_worktrees: 4
  gemini-cli:
    workflow_dir: runtime/harnesses/gemini/workflows
    output_dir: artifacts
  codex:
    agent_timeout: 30m
    max_agents: 4
```

---

## 8. Dependencies

- `runtime/specifications/output-contract.md` — Artifact definitions
- `runtime/state/` — State management
- `runtime/commands/research.sh` — Entry point command
- `docs/02-engine/research-loop.md` — Loop engine context
- `docs/02-engine/state-manager.md` — State coordination

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-07-12 | Initial specification |
