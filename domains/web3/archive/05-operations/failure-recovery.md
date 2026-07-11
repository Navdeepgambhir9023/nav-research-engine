# Failure Recovery

**Document ID**: 03.5
**Domain**: Operations
**Status**: Draft

---

## Purpose

Documents how to recover from common failure modes. Ensures resilience and prevents cascading failures by providing clear recovery procedures.

## Audience

- Operations team (incident response)
- On-call personnel
- Engineers (debugging)

## Failure Classification

### Severity Levels

| Level | Definition | Response Time | Example |
|-------|------------|---------------|---------|
| **SEV-1** | System down, no workaround | Immediate | System won't start |
| **SEV-2** | Major function impaired | < 1 hour | Daily cycle fails |
| **SEV-3** | Minor function impaired | < 4 hours | Single source fails |
| **SEV-4** | Degraded performance | Next business day | Slow responses |

---

## Recovery Procedures

### SEV-1: System Won't Start

**Symptoms**: `ros start` fails or system crashes immediately.

```
Step 1: Check basic system health
□ Verify disk space: df -h (need >1GB free)
□ Verify memory: free -h (need >500MB available)
□ Check for port conflicts: ros ports check

Step 2: Check logs for errors
□ View recent logs: ros logs --level error --since 1h
□ Check for panic messages: ros logs | grep -i panic

Step 3: Check knowledge base integrity
□ Verify data directory exists: ls -la $ROS_DATA
□ Check permissions: ls -la $ROS_DATA

Step 4: Attempt recovery
□ Clear temporary files: ros clean --temp
□ Reset lock files: ros lock reset --all
□ Retry start: ros start

Step 5: If still failing
□ Check for known issues: ros status --known-issues
□ Contact support with logs: ros logs export --format tar.gz
```

---

### SEV-2: Daily Cycle Fails

**Symptoms**: Daily cycle starts but does not complete.

```
Step 1: Identify failure point
□ Check cycle status: ros cycle status
□ View phase logs: ros logs --phase [phase-name]

Step 2: Check the specific failure
□ Discovery failed: See "Source Connection Failures"
□ Analysis failed: See "LLM Processing Failures"
□ Planning failed: See "Mission Queue Failures"
□ Validation failed: See "Quality Gate Failures"

Step 3: Attempt recovery
□ Retry phase: ros phase retry [phase-name]
□ Skip if appropriate: ros phase skip [phase-name]
□ Resume cycle: ros cycle resume

Step 4: Document incident
□ Log failure: ros incident log [description]
□ Create follow-up: ros ticket create --type bug

Step 5: Notify team
□ Alert: ros notify --channel ops "Cycle partial failure, [reason]"
```

---

### SEV-2: Knowledge Base Unavailable

**Symptoms**: Operations fail with "Knowledge base connection failed".

```
Step 1: Verify knowledge base status
□ Check DB process: ros kb process status
□ Check connectivity: ros kb ping

Step 2: Check storage
□ Disk space: df -h (for $ROS_DATA)
□ Check for lock: ls $ROS_DATA/*.lock

Step 3: Recovery attempts
□ Restart DB: ros kb restart
□ Clear locks: ros kb unlock
□ Rebuild from backup: ros backup restore --latest

Step 4: If data recovery needed
□ Check recent backup: ros backup list --limit 3
□ Restore to backup point: ros backup restore --point [timestamp]
□ Replay missed writes: ros kb replay --since [timestamp]

Step 5: Verify recovery
□ Check integrity: ros kb verify
□ Run health check: ros health check kb
```

---

### SEV-3: External Source Fails

**Symptoms**: One or more data sources return errors.

```
Step 1: Identify affected source
□ Check source status: ros sources status
□ View source logs: ros logs --source [source-name]

Step 2: Diagnose the issue
□ API error: Check API status page
□ Rate limit: Check rate limit status
□ Network: Verify connectivity to source

Step 3: Implement workaround
□ Switch to backup source: ros source switch [source-name] --to backup
□ Reduce polling frequency: ros source configure [source-name] --interval 1h
□ Disable temporarily: ros source disable [source-name]

Step 4: Monitor
□ Watch for recovery: ros source monitor [source-name]
□ Alert on recovery: ros alert on-recovery [source-name]

Step 5: Document and follow up
□ Log incident: ros incident log "Source [name] failed: [reason]"
□ Schedule investigation: ros ticket create --type reliability
```

---

### SEV-3: LLM Processing Fails

**Symptoms**: Analysis phase hangs or returns errors.

```
Step 1: Check LLM service status
□ Verify API status: ros llm status
□ Check API key: ros llm verify-key

Step 2: Check request status
□ View pending requests: ros llm requests --pending
□ Check failure rate: ros llm metrics --since 1h

Step 3: Implement retry
□ Retry failed requests: ros llm retry --failed
□ Clear stuck requests: ros llm cancel --stuck

Step 4: If persistent failures
□ Switch model: ros llm configure --model [alternate-model]
□ Reduce concurrency: ros llm configure --max-concurrent 1

Step 5: Monitor costs
□ Check token usage: ros llm usage --today
□ Set budget alert: ros llm alert --budget 80%
```

---

### SEV-4: Performance Degradation

**Symptoms**: System works but is slower than normal.

```
Step 1: Identify bottleneck
□ Check resource usage: ros resources
□ Check DB performance: ros kb stats --performance
□ Check network latency: ros network latency

Step 2: Check for resource exhaustion
□ CPU high: ros process top
□ Memory high: ros memory breakdown
□ Disk slow: ros disk benchmark

Step 3: Optimize
□ Clear cache: ros cache clear
□ Vacuum database: ros kb vacuum
□ Restart services: ros restart --service [name]

Step 4: Monitor improvement
□ Check latency: ros metrics latency --follow
□ Verify throughput: ros metrics throughput
```

---

## Rollback Procedures

### Quick Rollback

```
□ 1. List recent changes
   Command: ros deploy history --limit 5

□ 2. Identify rollback target
   Target: Previous working version

□ 3. Check rollback safety
   Command: ros rollback --check --target [version]
   Review: Data compatibility, running missions

□ 4. Execute rollback
   Command: ros rollback --confirm --target [version]

□ 5. Verify rollback
   Command: ros health check --all

□ 6. Notify team
   Command: ros notify --channel ops "Rolled back to [version]"
```

### Knowledge Base Rollback

```
□ 1. List backups
   Command: ros backup list --limit 10

□ 2. Select target backup
   Target: Most recent backup before incident

□ 3. Stop current operations
   Command: ros cycle stop

□ 4. Create snapshot of current state
   Command: ros backup snapshot

□ 5. Restore backup
   Command: ros backup restore --target [backup-id]

□ 6. Verify integrity
   Command: ros kb verify

□ 7. Replay recent writes (if applicable)
   Command: ros kb replay --since [backup-timestamp]

□ 8. Resume operations
   Command: ros cycle resume
```

---

## Recovery Time Objectives

| Component | RTO | RPO | Recovery Steps |
|-----------|-----|-----|---------------|
| Full System | 4 hours | 1 hour | Full recovery procedure |
| Knowledge Base | 2 hours | 15 minutes | DB restore + replay |
| Daily Cycle | 30 minutes | Start of phase | Phase retry |
| External Sources | 15 minutes | N/A | Source switch |

**RTO**: Recovery Time Objective - Maximum acceptable downtime
**RPO**: Recovery Point Objective - Maximum acceptable data loss

---

## Post-Incident Procedures

### Required for SEV-1 and SEV-2

```
□ 1. Document timeline
   What happened, when, impact

□ 2. Identify root cause
   Use 5-why analysis

□ 3. Create action items
   Prevent recurrence

□ 4. Update runbooks
   Add recovery steps if missing

□ 5. Schedule retrospective
   Within 48 hours

□ 6. Close incident
   Command: ros incident close [id]
```

---

## Dependencies

- `state-machine.md` — System states
- `runbook.md` — Operational procedures
- `07-safety/rollback-procedures.md` — Rollback details

## Related Documents

- `07-safety/error-taxonomy.md` — Error classification
- `07-safety/audit-logging.md` — Incident logging
- `07-safety/human-oversight.md` — Human review during incidents

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
