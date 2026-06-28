# Glossary

**Document ID**: 00.3
**Domain**: Foundation
**Status**: Draft

---

## Purpose

Provides canonical definitions for core terms used throughout the ROS documentation. Eliminates ambiguity in discussions by ensuring all contributors share the same vocabulary.

## Audience

- All contributors
- Anyone reading ROS documentation

## Conventions

- **Term**: Single-word or short phrase being defined
- **Definition**: Clear, unambiguous description
- **Context**: Where this term is used or what it relates to
- **Synonyms**: Common alternative terms (to avoid confusion)
- **See Also**: Related terms for further reading

---

## A

### Abstraction Layer
A component that hides implementation details behind a well-defined interface.

**Context**: Used when replacing one component with another (e.g., swapping LLM providers)
**See Also**: [Component Contracts](01-architecture/component-contracts.md)

### ADR (Architecture Decision Record)
A document capturing a significant architectural decision, its context, and rationale.

**Context**: Created when a decision has lasting impact on system design
**See Also**: [ADR Index](01-architecture/adr-index.md)

### Agent
An autonomous component capable of performing a defined task with some degree of self-direction.

**Context**: Differs from a simple function in that agents may make decisions, branch, or iterate
**Synonyms**: Actor, Worker
**See Also**: [Departments](01-architecture/departments.md)

---

## C

### Capability
A distinct, demonstrable function the ROS can perform.

**Context**: The roadmap tracks capabilities, not features
**Example**: "Detect knowledge gaps" is a capability; "gap-detector.py" is an implementation
**See Also**: [Roadmap](05-evolution/roadmap.md)

### Confidence Score
A numerical representation of belief in a claim's accuracy.

**Context**: Tied to evidence strength; ranges from 0.0 (impossible) to 1.0 (certain)
**See Also**: [Evidence Model](04-quality/evidence-model.md), [Scoring Model](04-quality/scoring-model.md)

---

## D

### Department
A functional area of the ROS with defined responsibilities and boundaries.

**Context**: Not a team (which is human), but a logical grouping of capabilities
**Example**: "The Discovery Department handles finding new opportunities"
**See Also**: [Departments](01-architecture/departments.md)

### Discovery
The process of finding new signals, trends, protocols, or opportunities.

**Context**: The first phase of the research loop
**See Also**: [Daily Cycle](03-operations/daily-cycle.md)

---

## E

### Entity
A discrete object in the knowledge graph with a unique identifier and properties.

**Context**: Can be a protocol, project, trend, person, organization, or concept
**Example**: "Ethereum", "Uniswap V4", "Layer 2 scaling"
**See Also**: [Knowledge Model](02-knowledge/knowledge-model.md), [Entity Schemas](02-knowledge/entity-schemas.md)

### Evidence
Information that supports or refutes a claim.

**Context**: Must be traceable to a source; strength determines confidence
**See Also**: [Evidence Model](04-quality/evidence-model.md)

### Evidence Chain
A sequence of linked evidence leading to a conclusion.

**Context**: Enables tracing reasoning backward from conclusions to sources
**See Also**: [Evidence Model](04-quality/evidence-model.md)

---

## G

### Gap (Knowledge Gap)
An area where the knowledge base lacks sufficient information to support confident decisions.

**Context**: Identified by comparing required knowledge against present knowledge
**See Also**: [Gap Detection](04-quality/gap-detection.md)

---

## H

### HITL (Human-in-the-Loop)
A design pattern where humans review, approve, or override system decisions.

**Context**: Required at defined quality gates; not optional
**See Also**: [Human Oversight](07-safety/human-oversight.md)

---

## I

### Intelligence Report
A structured output summarizing research findings.

**Context**: Produced weekly or monthly; includes confidence scores and evidence chains
**See Also**: [Weekly Cycle](03-operations/weekly-cycle.md)

---

## K

### Knowledge Base
The accumulated, structured information maintained by the ROS.

**Context**: Lives in the repository as versioned documents and data files
**See Also**: [Knowledge Model](02-knowledge/knowledge-model.md)

### Knowledge Graph
A graph structure representing entities and their relationships.

**Context**: Enables reasoning about connections between concepts
**See Also**: [Graph Schema](02-knowledge/graph-schema.md)

---

## M

### Mission (Research Mission)
A discrete unit of research work with defined objectives, scope, and acceptance criteria.

**Context**: Created when a gap is identified or an opportunity is discovered
**See Also**: [Mission Lifecycle](03-operations/mission-lifecycle.md)

---

## O

### Opportunity
A potential business opportunity identified in the Web3 ecosystem.

**Context**: Has a confidence score, evidence chain, and priority ranking
**See Also**: [Scoring Model](04-quality/scoring-model.md), [Taxonomy](02-knowledge/taxonomy.md)

---

## Q

### Quality Gate
A checkpoint where artifacts are validated against defined criteria.

**Context**: Knowledge enters the knowledge base only after passing gates
**See Also**: [Quality Gates](04-quality/quality-gates.md)

---

## R

### ROS (Research Operating System)
The autonomous research engine being built by this project.

**Context**: The system's internal name; "the ROS" refers to this software
**See Also**: [Vision](vision.md)

### Signal
A data point or observation that may indicate a trend, opportunity, or threat.

**Context**: Raw signals are processed; only validated signals become evidence
**See Also**: [Daily Cycle](03-operations/daily-cycle.md)

---

## T

### Taxonomy
A hierarchical classification system for categorizing entities and concepts.

**Context**: Provides consistent categorization across the knowledge base
**See Also**: [Taxonomy](02-knowledge/taxonomy.md)

### Trend
A pattern of change in the Web3 ecosystem over time.

**Context**: Distinguished from noise by sustained signal strength
**See Also**: [Scoring Model](04-quality/scoring-model.md)

---

## V

### Validation
The process of verifying that a claim or artifact meets quality criteria.

**Context**: Happens at quality gates before knowledge enters the base
**See Also**: [Evidence Model](04-quality/evidence-model.md), [Quality Gates](04-quality/quality-gates.md)

---

## Dependencies

None. This document is foundational.

## Related Documents

All documents in the documentation hierarchy use these terms.

## Maintenance

This glossary is a living document. Add new terms when:
1. A term is used with a specific meaning that differs from common usage
2. A new concept is introduced that requires definition
3. An existing definition changes significantly

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
