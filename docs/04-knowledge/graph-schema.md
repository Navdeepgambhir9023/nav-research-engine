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
│                              │  Ethereum   │                                │
│                              │  (L1 Node)  │                                │
│                              └──────┬──────┘                                │
│                                     │                                       │
│                    ┌────────────────┼────────────────┐                     │
│                    │                │                │                     │
│                    ▼                ▼                ▼                     │
│             ┌───────────┐   ┌───────────┐   ┌───────────┐                │
│             │  Uniswap  │   │   Aave    │   │  OpenSea  │                │
│             │   (DEX)   │   │ (Lending) │   │   (NFT)   │                │
│             └─────┬─────┘   └─────┬─────┘   └───────────┘                │
│                   │               │                                       │
│                   │               │                                       │
│                   ▼               ▼                                       │
│             ┌─────────────────────────────┐                               │
│             │      integrated-with        │                               │
│             │   (Relationship Edge)        │                               │
│             └─────────────────────────────┘                               │
│                                                                             │
│  Node Types: Protocol, Project, Person, Organization, Concept, Event        │
│  Edge Types: uses, integrates-with, invested-in, founded-by, etc.          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Node Types

### Protocol Node

```yaml
type: protocol
properties:
  - id: URI (unique identifier)
  - name: string
  - category: ProtocolCategory
  - ecosystem: string
  - status: active | paused | deprecated
  - firstSeen: datetime
  - lastUpdated: datetime

labels:
  - protocol
  - {category}  # e.g., dex, lending
  - {ecosystem}  # e.g., ethereum, solana
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
  - type: DAO | VC | Company | Exchange
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
| `version-of` | Version | Protocol | Protocol version history |
| `subcategory-of` | Subcategory | Category | Taxonomy hierarchy |

**Example**: `uniswap-v3 is-a dex`

#### 2. Functional Relationships

| Edge Type | From | To | Description |
|-----------|------|-----|-------------|
| `uses` | Protocol | Dependency | Uses another protocol/service |
| `integrates-with` | Protocol | Protocol | Integrations between protocols |
| `competes-with` | Protocol | Protocol | Direct competitors |
| `powers` | Infrastructure | Application | Enables applications |
| `bridges` | Bridge | Chain | Connects blockchain networks |

**Example**: `uniswap-v3 uses chainlink` (oracle)

#### 3. Temporal Relationships

| Edge Type | From | To | Description |
|-----------|------|-----|-------------|
| `founded-by` | Organization/Protocol | Person | Creator relationship |
| `invested-in` | Investor | Organization/Protocol | Investment relationship |
| `acquired-by` | Entity | Organization | Acquisition |
| `forked-from` | Protocol | Protocol | Fork relationship |
| `launched-on` | Protocol | Ecosystem | Deployment ecosystem |

**Example**: `aave invested-in by: paradigm` (investor on other side)

#### 4. Quantitative Relationships

| Edge Type | From | To | Properties |
|-----------|------|-----|------------|
| `has-tvl` | Protocol | Value | tvl: number, currency: string |
| `raised` | Protocol/Org | Value | amount: number, round: string |
| `users` | Protocol | Count | count: number, source: string |
| `volume` | Protocol | Value | volume: number, period: string |

#### 5. Causal Relationships

| Edge Type | From | To | Description |
|-----------|------|-----|-------------|
| `caused` | Event | Event | Causal chain |
| `resulted-in` | Action | Outcome | Outcome of an action |
| `enabled` | Capability | Opportunity | Enables an opportunity |
| `addresses` | Solution | Problem | Problem solution |
| `solves` | Protocol | Problem | Solves a specific problem |

---

## Relationship Direction Conventions

Graph relationships are **directional** but often have an inverse:

| Relationship | Direction | Inverse |
|--------------|-----------|---------|
| `uses` | Protocol → Dependency | `used-by` |
| `founded-by` | Entity → Person | `founded` |
| `invested-in` | Entity → Investor | `invested` |
| `integrates-with` | Protocol → Protocol | `integrates-with` (symmetric) |
| `competes-with` | Protocol → Protocol | `competes-with` (symmetric) |

**Query Pattern**: Always traverse in both directions when exploring.

---

## Edge Properties

Some edges carry additional data:

```yaml
uses:
  description: Protocol uses another protocol
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
    - dimension: string (ux, tvl, fees, etc.)
```

---

## Graph Query Patterns

### 1. Find Related Entities

```cypher
MATCH (e:protocol {name: "Uniswap"})-[:integrates-with|uses]->(related)
RETURN related
```

### 2. Find Ecosystem

```cypher
MATCH (p:protocol)-[:deployed-on|part-of]->(ecosystem:L1 {name: "Ethereum"})
WHERE p.category = "dex"
RETURN ecosystem, count(p) as protocol_count
ORDER BY protocol_count DESC
```

### 3. Find Investment Chain

```cypher
MATCH (investor:organization)-[:invested-in]->(entity)-[:founded-by]->(founder)
WHERE investor.name = "Paradigm"
RETURN founder, entity, investor
```

### 4. Find Competitors

```cypher
MATCH (p1:protocol)-[:competes-with]-(p2:protocol)
WHERE p1.category = "dex"
RETURN p1, collect(p2.name) as competitors
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
    description: Protocol should not depend on itself directly
    query: MATCH (p)-[:uses*1..5]->(p) RETURN p

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

## Related Documents

- `entity-schemas.md` — Detailed schema definitions
- `scoring-model.md` — Graph-based scoring patterns

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
