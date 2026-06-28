# Gemini Contract

**Document ID**: 06.2
**Domain**: Integration
**Status**: Draft

---

## Purpose

Defines the contract for Gemini Deep Research integration. Enables LLM-based research synthesis without tight coupling to the specific implementation.

## Audience

- Engineers (for implementation)
- Architects (for design)
- Researchers (for prompt design)

## Contract Overview

The ROS uses Gemini for:
1. **Research synthesis**: Combining evidence into insights
2. **Prompt generation**: Creating research prompts from missions
3. **Hypothesis generation**: Generating hypotheses from observations
4. **Report drafting**: Generating structured reports from findings

---

## Interface Definition

### Core Operations

```typescript
interface IGeminiService {
  // Generate content from a prompt
  generate(request: GenerationRequest): Promise<GenerationResponse>;
  
  // Stream content for long responses
  generateStream(request: GenerationRequest): AsyncIterable<string>;
  
  // Get model information
  getModelInfo(): Promise<ModelInfo>;
  
  // Estimate cost before generation
  estimateCost(request: GenerationRequest): CostEstimate;
}
```

---

## Generation Request

### Request Structure

```typescript
interface GenerationRequest {
  // System prompt (instructions)
  system: string;
  
  // User content
  user: string;
  
  // Generation parameters
  parameters: GenerationParameters;
  
  // Metadata
  metadata: RequestMetadata;
}

interface GenerationParameters {
  // Model to use
  model: 'gemini-pro' | 'gemini-ultra' | 'gemini-1.5-pro';
  
  // Temperature (creativity vs determinism)
  temperature: number;  // 0.0 - 2.0, default 0.7
  
  // Maximum tokens in response
  maxTokens: number;  // default 8192
  
  // Stop sequences
  stopSequences?: string[];
  
  // Response format
  responseFormat?: 'text' | 'json' | 'markdown';
  
  // Safety settings
  safetySettings?: SafetySetting[];
}

interface RequestMetadata {
  // Mission or task reference
  missionId?: string;
  
  // Purpose of this generation
  purpose: 'insight' | 'hypothesis' | 'report' | 'prompt_generation';
  
  // Expected output schema (if JSON)
  outputSchema?: object;
  
  // Callback for progress (for long operations)
  onProgress?: (progress: GenerationProgress) => void;
}
```

---

## Generation Response

### Response Structure

```typescript
interface GenerationResponse {
  // Generated content
  content: string;
  
  // Usage statistics
  usage: TokenUsage;
  
  // Model information
  model: string;
  
  // Finish information
  finishReason: FinishReason;
  
  // Metadata
  metadata: ResponseMetadata;
}

interface TokenUsage {
  promptTokens: number;
  completionTokens: number;
  totalTokens: number;
}

type FinishReason = 
  | 'stop'           // Natural stop
  | 'max_tokens'     // Hit token limit
  | 'safety'         // Safety filter triggered
  | 'recitation'     // Copyright detected
  | 'other';         // Other reason

interface ResponseMetadata {
  // Processing time
  processingTimeMs: number;
  
  // Timestamp
  generatedAt: string;  // ISO 8601
  
  // Safety ratings (if any)
  safetyRatings?: SafetyRating[];
}
```

---

## ROS-Specific Prompts

### Insight Generation Prompt

```markdown
## System
You are a Web3 research analyst synthesizing evidence into insights.
Follow the ROS evidence model. Always cite sources.
Be precise and distinguish fact from inference.

## User
Based on the following evidence, generate insights:

<evidence>
{evidence_content}
</evidence>

For each insight, provide:
1. Summary (1-2 sentences)
2. Supporting evidence (with confidence level)
3. Confidence score (0.0-1.0)
4. Gaps in evidence (if any)
5. Alternative interpretations (if applicable)

Output as JSON matching the schema:
<schema>
{output_schema}
</schema>
```

### Hypothesis Generation Prompt

```markdown
## System
You are a Web3 research analyst generating hypotheses.
Based on patterns and evidence, propose testable hypotheses.
Distinguish between observation and inference.

## User
Based on the following observations:

<observations>
{observations_content}
</observations>

Generate hypotheses that:
1. Explain the observed patterns
2. Are specific and testable
3. Have clear success criteria
4. Identify what evidence would confirm or refute them

Output as JSON:
<schema>
{output_schema}
</schema>
```

---

## Error Handling

### Error Types

```typescript
interface GeminiError {
  type: GeminiErrorType;
  message: string;
  retryable: boolean;
  details?: object;
}

type GeminiErrorType =
  | 'authentication'      // API key invalid
  | 'rate_limit'          // Too many requests
  | 'timeout'             // Request timed out
  | 'invalid_request'      // Malformed request
  | 'model_error'         // Model processing error
  | 'safety_block'        // Content blocked
  | 'network'             // Network error
  | 'unknown';            // Unknown error
```

### Retry Policy

| Error Type | Retry | Backoff |
|-----------|-------|---------|
| `rate_limit` | Yes | Exponential (1s, 2s, 4s, 8s, 16s) |
| `timeout` | Yes | Linear (1s, 2s, 3s) |
| `network` | Yes | Exponential (1s, 2s, 4s) |
| `authentication` | No | - |
| `invalid_request` | No | - |
| `safety_block` | No | - |

---

## Rate Limits

### Default Limits

| Tier | Requests/min | Tokens/min | Concurrent |
|------|-------------|------------|-------------|
| Free | 15 | 60,000 | 1 |
| Pro | 60 | 240,000 | 5 |
| Enterprise | Custom | Custom | Custom |

### ROS Configuration

```yaml
gemini:
  rate_limits:
    requests_per_minute: 30    # Conservative for burst handling
    tokens_per_minute: 120000  # Buffer for large requests
    concurrent_requests: 3      # Parallel mission processing
    
  retry:
    max_attempts: 3
    backoff_base: 1s
    backoff_max: 60s
```

---

## Cost Management

### Cost Estimation

```typescript
interface CostEstimate {
  promptTokens: number;
  completionTokens: number;
  estimatedCostUSD: number;
  currency: 'USD';
}

const COST_PER_1K_TOKENS = {
  'gemini-pro': 0.0005,      // $0.50 per 1M tokens
  'gemini-1.5-pro': 0.00125, // $1.25 per 1M tokens
  'gemini-ultra': 0.0075,    // $7.50 per 1M tokens
};

function estimateCost(request: GenerationRequest): CostEstimate {
  const promptTokens = estimateTokens(request.system + request.user);
  const maxTokens = request.parameters.maxTokens;
  const rate = COST_PER_1K_TOKENS[request.parameters.model];
  
  return {
    promptTokens,
    completionTokens: maxTokens,
    estimatedCostUSD: ((promptTokens + maxTokens) / 1000) * rate,
    currency: 'USD'
  };
}
```

### Budget Alerts

```yaml
gemini:
  budget:
    daily_limit_usd: 50.00      # Conservative daily limit
    alert_threshold: 0.80        # Alert at 80%
    emergency_threshold: 0.95    # Pause at 95%
```

---

## Monitoring

### Metrics

| Metric | Description | Alert |
|--------|-------------|-------|
| `gemini.requests.total` | Total requests | - |
| `gemini.requests.success` | Successful requests | - |
| `gemini.requests.error` | Failed requests | > 5% rate |
| `gemini.tokens.total` | Total tokens used | > 90% limit |
| `gemini.latency.p95` | P95 latency | > 30s |
| `gemini.cost.daily` | Daily cost | > 80% budget |

### Health Check

```typescript
async function healthCheck(): Promise<HealthStatus> {
  try {
    const info = await gemini.getModelInfo();
    return {
      status: 'healthy',
      model: info.name,
      available: true
    };
  } catch (error) {
    return {
      status: 'unhealthy',
      error: error.message,
      available: false
    };
  }
}
```

---

## Dependencies

- `01-architecture/component-contracts.md` — Interface definitions
- `04-quality/evidence-model.md` — Evidence standards for prompts

## Related Documents

- `06-integration/integration-overview.md` — Integration map
- `04-quality/scoring-model.md` — Using LLM output in scoring

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
