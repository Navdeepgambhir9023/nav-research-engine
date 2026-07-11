# Graph Schema

**Document ID**: 02.4
**Domain**: Knowledge
**Status**: Draft

---

## Purpose

Defines the structure of the knowledge graph—nodes, edge types, and relationship semantics. Enables graph-based reasoning and queries across the knowledge base.

## Audience

- Engineers implementing graph storage
- Data scientists writing graph queries
- Analysts exploring entity relationships

## Graph Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          KNOWLEDGE GRAPH                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                              ┌─────────────┐                                │
│                              │   Market    │                                │
│                              │  (Root)    │                                │
│                              └──────┬──────┘                                │
│                                     │                                       │
│                    ┌────────────────┼────────────────┐                     │
│                    │                │                │                     │
│                    ▼                ▼                ▼                     │
│             ┌───────────┐   ┌───────────┐   ┌───────────┐               │
│             │ Solution A │   │ Solution B │   │ Solution C │               │
│             │(Platform)  │   │ (Service)  │   │   (Tool)   │               │
│             └─────┬─────┘   └─────┬─────┘   └───────────┘               │
│                   │               │                                       │
│                   │               │                                       │
│                   ▼               ▼                                       │
│             ┌─────────────────────────────┐                              │
│             │        integrates-with        │                              │
│             │      (Relationship Edge)      │                              │
│             └─────────────────────────────┘                              │
│                                                                             │
│  Node Types: Solution, Project, Person, Organization, Concept, Event          │
│  Edge Types: uses, integrates-with, invested-in, founded-by, etc.           │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Node Types

### Solution Node

```yaml
type: solution
properties:
  - id: URI (unique identifier)
  - name: string
  - category: SolutionCategory
  - ecosystem: string (optional)
  - status: active | paused | deprecated
  - firstSeen: datetime
  - lastUpdated: datetime

labels:
  - solution
  - {category}  # e.g., platform, service, tool
```

### Person Node

```yaml
type: person
properties:
  - id: URI
  - name: string
  - role: string
  - affiliation: URI (to organization)
  - bio: text

labels:
  - person
  - {role}  # e.g., founder, developer, investor
```

### Organization Node

```yaml
type: organization
properties:
  - id: URI
  - name: string
  - type: Company | Fund | Exchange | ServiceProvider
  - founded: date

labels:
  - organization
  - {type}
```

---

## Edge Types

### Relationship Categories

#### 1. Hierarchical Relationships

| Edge Type | From | To | Description |
|-----------|------|-----|-------------|
| `is-a` | Instance | Category | Classification relationship |
| `part-of` | Component | Whole | Structural containment |
| `version-of` | Version | Solution | Solution version history |
| `subcategory-of` | Subcategory | Category | Taxonomy hierarchy |

**Example**: `acme-platform is-a platform`

#### 2. Functional Relationships

| Edge Type | From | To | Description |
|-----------|------|-----|-------------|
| `uses` | Solution | Dependency | Uses another solution/service |
| `integrates-with` | Solution | Solution | Integrations between solutions |
| `competes-with` | Solution | Solution | Direct competitors |
| `powers` | Infrastructure | Application | Enables applications |
| `connects` | Connector | System | Connects systems |

**Example**: `acme-platform uses external-api` (integration)

#### 3. Temporal Relationships

| Edge Type | From | To | Description |
|-----------|------|-----|-------------|
| `founded-by` | Organization/Solution | Person | Creator relationship |
| `invested-in` | Investor | Organization/Solution | Investment relationship |
| `acquired-by` | Entity | Organization | Acquisition |
| `derived-from` | Solution | Solution | Fork or derivation relationship |
| `launched-on` | Solution | Platform | Deployment platform |

**Example**: `acme-platform invested-in by: investor-abc`

#### 4. Quantitative Relationships

| Edge Type | From | To | Properties |
|-----------|------|-----|------------|
| `has-metric` | Solution | Value | metric: string, value: number |
| `raised` | Solution/Org | Value | amount: number, round: string |
| `users` | Solution | Count | count: number, source: string |
| `revenue` | Solution | Value | amount: number, period: string |

#### 5. Causal Relationships

| Edge Type | From | To | Description |
|-----------|------|-----|-------------|
| `caused` | Event | Event | Causal chain |
| `resulted-in` | Action | Outcome | Outcome of an action |
| `enables` | Capability | Opportunity | Enables an opportunity |
| `addresses` | Solution | Problem | Problem solution |
| `solves` | Solution | Problem | Solves a specific problem |

---

## Relationship Direction Conventions

Graph relationships are **directional** but often have an inverse:

| Relationship | Direction | Inverse |
|--------------|-----------|---------|
| `uses` | Solution → Dependency | `used-by` |
| `founded-by` | Entity → Person | `founded` |
| `invested-in` | Entity → Investor | `invested` |
| `integrates-with` | Solution → Solution | `integrates-with` (symmetric) |
| `competes-with` | Solution → Solution | `competes-with` (symmetric) |

**Query Pattern**: Always traverse in both directions when exploring.

---

## Edge Properties

Some edges carry additional data:

```yaml
uses:
  description: Solution uses another solution or dependency
  properties:
    - since: datetime (when the relationship started)
    - confidence: number (0-1)
    - source: string (evidence source)

invested-in:
  description: Investor put capital into entity
  properties:
    - amount: number
    - currency: string
    - round: string (seed, series-a, etc.)
    - date: datetime
    - source: string

competes-with:
  description: Direct competitive relationship
  properties:
    - strength: low | medium | high
    - dimension: string (features, price, etc.)
```

---

## Graph Query Patterns

### 1. Find Related Entities

```cypher
MATCH (e:solution {name: "Acme Platform"})-[:integrates-with|uses]->(related)
RETURN related
```

### 2. Find Market Solutions

```cypher
MATCH (s:solution)-[:part-of]->(market {name: "Enterprise Software"})
WHERE s.category = "platform"
RETURN market, count(s) as solution_count
ORDER BY solution_count DESC
```

### 3. Find Investment Chain

```cypher
MATCH (investor:organization)-[:invested-in]->(entity)-[:founded-by]->(founder)
WHERE investor.name = "Example Fund"
RETURN founder, entity, investor
```

### 4. Find Competitors

```cypher
MATCH (s1:solution)-[:competes-with]-(s2:solution)
WHERE s1.category = "platform"
RETURN s1, collect(s2.name) as competitors
```

### 5. Find Opportunity Paths

```cypher
MATCH (capability:concept)-[:enables]->(opp:opportunity)
MATCH (opp)-[:addresses]->(problem)-[:part-of]->(market)
WHERE opp.confidence > 0.7
RETURN market, problem, opp, capability
```

---

## Graph Quality Rules

### Validation Rules

1. **No Orphan Nodes**: Every node should have at least one relationship
2. **No Self-Loops**: Nodes should not reference themselves (except symmetric relationships)
3. **Type Consistency**: Edges must connect valid node types
4. **Temporal Validity**: Historical relationships should have dates
5. **Bidirectional Sync**: Symmetric edges must be created in both directions

### Consistency Checks

```yaml
checks:
  - name: duplicate_entities
    description: No two entities should represent the same real-world object
    query: MATCH (e1), (e2) WHERE e1.id <> e2.id AND e1.name = e2.name RETURN e1, e2

  - name: circular_dependencies
    description: Solution should not depend on itself directly
    query: MATCH (s)-[:uses*1..5]->(s) RETURN s

  - name: missing_provenance
    description: All relationships should have source evidence
    query: MATCH ()-[r]->() WHERE r.source IS NULL RETURN r
```

---

## Graph Storage Recommendations

### Technology Options

| Option | Best For | Trade-offs |
|--------|----------|------------|
| **Neo4j** | Complex traversals, graph algorithms | Requires separate storage |
| **PostgreSQL + extensions** | Simple graphs, existing infra | Limited graph features |
| **NetworkX (in-memory)** | Prototyping, small graphs | Not persistent |
| **Knowledge Graph DB** | Native graph support | Additional infrastructure |

### Recommended: Hybrid Approach

- **Primary Storage**: Files in repository (Markdown/JSON) for versioning
- **Graph Index**: Lightweight graph database for traversals
- **Sync**: Automated sync between file storage and graph index

---

## Dependencies

- `knowledge-model.md` — Conceptual knowledge model
- `entity-schemas.md` — Node type definitions
- `domain-config.md` — Domain-specific graph extensions

## Related Documents

- `entity-schemas.md` — Detailed schema definitions
- `scoring-model.md` — Graph-based scoring patterns

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.2.0 | 2026-07-12 | Abstracted for multi-domain use |
| 0.1.0 | 2026-06-29 | Initial draft |
