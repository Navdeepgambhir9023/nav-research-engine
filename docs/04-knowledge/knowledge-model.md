# Knowledge Model

**Document ID**: 04-knowledge.1
**Domain**: Knowledge
**Status**: Draft

---

**Extensibility Note**: This knowledge model defines domain-agnostic core entities. Domain-specific entities (e.g., Web3 protocols, DeFi primitives) are defined in `domains/<domain>/knowledge/`. See [domain-config.md](../01-architecture/domain-config.md) for the extension mechanism.

---

## 1. Philosophy

### What Is Knowledge?

Knowledge is the **primary asset** of the Research Operating System. Everything else—code, skills, departments, integrations—exists to create, maintain, and evolve knowledge.

We define knowledge as:

> **Knowledge is validated understanding that can be acted upon with confidence.**

This definition has four components:

1. **Validated** — Knowledge is not speculation. It is grounded in evidence that has passed quality gates.

2. **Understanding** — Knowledge is not raw data. It is data that has been processed, contextualized, and interpreted.

3. **Acted Upon** — Knowledge that cannot influence decisions is trivia. Knowledge must be connected to outcomes.

4. **Confidence** — Knowledge is not binary true or false. It exists on a spectrum, with explicit confidence levels.

### Knowledge vs. Information

Information is **processed data**. It has structure but no context.

```
Information: "TVL increased 50% this week"
Knowledge: "Curve Finance's TVL increased 50% this week, driven by crvUSD adoption, 
            corroborating the hypothesis that users prefer stablecoin-native DEXs"
```

Knowledge adds:
- Subject (who or what)
- Context (why)
- Connection (to other knowledge)
- Confidence (how certain)

### Knowledge vs. Reports

Reports are **presentations of knowledge**. They communicate knowledge to humans.

```
Report: "Weekly intelligence digest"
Knowledge: The underlying entities, relationships, and evidence that the report summarizes
```

Reports are outputs. Knowledge is the source of truth.

### Why Knowledge Is the Primary Asset

The repository improves over time. Every cycle, the knowledge base grows. The system becomes more capable. This is only possible if knowledge is the artifact that persists and improves.

```
Code degrades: New code replaces old code
Processes change: What worked yesterday may not work tomorrow
Skills evolve: Methods become obsolete

Knowledge accumulates: Each cycle adds to what we know
Knowledge compounds: New knowledge builds on existing knowledge
Knowledge persists: Unlike code, knowledge doesn't become "legacy"
```

---

## 2. Core Entity Types

Every first-class entity in the knowledge graph is defined here. These entities are the nouns of the research system—everything that can be known.

### Entity Type Definitions

#### Market

**Definition**: A defined space where value is exchanged between participants.

**Purpose**: Markets are the top-level containers for research. All other entities exist within markets.

**Properties**:
- Name
- Category (defined in domain taxonomy, e.g., Industry, Vertical, or domain-specific categories)
- Stage (emerging, growing, mature, declining)
- Total addressable value
- Growth trajectory

**Note**: Domain-specific market categories (e.g., "DeFi", "NFT", "Lending") are defined in `domains/<domain>/taxonomy.md`. This core model is domain-agnostic.

**Constraints**:
- A market may contain zero or more segments
- A market may contain zero or more solutions
- Every entity ultimately traces back to a market

---

#### Segment

**Definition**: A distinct portion of a market with shared characteristics.

**Purpose**: Segments allow focused research within a market.

**Properties**:
- Name
- Market (parent)
- Characteristics (what defines this segment)
- Size (market share, user count)
- Growth rate

**Constraints**:
- A segment belongs to exactly one market
- A segment may contain zero or more problems

---

#### Persona

**Definition**: A representation of a user type with distinct needs and behaviors.

**Purpose**: Personas humanize the research. They connect abstract market data to real user needs.

**Properties**:
- Name
- Description
- Demographics (simplified)
- Behavioral patterns
- Needs and pain points

**Constraints**:
- A persona may experience zero or more problems
- A persona may belong to one or more segments

---

#### Problem

**Definition**: A user need, pain point, or friction that creates opportunity.

**Purpose**: Problems are the fundamental unit of opportunity. All opportunity traces to a problem.

**Properties**:
- Name
- Description
- Severity (how much it affects users)
- Prevalence (how many users experience it)
- Currently addressed? (boolean)
- Addressed by (if yes, reference to solution)

**Constraints**:
- A problem belongs to exactly one segment
- A problem may be experienced by one or more personas
- A problem may be addressed by zero or more opportunities
- Every opportunity must reference at least one problem

---

#### Solution

**Definition**: A product, service, or system that provides a solution to one or more problems.

**Purpose**: Solutions are the primary actors in any research domain. In Web3, these are protocols. In other domains, these are products, services, or providers.

**Properties**:
- Name
- Category (defined in domain taxonomy, e.g., DEX, Lending, SaaS, Hardware)
- Ecosystem (platform or environment, optional)
- Status (active, paused, deprecated)
- Launch date
- Key metrics (domain-specific, optional)

**Note**: Web3-specific properties (TVL, Token, Ecosystem chains) are defined in `domains/web3/schemas/solution.md`.

**Constraints**:
- A solution may solve zero or more problems
- A solution may compete with zero or more solutions
- A solution may integrate with zero or more solutions

---

#### Signal

**Definition**: An observation that indicates a change, pattern, or event in the ecosystem.

**Purpose**: Signals are the raw material of research. They are what Discovery detects.

**Properties**:
- Type (opportunity, threat, trend, data)
- Title
- Description
- Source (provenance)
- Detected at (timestamp)
- Expires at (optional)

**States**:
- raw — Detected, not yet processed
- processed — Enriched with context
- promoted — Elevated to insight or opportunity
- archived — Expired or superseded

**Constraints**:
- A signal must have a source
- A signal may be derived from one or more observations
- A signal may contribute to zero or more insights

---

#### Observation

**Definition**: A raw data point from an external source.

**Purpose**: Observations are the leaves of the knowledge graph. They are what sensors capture.

**Properties**:
- Type (on-chain, social, news, market, study)
- Source (which sensor)
- Raw data (the actual data)
- Captured at (timestamp)

**Constraints**:
- An observation may be referenced by zero or more signals
- An observation must have a source

---

#### Evidence

**Definition**: Information that supports or refutes a claim.

**Purpose**: Evidence is the justification for knowledge. It is what makes assertions credible.

**Evidence Hierarchy**:

| Level | Name | Description |
|-------|------|-------------|
| 5 | Verified | Primary sources, on-chain data, cross-referenced |
| 4 | Strong | Multiple independent sources agree |
| 3 | Moderate | Single authoritative source |
| 2 | Weak | Social, secondhand, indirect |
| 1 | Inferior | Unverified, anecdotal |

**Properties**:
- Strength (1-5)
- Source (URL, API, document)
- Source type (primary, secondary, tertiary)
- Content summary
- Relevance to claim
- Retrieved at (timestamp)

**Constraints**:
- Evidence must reference at least one claim it supports
- Evidence may reference one or more observations
- Evidence may refute one or more claims

---

#### Claim

**Definition**: An assertion that can be evaluated against evidence.

**Purpose**: Claims are the units of knowledge that can be validated.

**Properties**:
- Statement (the assertion)
- Type (fact, interpretation, prediction)
- Confidence (0.0-1.0)
- Confidence rationale

**Constraints**:
- A claim must be supported by at least one evidence
- A claim may contribute to zero or more insights
- A claim may be contradicted by other claims

---

#### Insight

**Definition**: A synthesized understanding derived from signals, evidence, and context.

**Purpose**: Insights are what Analysis produces. They connect raw signals to meaning.

**Properties**:
- Title
- Summary (1-2 sentences)
- Supporting claims (list)
- Confidence
- Implications (list)
- Related problems (list)

**Constraints**:
- An insight must reference at least one claim
- An insight may reference zero or more problems
- An insight may contribute to zero or more hypotheses

---

#### Hypothesis

**Definition**: A testable proposition derived from insights and gaps.

**Purpose**: Hypotheses bridge understanding to action. They translate insights into questions that can be answered.

**Properties**:
- Statement (the proposition)
- Derived from (list of insights)
- Tests (what evidence would confirm or refute)
- Status (proposed, testing, confirmed, refuted)

**Constraints**:
- A hypothesis must reference at least one insight
- A hypothesis must define success criteria
- A hypothesis may be tested by zero or more experiments

---

#### Experiment

**Definition**: A structured investigation designed to test a hypothesis.

**Purpose**: Experiments are how hypotheses become validated knowledge.

**Properties**:
- Name
- Hypothesis (what it tests)
- Method (how it tests)
- Resources required
- Success criteria
- Results (when complete)
- Status (planned, running, completed, failed)

**Constraints**:
- An experiment must reference exactly one hypothesis
- An experiment may produce zero or more validated claims
- An experiment may produce zero or more new hypotheses

---

#### Validated Claim

**Definition**: A claim that has passed validation and can be used as a basis for decisions.

**Purpose**: Validated claims are the highest-confidence knowledge. They are the basis for action.

**Properties**:
- The claim itself
- Validation evidence (how it was validated)
- Validated at (timestamp)
- Validated by (human or system)

**Constraints**:
- A validated claim must have passed all quality gates
- A validated claim may be referenced by zero or more decisions

---

#### Opportunity

**Definition**: A potential action that addresses a validated problem.

**Purpose**: Opportunities are the output of research. They are what Planning ranks and prioritizes.

**Properties**:
- Name
- Description
- Problem addressed (reference)
- Solution type (market_entry, integration, partnership, investment)
- Phase (emerging, growing, mature, declining)
- Score (0-100, calculated)

**Constraints**:
- An opportunity must reference at least one validated problem
- An opportunity must have a confidence score
- An opportunity may be ranked against other opportunities

---

#### Decision

**Definition**: A commitment to act on an opportunity.

**Purpose**: Decisions are how research translates to outcomes.

**Properties**:
- Opportunity (what we decided on)
- Decision (proceed, defer, reject)
- Rationale
- Decision maker
- Decided at (timestamp)
- Status (pending, approved, rejected, implemented)

**Constraints**:
- A decision must reference exactly one opportunity
- A decision must reference at least one validated claim
- A decision must be made by a human

---

#### Trend

**Definition**: A pattern of change over time.

**Purpose**: Trends contextualize other knowledge. They show direction.

**Properties**:
- Name
- Direction (rising, falling, stable)
- Strength (weak, moderate, strong)
- Timeframe (immediate, short-term, medium-term, long-term)
- Impact (transformative, significant, moderate, minor)

**Constraints**:
- A trend may affect zero or more markets
- A trend may influence zero or more opportunities

---

#### Competitor

**Definition**: A solution that competes for the same users or capital as our subject.

**Purpose**: Competitors contextualize opportunities and threats.

**Properties**:
- Solution (reference)
- Competitive dimensions (where they compete)
- Competitive strength (weak, moderate, strong)
- Market share

**Constraints**:
- A competitor must reference exactly one solution
- A competitor may compete with zero or more other solutions

---

## 3. Entity Relationships

The knowledge graph connects entities through typed relationships. These relationships carry meaning, not just references.

### Relationship Types

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         KNOWLEDGE GRAPH                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                          ┌─────────┐                                      │
│                          │ MARKET  │                                      │
│                          └────┬────┘                                      │
│                               │                                            │
│                    ┌──────────┼──────────┐                               │
│                    │ contains │          │ contains                     │
│                    ▼          ▼          ▼                               │
│              ┌─────────┐ ┌─────────┐ ┌─────────┐                         │
│              │ SEGMENT │ │ SEGMENT │ │ SEGMENT │                         │
│              └────┬────┘ └────┬────┘ └────┬────┘                         │
│                   │           │           │                                │
│                   │ experienced by │ experienced by                       │
│                   ▼           ▼           ▼                               │
│              ┌─────────┐ ┌─────────┐ ┌─────────┐                         │
│              │ PERSONA │ │ PERSONA │ │ PERSONA │                         │
│              └────┬────┘ └────┬────┘ └────┬────┘                         │
│                   │           │           │                                │
│                   │ experiences │ experiences │                              │
│                   ▼           ▼           ▼                               │
│              ┌─────────────────────────────────────┐                      │
│              │             PROBLEM                │                      │
│              └──────────────┬─────────────────────┘                      │
│                             │                                              │
│                             │ addressed by                                │
│                             ▼                                              │
│              ┌─────────────────────────────────────┐                      │
│              │           OPPORTUNITY               │                      │
│              └──────────────┬─────────────────────┘                      │
│                             │                                              │
│                             │ based on                                    │
│                             ▼                                              │
│              ┌─────────────────────────────────────┐                      │
│              │         VALIDATED CLAIM             │                      │
│              └──────────────┬─────────────────────┘                      │
│                             │                                              │
│                             │ supports                                    │
│                             ▼                                              │
│              ┌─────────────────────────────────────┐                      │
│              │             INSIGHT                  │                      │
│              └──────────────┬─────────────────────┘                      │
│                             │                                              │
│                             │ derived from                                │
│                             ▼                                              │
│              ┌─────────────────────────────────────┐                      │
│              │           HYPOTHESIS                │                      │
│              └──────────────┬─────────────────────┘                      │
│                             │                                              │
│                             │ tested by                                   │
│                             ▼                                              │
│              ┌─────────────────────────────────────┐                      │
│              │          EXPERIMENT                  │                      │
│              └──────────────┬─────────────────────┘                      │
│                             │                                              │
│                             │ produces                                    │
│                             ▼                                              │
│              ┌─────────────────────────────────────┐                      │
│              │        NEW VALIDATED CLAIM           │                      │
│              └─────────────────────────────────────┘                      │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Relationship Catalog

#### Hierarchical Relationships

| Relationship | From | To | Description |
|-------------|------|-----|-------------|
| `contains` | Market | Segment | Market contains segment |
| `belongs_to` | Segment | Market | Segment belongs to market |
| `part_of` | Persona | Segment | Persona is part of segment |

#### Behavioral Relationships

| Relationship | From | To | Description |
|-------------|------|-----|-------------|
| `experiences` | Persona | Problem | Persona experiences problem |
| `addresses` | Opportunity | Problem | Opportunity addresses problem |
| `solved_by` | Problem | Opportunity | Problem is solved by opportunity |

#### Evidence Relationships

| Relationship | From | To | Description |
|-------------|------|-----|-------------|
| `supports` | Evidence | Claim | Evidence supports claim |
| `refutes` | Evidence | Claim | Evidence refutes claim |
| `derived_from` | Signal | Observation | Signal derived from observation |
| `contributes_to` | Signal | Insight | Signal contributes to insight |
| `based_on` | Insight | Claim | Insight based on claim |

#### Causal Relationships

| Relationship | From | To | Description |
|-------------|------|-----|-------------|
| `implies` | Claim | Insight | Claim implies insight |
| `leads_to` | Insight | Hypothesis | Insight leads to hypothesis |
| `tests` | Experiment | Hypothesis | Experiment tests hypothesis |
| `produces` | Experiment | ValidatedClaim | Experiment produces validated claim |

#### Comparative Relationships

| Relationship | From | To | Description |
|-------------|------|-----|-------------|
| `competes_with` | Solution | Solution | Solutions compete |
| `integrates_with` | Solution | Solution | Solutions integrate |
| `affects` | Trend | Market | Trend affects market |
| `influences` | Trend | Opportunity | Trend influences opportunity |

### Relationship Properties

All relationships may carry additional properties:

```yaml
relationship:
  type: string           # Relationship type
  source: EntityId       # Source entity
  target: EntityId       # Target entity
  weight: number         # Relationship strength (0.0-1.0)
  confidence: number     # Confidence in relationship (0.0-1.0)
  valid_from: datetime  # When relationship became true
  valid_until: datetime # When relationship ceased being true (null = current)
  created_at: datetime  # When recorded
  created_by: string    # Human or system
```

---

## 4. Knowledge Lifecycle

Knowledge does not appear fully formed. It evolves through a defined lifecycle from raw observation to actionable decision.

### Lifecycle Stages

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         KNOWLEDGE LIFECYCLE                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────┐                                                        │
│   │ OBSERVATION │  Raw data from sensors                                  │
│   └──────┬──────┘                                                        │
│          │                                                                  │
│          │ collected by                                                   │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │   SIGNAL    │  Detected pattern from observations                       │
│   └──────┬──────┘                                                        │
│          │                                                                  │
│          │ processed by                                                    │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │  EVIDENCE   │  Validated information supporting claims                  │
│   └──────┬──────┘                                                        │
│          │                                                                  │
│          │ supports                                                       │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │   CLAIM     │  Asserted proposition                                    │
│   └──────┬──────┘                                                        │
│          │                                                                  │
│          │ synthesized into                                                │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │   INSIGHT   │  Understood meaning                                     │
│   └──────┬──────┘                                                        │
│          │                                                                  │
│          │ generates                                                      │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │ HYPOTHESIS  │  Testable proposition                                    │
│   └──────┬──────┘                                                        │
│          │                                                                  │
│          │ validated by                                                    │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │ VALIDATED   │  Proven proposition                                      │
│   │   CLAIM     │                                                        │
│   └──────┬──────┘                                                        │
│          │                                                                  │
│          │ enables                                                        │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │ OPPORTUNITY │  Potential action                                         │
│   └──────┬──────┘                                                        │
│          │                                                                  │
│          │ selected for                                                   │
│          ▼                                                                  │
│   ┌─────────────┐                                                        │
│   │  DECISION   │  Commitment to act                                       │
│   └─────────────┘                                                        │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Transition Definitions

#### Observation → Signal

**Trigger**: Discovery department detects a pattern in observations.

**Criteria**:
- Observation has been collected
- Pattern detected (not just raw data)
- Signal classified (opportunity, threat, trend, data)
- Priority assigned

**Owner**: Discovery Department

**Output**: Signal in "raw" state

---

#### Signal → Evidence

**Trigger**: Analysis department processes signals.

**Criteria**:
- Signal enriched with context
- Source verified
- Evidence strength assessed
- Claims extracted

**Owner**: Analysis Department

**Output**: Evidence chain supporting one or more claims

---

#### Evidence → Claim

**Trigger**: Analysis department assembles evidence into claims.

**Criteria**:
- At least one evidence supports the claim
- Claim statement is clear and testable
- Confidence assessed

**Owner**: Analysis Department

**Output**: Claim with confidence score

---

#### Claim → Insight

**Trigger**: Analysis department synthesizes multiple claims.

**Criteria**:
- Multiple claims synthesized
- Implications identified
- Related problems found
- Confidence rationale documented

**Owner**: Analysis Department

**Output**: Insight connecting claims to meaning

---

#### Insight → Hypothesis

**Trigger**: Planning department identifies research direction.

**Criteria**:
- Insight suggests testable proposition
- Success criteria defined
- Required experiments identified

**Owner**: Planning Department

**Output**: Hypothesis with test criteria

---

#### Hypothesis → Validated Claim

**Trigger**: Execution department runs experiments.

**Criteria**:
- Experiment completed
- Results match success criteria
- Validation gates passed
- Human review completed (if required)

**Owner**: Execution Department (with Validation oversight)

**Output**: Validated Claim

---

#### Validated Claim → Opportunity

**Trigger**: Planning department identifies potential action.

**Criteria**:
- Validated claim connects to problem
- Problem has solution potential
- Opportunity characteristics defined

**Owner**: Planning Department

**Output**: Opportunity with scoring

---

#### Opportunity → Decision

**Trigger**: Human selects an opportunity.

**Criteria**:
- Opportunity ranked
- Resources allocated
- Decision rationale documented
- Human approval obtained

**Owner**: Human (not a department)

**Output**: Decision with status

---

## 5. Knowledge Quality

Knowledge matures through levels of quality. Higher levels represent greater confidence and actionability.

### Maturity Levels

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         KNOWLEDGE MATURITY                                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Level 5: STRATEGIC INSIGHT                                              │
│   ┌───────────────────────────────────────────────────────────────────┐  │
│   │ • Validated claims synthesized into actionable understanding        │  │
│   │ • Confidence: 0.85+                                               │  │
│   │ • Multiple sources, strong evidence                               │  │
│   │ • Human-reviewed                                                   │  │
│   │ Example: "L2 adoption will accelerate 200% in Q3, driving        │  │
│   │           opportunities in cross-chain infrastructure"             │  │
│   └───────────────────────────────────────────────────────────────────┘  │
│                              ▲                                             │
│   Level 4: VALIDATED KNOWLEDGE                                            │
│   ┌───────────────────────────────────────────────────────────────────┐  │
│   │ • Passed all quality gates                                        │  │
│   │ • Confidence: 0.70-0.84                                          │  │
│   │ • Multiple supporting evidence                                    │  │
│   │ • Consistent with existing knowledge                               │  │
│   │ Example: "Arbitrum TVL grew 45% in April 2024"                 │  │
│   └───────────────────────────────────────────────────────────────────┘  │
│                              ▲                                             │
│   Level 3: VERIFIED CLAIM                                                 │
│   ┌───────────────────────────────────────────────────────────────────┐  │
│   │ • Evidence chain complete                                         │  │
│   │ • Confidence: 0.50-0.69                                          │  │
│   │ • Single authoritative source or multiple weak sources            │  │
│   │ • Awaiting additional validation                                  │  │
│   │ Example: "New DEX launched with innovative AMM mechanism"         │  │
│   └───────────────────────────────────────────────────────────────────┘  │
│                              ▲                                             │
│   Level 2: ASSERTED CLAIM                                                │
│   ┌───────────────────────────────────────────────────────────────────┐  │
│   │ • Claim made, evidence gathered                                   │  │
│   │ • Confidence: 0.30-0.49                                          │  │
│   │ • Evidence weak or incomplete                                     │  │
│   │ • Needs further investigation                                    │  │
│   │ Example: "Users prefer lower-fee DEXs based on social sentiment"  │  │
│   └───────────────────────────────────────────────────────────────────┘  │
│                              ▲                                             │
│   Level 1: HYPOTHESIS                                                     │
│   ┌───────────────────────────────────────────────────────────────────┐  │
│   │ • Testable proposition formed                                     │  │
│   │ • Confidence: 0.10-0.29                                          │  │
│   │ • No direct evidence yet                                          │  │
│   │ • Requires experiment to validate                                 │  │
│   │ Example: "Lower fees increase DEX adoption in emerging markets"    │  │
│   └───────────────────────────────────────────────────────────────────┘  │
│                              ▲                                             │
│   Level 0: SPECULATION                                                    │
│   ┌───────────────────────────────────────────────────────────────────┐  │
│   │ • No evidence, opinion only                                       │  │
│   │ • Confidence: 0.00-0.09                                           │  │
│   │ • Marked as speculation                                           │  │
│   │ • Not actionable until elevated                                   │  │
│   │ Example: "This new protocol will disrupt Uniswap"                  │  │
│   └───────────────────────────────────────────────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Quality Progression Rules

| From Level | To Level | Requirements |
|-----------|----------|--------------|
| 0 → 1 | Hypothesis formed, test criteria defined |
| 1 → 2 | Evidence gathered, initial confidence calculated |
| 2 → 3 | Evidence chain complete, source verified |
| 3 → 4 | Quality gates passed, consistency checked |
| 4 → 5 | Human review passed, strategic synthesis complete |

### Demotion Rules

Knowledge can be demoted if:

- Contradicting evidence emerges
- Knowledge becomes outdated
- Quality gates fail on revalidation
- Human review revokes approval

---

## 6. Ownership

Every entity has exactly one owning department. Ownership determines accountability for creation, maintenance, and retirement.

### Ownership Matrix

| Entity | Owner | Creator Event | Updater Event | Quality Gate | Retirement |
|--------|-------|--------------|---------------|--------------|------------|
| **Observation** | Discovery | ObservationCollected | ObservationUpdated | None | Auto-archive after 30d |
| **Signal** | Discovery | SignalsDetected | SignalProcessed | SignalCompleteness | Expired or superseded |
| **Evidence** | Analysis | EvidenceAssembled | EvidenceStrengthened | EvidenceThreshold | Merged or superseded |
| **Claim** | Analysis | ClaimExtracted | ClaimUpdated | ClaimCoherence | Contradicted or merged |
| **Insight** | Analysis | InsightGenerated | InsightRefined | InsightQuality | Superseded by new insight |
| **Hypothesis** | Planning | HypothesisCreated | HypothesisRefined | HypothesisTestability | Confirmed, refuted, or merged |
| **Experiment** | Execution | ExperimentCreated | ExperimentCompleted | ExperimentValidity | Complete |
| **Validated Claim** | Validation | ValidationPassed | — | All gates passed | Deprecated if contradicted |
| **Opportunity** | Planning | OpportunityIdentified | OpportunityScored | OpportunityCompleteness | Decided or abandoned |
| **Decision** | Human | DecisionMade | DecisionUpdated | DecisionRationale | Implemented or rejected |
| **Trend** | Analysis | TrendDetected | TrendUpdated | TrendEvidence | Fades or reverses |
| **Competitor** | Analysis | CompetitorIdentified | CompetitorUpdated | CompetitorVerification | Protocol deprecated |
| **Problem** | Analysis | ProblemIdentified | ProblemUpdated | ProblemValidation | Problem solved |

### Creation Events

Each entity is created by a specific engine event:

```
Signal:               SignalsDetected
Evidence:             EvidenceAssembled
Claim:                ClaimExtracted
Insight:              InsightGenerated
Hypothesis:           HypothesisCreated
Experiment:           ExperimentCreated
Validated Claim:      ValidationPassed
Opportunity:          OpportunityIdentified
Decision:             DecisionMade
Trend:                TrendDetected
Competitor:           CompetitorIdentified
Problem:              ProblemIdentified
```

### Update Events

Entities are updated by downstream events:

```
Signal:               SignalProcessed, SignalClassified
Evidence:             EvidenceStrengthened, EvidenceChallenged
Claim:                ClaimUpdated, ClaimContradicted
Insight:              InsightRefined, InsightExpanded
Hypothesis:           HypothesisRefined, HypothesisStatusChanged
Experiment:           ExperimentStarted, ExperimentCompleted
Opportunity:          OpportunityScored, OpportunityRanked
Trend:                TrendUpdated, TrendDirectionChanged
Competitor:           CompetitorUpdated, CompetitorRepositioned
Problem:              ProblemUpdated, ProblemAddressed
```

---

## 7. Knowledge Integrity

The knowledge graph must maintain invariants—rules that are never violated. Violations indicate system errors or data corruption.

### Structural Invariants

**I1: No Orphan Entities**

Every entity must have at least one relationship to another entity, except:
- Observations (leaves of the graph)
- Signals (may be standalone until processed)

```
✓ Valid: Signal → supports → Evidence → supports → Claim
✗ Invalid: Claim with no supporting Evidence
```

**I2: No Self-Referential Relationships**

No entity may have a relationship to itself.

```
✗ Invalid: Protocol → competes_with → (same) Protocol
```

**I3: Proper Entity Type**

Relationships must connect valid entity types.

```
✓ Valid: Opportunity → addresses → Problem
✗ Invalid: Opportunity → addresses → Signal
```

### Referential Invariants

**I4: Evidence References Valid Source**

Every Evidence must reference an actual Observation or Signal.

```
✓ Valid: Evidence → source → Observation(id="obs-123")
✗ Invalid: Evidence → source → NonExistentEntity
```

**I5: Claim Has Supporting Evidence**

Every Claim must have at least one supporting Evidence.

```
✓ Valid: Claim ← supports — Evidence ← source — Observation
✗ Invalid: Claim with no Evidence relationships
```

**I6: Validated Claim Passed Gates**

Every Validated Claim must have passed all quality gates.

```
✓ Valid: ValidatedClaim has ValidationPassed event
✗ Invalid: Entity marked Validated without passing gates
```

### Temporal Invariants

**I7: Valid Time Sequence**

For entities with temporal validity:
- `valid_from` must be before `valid_until`
- Transaction time must be after valid time

```
✓ Valid: valid_from=2024-01-01, valid_until=2024-06-01
✗ Invalid: valid_from=2024-06-01, valid_until=2024-01-01
```

**I8: Temporal Continuity**

When an entity is updated:
- New version has `valid_from` = update time
- Old version has `valid_until` = update time

### Domain Invariants

**I9: Opportunity References Problem**

Every Opportunity must reference at least one Problem.

```
✓ Valid: Opportunity → addresses → Problem
✗ Invalid: Opportunity with no Problem reference
```

**I10: Decision References Opportunity**

Every Decision must reference exactly one Opportunity.

```
✓ Valid: Decision → selects → Opportunity
✗ Invalid: Decision with no Opportunity reference
```

**I11: Decision Made by Human**

Every Decision must have a human decision maker.

```
✓ Valid: Decision → decided_by → Human(reviewer)
✗ Invalid: Decision with decision_maker = "system"
```

**I12: Hypothesis Has Test Criteria**

Every Hypothesis must define success criteria.

```
✓ Valid: Hypothesis has tests defined (non-empty)
✗ Invalid: Hypothesis with no test criteria
```

**I13: Experiment References Hypothesis**

Every Experiment must reference exactly one Hypothesis.

```
✓ Valid: Experiment → tests → Hypothesis
✗ Invalid: Experiment with no Hypothesis reference
```

### Quality Invariants

**I14: Confidence Range**

Every entity with a confidence score must have it in [0.0, 1.0].

**I15: Evidence Chain Completeness**

Evidence chains must be complete:
- Every Evidence must have a source
- Every source must be reachable from an Observation

**I16: No Duplicate Entities**

No two entities may represent the same real-world object.

```
✓ Valid: Single Solution("Acme Product")
✗ Invalid: Solution("Acme Product") + Solution("Acme Product V2") as separate entities
```

---

## 8. Extensibility

The knowledge model must evolve without breaking. New entity types can be added; existing entity types can be extended.

### Adding New Entity Types

New entity types are added without modifying existing types:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    ADDING NEW ENTITY TYPE                                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Step 1: Define Entity                                                     │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Add to this document:                                               │   │
│   │ • Name and definition                                              │   │
│   │ • Purpose                                                         │   │
│   │ • Required properties                                             │   │
│   │ • Constraints                                                     │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   Step 2: Define Relationships                                             │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Add to relationship catalog:                                        │   │
│   │ • How new entity relates to existing entities                      │   │
│   │ • Directionality                                                   │   │
│   │ • Properties                                                       │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   Step 3: Assign Ownership                                                │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Add to ownership matrix:                                           │   │
│   │ • Owning department                                                │   │
│   │ • Creation event                                                   │   │
│   │ • Quality gates                                                    │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   Step 4: Define Invariants                                              │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Add structural rules:                                               │   │
│   │ • What relationships must exist                                      │   │
│   │ • What must reference this entity                                  │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
│   Step 5: Update Schema                                                   │
│   ┌───────────────────────────────────────────────────────────────────┐   │
│   │ Update entity-schemas.md:                                           │   │
│   │ • Add JSON Schema for new entity                                   │   │
│   │ • Update graph schema                                               │   │
│   └───────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Example: Adding "Technology" Entity

Suppose we need to add a "Technology" entity for tracking infrastructure components:

```
1. Define Entity
   Technology: A technical component or standard used by protocols
   
2. Define Relationships
   - Protocol uses Technology
   - Technology enables Protocol
   - Technology supersedes Technology (versioning)

3. Assign Ownership
   - Owner: Analysis
   - Creation: TechnologyIdentified
   - Quality Gate: TechnologyVerification

4. Define Invariants
   - I-NEW-1: Technology must be referenced by at least one Protocol
   - I-NEW-2: Technology must have a category

5. Update Schema
   - Add to entity-schemas.md
   - Add to graph-schema.md
```

### Extending Existing Entities

New properties can be added to existing entities without breaking changes:

```
Non-breaking:
✓ Add optional property
✓ Add derived property (computed from existing)
✓ Add relationship type

Breaking (requires version bump):
✗ Remove required property
✗ Change property type
✗ Remove relationship type
```

### Version Compatibility

The knowledge model uses semantic versioning:

| Change | Version Bump |
|--------|-------------|
| Add entity type | Minor |
| Add optional property | Minor |
| Add relationship type | Minor |
| Add required property | Major |
| Remove property | Major |
| Change relationship semantics | Major |

---

## Dependencies

This document defines the canonical knowledge model that all other system components reference.

- `03-departments/departments.md` — Departments that create and maintain entities
- `02-engine/research-loop.md` — Engine that orchestrates entity lifecycle
- `06-quality/quality-gates.md` — Quality gates entities must pass
- `06-quality/evidence-model.md` — Evidence standards that support claims

## Related Documents

- `04-knowledge/entity-schemas.md` — JSON Schema for entities
- `04-knowledge/graph-schema.md` — Graph relationship definitions
- `04-knowledge/taxonomy.md` — Classification taxonomy for entities

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
