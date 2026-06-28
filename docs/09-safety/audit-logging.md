# Audit Logging

**Document ID**: 07.4
**Domain**: Safety
**Status**: Draft

---

## Purpose

Defines what must be logged and retained for accountability and post-mortem analysis. Ensures that all significant actions are traceable to their sources.

## Audience

- Engineers (for implementation)
- Compliance (for audit requirements)
- Operations (for debugging)

## Logging Philosophy

> If it matters, log it. If it's logged, keep it. If it's kept, make it accessible.

Key principles:
1. **Completeness**: Log all significant events
2. **Integrity**: Logs cannot be tampered with
3. **Accessibility**: Logs are searchable and accessible
4. **Retention**: Logs are kept long enough to be useful

---

## Log Categories

### Category 1: System Events

Core system operations.

| Event | Logged | Retention |
|-------|--------|-----------|
| System startup | Yes | 1 year |
| System shutdown | Yes | 1 year |
| State transitions | Yes | 1 year |
| Configuration changes | Yes | 2 years |
| Deployment events | Yes | 2 years |
| Health check results | Yes | 90 days |

### Category 2: Data Events

Knowledge base operations.

| Event | Logged | Retention |
|-------|--------|-----------|
| Entity created | Yes | Indefinite |
| Entity updated | Yes | Indefinite |
| Entity deleted | Yes | Indefinite |
| Relationship created | Yes | Indefinite |
| Evidence added | Yes | Indefinite |
| Confidence adjusted | Yes | Indefinite |

### Category 3: Processing Events

Research processing.

| Event | Logged | Retention |
|-------|--------|-----------|
| Signal detected | Yes | 1 year |
| Insight generated | Yes | 1 year |
| Mission created | Yes | 2 years |
| Mission completed | Yes | 2 years |
| LLM request | Yes | 1 year |
| LLM response | Yes* | 1 year |

*LLM responses logged without full content (hash stored)

### Category 4: Quality Events

Quality gate processing.

| Event | Logged | Retention |
|-------|--------|-----------|
| Quality gate passed | Yes | 2 years |
| Quality gate failed | Yes | 2 years |
| Evidence validated | Yes | 2 years |
| Evidence rejected | Yes | 2 years |
| Consistency check | Yes | 1 year |

### Category 5: Human Review Events

Human oversight actions.

| Event | Logged | Retention |
|-------|--------|-----------|
| Review assigned | Yes | 2 years |
| Review completed | Yes | 2 years |
| Review approved | Yes | 2 years |
| Review rejected | Yes | 2 years |
| Override executed | Yes | Indefinite |
| Escalation | Yes | 2 years |

### Category 6: Error Events

Errors and exceptions.

| Event | Logged | Retention |
|-------|--------|-----------|
| Error occurred | Yes | 2 years |
| Error recovered | Yes | 2 years |
| Error escalated | Yes | Indefinite |
| Rollback executed | Yes | Indefinite |

---

## Log Format

### Standard Log Entry

```json
{
  "timestamp": "2024-01-15T10:30:00.000Z",
  "level": "INFO",
  "version": "1.0",
  "source": {
    "service": "ros-analysis",
    "host": "analysis-01",
    "traceId": "trace-abc123",
    "spanId": "span-def456"
  },
  "event": {
    "type": "entity.created",
    "category": "data",
    "code": "ROS-DATA-001"
  },
  "actor": {
    "type": "system",
    "id": "analysis-department",
    "missionId": "mission-001"
  },
  "target": {
    "type": "entity",
    "id": "entity-xyz789"
  },
  "data": {
    "entityType": "protocol",
    "name": "Uniswap V4"
  },
  "result": {
    "success": true
  },
  "metadata": {
    "confidence": 0.85,
    "sourcesCount": 3
  }
}
```

---

## Required Fields

### All Logs

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| timestamp | ISO 8601 | Yes | When event occurred |
| level | enum | Yes | DEBUG, INFO, WARN, ERROR |
| version | string | Yes | Log format version |
| traceId | string | Yes | Request correlation |
| event.type | string | Yes | Event type identifier |

### Data Logs

| Field | Required | Description |
|-------|----------|-------------|
| actor | Yes | Who/what initiated |
| target | Yes | What was affected |
| action | Yes | What was done |
| before | No | State before change |
| after | No | State after change |

### Human Review Logs

| Field | Required | Description |
|-------|----------|-------------|
| reviewer | Yes | Human who acted |
| decision | Yes | Approve/reject/override |
| rationale | Yes | Why decision was made |
| override | No | If this was an override |
| original | No | Original system decision |

---

## Log Integrity

### Integrity Mechanisms

```
1. IMMUTABLE STORAGE
   - Write-once storage
   - No delete permissions
   - Cryptographic integrity

2. SIGNING
   - Each log entry signed
   - Tamper-evident seals
   - Signature verification

3. CHAINING
   - Entries chained (hash of previous)
   - Forward chain integrity
   - Backward verification
```

### Verification

```bash
# Verify log integrity
ros logs verify --start 2024-01-01 --end 2024-01-15

# Check for gaps
ros logs verify --check-continuity

# Verify signatures
ros logs verify --check-signatures
```

---

## Log Retention

### Retention Policy

| Category | Duration | Justification |
|----------|----------|---------------|
| System events | 1 year | Operational debugging |
| Data events | Indefinite | Knowledge provenance |
| Processing events | 1 year | Research debugging |
| Quality events | 2 years | Quality auditing |
| Human review | 2 years | Accountability |
| Error events | 2 years | Incident analysis |
| Override events | Indefinite | Compliance |

### Archival

```
Active Storage: 90 days
Near-line Storage: 1 year
Cold Storage: Indefinite (critical events)
```

---

## Access Control

### Who Can Access

| Role | Read | Write | Delete |
|------|------|-------|--------|
| Admin | Yes | Yes | Yes |
| Auditor | Yes | No | No |
| Engineer | Yes* | No | No |
| Operator | Yes | Yes | No |
| System | No | Yes | No |

*Limited to relevant logs only

### Access Logging

All log access is logged:

```json
{
  "event": "log.accessed",
  "actor": { "type": "user", "id": "analyst-001" },
  "target": { "type": "log", "id": "log-xyz" },
  "action": "read",
  "filters": { "start": "...", "end": "..." }
}
```

---

## Query Capabilities

### Standard Queries

```bash
# All errors in time range
ros logs query --level ERROR --since 24h

# All events for specific entity
ros logs query --entity-id entity-xyz --since 7d

# All human review events
ros logs query --category human-review --since 30d

# All events for specific mission
ros logs query --mission-id mission-001

# Audit trail for entity
ros logs audit --entity-id entity-xyz
```

### Compliance Queries

```bash
# All override events
ros logs query --event-type override --since 90d

# All rejected reviews
ros logs query --event-type review.rejected --since 30d

# Data lineage
ros logs lineage --entity-id entity-xyz
```

---

## Log Monitoring

### Alert Conditions

| Condition | Severity | Action |
|-----------|----------|--------|
| Error rate spike | High | Alert ops |
| Missing logs | Critical | Alert security |
| Unauthorized access | Critical | Alert security |
| Retention failure | High | Alert engineering |
| Integrity failure | Critical | Alert immediately |

### Dashboards

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         LOG MONITORING DASHBOARD                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Last 24 Hours                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │ Total Events: 45,230   Errors: 127 (0.28%)   Warnings: 892         │  │
│  │                                                                             │  │
│  │ Error Rate   [▓▓▓▓▓▓▓▓░░░░░░░░░░░░░░░░░] 0.28%                      │  │
│  │ Warning Rate [▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░] 1.97%                      │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
│  Event Categories                                                          │
│  ┌─────────────────────────────────────────────────────────────────────┐  │
│  │ System: 12,450 (28%)   Data: 18,230 (40%)   Processing: 8,120 (18%)  │  │
│  │ Quality: 3,450 (8%)     Human: 2,980 (6%)                          │  │
│  └─────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## Dependencies

- `error-taxonomy.md` — Error logging
- `human-oversight.md` — Human review logging
- `failure-recovery.md` — Incident logging

## Related Documents

- `03-operations/runbook.md` — Operational logging
- `07-safety/rollback-procedures.md` — Rollback logging

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
