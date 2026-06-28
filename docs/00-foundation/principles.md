# Design Principles

**Document ID**: 00.2
**Domain**: Foundation
**Status**: Draft

---

## Purpose

Establishes the non-negotiable design axioms that guide all architectural decisions. When contributors disagree, these principles serve as the tiebreaker.

## Audience

- System architects
- Engineers implementing features
- Contributors making design decisions

## Principles

### 1. Modularity

> Every component should be replaceable without affecting the rest of the system.

**Implications**:
- Components communicate through well-defined interfaces (see `01-architecture/component-contracts.md`)
- No hidden dependencies between modules
- Each module has a single, well-defined responsibility
- Components can be developed, tested, and deployed independently

**Rationale**: Long-term maintainability requires that the system can evolve piece by piece without cascading rewrites.

---

### 2. Composability

> Complex behaviors emerge from composing simple, well-defined components.

**Implications**:
- Prefer small, focused components over large, monolithic ones
- Design components to be combined in unexpected ways
- Avoid special-casing in component logic; solve problems at the composition layer

**Rationale**: A composable system is extensible without modification to existing code.

---

### 3. Determinism

> Given the same inputs and system state, the system should produce the same outputs.

**Implications**:
- Avoid reliance on timing, randomness, or external services for core logic
- Make operations idempotent where possible
- Log all non-deterministic inputs (LLM responses, external API results)
- Design for reproducibility

**Rationale**: Non-deterministic systems are impossible to debug and fail silently in production.

---

### 4. Replaceability

> Any component can be replaced with a better implementation without changing the system around it.

**Implications**:
- All external-facing functionality goes through abstractions
- Database schemas, API contracts, and data formats are versioned
- Prefer interface-based design over implementation inheritance
- Deprecate components gracefully before removal

**Rationale**: The Web3 ecosystem evolves rapidly; the system must adapt without rewriting.

---

### 5. Version Control

> All knowledge, decisions, and code are versioned. Nothing is lost.

**Implications**:
- Git is the source of truth for all artifacts
- Knowledge base changes are tracked as commits
- Architecture decisions are recorded as ADRs (see `05-evolution/decisions/`)
- The evolution of any entity is traceable

**Rationale**: A research system without history is a system without accountability.

---

### 6. Repository First

> The repository itself is the primary product. Code serves the repository, not the reverse.

**Implications**:
- All research outputs are committed to the repository
- The knowledge base lives in the repository, not an external database
- CI/CD validates knowledge quality, not just code quality
- The repository's evolution is the measure of progress

**Rationale**: This inverts the typical software development model to match the project's long-term objectives.

---

### 7. Evidence Driven

> Every claim is traceable to verifiable evidence. Opinions are labeled as such.

**Implications**:
- All conclusions cite sources
- Confidence scores are tied to evidence strength (see `04-quality/evidence-model.md`)
- Speculation is explicitly marked and tracked separately from validated knowledge
- Quality gates reject claims without sufficient evidence

**Rationale**: Research credibility depends on distinguishability between facts and interpretations.

---

### 8. Human-in-the-Loop

> Humans are informed decision-makers, not rubber-stamps.

**Implications**:
- Critical decisions require human review
- The system surfaces evidence, not just conclusions
- Human decisions are recorded and influence future behavior
- Automation augments human judgment, not replaces it

**Rationale**: Autonomy without oversight produces systems that optimize for the wrong objectives.

---

### 9. Knowledge First

> Knowledge representation precedes knowledge processing.

**Implications**:
- Define what you know before defining how you learn
- Knowledge schemas are stable; learning algorithms may change
- The knowledge graph is a first-class citizen, not an afterthought
- Query patterns drive schema design

**Rationale**: Building intelligence on poorly defined data produces expensive rewrites.

---

### 10. Long-Term Maintainability

> Design decisions are evaluated by their impact on the system in 5+ years.

**Implications**:
- Prefer explicit over implicit
- Prefer simple over clever
- Prefer boring technology when it suffices
- Document the "why" behind decisions (see ADR process in `05-evolution/`)

**Rationale**: Research systems are long-lived investments. Technical debt compounds.

---

## Dependencies

- `vision.md` — These principles operationalize the vision

## Related Documents

- `glossary.md` — Terms used in these principles
- `01-architecture/component-contracts.md` — How modularity is implemented
- `04-quality/evidence-model.md` — How evidence-driven is operationalized

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
