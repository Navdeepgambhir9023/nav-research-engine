# Web Research Architecture

**Document ID**: 01.8
**Domain**: Architecture
**Status**: Draft

---

## Purpose

Defines how web search and browse capabilities integrate into the Research OS discovery phase. Establishes the source tracking system that ensures every claim has a traceable provenance back to its origin.

Web research enables the system to:
- Access real-time information beyond training data cutoff
- Verify claims against multiple independent sources
- Maintain evidence chains for quality gates
- Distinguish between confirmed facts and time-sensitive data

---

## Web Research Workflow

### Discovery Phase Integration

Web research operates as a first-class capability within the Discovery department, called when:
- Mission objectives require current market data
- Claims need verification against live sources
- Training data gaps are identified in knowledge gaps
- Time-sensitive opportunities require up-to-date information

```
┌─────────────────────────────────────────────────────────────────┐
│                      DISCOVERY WORKFLOW                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐ │
│  │ Identify │───▶│ Formulate│───▶│  Execute │───▶│ Extract  │ │
│  │  Query   │    │  Search  │    │  Search  │    │ Results  │ │
│  │          │    │   Query  │    │ + Browse │    │          │ │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘ │
│                                          │                    │
│                                          ▼                    │
│                                    ┌──────────┐              │
│                                    │  Source  │              │
│                                    │ Tracking │              │
│                                    └──────────┘              │
│                                          │                    │
│                                          ▼                    │
│                                    ┌──────────┐    ┌───────┐│
│                                    │ Generate │───▶│Signal ││
│                                    │  Signal  │    │Output ││
│                                    └──────────┘    └───────┘│
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Query Formulation

Before executing web research, the system must formulate precise queries:

```typescript
interface WebResearchQuery {
  // Core query
  objective: string;              // What we want to learn
  scope: 'broad' | 'targeted' | 'exhaustive';
  
  // Constraints
  timeRange?: {
    from?: Date;
    to?: Date;
  };
  sourceTypes?: SourceType[];     // news, academic, docs, social
  language?: string[];
  
  // Quality requirements
  minSourceCount: number;         // Minimum independent sources
  requireRecency?: boolean;       // Reject data older than threshold
}

// Source types for filtering
type SourceType = 'news' | 'academic' | 'documentation' | 
                 'social' | 'forums' | 'official' | 'data';
```

---

## Tool Integration Patterns

### Tool Taxonomy

Three primary tools handle web research, each with distinct capabilities:

| Tool | Purpose | Use Case |
|------|---------|----------|
| **Search** | Discover relevant sources | Initial exploration, finding candidates |
| **Browse** | Extract from URLs | Detailed content from identified sources |
| **WebFetch** | Parse structured content | Converting web pages to processable format |

### Search Tool Pattern

```typescript
interface SearchConfig {
  query: string;
  maxResults: number;           // Default: 10
  sourceFilter?: SourceType[];
  dateFilter?: 'day' | 'week' | 'month' | 'year' | 'any';
}

// Example usage
const searchResult = await search({
  query: "DeFi lending protocol TVL trends Q2 2024",
  maxResults: 15,
  dateFilter: 'month',
  sourceFilter: ['news', 'official']
});
```

### Browse Tool Pattern

```typescript
interface BrowseConfig {
  url: string;
  prompt?: string;              // Specific extraction focus
  extractLinks?: boolean;        // Include discovered links
}

// Example usage
const content = await browse({
  url: "https://example.com/protocol-documentation",
  prompt: "Extract TVL figures, user counts, and fee structure"
});
```

### WebFetch Tool Pattern

```typescript
interface WebFetchConfig {
  url: string;
  prompt: string;               // Required: what to extract
}

// Example usage
const extracted = await webFetch({
  url: "https://api.example.com/data",
  prompt: "Parse JSON response for metrics"
});
```

### Tool Selection Heuristics

```
IF objective requires comparing multiple perspectives
  → Use Search first, then Browse multiple sources

IF specific URL is known from prior search
  → Use Browse directly

IF URL returns structured data (JSON, CSV)
  → Use WebFetch with targeted extraction prompt

IF cross-referencing is required
  → Execute Search + Browse in parallel, merge results
```

---

## Real-Time vs Training Data Distinction

### Data Freshness Categories

All information in the knowledge base must be labeled by temporal origin:

| Category | Definition | Label |
|----------|------------|-------|
| **Real-Time** | Fetched from web within current session | `[REALTIME]` |
| **Recent** | Web data fetched within past 7 days | `[RECENT-YYYY-MM-DD]` |
| **Training** | From LLM training corpus | `[TRAINING-CUTOFF]` |
| **Historical** | Web data older than 7 days | `[HISTORICAL-YYYY-MM-DD]` |
| **Unknown** | Source not tracked | `[UNKNOWN-ORIGIN]` |

### Training Data Handling

```typescript
interface TrainingDataMarker {
  marker: '[TRAINING-CUTOFF]';
  cutoffDate: string;           // e.g., "2024-06"
  confidenceModifier: number;   // Typically 0.9 (10% uncertainty)
  caveat: string;               // Human-readable limitation
}

// Example: Training data claim
"[TRAINING-CUTOFF: 2024-06] Ethereum was the largest smart contract 
platform by TVL as of June 2024. This information may be outdated."
```

### Real-Time Data Handling

```typescript
interface RealtimeDataMarker {
  marker: '[REALTIME]';
  accessedAt: string;           // ISO8601
  sourceId: string;             // SRC-XXX reference
  ttlHours: number;             // When to re-verify
}

// Example: Real-time claim
"[REALTIME: 2024-07-12T14:30:00Z, SRC-042] Current ETH price is $3,450.
Source: CoinGecko API. Re-verify after 1 hour."
```

### Freshness Verification

Before using any data point:

```typescript
async function verifyDataFreshness(
  data: KnowledgeClaim
): Promise<FreshnessStatus> {
  const now = new Date();
  const ageHours = (now - data.accessedAt) / (1000 * 60 * 60);
  
  if (data.isRealtime && ageHours > 1) {
    return { status: 'STALE', action: 'REVERIFY' };
  }
  if (data.isRecent && ageHours > 168) { // 7 days
    return { status: 'AGED', action: 'ADD_CAVEAT' };
  }
  if (data.isTrainingData) {
    return { status: 'TRAINING', action: 'ADD_CUTOFF_CAVEAT' };
  }
  
  return { status: 'FRESH', action: 'USE' };
}
```

---

## Source Tracking System

### Source ID Format

Every source receives a unique identifier following the pattern `[SRC-NNN]`:

```typescript
interface SourceId {
  prefix: 'SRC';
  sequence: number;            // 001, 002, ... 999
  fullForm: string;            // SRC-001
  
  // Computed
  zeroPadded: string;         // Always 3 digits minimum
}

// Source registry entry
interface SourceRegistryEntry {
  id: SourceId;
  url: string;
  title: string;
  accessedAt: ISO8601DateTime;
  reliability: ReliabilityRating;
  contentHash?: string;        // SHA256 of fetched content
  domainAuthority?: number;    // 1-100 score
}

type ReliabilityRating = 'high' | 'medium' | 'low' | 'unknown';
```

### Source Metadata Schema

```typescript
interface SourceMetadata {
  // Identity
  sourceId: string;           // SRC-XXX format
  
  // Provenance
  url: string;
  title: string;
  domain: string;
  siteType: 'news' | 'blog' | 'official' | 'forum' | 'social' | 'academic' | 'other';
  
  // Temporal
  publishedAt?: ISO8601DateTime;
  accessedAt: ISO8601DateTime;
  lastVerifiedAt?: ISO8601DateTime;
  
  // Quality
  reliability: ReliabilityRating;
  biasIndicators?: string[];  // e.g., "promotional", "academic", "community"
  
  // Content
  contentType: 'article' | 'data' | 'documentation' | 'api' | 'social' | 'other';
  contentHash: string;         // SHA256 of actual content
  excerpt?: string;            // Key passage used
  
  // Relationships
  usedInClaims: string[];     // Claim IDs that cite this source
  relatedSources?: string[];    // SRC-XXX of related sources
}
```

### Source Registry Storage

Sources are stored in the knowledge base:

```
knowledge/
└── sources/
    ├── registry.json          # Master index
    └── content/
        └── SRC-001.json       # Individual source data
        └── SRC-002.json
        └── ...
```

### Source Registry Master Index

```json
{
  "version": "1.0",
  "lastUpdated": "2024-07-12T14:30:00Z",
  "totalSources": 42,
  "sources": [
    {
      "id": "SRC-001",
      "url": "https://example.com/article",
      "title": "Example Article",
      "accessedAt": "2024-07-12T14:00:00Z",
      "reliability": "high"
    }
  ]
}
```

---

## Citation Style Guide

### Inline Citation Format

All claims must include source citations in the following format:

```
[CLAIM] Bitcoin's market dominance is 52% as of July 2024.
[SRC-001, SRC-002, SRC-003]
```

### Citation Patterns

| Pattern | Usage | Example |
|---------|-------|---------|
| Single source | Direct fact | `BTC is a cryptocurrency [SRC-001]` |
| Multiple sources | Corroborated fact | `TVL increased [SRC-001, SRC-002, SRC-003]` |
| Training data | General knowledge | `Ethereum launched in 2015 [TRAINING-CUTOFF: 2024-06]` |
| Contradicting sources | Conflict notation | `Price is $X [SRC-001] vs $Y [SRC-002]` |

### Evidence Chain Documentation

For complex claims, use the evidence chain format:

```typescript
interface EvidenceChain {
  claim: string;
  confidence: number;           // 0.0 - 1.0
  sources: SourceCitation[];
  synthesis: string;           // How sources were reconciled
}

interface SourceCitation {
  sourceId: string;           // SRC-XXX
  relevance: number;           // 0.0 - 1.0, how directly it supports claim
  excerpt: string;             // Specific passage used
  contradicts?: boolean;       // True if this source contradicts the claim
}

// Example evidence chain
{
  "claim": "Protocol X has $500M TVL",
  "confidence": 0.85,
  "sources": [
    {
      "sourceId": "SRC-042",
      "relevance": 0.95,
      "excerpt": "TVL: $500.2M as of July 12, 2024",
      "contradicts": false
    },
    {
      "sourceId": "SRC-043",
      "relevance": 0.90,
      "excerpt": "Total value locked stands at $498M",
      "contradicts": false
    }
  ],
  "synthesis": "Two sources within 0.5% agreement. Confidence weighted toward DeFiLlama (higher authority)."
}
```

### Confidence Calculation from Sources

```typescript
function calculateSourceConfidence(
  sources: SourceCitation[]
): ConfidenceScore {
  // More sources = higher confidence (diminishing returns)
  const sourceMultiplier = Math.min(1 + (sources.length - 1) * 0.1, 1.5);
  
  // Average relevance
  const avgRelevance = sources.reduce((sum, s) => sum + s.relevance, 0) 
                       / sources.length;
  
  // Check for contradictions
  const hasContradiction = sources.some(s => s.contradicts);
  const contradictionPenalty = hasContradiction ? 0.3 : 0;
  
  // Calculate final confidence
  const confidence = Math.max(0, Math.min(1, 
    avgRelevance * sourceMultiplier - contradictionPenalty
  ));
  
  return {
    value: confidence,
    sourceCount: sources.length,
    hasContradiction
  };
}
```

---

## Tool Configuration

### Default Configuration

```typescript
const WEB_RESEARCH_CONFIG = {
  // Search defaults
  search: {
    maxResults: 10,
    defaultDateFilter: 'month',
    minSourceCount: 2,          // Minimum for VERIFIED status
    requireMultipleSources: true
  },
  
  // Browse defaults
  browse: {
    timeoutMs: 30000,
    maxContentLength: 50000,
    extractLinks: true
  },
  
  // Freshness thresholds
  freshness: {
    realtimeThresholdHours: 1,
    recentThresholdDays: 7,
    trainingCutoffDate: '2024-06'
  },
  
  // Reliability defaults
  reliability: {
    defaultRating: 'unknown',
    highAuthorityMin: 70,
    sourceFreshnessBonus: 0.1
  }
};
```

### Rate Limiting

Web research tools respect rate limits to avoid source blocking:

```typescript
const RATE_LIMITS = {
  search: {
    maxRequestsPerMinute: 20,
    burstLimit: 5
  },
  browse: {
    maxRequestsPerMinute: 60,
    concurrentLimit: 3
  }
};
```

---

## Dependencies

- `component-contracts.md` — Interfaces this layer implements
- `verification-layer.md` — Cross-referencing and conflict handling
- `knowledge-model.md` — Signal and Evidence structures

## Related Documents

- `verification-layer.md` — How claims are validated against sources
- `quality-gates.md` — Quality requirements for source tracking
- `execution-layer.md` — Runtime integration points

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-07-12 | Initial draft |
