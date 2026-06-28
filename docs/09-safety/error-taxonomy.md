# Error Taxonomy

**Document ID**: 07.2
**Domain**: Safety
**Status**: Draft

---

## Purpose

Classifies all possible failure modes in the ROS. Enables systematic safety analysis and ensures all errors can be detected, classified, and handled appropriately.

## Audience

- Engineers (for error handling)
- Operations (for incident response)
- Architects (for system design)

## Error Philosophy

> Every error is an opportunity to improve. The goal is not to prevent all errors, but to detect them early, handle them gracefully, and learn from them.

Key principles:
1. **Detection**: All errors must be detectable
2. **Classification**: Errors must be categorized for appropriate response
3. **Containment**: Errors should not cascade
4. **Recovery**: Errors should be recoverable
5. **Learning**: Errors should inform improvements

---

## Error Categories

### Category 1: Data Errors

Errors related to data quality, integrity, or processing.

```
Data Errors
├── Schema Violation
│   ├── Missing required field
│   ├── Invalid field type
│   ├── Invalid enum value
│   └── Schema version mismatch
├── Data Corruption
│   ├── Checksum failure
│   ├── Partial write
│   └── Encoding error
├── Data Inconsistency
│   ├── Duplicate entity
│   ├── Contradictory facts
│   └── Invalid reference
└── Data Staleness
    ├── Outdated information
    └── Expired data
```

---

### Category 2: External Dependency Errors

Errors from external services and integrations.

```
External Errors
├── API Errors
│   ├── Rate limit exceeded
│   ├── Authentication failure
│   ├── Authorization failure
│   └── Service unavailable
├── Network Errors
│   ├── Connection timeout
│   ├── DNS resolution failure
│   ├── Connection refused
│   └── Intermittent connectivity
├── Data Source Errors
│   ├── Invalid response format
│   ├── Missing data
│   ├── Data quality issues
│   └── Source-specific errors
└── LLM Errors
    ├── Model unavailable
    ├── Inference timeout
    ├── Content filter triggered
    └── Invalid response
```

---

### Category 3: System Errors

Errors in the core system operation.

```
System Errors
├── State Errors
│   ├── Invalid state transition
│   ├── State corruption
│   └── Concurrent modification
├── Processing Errors
│   ├── Processing timeout
│   ├── Resource exhaustion
│   ├── Deadlock
│   └── Infinite loop
├── Configuration Errors
│   ├── Missing configuration
│   ├── Invalid configuration
│   └── Configuration drift
└── Runtime Errors
    ├── Out of memory
    ├── Disk full
    ├── Permission denied
    └── Process crash
```

---

### Category 4: Logic Errors

Errors in business logic or decision-making.

```
Logic Errors
├── Validation Errors
│   ├── Quality gate failure
│   ├── Evidence insufficient
│   └── Confidence too low
├── Reasoning Errors
│   ├── Invalid conclusion
│   ├── Missing consideration
│   └── Incorrect assumption
├── Scoring Errors
│   ├── Score calculation error
│   ├── Weight misapplication
│   └── Threshold violation
└── Classification Errors
    ├── Wrong category assigned
    ├── Inconsistent classification
    └── Missing classification
```

---

### Category 5: Operational Errors

Errors in operations and procedures.

```
Operational Errors
├── Human Errors
│   ├── Incorrect review decision
│   ├── Misconfiguration
│   └── Procedure violation
├── Process Errors
│   ├── Step skipped
│   ├── Wrong order
│   └── Timeout not handled
├── Communication Errors
│   ├── Notification failure
│   ├── Misunderstanding
│   └── Incomplete handoff
└── Documentation Errors
    ├── Outdated documentation
    └── Inconsistent documentation
```

---

## Error Severity Levels

### Severity Definitions

| Level | Name | Impact | Response Time | Example |
|-------|------|--------|---------------|---------|
| **SEV-1** | Critical | System unusable | Immediate | System crash, data loss |
| **SEV-2** | High | Major function impaired | < 1 hour | Daily cycle fails |
| **SEV-3** | Medium | Minor function impaired | < 4 hours | Single source fails |
| **SEV-4** | Low | Minimal impact | < 24 hours | Minor inconsistency |
| **SEV-5** | Info | Informational | None | Routine events |

---

## Error Response Matrix

### By Category and Severity

| Category | SEV-1 | SEV-2 | SEV-3 | SEV-4 | SEV-5 |
|----------|--------|-------|-------|-------|-------|
| **Data** | Halt + Restore | Retry + Alert | Retry | Log | Log |
| **External** | Failover | Retry | Retry | Log | Log |
| **System** | Halt + Escalate | Restart | Retry | Alert | Log |
| **Logic** | Halt + Review | Human Review | Review | Log | Log |
| **Operational** | Human Review | Human Review | Alert | Log | Log |

---

## Error Detection

### Detection Methods

| Method | Description | Coverage |
|--------|-------------|----------|
| **Type checking** | Compile-time type validation | Schema errors |
| **Schema validation** | JSON Schema validation | Data structure |
| **Range validation** | Value within expected bounds | Numeric errors |
| **Consistency checks** | Cross-reference validation | Data inconsistency |
| **Health checks** | Periodic system health | System errors |
| **Circuit breakers** | Detect dependency failures | External errors |
| **Assertions** | Runtime checks in code | Logic errors |

---

## Error Codes

### Error Code Format

```
ROS-[CATEGORY]-[NUMBER]-[SEVERITY]

Example: ROS-DATA-001-2

Where:
- CATEGORY: Data, Ext, Sys, Log, Ops
- NUMBER: Sequential within category (001-999)
- SEVERITY: 1-5 (1=critical, 5=info)
```

### Error Code Registry

| Code | Description | Category | Severity |
|------|-------------|----------|----------|
| ROS-DATA-001 | Schema validation failed | Data | 3 |
| ROS-DATA-002 | Duplicate entity detected | Data | 4 |
| ROS-DATA-003 | Data corruption detected | Data | 1 |
| ROS-EXT-001 | API rate limit exceeded | External | 3 |
| ROS-EXT-002 | LLM service unavailable | External | 2 |
| ROS-EXT-003 | Network timeout | External | 3 |
| ROS-SYS-001 | State machine invalid transition | System | 1 |
| ROS-SYS-002 | Resource exhaustion | System | 2 |
| ROS-LOG-001 | Quality gate failed | Logic | 3 |
| ROS-LOG-002 | Insufficient evidence | Logic | 3 |
| ROS-OPS-001 | Human review timeout | Operational | 3 |
| ROS-OPS-002 | SLA breach | Operational | 3 |

---

## Error Handling Patterns

### Retry Pattern

```typescript
async function withRetry<T>(
  operation: () => Promise<T>,
  options: RetryOptions
): Promise<T> {
  const maxAttempts = options.maxAttempts || 3;
  const backoff = options.backoff || exponentialBackoff;
  
  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      return await operation();
    } catch (error) {
      if (!isRetryable(error) || attempt === maxAttempts) {
        throw error;
      }
      await backoff(attempt);
    }
  }
  throw new Error('Max retries exceeded');
}
```

### Circuit Breaker Pattern

```typescript
class CircuitBreaker {
  private state: 'closed' | 'open' | 'half-open';
  private failureCount: number = 0;
  private lastFailure: Date;
  
  async execute<T>(operation: () => Promise<T>): Promise<T> {
    if (this.state === 'open') {
      if (this.shouldAttemptReset()) {
        this.state = 'half-open';
      } else {
        throw new CircuitOpenError(this.name);
      }
    }
    
    try {
      const result = await operation();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      throw error;
    }
  }
}
```

### Fallback Pattern

```typescript
async function withFallback<T>(
  primary: () => Promise<T>,
  fallback: () => Promise<T>,
  options?: FallbackOptions
): Promise<T> {
  try {
    return await withTimeout(primary, options?.timeout);
  } catch (error) {
    if (options?.fallbackOn?.includes(error.type)) {
      log.warning(`Primary failed, using fallback: ${error.message}`);
      return fallback();
    }
    throw error;
  }
}
```

---

## Error Logging

### Log Format

```json
{
  "timestamp": "2024-01-15T10:30:00.000Z",
  "level": "ERROR",
  "code": "ROS-EXT-002",
  "message": "LLM service unavailable",
  "context": {
    "service": "gemini",
    "operation": "generate",
    "attempt": 3
  },
  "error": {
    "type": "ServiceUnavailable",
    "message": "Gemini API returned 503",
    "stack": "..."
  },
  "metadata": {
    "missionId": "mission-001",
    "userId": "system"
  }
}
```

### Required Fields

| Field | Required | Description |
|-------|----------|-------------|
| timestamp | Yes | ISO 8601 timestamp |
| level | Yes | DEBUG, INFO, WARN, ERROR |
| code | Yes | Error code from registry |
| message | Yes | Human-readable message |
| context | Yes | Operation context |
| error | Yes | Error details |
| metadata | Yes | Additional context |

---

## Dependencies

- `failure-recovery.md` — Error recovery procedures
- `runbook.md` — Operational error handling
- `audit-logging.md` — Error logging requirements

## Related Documents

- `03-operations/failure-recovery.md` — Recovery procedures
- `07-safety/audit-logging.md` — Logging standards

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
