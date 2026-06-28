# Scoring Model

**Document ID**: 04.3
**Domain**: Quality
**Status**: Draft

---

## Purpose

Defines the methodology for scoring opportunities and signals. Provides consistent, auditable prioritization that combines multiple factors into actionable rankings.

## Audience

- Analysts (for understanding rankings)
- Planners (for mission prioritization)
- Researchers (for understanding signals)

## Scoring Philosophy

> Scores should be:
> - **Reproducible**: Same inputs always produce same outputs
> - **Transparent**: Each factor's contribution is visible
> - **Adjustable**: Weights can be tuned based on results
> - **Auditable**: Every score can be traced to its components

---

## Opportunity Scoring

### Score Components

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                     OPPORTUNITY SCORE BREAKDOWN                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   Total Score = Σ(Component × Weight)                                        │
│                                                                             │
│   ┌──────────────┐                                                          │
│   │ Market Size │  Weight: 25%                                              │
│   │    (25%)    │  How large is the opportunity?                           │
│   └──────────────┘                                                          │
│         │                                                                   │
│         ▼                                                                   │
│   ┌──────────────┐                                                          │
│   │ Feasibility │  Weight: 25%                                              │
│   │    (25%)    │  Can we actually execute?                                 │
│   └──────────────┘                                                          │
│         │                                                                   │
│         ▼                                                                   │
│   ┌──────────────┐                                                          │
│   │   Timing    │  Weight: 20%                                              │
│   │    (20%)    │  Is now the right time?                                  │
│   └──────────────┘                                                          │
│         │                                                                   │
│         ▼                                                                   │
│   ┌──────────────┐                                                          │
│   │ Competition │  Weight: 15%                                              │
│   │    (15%)    │  How crowded is the space?                               │
│   └──────────────┘                                                          │
│         │                                                                   │
│         ▼                                                                   │
│   ┌──────────────┐                                                          │
│   │     Risk    │  Weight: 15%                                              │
│   │    (15%)    │  What could go wrong?                                     │
│   └──────────────┘                                                          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### Component Definitions

#### 1. Market Size (25%)

**Question**: How large is the potential market?

**Inputs**:
- TAM (Total Addressable Market)
- SAM (Serviceable Addressable Market)
- SOM (Serviceable Obtainable Market)
- Growth rate
- Market trends

**Calculation**:

```
Market Score = (Market_Reach × 0.4) + (Growth_Rate × 0.3) + (Trend_Strength × 0.3)

Where:
- Market_Reach = log10(SAM) / 10 (normalized to 0-1)
- Growth_Rate = min(annual_growth_rate / 0.5, 1.0) (capped at 50%)
- Trend_Strength = signal_strength_for_market (0-1)
```

**Evidence Requirements**:
- Market size from primary sources
- Growth projections from reports
- Trend data from analytics

---

#### 2. Feasibility (25%)

**Question**: Can we realistically capture this opportunity?

**Inputs**:
- Technical complexity
- Resource requirements
- Our current capabilities
- Competitive advantages
- Resource fit score

**Calculation**:

```
Feasibility Score = (Tech_Fit × 0.3) + (Resource_Fit × 0.3) + (Advantage × 0.2) + (Complexity × 0.2)

Where:
- Tech_Fit = how well opportunity matches our capabilities (0-1)
- Resource_Fit = do we have required resources? (0-1)
- Advantage = competitive advantage strength (0-1)
- Complexity = inverse of technical difficulty (1 - difficulty)
```

**Evidence Requirements**:
- Technical assessment
- Resource audit
- Competitive analysis

---

#### 3. Timing (20%)

**Question**: Is now the right time?

**Inputs**:
- Time-criticality
- Market readiness
- Competitive urgency
- Seasonal factors
- Regulatory timeline

**Calculation**:

```
Timing Score = (Window_Openness × 0.4) + (Competitive_Pressure × 0.3) + (Market_Readiness × 0.3)

Where:
- Window_Openness = is the opportunity window open? (0-1)
- Competitive_Pressure = how quickly do we need to act (0-1, higher = more urgent)
- Market_Readiness = is market ready for solution? (0-1)
```

**Evidence Requirements**:
- Market timing signals
- Competitive activity
- Regulatory developments

---

#### 4. Competition (15%)

**Question**: How crowded is the space?

**Inputs**:
- Number of competitors
- Competitor strength
- Market saturation
- Differentiation potential

**Calculation**:

```
Competition Score = (1 - Saturation × 0.5) + (Differentiation × 0.5)

Where:
- Saturation = market_saturation_level (0-1, higher = more saturated)
- Differentiation = our differentiation potential (0-1)
```

**Evidence Requirements**:
- Competitor landscape
- Market share data
- Differentiation analysis

---

#### 5. Risk (15%)

**Question**: What could go wrong?

**Inputs**:
- Technical risks
- Market risks
- Regulatory risks
- Execution risks
- Financial risks

**Calculation**:

```
Risk Score = 1 - (Technical_Risk × 0.25 + Market_Risk × 0.25 + Regulatory_Risk × 0.25 + Execution_Risk × 0.25)

Where:
- Each risk = severity × likelihood (0-1 scale)
```

**Evidence Requirements**:
- Risk assessment
- Scenario analysis
- Historical precedents

---

### Score Aggregation

```python
def calculate_opportunity_score(opportunity):
    components = {
        'market_size': calculate_market_score(opportunity),
        'feasibility': calculate_feasibility_score(opportunity),
        'timing': calculate_timing_score(opportunity),
        'competition': calculate_competition_score(opportunity),
        'risk': calculate_risk_score(opportunity)
    }
    
    weights = {
        'market_size': 0.25,
        'feasibility': 0.25,
        'timing': 0.20,
        'competition': 0.15,
        'risk': 0.15
    }
    
    total = sum(components[k] * weights[k] for k in components)
    
    return {
        'total': round(total * 100, 1),  # 0-100 scale
        'components': {k: round(v * 100, 1) for k, v in components.items()},
        'weights': weights,
        'methodology': 'weighted_sum',
        'calculated_at': datetime.now().isoformat()
    }
```

---

## Signal Scoring

### Priority Classification

| Score Range | Priority | Description | Action |
|-------------|----------|-------------|--------|
| 80-100 | Critical | Immediate attention required | Alert + Process immediately |
| 60-79 | High | Important, process soon | Include in daily cycle |
| 40-59 | Medium | Monitor closely | Include in weekly review |
| 20-39 | Low | Background monitoring | Store for trend analysis |
| 0-19 | Minimal | Minimal relevance | Archive |

### Signal Components

```
Signal Score = (Novelty × 0.3) + (Relevance × 0.3) + (Credibility × 0.2) + (Urgency × 0.2)
```

| Component | Weight | Description |
|-----------|--------|-------------|
| **Novelty** | 30% | How new/unexpected is this? |
| **Relevance** | 30% | How relevant to our focus areas? |
| **Credibility** | 20% | Source reliability and evidence |
| **Urgency** | 20% | Time-sensitive factors |

---

## Scoring Adjustments

### Manual Overrides

**Authorized Personnel**: Lead Researcher, Operations Lead

**Override Process**:
1. Document override reason
2. Record override authority
3. Flag in scoring record
4. Review override effectiveness quarterly

**Override Limits**:
- Score adjustment: ±20 points maximum
- Must maintain minimum evidence threshold

### Confidence Adjustments

Scores adjusted based on evidence confidence:

| Evidence Confidence | Score Adjustment |
|--------------------|--------------------|
| 0.90+ | No adjustment |
| 0.70-0.89 | -5 points |
| 0.50-0.69 | -10 points |
| < 0.50 | -20 points, flag for review |

---

## Score Interpretation Guide

| Total Score | Interpretation | Recommended Action |
|-------------|----------------|-------------------|
| 80-100 | Excellent opportunity | Prioritize immediately |
| 70-79 | Strong opportunity | Include in next cycle |
| 60-69 | Good opportunity | Include in weekly planning |
| 50-59 | Moderate opportunity | Monitor for improvement |
| 40-49 | Below average | Requires improvement to pursue |
| < 40 | Weak opportunity | Deprioritize unless strategic |

---

## Score Tracking

### Historical Tracking

Every score includes:
- Timestamp
- Input factors
- Methodology version
- Authority (system or human)
- Previous score (if updated)

### Score Decay

| Evidence Age | Score Adjustment |
|-------------|------------------|
| < 7 days | None |
| 7-30 days | -5% |
| 30-90 days | -15% |
| > 90 days | -30%, flag for review |

---

## Dependencies

- `evidence-model.md` — Evidence standards for scoring
- `quality-gates.md` — Quality gate integration
- `taxonomy.md` — Opportunity classification

## Related Documents

- `gap-detection.md` — Gap-based scoring
- `daily-cycle.md` — Using scores in daily operations

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
