# Verification Layer

**Document ID**: 01.9
**Domain**: Architecture
**Status**: Draft

---

## Purpose

Defines the verification workflow for validating knowledge claims against web sources. Establishes consensus detection, conflict resolution, and verification status determination to ensure the knowledge base contains only claims that meet the honesty standards.

The verification layer ensures:
- Every claim is traceable to one or more sources
- Source agreement is detected and quantified
- Source conflicts are surfaced honestly, not papered over
- Verification status accurately reflects claim reliability

---

## Cross-Reference Workflow

### Overview

Before any claim enters the knowledge base, it must pass through the verification layer:

```
┌─────────────────────────────────────────────────────────────────┐
│                    VERIFICATION WORKFLOW                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────┐    ┌──────────────┐    ┌──────────────┐         │
│  │ Claim    │───▶│ Source       │───▶│ Cross-       │         │
│  │ Submitted│    │ Collection   │    │ Reference    │         │
│  └──────────┘    └──────────────┘    └──────┬───────┘         │
│                                              │                   │
│                                              ▼                   │
│  ┌──────────┐    ┌──────────────┐    ┌──────────────┐         │
│  │ Verified │◀───│ Consensus    │◀───│ Conflict     │         │
│  │ Output   │    │ Detection    │    │ Analysis     │         │
│  └──────────┘    └──────────────┘    └──────────────┘         │
│                                                                 │
└─��───────────────────────────────────────────────────────────────┘
```

### Step 1: Source Collection

For each claim, the system collects multiple independent sources:

```typescript
interface SourceCollection {
  claim: string;
  collectedSources: SourceMetadata[];
  collectionStrategy: 'single' | 'multi' | 'exhaustive';
  
  // Constraints
  minSources: number;              // Default: 2 for VERIFIED
  maxSources: number;              // Default: 10
  sourceTypeDiversity?: boolean;   // Require different source types
}

async function collectSources(claim: string): Promise<SourceCollection> {
  const searchQuery = formulateVerificationQuery(claim);
  const searchResults = await search(searchQuery);
  
  const sources = await Promise.all(
    searchResults.slice(0, 10).map(result => browse(result.url))
  );
  
  return {
    claim,
    collectedSources: sources,
    collectionStrategy: sources.length >= 3 ? 'exhaustive' : 'multi',
    minSources: 2,
    maxSources: 10
  };
}
```

### Step 2: Cross-Reference Analysis

Each collected source is analyzed for claim support:

```typescript
interface CrossReference {
  sourceId: string;
  claim: string;
  
  // Analysis
  supports: boolean;
  contradicts: boolean;
  neutral: boolean;
  
  // Evidence
  relevantExcerpts: string[];
  relevanceScore: number;          // 0.0 - 1.0
  
  // Source quality
  sourceReliability: ReliabilityRating;
  sourceRecency: DateComparison;
}

interface DateComparison {
  isCurrent: boolean;             // Within 7 days
  isRecent: boolean;              // Within 90 days
  ageDays: number;
}

async function crossReference(
  claim: string,
  sources: SourceMetadata[]
): Promise<CrossReference[]> {
  const references: CrossReference[] = [];
  
  for (const source of sources) {
    const content = await fetchSourceContent(source);
    const analysis = analyzeClaimSupport(claim, content);
    
    references.push({
      sourceId: source.id,
      claim,
      supports: analysis.supports,
      contradicts: analysis.contradicts,
      neutral: analysis.neutral,
      relevantExcerpts: analysis.excerpts,
      relevanceScore: analysis.score,
      sourceReliability: source.reliability,
      sourceRecency: calculateRecency(source.accessedAt)
    });
  }
  
  return references;
}
```

### Step 3: Evidence Synthesis

References are synthesized into a verification determination:

```typescript
interface VerificationSynthesis {
  claim: string;
  
  // Source counts
  supportingSources: string[];
  contradictingSources: string[];
  neutralSources: string[];
  
  // Analysis
  consensusLevel: ConsensusLevel;
  conflictLevel: ConflictLevel;
  
  // Output
  verificationStatus: VerificationStatus;
  confidenceScore: number;        // 0.0 - 1.0
  statusRationale: string;
}

type ConsensusLevel = 'strong' | 'moderate' | 'weak' | 'none';
type ConflictLevel = 'none' | 'minor' | 'significant' | 'major';

function synthesizeVerification(
  references: CrossReference[]
): VerificationSynthesis {
  const supporting = references.filter(r => r.supports);
  const contradicting = references.filter(r => r.contradicts);
  const neutral = references.filter(r => r.neutral);
  
  // Calculate consensus
  const consensusLevel = calculateConsensusLevel(supporting.length, references.length);
  
  // Calculate conflict
  const conflictLevel = calculateConflictLevel(contradicting.length, references.length);
  
  // Determine status
  let verificationStatus: VerificationStatus;
  let statusRationale: string;
  
  if (contradicting.length > 0 && supporting.length === 0) {
    verificationStatus = 'CONFLICTING';
    statusRationale = 'All sources contradict the claim';
  } else if (contradicting.length > 0) {
    verificationStatus = 'CONFLICTING';
    statusRationale = `${contradicting.length} sources contradict, ${supporting.length} support`;
  } else if (supporting.length >= 2) {
    verificationStatus = 'VERIFIED';
    statusRationale = `${supporting.length} independent sources support the claim`;
  } else if (supporting.length === 1) {
    verificationStatus = 'PARTIALLY_VERIFIED';
    statusRationale = 'Single supporting source; additional verification recommended';
  } else {
    verificationStatus = 'UNVERIFIED';
    statusRationale = 'No sources directly support or contradict the claim';
  }
  
  return {
    claim: references[0]?.claim || '',
    supportingSources: supporting.map(s => s.sourceId),
    contradictingSources: contradicting.map(s => s.sourceId),
    neutralSources: neutral.map(s => s.sourceId),
    consensusLevel,
    conflictLevel,
    verificationStatus,
    confidenceScore: calculateConfidence(references),
    statusRationale
  };
}
```

---

## Consensus Detection

### Consensus Thresholds

Consensus is detected when multiple independent sources agree on a claim:

| Threshold | Description | Status |
|-----------|-------------|--------|
| **3+ sources** | Strong consensus | VERIFIED (high confidence) |
| **2 sources** | Moderate consensus | VERIFIED |
| **1 source** | Single source | PARTIALLY_VERIFIED |
| **0 sources** | No evidence | UNVERIFIED |

### Consensus Calculation

```typescript
interface ConsensusMetrics {
  agreementRatio: number;          // supporting / total relevant
  independenceScore: number;       // 0.0 - 1.0, penalize shared origins
  recencyWeightedScore: number;    // More recent sources weighted higher
  
  // Final assessment
  consensusLevel: ConsensusLevel;
  meetsThreshold: boolean;
}

function calculateConsensus(
  references: CrossReference[]
): ConsensusMetrics {
  const relevant = references.filter(r => !r.neutral);
  
  if (relevant.length === 0) {
    return {
      agreementRatio: 0,
      independenceScore: 0,
      recencyWeightedScore: 0,
      consensusLevel: 'none',
      meetsThreshold: false
    };
  }
  
  const supporting = relevant.filter(r => r.supports);
  const agreementRatio = supporting.length / relevant.length;
  
  // Penalize sources from same domain/author
  const independenceScore = calculateIndependence(relevant);
  
  // Weight recent sources higher
  const recencyWeightedScore = calculateRecencyWeightedScore(relevant);
  
  // Determine consensus level
  let consensusLevel: ConsensusLevel;
  if (agreementRatio >= 0.8 && supporting.length >= 3) {
    consensusLevel = 'strong';
  } else if (agreementRatio >= 0.6 && supporting.length >= 2) {
    consensusLevel = 'moderate';
  } else if (agreementRatio >= 0.3) {
    consensusLevel = 'weak';
  } else {
    consensusLevel = 'none';
  }
  
  return {
    agreementRatio,
    independenceScore,
    recencyWeightedScore,
    consensusLevel,
    meetsThreshold: supporting.length >= 2
  };
}
```

### Independence Scoring

Sources from the same domain, author, or publication are penalized:

```typescript
function calculateIndependence(references: CrossReference[]): number {
  if (references.length <= 1) return 1.0;
  
  let penalty = 0;
  const domains = references.map(r => extractDomain(r.sourceId));
  const uniqueDomains = new Set(domains);
  
  // Penalize for duplicate domains
  penalty += (domains.length - uniqueDomains.size) * 0.2;
  
  // Penalize for temporal clustering (all sources published same day)
  const publicationDates = references.map(r => r.publishedAt);
  if (allSameDay(publicationDates)) {
    penalty += 0.3;
  }
  
  return Math.max(0, 1 - penalty);
}
```

### Recency Weighting

More recent sources are weighted higher in consensus calculation:

```typescript
function calculateRecencyWeightedScore(references: CrossReference[]): number {
  const now = new Date();
  const weights = references.map(r => {
    const ageDays = (now.getTime() - r.publishedAt.getTime()) / (1000 * 60 * 60 * 24);
    
    // Exponential decay: newest sources have highest weight
    // 0 days = 1.0, 7 days = 0.7, 30 days = 0.5, 90 days = 0.3
    const weight = Math.exp(-ageDays / 30);
    return r.supports ? weight : -weight;
  });
  
  const sum = weights.reduce((a, b) => a + b, 0);
  return (sum + 1) / 2; // Normalize to 0-1
}
```

---

## Conflict Handling

### Conflict Detection

Conflicts are detected when sources provide contradictory information:

```typescript
interface ConflictDetection {
  hasConflict: boolean;
  conflictingPairs: ConflictPair[];
  conflictSeverity: ConflictLevel;
}

interface ConflictPair {
  sourceA: string;
  sourceB: string;
  claimA: string;                // What source A says
  claimB: string;               // What source B says
  conflictType: ConflictType;
  resolutionAttempted: boolean;
  resolutionOutcome?: ResolutionOutcome;
}

type ConflictType = 
  | 'direct_contradiction'      // A says X, B says not X
  | 'magnitude_disagreement'    // A says X, B says Y (X ≠ Y)
  | 'contextual_conflict'       // Same data, different framing
  | 'temporal_conflict';        // Same claim, different timeframes

function detectConflicts(
  references: CrossReference[]
): ConflictDetection {
  const conflicts: ConflictPair[] = [];
  
  for (let i = 0; i < references.length; i++) {
    for (let j = i + 1; j < references.length; j++) {
      const refA = references[i];
      const refB = references[j];
      
      if (refA.contradicts && refB.supports) {
        conflicts.push({
          sourceA: refA.sourceId,
          sourceB: refB.sourceId,
          claimA: refA.relevantExcerpts[0] || '',
          claimB: refB.relevantExcerpts[0] || '',
          conflictType: classifyConflict(refA, refB),
          resolutionAttempted: false
        });
      }
    }
  }
  
  return {
    hasConflict: conflicts.length > 0,
    conflictingPairs: conflicts,
    conflictSeverity: calculateConflictSeverity(conflicts)
  };
}
```

### Conflict Resolution Strategy

When conflicts are detected, the system attempts resolution in order:

```typescript
type ResolutionStrategy = 
  | 'primary_source_priority'
  | 'recency_weighting'
  | 'majority_vote'
  | 'authority_weighting'
  | 'unresolvable';

interface ConflictResolution {
  strategy: ResolutionStrategy;
  winningSource?: string;
  winningClaim?: string;
  confidenceImpact: number;       // How much this lowers overall confidence
  rationale: string;
}

function resolveConflict(
  conflict: ConflictPair,
  allReferences: CrossReference[]
): ConflictResolution {
  const sourceA = allReferences.find(r => r.sourceId === conflict.sourceA);
  const sourceB = allReferences.find(r => r.sourceId === conflict.sourceB);
  
  if (!sourceA || !sourceB) {
    return {
      strategy: 'unresolvable',
      confidenceImpact: 0.5,
      rationale: 'Required sources not found in reference set'
    };
  }
  
  // Strategy 1: Primary vs Secondary Source Priority
  if (isPrimarySource(sourceA) && !isPrimarySource(sourceB)) {
    return {
      strategy: 'primary_source_priority',
      winningSource: sourceA.sourceId,
      winningClaim: conflict.claimA,
      confidenceImpact: 0.1,
      rationale: 'Primary source (official documentation) takes precedence over secondary source'
    };
  }
  
  // Strategy 2: Recency Weighting
  const ageA = getSourceAge(sourceA);
  const ageB = getSourceAge(sourceB);
  
  if (ageA < ageB * 0.5) { // A is significantly more recent
    return {
      strategy: 'recency_weighting',
      winningSource: sourceA.sourceId,
      winningClaim: conflict.claimA,
      confidenceImpact: 0.15,
      rationale: 'More recent source provides current data'
    };
  }
  
  // Strategy 3: Authority Weighting
  if (sourceA.sourceReliability === 'high' && sourceB.sourceReliability !== 'high') {
    return {
      strategy: 'authority_weighting',
      winningSource: sourceA.sourceId,
      winningClaim: conflict.claimA,
      confidenceImpact: 0.2,
      rationale: 'Higher reliability source preferred'
    };
  }
  
  // Cannot resolve
  return {
    strategy: 'unresolvable',
    confidenceImpact: 0.4,
    rationale: 'Insufficient differentiation between sources for automatic resolution'
  };
}
```

### Primary vs Secondary Source Priority

Source type determines resolution priority:

| Priority | Source Type | Examples |
|----------|-------------|----------|
| **1 (Highest)** | Primary/Official | Whitepapers, official docs, press releases |
| **2** | Academic/Research | Peer-reviewed, research papers |
| **3** | Professional News | Reuters, Bloomberg, industry publications |
| **4** | Secondary News | General news, blogs |
| **5 (Lowest)** | Community/Social | Forums, social media, user-generated content |

```typescript
function isPrimarySource(source: SourceMetadata): boolean {
  const primaryTypes = ['whitepaper', 'official-documentation', 'press-release'];
  return primaryTypes.includes(source.contentType);
}

function getSourcePriority(source: SourceMetadata): number {
  const priorityMap: Record<string, number> = {
    'whitepaper': 1,
    'official-documentation': 1,
    'press-release': 1,
    'academic': 2,
    'research-paper': 2,
    'professional-news': 3,
    'blog': 4,
    'forum': 5,
    'social': 5
  };
  
  return priorityMap[source.contentType] || 5;
}
```

### Recency Weighting in Conflicts

When sources conflict, recency is a key differentiator:

```typescript
interface RecencyWeightedConflict {
  claim: string;
  sources: {
    sourceId: string;
    claim: string;
    publishedAt: Date;
    weight: number;
  }[];
  
  winner?: string;
  rationale: string;
}

function resolveByRecency(
  conflict: ConflictPair,
  references: CrossReference[]
): RecencyWeightedConflict {
  const sourceA = references.find(r => r.sourceId === conflict.sourceA);
  const sourceB = references.find(r => r.sourceId === conflict.sourceB);
  
  if (!sourceA || !sourceB) {
    return { claim: conflict.claimA, sources: [], rationale: 'Sources not found' };
  }
  
  // Weight calculation: exponential decay over 90 days
  const now = new Date();
  const weightA = Math.exp(-daysBetween(sourceA.publishedAt, now) / 30);
  const weightB = Math.exp(-daysBetween(sourceB.publishedAt, now) / 30);
  
  const winner = weightA > weightB ? sourceA.sourceId : sourceB.sourceId;
  const winnerClaim = weightA > weightB ? conflict.claimA : conflict.claimB;
  
  return {
    claim: conflict.claimA,
    sources: [
      { sourceId: sourceA.sourceId, claim: conflict.claimA, publishedAt: sourceA.publishedAt, weight: weightA },
      { sourceId: sourceB.sourceId, claim: conflict.claimB, publishedAt: sourceB.publishedAt, weight: weightB }
    ],
    winner,
    rationale: weightA > weightB 
      ? `Source A is ${(weightA / weightB).toFixed(1)}x more recent`
      : `Source B is ${(weightB / weightA).toFixed(1)}x more recent`
  };
}
```

---

## Verification Status

### Status Types

Every claim receives one of four verification statuses:

| Status | Meaning | Badge Color |
|--------|---------|-------------|
| **VERIFIED** | Multiple independent sources agree | Green |
| **CONFLICTING** | Sources disagree; cannot automatically resolve | Orange |
| **PARTIALLY_VERIFIED** | Single supporting source; needs more evidence | Yellow |
| **UNVERIFIED** | No supporting sources found | Red |

### Status Display Format

Claims are displayed with their verification status:

```
┌─────────────────────────────────────────────────────────────────┐
│ [VERIFIED] Bitcoin's market dominance is 52% as of July 2024     │
│                                                                 │
│ Confidence: 0.92                                                │
│ Sources: SRC-001, SRC-002, SRC-003 (3 independent sources)     │
│ Updated: 2024-07-12T14:30:00Z                                   │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ [CONFLICTING] Protocol X has $500M TVL                          │
│                                                                 │
│ Confidence: 0.35                                                │
│ Supporting: SRC-042 (DeFiLlama, 2024-07-12)                    │
│ Contradicting: SRC-043 (DappRadar, 2024-07-10) - $480M claim  │
│ Resolution: Unable to automatically resolve (within 4% margin) │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ [PARTIALLY_VERIFIED] Team size is 15 people                     │
│                                                                 │
│ Confidence: 0.55                                                 │
│ Sources: SRC-051 (LinkedIn, single source)                      │
│ Recommendation: Verify with additional source                   │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│ [UNVERIFIED] Protocol Y launched in Q3 2023                    │
│                                                                 │
│ Confidence: 0.10                                                 │
│ Sources: None found supporting this claim                        │
│ Action: Requires primary source verification                    │
└─────────────────────────────────────────────────────────────────┘
```

### Status Determination Logic

```typescript
function determineVerificationStatus(
  synthesis: VerificationSynthesis,
  conflictDetection: ConflictDetection
): VerificationStatusResult {
  // If conflicts exist and cannot be resolved
  if (conflictDetection.hasConflict) {
    const unresolvedConflicts = conflictDetection.conflictingPairs.filter(
      c => !c.resolutionAttempted || c.resolutionOutcome?.strategy === 'unresolvable'
    );
    
    if (unresolvedConflicts.length > 0) {
      return {
        status: 'CONFLICTING',
        confidencePenalty: 0.4,
        displayReason: `Conflicting data from ${unresolvedConflicts.length} source pair(s)`,
        userAction: 'Review conflicting sources manually'
      };
    }
  }
  
  // Consensus-based status
  if (synthesis.supportingSources.length >= 2) {
    const confidenceBonus = synthesis.consensusLevel === 'strong' ? 0.15 : 0;
    return {
      status: 'VERIFIED',
      confidencePenalty: 0,
      displayReason: `${synthesis.supportingSources.length} independent sources`,
      userAction: synthesis.consensusLevel === 'strong' ? null : 'Additional sources would increase confidence'
    };
  }
  
  if (synthesis.supportingSources.length === 1) {
    return {
      status: 'PARTIALLY_VERIFIED',
      confidencePenalty: 0.2,
      displayReason: 'Single source support',
      userAction: 'Seek additional independent verification'
    };
  }
  
  return {
    status: 'UNVERIFIED',
    confidencePenalty: 0.5,
    displayReason: 'No supporting sources found',
    userAction: 'Requires primary research or source discovery'
  };
}
```

### Confidence Score Calculation

Final confidence reflects source agreement and conflict status:

```typescript
interface ConfidenceResult {
  score: number;                  // 0.0 - 1.0
  breakdown: {
    sourceCount: number;
    consensusBonus: number;
    recencyBonus: number;
    conflictPenalty: number;
    independencePenalty: number;
  };
  verdict: string;
}

function calculateFinalConfidence(
  synthesis: VerificationSynthesis,
  conflictDetection: ConflictDetection
): ConfidenceResult {
  let score = 0.5; // Base score
  
  // Source count bonus (2-5 sources optimal)
  const sourceCountBonus = Math.min(synthesis.supportingSources.length * 0.1, 0.3);
  score += sourceCountBonus;
  
  // Consensus bonus
  const consensusBonus = {
    'strong': 0.2,
    'moderate': 0.1,
    'weak': 0,
    'none': -0.1
  }[synthesis.consensusLevel];
  score += consensusBonus;
  
  // Conflict penalty
  const conflictPenalty = {
    'none': 0,
    'minor': -0.1,
    'significant': -0.25,
    'major': -0.4
  }[conflictDetection.conflictSeverity];
  score += conflictPenalty;
  
  // Clamp to valid range
  score = Math.max(0, Math.min(1, score));
  
  return {
    score,
    breakdown: {
      sourceCount: synthesis.supportingSources.length,
      consensusBonus,
      recencyBonus: 0, // Calculated separately in recency weighting
      conflictPenalty,
      independencePenalty: 0
    },
    verdict: getVerdict(score)
  };
}

function getVerdict(score: number): string {
  if (score >= 0.8) return 'HIGH CONFIDENCE';
  if (score >= 0.6) return 'MODERATE CONFIDENCE';
  if (score >= 0.4) return 'LOW CONFIDENCE';
  return 'VERY LOW CONFIDENCE';
}
```

---

## Verification Pipeline

### Complete Workflow

```typescript
interface VerificationPipeline {
  input: {
    claim: string;
    context?: string;
    requiredConfidence?: number;
  };
  
  stages: {
    sourceCollection: SourceCollection;
    crossReference: CrossReference[];
    consensusDetection: ConsensusMetrics;
    conflictDetection: ConflictDetection;
    synthesis: VerificationSynthesis;
    status: VerificationStatusResult;
  };
  
  output: {
    status: VerificationStatus;
    confidence: number;
    sources: string[];
    conflicts?: ConflictPair[];
    recommendation: string;
  };
}

async function runVerificationPipeline(
  input: VerificationPipeline['input']
): Promise<VerificationPipeline> {
  // Stage 1: Collect sources
  const sourceCollection = await collectSources(input.claim);
  
  // Stage 2: Cross-reference analysis
  const crossReference = await crossReference(input.claim, sourceCollection.collectedSources);
  
  // Stage 3: Consensus detection
  const consensusDetection = calculateConsensus(crossReference);
  
  // Stage 4: Conflict detection
  const conflictDetection = detectConflicts(crossReference);
  
  // Stage 5: Synthesis
  const synthesis = synthesizeVerification(crossReference);
  
  // Stage 6: Status determination
  const status = determineVerificationStatus(synthesis, conflictDetection);
  
  return {
    input,
    stages: {
      sourceCollection,
      crossReference,
      consensusDetection,
      conflictDetection,
      synthesis,
      status
    },
    output: {
      status: status.status,
      confidence: calculateFinalConfidence(synthesis, conflictDetection).score,
      sources: synthesis.supportingSources,
      conflicts: conflictDetection.hasConflict ? conflictDetection.conflictingPairs : undefined,
      recommendation: status.userAction
    }
  };
}
```

---

## Dependencies

- `component-contracts.md` — Interfaces this layer implements
- `web-research-architecture.md` — Source collection and tracking
- `knowledge-model.md` — Signal and Evidence structures

## Related Documents

- `web-research-architecture.md` — Source tracking infrastructure
- `quality-gates.md` — Quality requirements for verification
- `honesty-framework.md` — Honest uncertainty communication

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-07-12 | Initial draft |
