# Rollback Procedures

**Document ID**: 07.3
**Domain**: Safety
**Status**: Draft

---

## Purpose

Documents how to revert to known-good states when things go wrong. Critical for recovering from bad research conclusions, system failures, or corrupted knowledge.

## Audience

- Operations team (for recovery)
- Engineers (for implementation)
- On-call personnel (for emergency response)

## Rollback Philosophy

> Rollback should be safe, fast, and auditable. Every rollback is a lesson learned.

Key principles:
1. **Safety first**: Never lose data permanently
2. **Speed**: Minimize recovery time
3. **Auditability**: Every rollback is logged
4. **Minimal impact**: Rollback only what's necessary

---

## Rollback Types

### Type 1: Knowledge Rollback

Revert knowledge base to previous state.

**When**: Bad data incorporated, corrupted knowledge, wrong conclusions.

```
Trigger:
□ Entity incorrectly added
□ Relationship incorrectly created
□ Evidence chain corrupted
□ Confidence score manipulated
□ Quality gate bypassed
```

---

### Type 2: Mission Rollback

Revert mission to previous state.

**When**: Mission in bad state, incorrect output, failed execution.

```
Trigger:
□ Mission completed incorrectly
□ Output quality unacceptable
□ Human review discovered error
□ Mission contaminated by bad data
```

---

### Type 3: System Rollback

Revert system configuration or code.

**When**: System failure, configuration error, deployment issue.

```
Trigger:
□ Deployment caused failures
□ Configuration changed incorrectly
□ System parameters corrupted
□ Dependency version conflict
```

---

## Knowledge Rollback Procedure

### Step 1: Identify Scope

```
□ Identify affected entities
□ Determine root cause
□ Assess spread of corruption
□ Identify rollback boundaries
```

### Step 2: Create Snapshot

```
□ Create snapshot of current state
□ Verify snapshot integrity
□ Store snapshot securely
□ Document snapshot timestamp
```

### Step 3: Execute Rollback

```
□ Stop active operations
□ Select target version
□ Execute rollback to version
□ Verify rollback success
```

### Step 4: Validate

```
□ Verify entity integrity
□ Check relationship consistency
□ Validate confidence scores
□ Test knowledge queries
```

### Step 5: Recover

```
□ Resume operations
□ Monitor for issues
□ Document incident
□ Plan prevention
```

---

## Rollback Commands

### Knowledge Base Rollback

```bash
# 1. List available versions
ros kb versions --list

# 2. Create snapshot of current state
ros kb snapshot --create --description "Pre-rollback snapshot"

# 3. View changes since version
ros kb diff --from v2024-01-14 --to v2024-01-15

# 4. Execute rollback
ros kb rollback --to v2024-01-14 --confirm

# 5. Verify rollback
ros kb verify --full

# 6. Monitor for issues
ros monitor --watch --duration 1h
```

### Mission Rollback

```bash
# 1. List mission versions
ros mission versions --mission-id mission-001

# 2. Rollback mission to version
ros mission rollback --mission-id mission-001 --to-version 1.2

# 3. Reset mission state
ros mission reset --mission-id mission-001 --state PROPOSED

# 4. Notify stakeholders
ros notify --channel ops "Mission rolled back to version 1.2"
```

### Configuration Rollback

```bash
# 1. List config versions
ros config history --limit 10

# 2. View config diff
ros config diff --from current --to previous

# 3. Rollback configuration
ros config rollback --confirm

# 4. Restart affected services
ros service restart --affected
```

---

## Version Selection Guide

### Selecting Target Version

| Scenario | Target | Rationale |
|----------|--------|-----------|
| Single bad entity | Last version before entity | Minimize changes |
| Batch bad data | Version before batch import | Revert entire import |
| Corruption | Last known good | Most recent clean |
| Configuration error | Known working config | Restore function |

### Version Identification

```
Good Version Characteristics:
□ All quality gates passed
□ Human reviews completed
□ No errors in logs
□ System metrics normal
□ Stakeholder approval received

Bad Version Characteristics:
□ Quality gates failed
□ Anomalous metrics
□ Error spike
□ Manual override
□ Stakeholder flag
```

---

## Partial Rollback

### Selective Entity Rollback

For partial corruption, rollback specific entities:

```bash
# 1. Identify affected entities
ros kb entities --filter corrupted=true

# 2. Export affected list
ros kb entities --filter corrupted=true --export affected.json

# 3. Rollback specific entities
ros kb rollback --entities affected.json --to v2024-01-14

# 4. Verify only affected rollback
ros kb verify --entities affected.json
```

### Merge Rollback

For conflicting rollbacks:

```bash
# 1. Identify conflicts
ros kb conflicts --list

# 2. Resolve conflicts
ros kb conflicts --resolve --strategy keep-new  # or keep-old, manual

# 3. Verify resolution
ros kb verify --full
```

---

## Rollback Safety

### Pre-Rollback Checklist

```
□ Snapshot created of current state
□ Impact assessed (what will be lost)
□ Stakeholders notified
□ Rollback target verified
□ Rollback command verified
□ Monitoring enabled
□ Fallback plan prepared
□ Incident logged
```

### Post-Rollback Checklist

```
□ Verification passed
□ Affected functionality restored
□ Monitoring shows normal
□ Stakeholders confirmed
□ Incident documented
□ Root cause addressed
□ Prevention planned
```

---

## Rollback Metrics

| Metric | Target | Alert |
|--------|--------|-------|
| Rollback frequency | < 1/month | > 2/month |
| Data loss | 0 | Any |
| Recovery time | < 30 min | > 1 hour |
| Rollback success rate | 100% | < 99% |

---

## Dependencies

- `03-operations/failure-recovery.md` — Failure handling
- `07-safety/audit-logging.md` — Rollback logging
- `version-strategy.md` — Version management

## Related Documents

- `03-operations/failure-recovery.md` — Recovery procedures
- `05-evolution/version-strategy.md` — Version handling

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
