# Integration Overview

**Document ID**: 06.1
**Domain**: Integration
**Status**: Draft

---

## Purpose

Provides a high-level map of all external integrations—data sources, AI providers, and consumer research platforms. Shows the extensibility surface and helps contributors understand how the ROS connects to the outside world.

## Audience

- Architects (for design)
- Engineers (for implementation)
- Contributors (for understanding)

## Integration Philosophy

> Integrations are contracts, not implementations. Each integration defines what data flows in and out, without dictating how the data is processed.

Key principles:
1. **Loose coupling**: Integrations communicate through well-defined contracts
2. **Fail-safe defaults**: System continues if integration fails
3. **Explicit boundaries**: Clear data ownership and transformation
4. **Versioning**: Contracts are versioned independently

---

## Integration Map

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     INTEGRATION ARCHITECTURE                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                          ┌───────────────┐                                 │
│                          │   RESEARCH    │                                 │
│                          │   OPERATING   │                                 │
│                          │   SYSTEM      │                                 │
│                          └───────┬───────┘                                 │
│                                  │                                          │
│      ┌──────────────────────────┼──────────────────────────┐             │
│      │                          │                          │             │
│      ▼                          ▼                          ▼             │
│ ┌─────────────┐         ┌─────────────┐         ┌─────────────┐        │
│ │   DATA      │         │     AI      │         │  RESEARCH   │        │
│ │   INGEST    │         │   PROVIDER  │         │   PLATFORM  │        │
│ └──────┬──────┘         └──────┬──────┘         └──────┬──────┘        │
│        │                        │                        │                │
│        ▼                        ▼                        ▼                │
│ ┌─────────────┐         ┌─────────────┐         ┌─────────────┐        │
│ │  Web3 APIs │         │   Gemini    │         │  Consumr.ai │        │
│ │             │         │             │         │             │        │
│ └──────┬──────┘         └─────────────┘         └─────────────┘        │
│        │                                                                   │
│        ▼                                                                   │
│ ┌─────────────────────────────────────────────────────────────────────┐   │
│ │                        EXTERNAL DATA SOURCES                         │   │
│ │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐     │   │
│ │  │On-Chain │ │DeFi     │ │News &   │ │Social   │ │Market   │     │   │
│ │  │Data     │ │Aggregat.│ │Research │ │Media    │ │Data     │     │   │
│ │  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘     │   │
│ └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Integration Categories

### Category 1: Data Ingestion

Sources that provide data to the ROS.

| Integration | Purpose | Data Type | Priority |
|-------------|---------|-----------|----------|
| **On-Chain Data** | Blockchain activity | Transactions, contracts, events | Critical |
| **DeFi Aggregators** | DeFi protocol data | TVL, volume, yields | Critical |
| **News Sources** | Industry news | Articles, announcements | High |
| **Social Media** | Community signals | Sentiment, trends | Medium |
| **Market Data** | Price and volume | Market data | Medium |

### Category 2: AI Processing

LLM providers for research synthesis.

| Integration | Purpose | Data Flow | Priority |
|-------------|---------|-----------|----------|
| **Gemini** | Research synthesis | In/Out | Critical |

### Category 3: Research Platforms

Platforms that provide consumer or market research.

| Integration | Purpose | Data Flow | Priority |
|-------------|---------|-----------|----------|
| **Consumr.ai** | Consumer studies | In | High |

### Category 4: Output Destinations

Systems that receive ROS outputs.

| Integration | Purpose | Data Flow | Priority |
|-------------|---------|-----------|----------|
| **Intelligence Reports** | Stakeholder delivery | Out | Critical |
| **Dashboards** | Monitoring | Out | High |
| **Alerts** | Notifications | Out | High |

---

## Data Flow Summary

### Ingestion Flow

```
External Source → Adapter → Normalizer → Discovery Department
```

| Source | Adapter | Data Format | Frequency |
|--------|---------|-------------|-----------|
| On-chain (The Graph) | `web3-adapter` | JSON | Real-time |
| DeFi Llama | `defi-adapter` | JSON | Hourly |
| News API | `news-adapter` | JSON | Hourly |
| Twitter/X | `social-adapter` | JSON | Real-time |

### Processing Flow

```
Discovery → Analysis (LLM) → Planning → Validation → Knowledge Base
```

### Output Flow

```
Knowledge Base → Report Generator → Intelligence Reports
                    ↓
               Dashboards
                    ↓
               Alerts
```

---

## Integration Contracts

Each integration has a contract defining:

```yaml
contract:
  name: string           # Integration name
  version: semver        # Contract version
  direction: in | out | both
  
  # Data contract
  data:
    input_format: string   # Expected input format
    output_format: string  # Output format
    schema: uri           # JSON Schema reference
    
  # Operational
  operations:
    frequency: string     # polling interval
    timeout: duration     # Request timeout
    retry_policy: object  # Retry configuration
    
  # Quality
  quality:
    freshness_requirement: duration  # Max data age
    completeness_requirement: float  # Min completeness
    accuracy_tracking: boolean      # Track accuracy
    
  # Monitoring
  monitoring:
    health_check_endpoint: string
    metrics: [string]      # Metrics to track
```

---

## Integration Status

| Integration | Status | Contract | Implementation |
|------------|--------|----------|----------------|
| Web3 APIs (The Graph) | Contract Only | 06.4 | Pending |
| Gemini | Contract Only | 06.2 | Pending |
| Consumr.ai | Contract Only | 06.3 | Pending |
| News Sources | Planned | TBD | Pending |
| Social Media | Planned | TBD | Pending |

---

## Adding New Integrations

### Process

1. **Define Contract** (in `06-integration/`)
   - Document data format
   - Define operations
   - Specify quality requirements

2. **Implement Adapter** (in `src/adapters/`)
   - Create adapter class
   - Implement contract interface
   - Add error handling

3. **Add Monitoring** (in `src/monitoring/`)
   - Health check
   - Metrics
   - Alerts

4. **Document** (in `06-integration/`)
   - Usage examples
   - Troubleshooting
   - Limitations

### Checklist

```
□ Contract document created
□ Contract reviewed and approved
□ Adapter implemented
□ Adapter tests written
□ Health check implemented
□ Metrics integrated
□ Error handling complete
□ Documentation updated
□ Integration tested end-to-end
```

---

## Dependencies

- `01-architecture/system-context.md` — System boundaries
- `01-architecture/component-contracts.md` — Interface definitions

## Related Documents

- `06-integration/gemini-contract.md` — Gemini integration
- `06-integration/consumr-ai-contract.md` — Consumr.ai integration
- `06-integration/web3-apis.md` — Web3 data integration

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
