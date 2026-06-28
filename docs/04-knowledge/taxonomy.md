# Taxonomy

**Document ID**: 02.3
**Domain**: Knowledge
**Status**: Draft

---

## Purpose

Defines the hierarchical classification system used to categorize entities, opportunities, and concepts consistently across the knowledge base.

## Audience

- Researchers (for consistent tagging)
- Analysts (for classification queries)
- Engineers (for implementing categorization)

## Design Principles

1. **Exhaustive**: Every entity should fit somewhere
2. **Mutually Exclusive**: Categories should not overlap significantly
3. **Clearly Defined**: Each category has an unambiguous definition
4. **Extensible**: New categories can be added without breaking existing ones
5. **Stable**: Core categories should rarely change

---

## Entity Classification Hierarchy

```
Entity
├── Protocol
│   ├── DeFi Primitives
│   │   ├── DEX
│   │   ├── Lending
│   │   ├── Yield Aggregator
│   │   ├── Derivatives
│   │   ├── Options
│   │   └── Stablecoins
│   ├── Infrastructure
│   │   ├── Layer 1
│   │   ├── Layer 2
│   │   ├── Bridge
│   │   └── Oracle
│   ├── Application
│   │   ├── NFT
│   │   ├── Gaming
│   │   ├── Social
│   │   └── Productivity
│   └── DAO
│
├── Project
│   ├── dApp
│   ├── Protocol Implementation
│   ├── Tooling
│   └── Research
│
├── Organization
│   ├── DAO
│   ├── VC / Fund
│   ├── Exchange
│   └── Service Provider
│
├── Person
│   ├── Founder
│   ├── Developer
│   ├── Investor
│   └── Researcher
│
├── Concept
│   ├── Mechanism
│   ├── Standard
│   ├── Pattern
│   └── Theory
│
├── Event
│   ├── Launch
│   ├── Incident
│   ├── Governance
│   ├── Funding
│   └── Partnership
│
├── Opportunity
│   ├── Market Entry
│   ├── Integration
│   ├── Partnership
│   ├── Investment
│   └── Acquisition
│
├── Trend
│   ├── Technology
│   ├── Market
│   ├── Regulatory
│   └── Social
│
└── Threat
    ├── Technical Risk
    ├── Market Risk
    ├── Regulatory Risk
    └── Competitive Risk
```

---

## Protocol Categories

### DeFi Primitives

| Category | Definition | Examples |
|----------|-----------|----------|
| **DEX** | Decentralized exchanges for token swaps | Uniswap, Curve, Balancer |
| **Lending** | Protocols for borrowing/lending assets | Aave, Compound, MakerDAO |
| **Yield Aggregator** | Strategies that optimize yield across protocols | Yearn, Convex, Beefy |
| **Derivatives** | Synthetic assets and structured products | Synthetix, dYdX |
| **Options** | Protocols for options trading | Hegic, Dopex, Lyra |
| **Stablecoins** | Price-stable tokens | USDC, USDT, DAI |

### Infrastructure

| Category | Definition | Examples |
|----------|-----------|----------|
| **Layer 1** | Base blockchain networks | Ethereum, Solana, Avalanche |
| **Layer 2** | Scaling solutions built on L1s | Arbitrum, Optimism, zkSync |
| **Bridge** | Cross-chain asset transfer protocols | LayerZero, Wormhole, Axelar |
| **Oracle** | External data providers for smart contracts | Chainlink, Band Protocol |

### Application Categories

| Category | Definition | Examples |
|----------|-----------|----------|
| **NFT** | Non-fungible token platforms and marketplaces | OpenSea, Blur, Magic Eden |
| **Gaming** | GameFi and blockchain gaming platforms | Axie Infinity, Illuvium |
| **Social** | Decentralized social networks | Lens Protocol, Friend.tech |
| **Productivity** | Work and collaboration tools | Gitcoin, Rabbithole |

---

## Ecosystem Classification

```
Ecosystem
├── Ethereum
│   ├── Mainnet
│   ├── Arbitrum
│   ├── Optimism
│   └── Polygon
├── Solana
├── Avalanche
├── Polygon
├── BSC
├── Cosmos
│   ├── Cosmos Hub
│   └── IBC Chains
├── Arbitrum
├── Base
└── Other
```

---

## Opportunity Classification

### By Type

| Type | Definition |
|------|------------|
| **Market Entry** | Entering a new market or vertical |
| **Integration** | Integrating with existing protocols |
| **Partnership** | Strategic partnerships or collaborations |
| **Investment** | Investment opportunities (token, equity) |
| **Acquisition** | Acquiring or merging with other entities |
| **Product Extension** | Extending existing products |
| **Geographic** | Expanding to new geographies |
| **User Segment** | Targeting new user demographics |
| **Protocol Creation** | Building new protocols |

### By Phase

| Phase | Definition |
|-------|------------|
| **Emerging** | Early stage, high uncertainty, high potential |
| **Growing** | Active growth, increasing adoption |
| **Mature** | Established market, stable growth |
| **Declining** | Market contracting or losing relevance |

### By Confidence

| Level | Score Range | Definition |
|-------|-------------|------------|
| **Certain** | 0.95 - 1.00 | Very high confidence |
| **High** | 0.80 - 0.94 | High confidence based on evidence |
| **Medium** | 0.60 - 0.79 | Moderate confidence |
| **Low** | 0.40 - 0.59 | Low confidence, needs validation |
| **Speculative** | 0.20 - 0.39 | Hypothesis, highly uncertain |
| **Rejected** | 0.00 - 0.19 | Evidence suggests this is unlikely |

---

## Trend Classification

### By Type

| Type | Definition |
|------|------------|
| **Technology** | Technical innovations and improvements |
| **Market** | Market dynamics and economic shifts |
| **Regulatory** | Legal and regulatory developments |
| **Social** | Cultural and community trends |

### By Impact

| Impact | Definition |
|--------|------------|
| **Transformative** | Will fundamentally change the ecosystem |
| **Significant** | Will have notable effects |
| **Moderate** | Worth monitoring but not game-changing |
| **Minor** | Marginal impact |

### By Timeframe

| Timeframe | Definition |
|-----------|------------|
| **Immediate** | Effect within 0-3 months |
| **Short-term** | Effect within 3-12 months |
| **Medium-term** | Effect within 1-3 years |
| **Long-term** | Effect beyond 3 years |

---

## Tag Taxonomy

For flexible categorization beyond hierarchical classification:

### Status Tags

```
status:active
status:paused
status:deprecated
status:acquired
status:merged
```

### Quality Tags

```
quality:verified
quality:high-confidence
quality:needs-validation
quality:disputed
```

### Priority Tags

```
priority:critical
priority:high
priority:medium
priority:low
```

### Domain Tags

```
domain:defi
domain:nft
domain:gaming
domain:dao
domain:infrastructure
domain:cefi
```

---

## Classification Guidelines

### Rules for Classifying Entities

1. **Primary Classification**: Every entity has one primary classification
2. **Secondary Classifications**: Entities can have multiple secondary tags
3. **Specificity**: Prefer specific categories over general ones
4. **Consistency**: Use the same classification across similar entities
5. **Review**: Classifications should be reviewed during quality gates

### Classification Examples

| Entity | Primary Type | Secondary Tags |
|--------|--------------|----------------|
| Uniswap V3 | Protocol > DeFi > DEX | ecosystem:ethereum, status:active |
| Aave | Protocol > DeFi > Lending | ecosystem:ethereum, status:active |
| Vitalik Buterin | Person > Founder | org:ethereum-foundation |
| Paradigm | Organization > VC | focus:research |
| ETH Bull Run | Event > Market | impact:significant, timeframe:medium-term |

---

## Dependencies

- `knowledge-model.md` — Conceptual foundation
- `entity-schemas.md` — Schema definitions for categories
- `scoring-model.md` — Opportunity scoring methodology

## Related Documents

- `gap-detection.md` — Detecting gaps in coverage
- `evidence-model.md` — Evidence for classifications

## Maintenance

Review taxonomy quarterly for:
- New categories needed
- Deprecated categories
- Ambiguous definitions
- Classification drift

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
