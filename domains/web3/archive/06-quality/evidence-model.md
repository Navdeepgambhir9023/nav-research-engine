# Evidence Model

**Document ID**: 04.2
**Domain**: Quality
**Status**: Draft

---

## Purpose

Defines standards for what constitutes valid evidence—how evidence is collected, evaluated, and weighted. Ensures all claims in the knowledge base are traceable to credible sources.

## Audience

- Researchers (for evidence collection)
- Validators (for evidence evaluation)
- Analysts (for understanding provenance)

## Evidence Philosophy

> All claims must be traceable. Evidence is the chain that connects conclusions to reality.

Key principles:
1. **Traceability**: Every claim has a provenance chain
2. **Strength Grading**: Evidence is evaluated by quality
3. **Source Diversity**: Multiple sources increase confidence
4. **Currency**: Recent evidence is more valuable
5. **Relevance**: Evidence must directly support the claim

---

## Evidence Hierarchy

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           EVIDENCE STRENGTH                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Level 5: VERIFIED                                                          │
│  ┌─────────────────────────────────────────────────────────────────────┐ │
│  │ • Direct on-chain data                                               │ │
│  │ • Official documentation                                             │ │
│  │ • Primary sources with verification                                  │ │
│  │ • Cross-referenced multiple sources                                   │ │
│  └─────────────────────────────────────────────────────────────────────┘ │
│                              ▲                                             │
│  Level 4: STRONG                                                            │
│  ┌─────────────────────────────────────────────────────────────────────┐ │
│  │ • Multiple independent primary sources agree                         │ │
│  │ • Well-known authoritative sources                                   │ │
│  │ • Industry-recognized data providers                                  │ │
│  └─────────────────────────────────────────────────────────────────────┘ │
│                              ▲                                             │
│  Level 3: MODERATE                                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐ │
│  │ • Single primary source                                              │ │
│  │ • Secondary sources (news, reports)                                  │ │
│  │ • Professional analysis                                              │ │
│  └─────────────────────────────────────────────────────────────────────┘ │
│                              ▲                                             │
│  Level 2: WEAK                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐ │
│  │ • Social media / community sources                                  │ │
│  │ • Secondhand reports                                                │ │
│  │ • Indirect indicators                                               │ │
│  └─────────────────────────────────────────────────────────────────────┘ │
│                              ▲                                             │
│  Level 1: INFERENTIAL                                                      │
│  ┌─────────────────────────────────────────────────────────────────────┐ │
│  │ • Logical inference                                                 │ │
│  │ • Pattern extrapolation                                              │ │
│  │ • Expert opinion without data                                        │ │
│  └─────────────────────────────────────────────────────────────────────┘ │
│                              ▲                                             │
│  Level 0: SPECULATION                                                      │
│  ┌─────────────────────────────────────────────────────────────────────┐ │
│  │ • Unverified claims                                                 │ │
│  │ • Opinion                                                           │ │
│  │ • No supporting data                                                │ │
│  └─────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Source Types

### Primary Sources (Strength: 4-5)

| Source Type | Description | Examples |
|------------|-------------|----------|
| **On-Chain** | Direct blockchain data | Transaction history, contract calls, token transfers |
| **Official Documentation** | Primary sources from entities | Whitepapers, docs, official blog posts |
| **Direct Observation** | Eyewitness or first-hand account | Official announcements, verified tweets |
| **Government/Regulatory** | Official regulatory filings | SEC filings, legal documents |

### Secondary Sources (Strength: 3)

| Source Type | Description | Examples |
|------------|-------------|----------|
| **News** | Journalistic coverage | Coindesk, The Block, Decrypt |
| **Research Reports** | Analytical reports | Messari, Delphi Digital, Dune Analytics |
| **Academic** | Peer-reviewed or academic work | Research papers, theses |
| **Industry Analysis** | Professional analysis | Consensys reports, foundation reports |

### Tertiary Sources (Strength: 2)

| Source Type | Description | Examples |
|------------|-------------|----------|
| **Social** | Community discussion | Twitter/X, Discord, Reddit |
| **Aggregated** | Aggregated data | CoinGecko, DeFi Llama |
| **Secondary News** | News about news | Summaries, reposts |

### Informal Sources (Strength: 1)

| Source Type | Description | Examples |
|------------|-------------|----------|
| **Community Claims** | Unverified community reports | Forum posts, Telegram messages |
| **Indirect Indicators** | Circumstantial evidence | Sentiment, social volume |

---

## Evidence Collection Standards

### Required Fields

Every piece of evidence must include:

```yaml
evidence:
  id: string           # Unique identifier (UUID)
  type: enum           # primary | secondary | tertiary | informal
  source:
    name: string       # Source name
    type: enum         # api | webpage | document | study | manual
    url: string        # URL if applicable
    retrievedAt: datetime  # When retrieved
  content:
    summary: string    # Brief description of evidence content
    relevantData: any  # Structured data if applicable
  relevance:
    claimId: string    # ID of claim this evidence supports
    weight: number      # 0.0-1.0, how directly it supports claim
  metadata:
    currency: datetime  # How current is this evidence?
    reliability: enum  # verified | reliable | uncertain | unreliable
```

### Evidence Chain Requirements

| Claim Confidence | Minimum Chain |
|-----------------|---------------|
| 0.90 - 1.00 | 3+ primary sources, all verified |
| 0.75 - 0.89 | 2+ primary sources OR 4+ secondary |
| 0.60 - 0.74 | 1+ primary source OR 2+ secondary |
| 0.40 - 0.59 | 1+ source (any type) with documented reasoning |
| < 0.40 | Inference documented, labeled as speculative |

---

## Evidence Evaluation

### Source Reliability Scores

| Source | Base Score | Factors |
|--------|-----------|---------|
| Official entity channels | 0.95 | Verification status |
| Major news outlets | 0.85 | Editorial standards |
| Known analysts | 0.80 | Track record |
| Community aggregators | 0.60 | Verification status |
| Social media | 0.40 | Multiple confirmation needed |
| Anonymous sources | 0.20 | Requires strong corroboration |

### Adjustments

**Positive Adjustments**:
- Source historically accurate: +0.10
- Multiple independent sources: +0.10 per additional source
- Recent data (< 24h): +0.05
- Cross-referenced: +0.10

**Negative Adjustments**:
- Outdated data (> 30 days): -0.10
- Single source (no corroboration): -0.15
- Source has history of errors: -0.20
- Anonymous or unverified: -0.30

---

## Evidence Conflict Resolution

### When Evidence Conflicts

```
Step 1: Verify evidence authenticity
□ Check source reliability scores
□ Verify retrieval timestamps
□ Confirm no data errors

Step 2: Assess conflict severity
□ Direct contradiction: Evidence says X, other says not-X
□ Partial conflict: Evidence says X, other adds nuance

Step 3: Apply resolution rules
□ Stronger evidence prevails (if significantly stronger)
□ More recent evidence prevails (if similar strength)
□ Multiple sources vs. single source: multiple wins
□ Direct source vs. reported source: direct wins

Step 4: Document resolution
□ Record which evidence was weighted higher
□ Record reason for weighting
□ Flag for human review if unresolved
```

### Conflict Documentation

```yaml
conflict:
  claim1:
    id: string
    evidence: [list]
    conclusion: string
  claim2:
    id: string
    evidence: [list]
    conclusion: string
  resolution:
    method: enum  # evidence_strength | recency | human_review
    outcome: string
    rationale: string
    reviewedBy: string  # if human review
    reviewedAt: datetime
```

---

## Evidence Storage

### Storage Format

Evidence stored alongside claims in knowledge base:

```
knowledge/
├── entities/
│   ├── protocols/
│   │   └── [entity-id].json
│   └── ...
├── evidence/
│   └── [evidence-id].json
└── claims/
    └── [claim-id].json
```

### Evidence Retention

| Evidence Type | Retention | Rationale |
|---------------|-----------|-----------|
| Primary sources | Indefinite | Core knowledge |
| Secondary sources | 1 year | Validation reference |
| Tertiary sources | 6 months | Contextual only |
| Informal sources | 3 months | Transient value |

---

## Evidence Quality Metrics

| Metric | Definition | Target |
|--------|-----------|--------|
| Source diversity | Avg sources per claim | >2.5 |
| Primary source rate | % claims with primary sources | >60% |
| Evidence freshness | Avg age of evidence | <7 days |
| Conflict resolution rate | % conflicts resolved automatically | >80% |
| Traceability completeness | % claims with complete provenance | >95% |

---

## Dependencies

- `knowledge-model.md` — Knowledge hierarchy
- `quality-gates.md` — Quality gate criteria
- `entity-schemas.md` — Evidence in entity schemas

## Related Documents

- `scoring-model.md` — Confidence scoring
- `gap-detection.md` — Identifying evidence gaps

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
