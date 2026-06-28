# Web3 APIs Contract

**Document ID**: 06.4
**Domain**: Integration
**Status**: Draft

---

## Purpose

Defines standards for blockchain and protocol data ingestion. Ensures consistent data from diverse on-chain sources while maintaining provenance and quality.

## Audience

- Engineers (for implementation)
- Data engineers (for source management)
- Analysts (for data interpretation)

## Data Sources

### On-Chain Sources

| Source | Type | Data Provided | Priority |
|--------|------|---------------|----------|
| **The Graph** | Indexing | Protocol metrics, transactions | Critical |
| **Dune Analytics** | Analytics | Dashboard queries, charts | High |
| **DeFi Llama** | Aggregator | TVL, yields, protocol stats | Critical |
| **Nansen** | Analytics | Wallet labeling, fund flows | Medium |
| **Etherscan** | Explorer | Contract code, transactions | Medium |

### Off-Chain Sources

| Source | Type | Data Provided | Priority |
|--------|------|---------------|----------|
| **CoinGecko** | Price | Token prices, market data | Critical |
| **DefiLlama** | Yield | Yield rates, strategy data | High |
| **Twitter/X** | Social | Sentiment, announcements | High |
| **Discord** | Social | Community activity | Medium |

---

## Interface Definition

### Generic Web3 Adapter

```typescript
interface IWeb3Adapter {
  // Check source health
  healthCheck(): Promise<HealthStatus>;
  
  // Fetch data from source
  fetch<T>(endpoint: string, params?: FetchParams): Promise<T>;
  
  // Poll for updates
  poll<T>(config: PollConfig<T>): AsyncIterable<T[]>;
  
  // Get rate limit status
  getRateLimitStatus(): RateLimitStatus;
}
```

---

## Data Contracts

### Protocol Data

```typescript
interface ProtocolData {
  // Identity
  protocol: string;
  chain: string;
  
  // Metrics
  tvl: ValueWithCurrency;
  volume24h: ValueWithCurrency;
  fees24h: ValueWithCurrency;
  revenue24h: ValueWithCurrency;
  
  // User metrics
  users24h: number;
  transactions24h: number;
  
  // Token data (if applicable)
  tokenPrice?: number;
  tokenVolume24h?: number;
  
  // Timestamp
  timestamp: string;  // ISO 8601
  blockNumber?: number;
}

interface ValueWithCurrency {
  value: number;
  currency: string;  // USD, ETH, etc.
}
```

### Transaction Data

```typescript
interface TransactionData {
  // Identity
  hash: string;
  chain: string;
  
  // Classification
  type: 'swap' | 'lend' | 'borrow' | 'stake' | 'unstake' | 'transfer' | 'other';
  protocol?: string;
  
  // Participants
  from: string;  // Address
  to: string;    // Address
  value: string; // In native token
  
  // Token flows
  tokensIn: TokenFlow[];
  tokensOut: TokenFlow[];
  
  // Gas
  gasUsed?: number;
  gasPrice?: string;
  
  // Timestamp
  timestamp: string;
  blockNumber: number;
}

interface TokenFlow {
  token: string;   // Address
  symbol: string;
  amount: string;
  usdValue?: number;
}
```

### Governance Data

```typescript
interface GovernanceData {
  // Identity
  proposalId: string;
  protocol: string;
  chain: string;
  
  // Content
  title: string;
  description: string;
  discussionUrl?: string;
  
  // Status
  status: 'active' | 'passed' | 'failed' | 'executed' | 'queued' | 'expired';
  voteStart: string;
  voteEnd: string;
  
  // Results
  forVotes: number;
  againstVotes: number;
  abstainVotes: number;
  
  // Quorum
  quorumRequired?: number;
  quorumMet?: boolean;
}
```

---

## Source Adapters

### The Graph Adapter

```typescript
interface ITheGraphAdapter extends IWeb3Adapter {
  // Query subgraphs
  query<T>(subgraph: string, query: GraphQLQuery): Promise<T>;
  
  // Available subgraphs
  listSubgraphs(): Promise<Subgraph[]>;
  
  // Health of subgraphs
  getSubgraphHealth(subgraph: string): Promise<SubgraphHealth>;
}

// Example usage
const subgraph = 'uniswap/uniswap-v3';
const query = `
  query {
    pools(first: 5, orderBy: volumeUSD, orderDirection: desc) {
      id
      token0 { symbol }
      token1 { symbol }
      volumeUSD
      tvlUSD
    }
  }
`;
const pools = await adapter.query<Pool[]>(subgraph, { query });
```

### DeFi Llama Adapter

```typescript
interface IDeFiLlamaAdapter extends IWeb3Adapter {
  // Get protocol TVL
  getProtocolTVL(protocol: string): Promise<ProtocolTVL>;
  
  // Get chain TVL
  getChainTVL(chain: string): Promise<ChainTVL>;
  
  // Get yields
  getYields(pool?: string): Promise<YieldData[]>;
  
  // Get historical data
  getHistoricalTVL(protocol: string, days: number): Promise<HistoricalTVL[]>;
}
```

---

## Configuration

### Source Registry

```yaml
sources:
  the_graph:
    name: "The Graph"
    base_url: "https://gateway.thegraph.com/api/{api_key}/subgraphs/id"
    rate_limits:
      requests_per_minute: 50
      queries_per_minute: 1000
      
  defi_llama:
    name: "DeFi Llama"
    base_url: "https://api.llama.fi"
    rate_limits:
      requests_per_minute: 30
      
  dune:
    name: "Dune Analytics"
    base_url: "https://api.dune.com/api/v1"
    rate_limits:
      requests_per_minute: 30
      concurrent: 5
```

### Polling Intervals

| Source | Data Type | Polling Interval | Rationale |
|--------|-----------|-----------------|-----------|
| The Graph | Real-time | 5 min | Near real-time |
| DeFi Llama | TVL/Yields | 15 min | Changes slowly |
| Dune | Analytics | 1 hour | Aggregated data |
| CoinGecko | Prices | 1 min | Fast-moving |
| Twitter | Sentiment | 5 min | Real-time |

---

## Data Quality

### Validation Rules

```typescript
const validationRules = {
  tvl: {
    min: 0,
    max: 1e12,  // Reasonable upper bound
    freshness: '1h'  // Must be recent
  },
  volume: {
    min: 0,
    sanity_check: (v, tvl) => v < tvl * 10  // Volume < 10x TVL
  },
  price: {
    min: 0,
    staleness: '5m'  // Must be very recent
  }
};
```

### Provenance Tracking

```typescript
interface ProvenanceRecord {
  source: string;
  endpoint: string;
  retrievedAt: string;
  responseTime: number;
  statusCode: number;
  cacheHit: boolean;
  dataFreshness: string;  // Age of data
}
```

---

## Error Handling

### Source Failures

| Error Type | Handling | Fallback |
|-----------|----------|----------|
| Rate limit | Retry with backoff | Alternative source |
| Timeout | Retry 3x | Stale data with flag |
| 4xx error | Log, skip | Alternative source |
| 5xx error | Retry with backoff | Stale data with flag |
| No data | Log warning | None |

### Data Freshness

```typescript
interface DataFreshness {
  data: any;
  freshness: {
    retrievedAt: string;
    dataTimestamp: string;
    age: number;  // milliseconds
    status: 'fresh' | 'stale' | 'expired';
  };
}
```

---

## Dependencies

- `06-integration/integration-overview.md` — Integration map
- `02-knowledge/entity-schemas.md` — Data format contracts

## Related Documents

- `06-integration/gemini-contract.md` — LLM integration
- `04-quality/evidence-model.md` — Evidence standards

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
