# Limitations: What This Engine Cannot Determine

> **Purpose:** Explicit documentation of research engine limitations to ensure honest, accurate outputs.

---

## Overview

This research engine operates on publicly available data, aggregated sources, and secondary research methodologies. This document explicitly defines what the system **cannot** determine without primary research, user-provided data, or direct access to private information.

**Core Principle:** When in doubt, flag the limitation rather than fabricate an answer.

---

## Cannot Determine Patterns

The following patterns are standard limitation declarations used throughout research outputs:

| Pattern | When Applied |
|---------|---------------|
| `Cannot determine X without Y` | Primary data missing |
| `Requires direct access to Z` | Private or restricted data |
| `Insufficient evidence for Q` | Confidence below threshold |

---

## Market Research Limitations

### Revenue and Financials

- **Cannot determine YOUR specific revenue** without direct financial disclosures, tax filings, or investor presentations
- **Cannot determine competitor revenue** without SEC filings, earnings calls, or voluntary disclosures
- **Cannot determine unit economics** without cost breakdowns the company has not published
- **Cannot determine burn rate** without direct access to cap tables or financial statements
- **Cannot determine customer LTV** without proprietary sales data

### Market Position

- **Cannot determine YOUR market share** without industry-specific reporting or direct company disclosure
- **Cannot determine competitor market share** without verified third-party data sources
- **Cannot predict market shifts** without real-time data feeds and direct industry access
- **Cannot determine pricing strategy effectiveness** without A/B test results or sales data

### Competitive Intelligence

- **Cannot determine unreleased product features** without insider access or official announcements
- **Cannot determine internal strategy decisions** without direct company statements or leaks
- **Cannot determine unannounced funding rounds** without regulatory filings or direct sources
- **Cannot determine executive decisions** without official communications or verified insider information

---

## Data Gaps

### Private Company Data

The engine cannot access:

- Private company financials (P&L, balance sheets, cash flow statements)
- Internal roadmaps and strategic plans
- Undisclosed customer metrics
- Private equity or VC fund documents
- NDA-protected information

### Unreleased Information

The engine cannot determine:

- Product features in development
- Acquisitions or mergers before announcement
- Leadership changes before official statement
- Regulatory decisions before publication
- Market entry timing for unrevealed products

### Internal Decision-Making

The engine cannot assess:

- Board-level strategic priorities
- Internal disagreement or organizational conflicts
- Employee sentiment without surveys
- Cultural factors without direct engagement
- Management conviction beyond public statements

---

## Primary Research Requirements

### Requires Customer Interviews

The following **require direct customer interviews** to determine:

| Research Area | Primary Research Need |
|---------------|----------------------|
| Customer sentiment | Direct interviews or surveys |
| User preferences | A/B testing or interviews |
| Pain points | User interviews or support data |
| Feature prioritization | Customer feedback sessions |
| Willingness to pay | Pricing interviews |

### Requires Market Surveys

The following **require structured market surveys**:

| Research Area | Primary Research Need |
|---------------|----------------------|
| TAM estimates | Primary market surveys |
| Market share | Industry-wide surveys |
| Adoption rates | Direct market sampling |
| Customer demographics | Survey data |
| Purchase intent | Survey research |

### Requires Financial Analysis

The following **require direct financial analysis**:

| Research Area | Primary Research Need |
|---------------|----------------------|
| Revenue figures | Financial disclosures |
| Cost structure | Detailed financial data |
| Unit economics | Transaction-level data |
| Profitability | Complete P&L data |
| Cash flow | Direct financial access |

---

## Honest Limitations by Research Type

### DeFi Protocol Research

**Cannot determine without on-chain analytics or disclosures:**

- True daily active users (vs. Sybil/gaming)
- Actual revenue vs. token inflation
- Real TVL sustainability
- Developer team identity and competence
- Long-term protocol sustainability

### NFT Market Research

**Cannot determine without transaction data:**

- True collection holder distribution
- Wash trading vs. organic volume
- Floor price sustainability
- Creator royalty enforcement
- Market manipulation presence

### General Web3 Research

**Cannot determine without primary sources:**

- Founding team track record (without interviews)
- VC fund thesis and conviction level
- Community health beyond metrics
- Competitive moat durability
- Regulatory risk quantification

---

## Response Templates

When encountering limitations, use these standard responses:

### Template: Insufficient Data

```
**Limitation:** Cannot determine [specific claim] without [missing data type].

**Current Evidence:** [What we do have]
**Confidence Level:** [0-49% - Highly uncertain]
**Recommendation:** [Primary research action]
```

### Template: Private Information Required

```
**Limitation:** [Specific data] is not publicly available.

**Why:** [Reason for unavailability]
**What Would Help:** [Data source that would enable determination]
**Alternative Approach:** [Secondary research that could approximate]
```

### Template: Speculation Required

```
**Warning:** This analysis requires speculation beyond available evidence.

**Known:** [Verifiable facts]
**Inferred:** [Logical but unverified conclusions]
**Speculated:** [Hypothetical scenarios]
**Confidence:** [Low - significant uncertainty]
```

---

## Implementation Guidelines

1. **Always flag limitations** before providing analysis on affected topics
2. **Never fabricate** data points to fill gaps
3. **Provide pathways** to resolve limitations through primary research
4. **Update confidence scores** based on available evidence
5. **Document new limitations** discovered during research for future reference

---

## Quality Gates

Before publishing any research output:

1. Verify all "Cannot determine" patterns are properly flagged
2. Ensure confidence scores reflect data availability
3. Confirm primary research recommendations are actionable
4. Check that no private data claims are made without sourcing

---

*This document is the source of truth for research engine limitations. Updates require ADR approval.*
