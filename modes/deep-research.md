# Mode: deep-research — Comprehensive Investigation

<!-- ============================================================
     Read modes/_shared.md FIRST for system context.
     ============================================================ -->

## Purpose

Execute a comprehensive, multi-axis research investigation. Use when:
- High-stakes decision depends on the outcome
- Multiple dimensions need examination
- User needs thorough understanding before acting

**Time estimate:** 15-30 minutes of focused research

---

## Command Signature

```
/nav:research --domain <domain> --deep <query>
```

Or invoke directly:
```
/nav:research --mode deep --domain <domain> <query>
```

---

## 6-Axis Investigation Framework

Each research topic is examined across 6 axes. Not all apply to every topic — use judgment.

### Axis 1: Current State

**What it is right now:**
- Size, scope, market share
- Key players and their positions
- Current trends and trajectories
- Recent developments (last 6 months)

**Questions:**
- What is the current size/value?
- Who dominates? What's their moat?
- What's changed recently?
- What are the obvious signals?

---

### Axis 2: Market Dynamics

**Supply, demand, economics:**
- Revenue models and unit economics
- Customer segments and needs
- Pricing structures
- Growth rates and projections

**Questions:**
- How does money flow?
- Who pays for what?
- What drives growth?
- Is it economically sustainable?

---

### Axis 3: Competition Landscape

**Who's fighting for what:**
- Direct competitors
- Indirect competitors
- Substitutes
- New entrants

**Questions:**
- What differentiates players?
- What's the competitive moat?
- Where is the race being run?
- Are there uncontested spaces?

---

### Axis 4: Risks & Challenges

**What could go wrong:**
- Technical challenges
- Regulatory threats
- Market risks
- Execution risks

**Questions:**
- What are the failure modes?
- What are competitors struggling with?
- What could disrupt this?
- What's the 3-year outlook?

---

### Axis 5: Opportunities

**Where value can be captured:**
- Underserved segments
-未被满足的需求 (Unmet needs)
- Innovation gaps
- Timing advantages

**Questions:**
- What needs aren't being met?
- Where are margins thickest?
- What's someone new missing?
- What timing advantages exist?

---

### Axis 6: Decision Framework

**For the specific user question:**
- Evidence synthesis
- Confidence assessment
- Trade-offs
- Recommendation

**Format:**
```
Based on [Axis 1-5], here's the honest picture:

WHAT THIS MEANS: {direct assessment}
CONFIDENCE: {overall 0-100%}
TRADE-OFFS:
  - Pros: {bullet points}
  - Cons: {bullet points}
BOTTOM LINE: {one-sentence recommendation}
NEXT STEPS: {actionable items}
```

---

## Execution Workflow

### Step 1: Scope Definition

Before research, confirm scope:

```
For this deep research on "{query}", I'll cover:
1. Current state and key players
2. Market dynamics and economics
3. Competitive landscape
4. Risks and challenges
5. Opportunities
6. Honest recommendation

Is this scope correct? Any additional axes to add?
```

---

### Step 2: Parallel Discovery

Run searches for each axis simultaneously:

```
Axis 1: {query} current state 2024
Axis 2: {query} market size revenue
Axis 3: {query} competitors comparison
Axis 4: {query} challenges risks problems
Axis 5: {query} opportunities gaps opportunities
```

Target: 3-5 high-quality sources per axis.

---

### Step 3: Deep Verification

For each key claim:

1. **Source triangulation**
   - Primary source: official data, docs, filings
   - Secondary source: analysis, news
   - Tertiary source: social, forums (lowest confidence)

2. **Recency check**
   - Published within 3 months: full confidence
   - 3-6 months: -10% confidence
   - 6-12 months: -20% confidence
   - >1 year: flag as potentially stale

3. **Conflict detection**
   - Do sources agree?
   - What's the nature of disagreement?
   - How recent is the conflicting data?

---

### Step 4: Evidence Synthesis

Build evidence chains:

```
Key Finding: {claim}

Evidence:
- [SRC-001] {specific data point}
- [SRC-002] {specific data point}
- [SRC-003] {specific data point}

Verification Status: VERIFIED / CONFLICTING / UNVERIFIED
Confidence: {score}%

Analysis: {what this means}
```

---

### Step 5: HONEST ASSESSMENT

Write the brutal truth:

```
## HONEST ASSESSMENT

{4-6 sentences max. No fluff. Answer the original question directly.}

What this really means:
1. {Specific takeaway}
2. {Specific takeaway}
3. {Specific takeaway}

If I had to bet on one thing: {single most important insight}
```

---

## Output Template

```
# Deep Research Report: {Topic}

**Generated:** {date}
**Domain:** {domain}
**Scope:** {confirmed scope}
**Overall Confidence:** {0-100%}

---

## Executive Summary
{Max 3 sentences. The brutal truth.}

---

## Axis 1: Current State

### Key Players
| Player | Position | Source | Confidence |
|--------|----------|--------|------------|
| | | | |

### Current Trends
- [Finding] [SRC-XXX] [Confidence: XX%]

---

## Axis 2: Market Dynamics

### Economics
- [Finding] [SRC-XXX] [Confidence: XX%]

### Growth
- [Finding] [SRC-XXX] [Confidence: XX%]

---

## Axis 3: Competition

### Landscape
{Competitive positioning summary}

### Moats
- [Moat 1] [SRC-XXX] [Confidence: XX%]
- [Moat 2] [SRC-XXX] [Confidence: XX%]

---

## Axis 4: Risks

| Risk | Severity | Likelihood | Evidence |
|------|----------|------------|----------|
| | High/Med/Low | High/Med/Low | |

---

## Axis 5: Opportunities

| Opportunity | TAM | Timing | Confidence |
|-------------|-----|--------|------------|
| | | | |

---

## Axis 6: Decision Framework

### Evidence Synthesis
{Summary of key evidence}

### HONEST ASSESSMENT
{Required section — brutal truth}

### Trade-offs
**Pros:**
- {bullet}

**Cons:**
- {bullet}

### Recommendation
{Clear recommendation or "insufficient data"}

### Next Steps
1. {Actionable item}
2. {Actionable item}

---

## Source Index

[SRC-001] {Title}
URL: {url}
Type: {primary/secondary/tertiary}
Reliability: {high/medium/low}

... (all sources used)

---

## Limitations
{What couldn't be determined}
```

---

## Quality Checklist

Before outputting:

- [ ] All 6 axes covered (or justified why skipped)
- [ ] Every claim has `[SRC-XXX]`
- [ ] Every claim has confidence score
- [ ] Conflicts explicitly flagged
- [ ] HONEST ASSESSMENT present and direct
- [ ] No unsupported assertions
- [ ] Recommendation matches evidence
- [ ] Next steps are actionable

---

## Time Management

**Timebox each phase:**

| Phase | Time | Focus |
|-------|------|-------|
| Scope Definition | 2 min | Confirm direction |
| Discovery | 8 min | Get sources |
| Verification | 10 min | Validate claims |
| Synthesis | 5 min | Build findings |
| Output | 5 min | Write report |

**If running low on time:**
- Cut to 3 axes: Current State, Risks, Recommendation
- Focus on highest-confidence findings
- Flag what couldn't be covered

---

## Tools by Phase

| Phase | Primary Tools | Fallback |
|-------|---------------|----------|
| Discovery | WebSearch | WebFetch for known pages |
| Verification | WebFetch | Playwright for dynamic |
| Synthesis | Read local files | WebSearch for gaps |

---

## Integration

Read for context:
- `docs/01-architecture/web-research-architecture.md`
- `docs/01-architecture/verification-layer.md`
- `docs/01-architecture/honesty-framework.md`

This mode implements the full research specification.
