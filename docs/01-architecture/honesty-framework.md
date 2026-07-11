# Honesty Framework

**Purpose:** Ensure all research output is calibrated to reality, never overpromises, and delivers bad news as forcefully as good news.

**Scope:** All research output, confidence scores, and communications from this engine.

---

## 1. Confidence Scoring Scale

### 1.1 Scale Definition (0-100%)

| Score Range | Level | Label | Description |
|-------------|-------|-------|-------------|
| 90-100% | 4 | **High Confidence** | Multiple independent verified sources; well-established facts |
| 70-89% | 3 | **Medium Confidence** | Single authoritative source or multiple weak sources aligned |
| 50-69% | 2 | **Low Confidence** | Indirect evidence, weak correlation, or single anecdotal source |
| 0-49% | 1 | **Highly Uncertain** | Speculation, minimal data, or contradictory sources |

### 1.2 Score Calculation Methodology

**Formula:**

```
Confidence Score = (Source_Authority × 0.4) + (Source_Count × 0.3) + (Recency × 0.2) + (Consistency × 0.1)
```

**Factors:**

| Factor | Weight | Scoring Criteria |
|--------|--------|------------------|
| **Source Authority** | 40% | Official > Industry Report > News > Blog > Social |
| **Source Count** | 30% | 3+ = 100%, 2 = 70%, 1 = 50% |
| **Recency** | 20% | <3 months = 100%, 3-12 months = 80%, >12 months = 50% |
| **Consistency** | 10% | All sources agree = 100%, Partial = 60%, Contradictory = 20% |

**Minimum Thresholds:**

- Below 50% → Flag as "Cannot determine definitively"
- Below 30% → Explicitly state "This is speculative"
- Multiple contradictory sources → Auto-escalate to Highly Uncertain

---

## 2. Uncertainty Language Standards

### 2.1 Required Phrases by Confidence Level

All research output MUST use the matching phrase:

| Confidence | Required Prefix |
|------------|-----------------|
| 90-100% | "Based on verified data from [SOURCE-IDs]..." |
| 70-89% | "Evidence suggests..." |
| 50-69% | "Indications point to..." |
| 0-49% | "Cannot determine definitively; requires primary research" |

### 2.2 Prohibited Language

| Prohibited | Replace With |
|------------|--------------|
| "Clearly" | "Data indicates" |
| "Obviously" | "Consistently shows" |
| "Definitely" | "Confirmed by [SOURCE]" |
| "Always/Never" | "In documented cases" / "No documented cases" |
| "Guaranteed" | "High probability based on..." |
| "VCs love X" | "VCs have invested in X (see funding data)" |

### 2.3 Hedging Standards

**When to hedge:**
- Single source claims
- Predictions about future markets
- Revenue or financial estimates
- Private company data

**Acceptable hedges:**
- "Estimated at approximately..."
- "According to available data..."
- "Limited evidence suggests..."
- "Based on [X]'s public statements..."

---

## 3. Brutal Honesty Principles

### 3.1 When to Deliver Bad News Forcefully

These findings MUST be delivered with maximum clarity, never softened:

**Market Entry:**
- "This is NOT a greenfield opportunity"
- "You are LATE to this market by [X] months/years"
- "This market has [N] well-funded incumbents"

**Funding Climate:**
- "VC appetite is DECLINING for this sector"
- "This category saw [X]% decrease in funding in [period]"
- "No disclosed rounds in [X] months - signals investor retreat"

**Competitive Reality:**
- "Your differentiation claim is not supported by available data"
- "Competitor [X] has [Y]x your funding"
- "Your assumed moat is not defensible based on [evidence]"

### 3.2 Bad News Templates

**Template: Market Saturation**
```
BRUTAL ASSESSMENT: [Market Name]

This market is NOT enterable at scale based on current data:
- Top 3 players control [X]% of market
- Average funding per player: $[N]M
- Market growth rate: [X]% (below SaaS average of 20%)
- Your estimated time-to-market: [X] months (market may saturate by [date])

VERDICT: High risk of commoditization before profitability.
```

**Template: Competitive Disadvantage**
```
BRUTAL ASSESSMENT: Competitive Position

You face [N] competitors with significant advantages:
- [Competitor A]: [X]x your funding, [Y] years head start
- [Competitor B]: [X]x your team size in this domain
- [Competitor C]: [X]x your user base

Your assumed advantages:
- [Claimed advantage]: NOT supported by available evidence
- [Claimed advantage]: Partially supported, but insufficient for market entry

VERDICT: Reconsider market or pivot differentiation strategy.
```

**Template: Timing Failure**
```
BRUTAL ASSESSMENT: Entry Timing

You are [X] months/years late to this market.
- First-mover advantage window: CLOSED
- Incumbent lock-in: [Low/Medium/High]
- Migration costs for customers: [X] (determines incumbent stickiness)
- Your differentiation window: [X] months based on [evidence]

VERDICT: Without a structural advantage, entry is inadvisable.
```

---

## 4. Source Attribution Requirements

### 4.1 Mandatory Source Tracking

Every factual claim MUST include:

```
[CONFIDENCE: XX%] [SOURCE: SRC-XXX] [DATE: YYYY-MM-DD]
```

**Example:**
```
Bitcoin ETF approval drives institutional adoption.
[CONFIDENCE: 85%] [SOURCE: SRC-044, SRC-045] [DATE: 2026-07-10]
```

### 4.2 Source Quality Tiers

| Tier | Type | Confidence Boost |
|------|------|------------------|
| **Tier 1** | Official filings, SEC/regulatory documents | +20% |
| **Tier 2** | Peer-reviewed research, industry reports (Gartner, McKinsey) | +15% |
| **Tier 3** | Major news outlets (Reuters, Bloomberg, WSJ) | +10% |
| **Tier 4** | Industry blogs, company announcements | +5% |
| **Tier 5** | Social media, forums, unverified sources | 0% |

### 4.3 Contradictory Source Protocol

When sources contradict:

1. **Flag immediately**: "CONFLICTING SOURCES DETECTED"
2. **Report both positions** with confidence scores
3. **Do not resolve** - user must make judgment
4. **Default to lower confidence** until resolved

---

## 5. Quality Gates for Honesty

### 5.1 Pre-Output Checklist

Before any research output is delivered, verify:

- [ ] Every claim has a confidence score
- [ ] Every claim has a source reference
- [ ] Language matches confidence level (no over-promising)
- [ ] Bad news is delivered clearly, not softened
- [ ] Speculation is labeled as such
- [ ] No use of prohibited hedging language
- [ ] Contradictory sources are flagged

### 5.2 Confidence Score Validation

**Score inflation detection:**
- If all scores are 80%+, the analysis is likely over-confident
- Flag for review if >50% of claims are 90%+
- Real-world data rarely achieves >85% confidence

**Score deflation detection:**
- If all scores are below 50%, the analysis may lack rigor
- Review whether sources support higher confidence

### 5.3 Review Triggers

Escalate to human review when:
- Any claim scores below 30%
- Findings contradict user's stated assumptions
- Multiple contradictory sources exist
- Market timing assessment is negative
- Competitive position is assessed as unfavorable

---

## 6. Document History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2026-07-12 | Initial framework |

---

**Adopted:** 2026-07-12
**Owner:** Research Engine Architecture
**Review Cycle:** Quarterly
