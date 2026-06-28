# Consumr.ai Contract

**Document ID**: 06.3
**Domain**: Integration
**Status**: Draft

---

## Purpose

Defines the contract for Consumr.ai consumer study integration. Enables ingestion of consumer research data to inform opportunity identification and validation.

## Audience

- Engineers (for implementation)
- Researchers (for understanding data)
- Analysts (for study interpretation)

## Integration Overview

Consumr.ai provides consumer research studies containing:
- User behavior data
- Preference surveys
- Market sentiment
- Trend indicators

This data enriches the ROS's understanding of user needs and market demand.

---

## Interface Definition

### Core Operations

```typescript
interface IConsumrService {
  // List available studies
  listStudies(filter?: StudyFilter): Promise<StudyList>;
  
  // Get study details
  getStudy(studyId: string): Promise<Study>;
  
  // Get study data
  getStudyData(studyId: string): Promise<StudyData>;
  
  // Subscribe to new studies
  subscribe(callback: (study: Study) => void): Promise<Subscription>;
  
  // Health check
  healthCheck(): Promise<HealthStatus>;
}
```

---

## Data Types

### Study

```typescript
interface Study {
  // Identity
  id: string;
  title: string;
  description: string;
  
  // Classification
  category: StudyCategory;
  tags: string[];
  
  // Metadata
  publishedAt: string;  // ISO 8601
  sampleSize: number;
  methodology: string;
  
  // Coverage
  regions: string[];
  demographics: DemographicInfo;
  
  // Links
  reportUrl: string;
  dataUrl: string;
}

type StudyCategory =
  | 'defi_adoption'
  | 'nft_usage'
  | 'wallet_behavior'
  | 'trading_patterns'
  | 'protocol_preference'
  | 'user_sentiment'
  | 'emerging_trends';
```

### Study Data

```typescript
interface StudyData {
  // Reference
  studyId: string;
  retrievedAt: string;
  
  // Summary statistics
  summary: StudySummary;
  
  // Key findings
  findings: Finding[];
  
  // Raw data (if available)
  rawData?: DataTable[];
  
  // Charts/visualizations
  visualizations?: Visualization[];
}

interface StudySummary {
  totalRespondents: number;
  completionRate: number;
  confidence: number;
  keyMetric: KeyMetric[];
}

interface Finding {
  id: string;
  statement: string;          // e.g., "65% of users prefer DEX over CEX"
  supportingData: string[];   // References to raw data
  confidence: number;        // 0.0 - 1.0
  relevance: number;          // 0.0 - 1.0 (relevance to Web3 research)
}

interface KeyMetric {
  name: string;
  value: number;
  unit: string;
  comparison?: {
    previousValue: number;
    changePercent: number;
  };
}
```

---

## Data Format

### Example Study Response

```json
{
  "id": "study_2024_06_crypto_adoption",
  "title": "Q2 2024 Cryptocurrency Adoption Survey",
  "description": "Survey of 10,000 cryptocurrency users on adoption patterns",
  "category": "defi_adoption",
  "tags": ["adoption", "retail", "institutional"],
  "publishedAt": "2024-06-15T00:00:00Z",
  "sampleSize": 10000,
  "methodology": "Online survey with stratified sampling",
  "regions": ["North America", "Europe", "Asia Pacific"],
  "demographics": {
    "ageRange": "18-65",
    "cryptoExperience": "6 months - 5+ years"
  },
  "reportUrl": "https://consumr.ai/reports/study_2024_06",
  "dataUrl": "https://consumr.ai/data/study_2024_06"
}
```

---

## Integration Configuration

### Connection Settings

```yaml
consumr:
  base_url: "https://api.consumr.ai/v1"
  
  authentication:
    type: "api_key"  # or "oauth2"
    key_header: "X-API-Key"
    
  rate_limits:
    requests_per_minute: 30
    burst: 10
    
  retry:
    max_attempts: 3
    backoff_ms: 1000
```

### Polling Configuration

```yaml
consumr:
  polling:
    # Check for new studies every hour
    interval_minutes: 60
    
    # Filter for relevant categories
    categories:
      - "defi_adoption"
      - "nft_usage"
      - "trading_patterns"
      - "protocol_preference"
      - "user_sentiment"
      
    # Only fetch studies from last 90 days
    max_age_days: 90
```

---

## Data Transformation

### To Signal

Consumr findings are transformed into signals:

```typescript
function consumrToSignal(study: Study, finding: Finding): Signal {
  return {
    id: `consumr_${study.id}_${finding.id}`,
    type: 'opportunity',  // or 'trend' or 'data'
    source: [{
      type: 'study',
      sourceId: study.id,
      url: study.reportUrl,
      retrievedAt: new Date().toISOString()
    }],
    title: finding.statement,
    description: `From Consumr.ai study: ${study.title}`,
    tags: study.tags,
    priority: finding.relevance > 0.7 ? 'high' : 'medium',
    confidence: finding.confidence,
    confidenceRationale: `Consumer study with n=${study.sampleSize}`,
    detectedAt: finding.createdAt || study.publishedAt
  };
}
```

---

## Quality Standards

### Data Validation

| Check | Requirement |
|-------|-------------|
| Sample size | ≥ 100 respondents |
| Completion rate | ≥ 70% |
| Confidence | ≥ 0.70 |
| Relevance | ≥ 0.50 for ROS ingestion |

### Evidence Chain

When consuming Consumr data:

```yaml
evidence:
  type: "consumer_study"
  source:
    name: "Consumr.ai"
    url: "{study.reportUrl}"
    methodology: "{study.methodology}"
  quality:
    sample_size: "{study.sampleSize}"
    completion_rate: "{study.completionRate}"
    confidence: "{study.confidence}"
```

---

## Monitoring

### Metrics

| Metric | Description | Alert |
|--------|-------------|-------|
| `consumr.studies.total` | Total studies fetched | - |
| `consumr.studies.new` | New studies in period | > 50/week |
| `consumr.findings.extracted` | Findings extracted | - |
| `consumr.latency.p95` | API latency | > 5s |
| `consumr.errors` | API errors | > 1% |

---

## Dependencies

- `06-integration/integration-overview.md` — Integration map
- `04-quality/evidence-model.md` — Evidence standards

## Related Documents

- `06-integration/gemini-contract.md` — LLM integration
- `04-quality/scoring-model.md` — Using study data in scoring

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
