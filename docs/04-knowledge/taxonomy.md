# Taxonomy

**Document ID**: 02.3
**Domain**: Knowledge
**Status**: Draft

---

## Purpose

Defines the hierarchical classification system used to categorize entities, opportunities, and concepts consistently across the knowledge base.

## Audience

- Researchers (for consistent tagging)
- Analysts (for classification queries)
- Engineers (for implementing categorization)

## Design Principles

1. **Exhaustive**: Every entity should fit somewhere
2. **Mutually Exclusive**: Categories should not overlap significantly
3. **Clearly Defined**: Each category has an unambiguous definition
4. **Extensible**: New categories can be added without breaking existing ones
5. **Stable**: Core categories should rarely change

---

## Domain-Specific Taxonomies

Core taxonomy categories are domain-agnostic. Domain-specific categories are defined in:

- `domains/<domain>/taxonomy.md`

This document defines the core hierarchical structure that applies across all domains.

---

## Core Entity Classification Hierarchy

```
Entity
├── Solution
│   ├── Product
│   │   ├── Platform
│   │   ├── Service
│   │   └── Tool
│   ├── Infrastructure
│   │   ├── Foundation
│   │   ├── Middleware
│   │   └── Connector
│   └── Application
│
├── Project
│   ├── Implementation
│   ├── Tooling
│   └── Research
│
├── Organization
│   ├── Company
│   ├── Fund / Investor
│   ├── Exchange
│   └── Service Provider
│
├── Person
│   ├── Founder
│   ├── Developer
│   ├── Investor
│   └── Researcher
│
├── Concept
│   ├── Mechanism
│   ├── Standard
│   ├── Pattern
│   └── Theory
│
├── Event
│   ├── Launch
│   ├── Incident
│   ├── Governance
│   ├── Funding
│   └── Partnership
│
├── Opportunity
│   ├── Market Entry
│   ├── Integration
│   ├── Partnership
│   ├── Investment
│   └── Acquisition
│
├── Trend
│   ├── Technology
│   ├── Market
│   ├── Regulatory
│   └── Social
│
└── Threat
    ├── Technical Risk
    ├── Market Risk
    ├── Regulatory Risk
    └── Competitive Risk
```

---

## Generic Solution Categories

These categories are domain-agnostic. Domain-specific subcategories are defined in `domains/<domain>/taxonomy.md`.

### By Solution Type

| Category | Definition | Examples |
|----------|-----------|----------|
| **Platform** | Comprehensive solutions enabling multiple use cases | Operating systems, marketplaces |
| **Service** | Offerings that provide value to customers | SaaS, consulting |
| **Tool** | Specialized solutions for specific tasks | Utilities, development tools |

### By Layer

| Category | Definition | Examples |
|----------|-----------|----------|
| **Foundation** | Base infrastructure or core technology | Databases, protocols |
| **Middleware** | Solutions connecting components | APIs, integration layers |
| **Connector** | Solutions enabling interoperability | Bridges, adapters |

---

## Generic Organization Categories

| Category | Definition | Examples |
|----------|-----------|----------|
| **Company** | Business entities providing products/services | Corporations, startups |
| **Fund / Investor** | Financial backers and investors | VC funds, angel investors |
| **Exchange** | Platforms for trading or exchange | Marketplaces, trading venues |
| **Service Provider** | Entities providing specialized services | Agencies, consultancies |

---

## Opportunity Classification

### By Type

| Type | Definition |
|------|------------|
| **Market Entry** | Entering a new market or vertical |
| **Integration** | Integrating with existing solutions |
| **Partnership** | Strategic partnerships or collaborations |
| **Investment** | Investment opportunities |
| **Acquisition** | Acquiring or merging with other entities |
| **Product Extension** | Extending existing products |
| **Geographic** | Expanding to new geographies |
| **User Segment** | Targeting new user demographics |

### By Phase

| Phase | Definition |
|-------|------------|
| **Emerging** | Early stage, high uncertainty, high potential |
| **Growing** | Active growth, increasing adoption |
| **Mature** | Established market, stable growth |
| **Declining** | Market contracting or losing relevance |

### By Confidence

| Level | Score Range | Definition |
|-------|-------------|------------|
| **Certain** | 0.95 - 1.00 | Very high confidence |
| **High** | 0.80 - 0.94 | High confidence based on evidence |
| **Medium** | 0.60 - 0.79 | Moderate confidence |
| **Low** | 0.40 - 0.59 | Low confidence, needs validation |
| **Speculative** | 0.20 - 0.39 | Hypothesis, highly uncertain |
| **Rejected** | 0.00 - 0.19 | Evidence suggests this is unlikely |

---

## Trend Classification

### By Type

| Type | Definition |
|------|------------|
| **Technology** | Technical innovations and improvements |
| **Market** | Market dynamics and economic shifts |
| **Regulatory** | Legal and regulatory developments |
| **Social** | Cultural and community trends |

### By Impact

| Impact | Definition |
|--------|------------|
| **Transformative** | Will fundamentally change the landscape |
| **Significant** | Will have notable effects |
| **Moderate** | Worth monitoring but not game-changing |
| **Minor** | Marginal impact |

### By Timeframe

| Timeframe | Definition |
|-----------|------------|
| **Immediate** | Effect within 0-3 months |
| **Short-term** | Effect within 3-12 months |
| **Medium-term** | Effect within 1-3 years |
| **Long-term** | Effect beyond 3 years |

---

## Tag Taxonomy

For flexible categorization beyond hierarchical classification:

### Status Tags

```
status:active
status:paused
status:deprecated
status:acquired
status:merged
```

### Quality Tags

```
quality:verified
quality:high-confidence
quality:needs-validation
quality:disputed
```

### Priority Tags

```
priority:critical
priority:high
priority:medium
priority:low
```

### Domain Tags

```
domain:<domain-name>
```

---

## Classification Guidelines

### Rules for Classifying Entities

1. **Primary Classification**: Every entity has one primary classification
2. **Secondary Classifications**: Entities can have multiple secondary tags
3. **Specificity**: Prefer specific categories over general ones
4. **Consistency**: Use the same classification across similar entities
5. **Review**: Classifications should be reviewed during quality gates

### Classification Examples

| Entity | Primary Type | Secondary Tags |
|--------|--------------|----------------|
| Acme Platform | Solution > Product > Platform | domain:enterprise, status:active |
| Beta Service | Solution > Product > Service | domain:saas, status:active |
| Gamma Company | Organization > Company | domain:tech, status:active |
| Delta Fund | Organization > Fund / Investor | focus:early-stage |
| Tech Innovation | Event > Launch | impact:significant, timeframe:short-term |

---

## Dependencies

- `knowledge-model.md` — Conceptual foundation
- `entity-schemas.md` — Schema definitions for categories
- `scoring-model.md` — Opportunity scoring methodology
- `domain-config.md` — Domain taxonomy extension mechanism

## Related Documents

- `gap-detection.md` — Detecting gaps in coverage
- `evidence-model.md` — Evidence for classifications

## Maintenance

Review taxonomy quarterly for:
- New categories needed
- Deprecated categories
- Ambiguous definitions
- Classification drift

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.2.0 | 2026-07-12 | Abstracted for multi-domain use |
| 0.1.0 | 2026-06-29 | Initial draft |
