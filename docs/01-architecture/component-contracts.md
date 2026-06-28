# Component Contracts

**Document ID**: 01.4
**Domain**: Architecture
**Status**: Draft

---

## Purpose

Specifies the interfaces between major components and departments. Enables independent development, testing, and replacement of parts by ensuring well-defined contracts.

## Audience

- Engineers implementing components
- Architects defining system boundaries
- QA writing integration tests

## Contract Philosophy

Contracts are:
- **Explicit**: All inputs, outputs, and side effects are documented
- **Versioned**: Breaking changes require version bumps
- **Validated**: Contracts include schema validation rules
- **Stable**: Contracts change slower than implementations

---

## Department Contracts

### Discovery → Analysis Contract

**Envelope**: `Signal`

```typescript
interface Signal {
  // Identity
  id: string;                    // UUID
  type: SignalType;              // opportunity | threat | trend | data
  source: SourceReference[];      // Provenance chain
  
  // Content
  title: string;                 // Human-readable summary
  description: string;           // Detailed description
  rawData: Record<string, any>;  // Original data from source
  
  // Classification
  tags: string[];                // Taxonomy tags
  priority: 'low' | 'medium' | 'high' | 'critical';
  
  // Temporal
  detectedAt: ISO8601DateTime;
  expiresAt?: ISO8601DateTime;  // Optional TTL
  
  // Quality
  confidence: number;             // 0.0 - 1.0
  confidenceRationale: string;   // Why this confidence level
}

interface SourceReference {
  type: 'api' | 'scrape' | 'study' | 'manual';
  sourceId: string;
  retrievedAt: ISO8601DateTime;
  url?: string;
  checksum?: string;
}
```

---

### Analysis → Planning Contract

**Envelope**: `Insight`

```typescript
interface Insight {
  // Identity
  id: string;
  derivedFrom: string[];         // Signal IDs used
  
  // Content
  summary: string;               // One-paragraph summary
  findings: Finding[];            // Specific findings
  implications: string[];        // What this means
  
  // Evidence
  evidenceChain: Evidence[];
  confidence: ConfidenceScore;
  
  // Classification
  opportunityScore?: OpportunityScore;  // If applicable
  relatedEntities: string[];     // Entity IDs from knowledge base
  
  // Gaps
  knowledgeGaps: KnowledgeGap[]; // What we still need
  
  // Metadata
  generatedAt: ISO8601DateTime;
  modelVersion: string;          // LLM model used
}

interface ConfidenceScore {
  value: number;                // 0.0 - 1.0
  factors: ConfidenceFactor[];   // What influenced this
}

interface ConfidenceFactor {
  factor: string;
  contribution: number;          // +/- impact on confidence
  evidence: string[];            // Supporting evidence IDs
}
```

---

### Planning → Validation Contract

**Envelope**: `Mission`

```typescript
interface Mission {
  // Identity
  id: string;
  status: MissionStatus;
  createdAt: ISO8601DateTime;
  
  // Definition
  title: string;
  description: string;
  objectives: MissionObjective[];
  scope: MissionScope;
  
  // Resources
  estimatedEffort: Duration;
  requiredCapabilities: Capability[];
  priority: Priority;
  
  // Relationships
  addressesGaps: string[];      // KnowledgeGap IDs
  relatedSignals: string[];      // Signal IDs
  relatedEntities: string[];     // Entity IDs
  
  // Execution tracking
  assignedTo?: string;           // Agent or human
  checkpoint?: string;            // Current checkpoint
  progress: number;               // 0.0 - 1.0
  
  // Outputs
  results?: MissionResults;
  reviewStatus?: ReviewStatus;
}

interface MissionObjective {
  id: string;
  description: string;
  acceptanceCriteria: string[];
  completed: boolean;
}
```

---

### Validation → Knowledge Base Contract

**Envelope**: `ValidatedEntity`

```typescript
interface ValidatedEntity {
  // Identity
  id: string;
  entityType: EntityType;
  version: number;
  previousVersion?: string;     // For tracking changes
  
  // Content
  name: string;
  description: string;
  properties: Record<string, any>;
  
  // Provenance
  validatedBy: string;           // Validation agent ID
  validatedAt: ISO8601DateTime;
  evidenceReferences: string[];
  
  // Quality
  confidence: number;
  qualityScore: number;          // 0.0 - 1.0
  
  // Relationships
  relationships: Relationship[];
  
  // Lifecycle
  status: 'active' | 'deprecated' | 'merged' | 'deleted';
  effectiveFrom: ISO8601DateTime;
  effectiveUntil?: ISO8601DateTime;
}

interface Relationship {
  type: RelationshipType;
  targetId: string;
  targetType: EntityType;
  weight: number;               // 0.0 - 1.0
  bidirectional: boolean;
}
```

---

## Service Contracts

### LLM Service Contract

**Interface**: `ILlmService`

```typescript
interface ILlmService {
  // Core operations
  generate(prompt: LlmPrompt): Promise<LlmResponse>;
  generateStream(prompt: LlmPrompt): AsyncIterable<string>;
  
  // Management
  getModelInfo(): ModelInfo;
  estimateTokens(input: string): number;
  estimateCost(prompt: LlmPrompt): CostEstimate;
}

interface LlmPrompt {
  system: string;                 // System instructions
  user: string;                  // User content
  temperature?: number;          // 0.0 - 2.0
  maxTokens?: number;
  stopSequences?: string[];
}

interface LlmResponse {
  content: string;
  usage: TokenUsage;
  model: string;
  finishReason: 'stop' | 'length' | 'content_filter' | 'error';
}

interface TokenUsage {
  promptTokens: number;
  completionTokens: number;
  totalTokens: number;
}
```

---

### Knowledge Store Contract

**Interface**: `IKnowledgeStore`

```typescript
interface IKnowledgeStore {
  // Entity operations
  create(entity: ValidatedEntity): Promise<string>;  // Returns ID
  read(id: string): Promise<ValidatedEntity | null>;
  update(id: string, entity: Partial<ValidatedEntity>): Promise<void>;
  delete(id: string): Promise<void>;
  
  // Query operations
  query(query: KnowledgeQuery): Promise<QueryResult[]>;
  search(term: string, options?: SearchOptions): Promise<SearchResult[]>;
  
  // Graph operations
  getNeighbors(id: string, options?: NeighborOptions): Promise<Entity[]>;
  getPath(fromId: string, toId: string): Promise<Path | null>;
  
  // Batch operations
  batchCreate(entities: ValidatedEntity[]): Promise<string[]>;
  batchUpdate(updates: UpdateRequest[]): Promise<void>;
}

interface KnowledgeQuery {
  filters: Filter[];
  relations?: RelationFilter[];
  pagination?: Pagination;
  sort?: Sort[];
}

interface SearchOptions {
  limit?: number;
  offset?: number;
  fields?: string[];             // Which fields to search
  boost?: Record<string, number>;  // Field weights
}
```

---

## Contract Versioning

### Versioning Strategy

Contracts use semantic versioning with major version bumps for breaking changes:

```
ContractVersion: 1.2.3
              │ │ └── Patch: backward-compatible additions
              │ └──── Minor: backward-compatible changes
              └────── Major: breaking changes
```

### Compatibility Rules

| Change Type | Compatible? | Action Required |
|------------|-------------|----------------|
| Add optional field | Yes | None |
| Add required field | No | Major version bump |
| Remove field | No | Major version bump + deprecation |
| Change field type | No | Major version bump |
| Add new enum value | Yes* | Mark as non-exhaustive |
| Remove enum value | No | Major version bump + deprecation |

*Code should handle unknown enum values gracefully.

---

## Dependencies

- `departments.md` — Departments this contract connects
- `entity-schemas.md` — JSON Schema definitions for types
- `graph-schema.md` — Relationship types

## Related Documents

- `data-flows.md` — How data moves across contracts
- `state-machine.md` — State transitions that trigger contract calls

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
