# Data Flows

**Document ID**: 01.5
**Domain**: Architecture
**Status**: Draft

---

## Purpose

Describes how information moves through the ROS—from external sources through departments to outputs. Critical for understanding performance characteristics, debugging, and data provenance.

## Audience

- Engineers (for implementation)
- Data engineers (for pipeline optimization)
- QA (for data lineage testing)

## Data Flow Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              EXTERNAL DATA                                  │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐      │
│  │Web3 APIs│  │Social   │  │News     │  │Consumr  │  │Human    │      │
│  │         │  │Media    │  │Sources  │  │Studies  │  │Experts  │      │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘      │
└───────┼─────────────┼─────────────┼─────────────┼─────────────┼───────────┘
        │             │             │             │             │
        ▼             ▼             ▼             ▼             ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          INGESTION LAYER                                    │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    Source Adapters                                   │   │
│  │   ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐    │   │
│  │   │ Web3    │ │ Social  │ │  News   │ │ Consumr │ │ Human   │    │   │
│  │   │ Adapter │ │ Adapter │ │ Adapter │ │ Adapter │ │ Adapter │    │   │
│  │   └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘    │   │
│  └────────┼───────────┼───────────┼───────────┼───────────┼─────────────┘   │
└───────────┼───────────┼───────────┼───────────┼───────────┼──────────────────┘
            │           │           │           │           │
            ▼           ▼           ▼           ▼           ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                        NORMALIZATION LAYER                                  │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐               │   │
│  │  │   Schema    │  │  Canonical  │  │  Provenance │               │   │
│  │  │  Validation │──▶│   Format    │──▶│  Tracking   │               │   │
│  │  └─────────────┘  └─────────────┘  └──────┬──────┘               │   │
│  └────────────────────────────────────────────┼────────────────────────┘   │
└─────────────────────────────────────────────┼──────────────────────────────┘
                                              │
                                              ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                       DEPARTMENT PROCESSING                                 │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        DISCOVERY DEPARTMENT                          │   │
│  │   Input: Raw signals from normalization                              │   │
│  │   Processing: Deduplication, classification, priority scoring        │   │
│  │   Output: Enriched signals with provenance                           │   │
│  │   ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐             │   │
│  │   │Dedup    │──▶│Classify │──▶│Score    │──▶│Publish  │             │   │
│  │   │Engine   │  │Pipeline │  │Engine   │  │Signals  │             │   │
│  │   └─────────┘  └─────────┘  └─────────┘  └────┬────┘             │   │
│  └─────────────────────────────────────────────────┼───────────────────┘   │
│                                                    │                       │
│                                                    ▼                       │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        ANALYSIS DEPARTMENT                           │   │
│  │   Input: Enriched signals from Discovery                             │   │
│  │   Processing: Contextualization, evidence assembly, insight gen       │   │
│  │   Output: Insights with confidence scores and evidence chains        │   │
│  │   ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐               │   │
│  │   │Context  │──▶│Evidence │──▶│LLM      │──▶│Insight  │            │   │
│  │   │Builder  │  │Assembler│  │Synthesis│  │Formatter│              │   │
│  │   └─────────┘  └─────────┘  └─────────┘  └────┬────┘               │   │
│  └─────────────────────────────────────────────────┼───────────────────┘   │
│                                                    │                       │
│                                                    ▼                       │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        PLANNING DEPARTMENT                           │   │
│  │   Input: Insights from Analysis                                      │   │
│  │   Processing: Opportunity scoring, mission creation, resource alloc  │   │
│  │   Output: Mission queue with priorities                              │   │
│  │   ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐             │   │
│  │   │Opport.  │──▶│Mission  │──▶│Resource │──▶│Queue    │            │   │
│  │   │Scorer   │  │Generator│  │Allocator│  │Manager  │              │   │
│  │   └─────────┘  └─────────┘  └─────────┘  └────┬────┘               │   │
│  └─────────────────────────────────────────────────┼───────────────────┘   │
│                                                    │                       │
│                                                    ▼                       │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                       VALIDATION DEPARTMENT                          │   │
│  │   Input: Mission outputs and insights                                │   │
│  │   Processing: Quality gates, consistency checks, human review       │   │
│  │   Output: Validated knowledge ready for incorporation               │   │
│  │   ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐             │   │
│  │   │Quality  │──▶│Consist. │──▶│Human    │──▶│Approval │             │   │
│  │   │Gates    │  │Checker  │  │Review    │  │Engine   │              │   │
│  │   └─────────┘  └─────────┘  └─────────┘  └────┬────┘               │   │
│  └─────────────────────────────────────────────────┼───────────────────┘   │
│                                                    │                       │
└────────────────────────────────────────────────────┼───────────────────────┘
                                                     │
                                                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          KNOWLEDGE BASE                                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │
│  │  Entities   │  │   Graph     │  │  Evidence   │  │  Missions   │      │
│  │   Store     │  │   Store     │  │   Store     │  │   Archive   │      │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘      │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                       OUTPUT GENERATION                              │   │
│  │   ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐             │   │
│  │   │Daily    │  │Weekly   │  │Monthly  │  │On-Demand │             │   │
│  │   │Summary  │  │Report   │  │Report   │  │Query    │              │   │
│  │   └─────────┘  └─────────┘  └─────────┘  └─────────┘             │   │
│  └────────────────────────────────────────────────────────��────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Key Data Flows

### Flow 1: Signal Ingestion

```
Source API → Adapter → Normalizer → Signal Store → Discovery
```

**Characteristics**:
- Latency: Near real-time (minutes)
- Volume: High (continuous stream)
- Error handling: Retry with backoff, dead letter queue

### Flow 2: Insight Generation

```
Signals → Analysis (LLM) → Insight Store → Planning
```

**Characteristics**:
- Latency: Variable (minutes to hours)
- Volume: Medium (bounded by signal rate)
- Error handling: Validation, manual review on failure

### Flow 3: Knowledge Incorporation

```
Mission Output → Validation Gates → Knowledge Base
```

**Characteristics**:
- Latency: Minutes (with potential human review delay)
- Volume: Low (only validated outputs)
- Error handling: Strict quality gates, rejection tracking

### Flow 4: Report Generation

```
Knowledge Base → Query Engine → Report Formatter → Output
```

**Characteristics**:
- Latency: Seconds to minutes
- Volume: Low (per-request)
- Error handling: Fallback to cached reports

---

## Data Volume Estimates

| Flow | Daily Volume | Storage Growth | Retention |
|------|-------------|----------------|-----------|
| Raw Signals | ~10,000 | ~100 MB/day | 30 days |
| Processed Signals | ~1,000 | ~10 MB/day | 90 days |
| Insights | ~100 | ~5 MB/day | 1 year |
| Validated Knowledge | ~10-50 | ~1 MB/day | Indefinite |
| Evidence Chains | ~500 | ~20 MB/day | 1 year |

---

## Data Ownership

| Data Type | Owner | Readers |
|-----------|-------|---------|
| Raw Signals | Discovery | Analysis, Archive |
| Processed Signals | Discovery | Analysis, Reporting |
| Insights | Analysis | Planning, Validation, Reporting |
| Missions | Planning | Validation, Operations |
| Validated Knowledge | Validation | All Departments |
| Evidence | All Departments | Validation, Reporting |

---

## Dependencies

- `departments.md` — Department boundaries
- `state-machine.md` — When flows are triggered
- `entity-schemas.md` — Data format contracts

## Related Documents

- `component-contracts.md` — Technical interfaces
- `03-operations/daily-cycle.md` — Daily flow execution

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
