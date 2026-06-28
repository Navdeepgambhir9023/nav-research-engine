# System Context

**Document ID**: 01.1
**Domain**: Architecture
**Status**: Draft

---

## Purpose

Shows the Research Operating System (ROS) in its environment—external systems, data flows, and boundaries. Helps readers understand what is inside the ROS versus what is outside.

## Audience

- All contributors (to understand scope)
- Architects (for boundary decisions)
- Reviewers (for evaluating integration decisions)

## Context Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        EXTERNAL ENVIRONMENT                                  │
│                                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    │
│  │   Web3     │    │   LLM       │    │  Consumer   │    │   Manual   │    │
│  │   Data     │    │   Providers │    │   Studies   │    │   Review   │    │
│  │   Sources  │    │   (Gemini)  │    │ (Consumr.ai)│    │   (HITL)   │    │
│  └──────┬──────┘    └──────┬──────┘    └──────┬──────┘    └──────┬──────┘    │
│         │                  │                  │                  │           │
└─────────┼──────────────────┼──────────────────┼──────────────────┼───────────┘
          │                  │                  │                  │
          ▼                  ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           INTEGRATION LAYER                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌────��────────┐   │
│  │ Web3 APIs  │    │  Gemini     │    │ Consumr.ai  │    │  Human     │   │
│  │  Adapter   │    │  Contract   │    │  Contract   │    │  Interface  │   │
│  └──────┬─────┘    └──────┬─────┘    └──────┬─────┘    └──────┬─────┘    │
└─────────┼──────────────────┼──────────────────┼──────────────────┼──────────┘
          │                  │                  │                  │
          ▼                  ▼                  ▼                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        RESEARCH OPERATING SYSTEM                            │
│                                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐   │
│  │  Discovery  │    │  Analysis   │    │  Planning   │    │ Validation │   │
│  │ Department  │───▶│ Department  │───▶│ Department  │───▶│ Department │   │
│  └─────────────┘    └─────────────┘    └─────────────┘    └──────┬─────┘   │
│         │                                                            │       │
│         │         ┌─────────────────────────────────────┐           │       │
│         │         │                                     │           │       │
│         │         ▼                                     ▼           ▼       │
│         │    ┌─────────────────────────────────────────────────────────┐    │
│         └───▶│                    KNOWLEDGE BASE                      │◄───┘
│              │                                                         │    │
│              │  ┌───────────┐  ┌───────────┐  ┌───────────┐           │    │
│              │  │ Entities  │  │  Graph    │  │ Evidence  │           │    │
│              │  │ (Protocols│  │ (Relations│  │  Chains   │           │    │
│              │  │  Projects) │  │           │  │           │           │    │
│              │  └───────────┘  └───────────┘  └───────────┘           │    │
│              └─────────────────────────────────────────────────────────┘    │
│                                │                                           │
│                                ▼                                           │
│              ┌─────────────────────────────────────────────┐              │
│              │            OUTPUT PRODUCTS                  │              │
│              │  • Weekly Intelligence Reports              │              │
│              │  • Opportunity Rankings                      │              │
│              │  • Research Missions                        │              │
│              │  • Knowledge Exports                        │              │
│              └─────────────────────────────────────────────┘              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## System Boundaries

### Inside the ROS

The ROS owns and maintains:

1. **Knowledge Base**: All structured knowledge, entity schemas, and the knowledge graph
2. **Department Logic**: The four core departments (Discovery, Analysis, Planning, Validation)
3. **Quality Systems**: Evidence validation, scoring, and quality gates
4. **State Machine**: The research loop and mission lifecycle
5. **Operations Procedures**: Daily/weekly cycles and runbooks

### Outside the ROS

The ROS consumes but does not own:

1. **Web3 Data Sources**: Blockchain data, protocol information, market data
2. **LLM Providers**: Gemini API and any future AI providers
3. **Consumer Studies**: Consumr.ai and similar research platforms
4. **Human Reviewers**: Subject matter experts who provide judgment
5. **Output Consumers**: Leadership, analysts, and external systems that use ROS outputs

### Integration Contracts

Every external dependency uses a formal contract (see `06-integration/`):

| External System | Contract Document | Data Direction |
|----------------|-------------------|----------------|
| Web3 APIs | `06-integration/web3-apis.md` | In |
| Gemini | `06-integration/gemini-contract.md` | In/Out |
| Consumr.ai | `06-integration/consumr-ai-contract.md` | In |
| Human Review | `07-safety/human-oversight.md` | In/Out |

## Key Responsibilities

### The ROS Is Responsible For

- Maintaining knowledge base integrity
- Ensuring evidence quality before incorporation
- Managing the research lifecycle
- Producing structured, auditable outputs
- Detecting and surfacing knowledge gaps

### The ROS Is NOT Responsible For

- Generating raw Web3 data (sources do this)
- Providing AI reasoning (providers do this)
- Making final business decisions (humans do this)
- Storing knowledge outside the repository

## Trust Boundaries

```
Trust Level: HIGH (ROS owns)  │  Trust Level: MEDIUM (Contracts)  │  Trust Level: LOW (External)
─────────────────────────────│──────────────────────────────────────│─────────────────────────────
Knowledge Base               │  Integration Adapters               │  External APIs
Department Logic             │  LLM Prompt Generation               │  Consumer Studies
Quality Gates                │  Data Transformation                 │  Human Input
State Machine                │  Output Formatting                   │  Output Consumers
```

## Dependencies

- `00-foundation/vision.md` — Establishes what the system is
- `00-foundation/glossary.md` — Defines terms used here
- `06-integration/integration-overview.md` — Maps all external integrations

## Related Documents

- `departments.md` — Detailed department responsibilities
- `state-machine.md` — How the system moves between states
- `component-contracts.md` — Interfaces between components

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
