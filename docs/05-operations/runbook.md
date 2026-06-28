# Runbook

**Document ID**: 03.4
**Domain**: Operations
**Status**: Draft

---

## Purpose

Step-by-step operational checklists for running the ROS. Reduces errors in manual execution procedures and serves as a reference for operators.

## Audience

- Operations team (daily execution)
- Engineers (debugging)
- On-call personnel (incident response)

## Document Structure

This runbook is organized by operational procedure:

1. [Daily Operations](#daily-operations)
2. [Weekly Operations](#weekly-operations)
3. [Incident Response](#incident-response)
4. [Maintenance Tasks](#maintenance-tasks)

---

## Daily Operations

### Pre-Flight Checklist

Run before starting the daily cycle.

```
□ 1. Verify system state is IDLE
   Command: ros status
   Expected: "State: IDLE, Last cycle: [timestamp]"

□ 2. Check knowledge base accessibility
   Command: ros kb ping
   Expected: "Knowledge base reachable"

□ 3. Verify external API connectivity
   Command: ros health check --all
   Expected: All services: HEALTHY

□ 4. Check human review queue
   Command: ros queue pending --type review
   Expected: List of pending reviews (may be empty)

□ 5. Review previous cycle logs
   Command: ros logs --since yesterday
   Expected: No ERROR or CRITICAL entries

□ 6. Verify backup completion
   Command: ros backup status
   Expected: "Last backup: [timestamp], Status: SUCCESS"
```

### Starting Daily Cycle

```
□ 1. Confirm pre-flight checklist complete
□ 2. Check calendar for any urgent priorities
   Command: ros calendar today
□ 3. Notify team cycle starting
   Command: ros notify --channel ops "Starting daily cycle"
□ 4. Start cycle
   Command: ros cycle start --mode daily
□ 5. Monitor progress
   Command: ros monitor --follow
□ 6. Review cycle completion report
   Command: ros cycle report --latest
```

### Monitoring Daily Cycle

```
□ 1. Check phase progress
   Command: ros phase status
   Expected: Current phase and estimated completion

□ 2. Check for warnings
   Command: ros logs --level warning --since 1h
□ 3. Check resource utilization
   Command: ros resources
   Expected: CPU < 80%, Memory < 85%

□ 4. Review signal processing
   Command: ros signals stats --since 1h
   Expected: Signals processed > threshold

□ 5. Check mission queue
   Command: ros missions queue --limit 5
   Expected: Missions prioritized correctly
```

### Ending Daily Cycle

```
□ 1. Verify all phases completed
   Command: ros cycle status
   Expected: State: DONE

□ 2. Review completion report
   Command: ros cycle report --latest
□ 3. Check for pending human reviews
   Command: ros queue pending --type review
□ 4. Alert team to pending reviews
   If: reviews > 0
   Command: ros notify --channel ops "X reviews pending"
□ 5. Archive cycle logs
   Command: ros logs archive --cycle-id [id]
□ 6. Transition to IDLE
   Command: ros state set IDLE
□ 7. Schedule next cycle
   Command: ros schedule next --time 06:00
```

---

## Weekly Operations

### Week-End Checklist (Friday)

```
□ 1. Complete daily cycle for Friday
□ 2. Generate weekly aggregation
   Command: ros weekly aggregate
□ 3. Review weekly metrics
   Command: ros metrics weekly --format report
□ 4. Draft weekly intelligence report
   Command: ros report generate --type weekly --draft
□ 5. Send report to stakeholders
   Command: ros report send --type weekly
□ 6. Review and update mission priorities
   Command: ros missions review --since 7d
□ 7. Clean up stale data
   Command: ros cleanup --dry-run
   Review output, then: ros cleanup --confirm
□ 8. Back up knowledge base
   Command: ros backup full
```

### Week-Begin Checklist (Monday)

```
□ 1. Review weekend alerts
   Command: ros alerts --since friday
□ 2. Check system status
   Command: ros health check --all
□ 3. Resume normal operations
   Command: ros cycle start --mode daily
□ 4. Review pending human reviews from Friday
□ 5. Update team on priorities for the week
```

---

## Incident Response

### System Unavailable

```
If: ros status returns "UNAVAILABLE"

□ 1. Check system processes
   Command: ros ps
   Expected: List of running processes

□ 2. Check system logs
   Command: ros logs --level error --since 1h
□ 3. Check disk space
   Command: df -h
   Expected: / Usage < 85%

□ 4. Check memory
   Command: free -h
   Expected: Memory available

□ 5. Check external connectivity
   Command: ros network check
□ 6. Review recent changes
   Command: ros changelog --since 24h

If issue identified: See [Error Reference](#error-reference)
If no issue identified: Restart system
   Command: ros restart
```

### High Error Rate

```
If: Error rate > 5% in any phase

□ 1. Identify error pattern
   Command: ros logs --level error --since 1h | grep -A5 "ERROR"

□ 2. Check specific phase
   Command: ros phase status
   Expected: Specific phase with issues

□ 3. Check external dependencies
   Command: ros health check external --all

□ 4. Review recent deployments
   Command: ros deploy history --since 24h

□ 5. Consider rollback
   Command: ros rollback --check
   If: rollback recommended
   Command: ros rollback --confirm
```

### Knowledge Base Corruption

```
If: Knowledge base returns unexpected results

□ 1. Verify corruption
   Command: ros kb verify
   Expected: "Knowledge base valid" or list of issues

□ 2. Check recent writes
   Command: ros kb history --since 1h

□ 3. Restore from backup
   Command: ros backup restore --latest
□ 4. Verify restoration
   Command: ros kb verify
□ 5. Replay any missed writes
   Command: ros kb replay --since [timestamp]
```

---

## Maintenance Tasks

### Monthly Knowledge Base Maintenance

```
□ 1. Analyze knowledge base size
   Command: ros kb stats --history

□ 2. Identify stale entities
   Command: ros kb stale --since 6m

□ 3. Review entity relationships
   Command: ros kb orphan-check
   Expected: No orphan entities

□ 4. Vacuum old evidence
   Command: ros cleanup evidence --older-than 1y --dry-run
□ 5. Rebuild graph index
   Command: ros kb reindex
□ 6. Generate maintenance report
   Command: ros report generate --type maintenance
```

### Quarterly Review

```
□ 1. Review taxonomy usage
   Command: ros taxonomy stats

□ 2. Identify unused categories
   Command: ros taxonomy unused

□ 3. Review schema compliance
   Command: ros schema validate --all

□ 4. Audit access patterns
   Command: ros audit access --since 90d

□ 5. Review and update documentation
□ 6. Conduct retrospective
```

---

## Error Reference

### Common Errors and Resolutions

| Error | Cause | Resolution |
|-------|-------|------------|
| `KB_CONNECTION_FAILED` | Database unavailable | Check DB, restart if needed |
| `API_RATE_LIMITED` | External API throttled | Wait, reduce polling rate |
| `LLM_TIMEOUT` | LLM service slow | Retry with backoff |
| `VALIDATION_FAILED` | Schema violation | Check data, fix source |
| `GRAPH_CORRUPT` | Graph data issue | Run verification, restore |

---

## Dependencies

- `daily-cycle.md` — Daily procedures
- `failure-recovery.md` — Error handling
- `07-safety/rollback-procedures.md` — Rollback procedures

## Related Documents

- `failure-recovery.md` — Detailed recovery procedures
- `07-safety/error-taxonomy.md` — Error classification

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
