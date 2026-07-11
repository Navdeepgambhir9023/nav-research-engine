# Version Strategy

**Document ID**: 05.3
**Domain**: Evolution
**Status**: Draft

---

## Purpose

Defines how the ROS versions itself and its outputs. Ensures that as the system evolves, stakeholders can track what changed and what capabilities are available.

## Audience

- Engineers (for implementation)
- Operations (for deployment)
- Stakeholders (for capability tracking)

## Versioning Philosophy

> Versions should be meaningful. They should tell you what changed and why it matters.

Key principles:
1. **Semantic versioning** for the system
2. **Capability-based** versioning for stakeholders
3. **Provenance tracking** for knowledge

---

## System Versioning

### Semantic Versioning

The ROS follows semantic versioning (SemVer):

```
MAJOR.MINOR.PATCH

Example: 1.2.3

MAJOR: Breaking changes that require migration
MINOR: New capabilities (backward compatible)
PATCH: Bug fixes and improvements
```

### Version Rules

| Change Type | Version Bump | Migration Required |
|------------|-------------|-------------------|
| Breaking change | MAJOR | Yes |
| New capability | MINOR | No |
| Bug fix | PATCH | No |
| Documentation | None | No |
| Internal refactor | PATCH | No |

### Breaking Changes

A breaking change is anything that:
- Removes or renames an API
- Changes expected behavior
- Invalidates existing data formats
- Requires different resources

### Pre-Release Versions

For active development:

```
1.0.0-alpha       # Alpha release
1.0.0-beta.1      # Beta release
1.0.0-rc.1        # Release candidate
1.0.0             # Stable release
```

---

## Capability Versioning

### Capability Levels

For stakeholders, we track capabilities by phase:

| Phase | Version Prefix | Description |
|-------|----------------|-------------|
| Foundation | 0.x | Pre-production, design only |
| Alpha | 0.x | Basic functionality working |
| Beta | 0.x | Production-ready features, testing |
| Production | 1.x | Stable, supported |

### Capability Tracking

Each version documents capabilities:

```markdown
## v0.2.0 - Alpha 2

### Capabilities Added
- Discovery: Basic signal detection from Web3 APIs
- Analysis: LLM-powered insight generation
- Storage: Knowledge base with entity schemas

### Capabilities Changed
- Quality gates: Added Gate 3 (Human Review)

### Known Limitations
- No concurrent mission execution
- Manual intervention required daily
```

---

## Knowledge Versioning

### Knowledge Base Versions

The knowledge base is versioned with each significant update:

```
KB/2026.06.29.v1    # First version
KB/2026.06.30.v1    # Daily update
KB/2026.07.01.v2    # Major update (new entity types)
```

### Version Contents

Each knowledge base version includes:
- Snapshot of all entities
- Graph structure
- Evidence chains
- Provenance records

### Version Retention

| Version Type | Retention | Purpose |
|-------------|-----------|---------|
| Daily snapshots | 30 days | Recent rollback |
| Weekly snapshots | 1 year | Analysis |
| Monthly snapshots | 5 years | Historical |
| Milestone snapshots | Indefinite | Key moments |

---

## Document Versioning

### Document Version Format

```
Document: [Document Name]
Version: [Semantic Version]
Last Updated: [Date]
Status: [Draft | Review | Approved | Deprecated]
```

### Version Status

| Status | Meaning |
|--------|---------|
| **Draft** | In development, may change |
| **Review** | Under review by stakeholders |
| **Approved** | Reviewed and accepted |
| **Deprecated** | Replaced or obsolete |

### Document Change Rules

| Change Type | Version Bump |
|------------|-------------|
| New document | 1.0.0 |
| Significant content change | MINOR |
| Minor fix/addition | PATCH |
| Breaking restructure | MAJOR |

---

## Mission Versioning

### Mission Versioning

Each mission has a version for tracking changes:

```
Mission: protocol-research-2026-001
Version: 1.0         # Initial
Version: 1.1         # Scope change
Version: 2.0         # Major change, restarted
```

### Version Tracking

Mission versions track:
- Objective changes
- Scope changes
- Resource changes
- Output changes

---

## Release Management

### Release Cycle

| Cycle | Frequency | Content |
|-------|-----------|---------|
| **Daily** | Daily | Latest knowledge base |
| **Weekly** | Weekly | Weekly intelligence report |
| **Monthly** | Monthly | Comprehensive snapshot |
| **Quarterly** | Quarterly | Major capability release |

### Release Artifacts

Each release includes:

```
Release v1.2.0/
├── CHANGELOG.md         # What changed
├── CAPABILITIES.md      # What's included
├── MIGRATION.md         # If breaking changes
├── ARTIFACTS/
│   ├── knowledge-base/  # Knowledge snapshots
│   ├── schemas/         # Schema definitions
│   └── docs/            # Documentation
└── VALIDATION/
    └── tests/           # Validation results
```

---

## Dependencies

- `05-evolution/changelog.md` — Change logging
- `05-evolution/roadmap.md` — Phase definitions

## Related Documents

- `03-operations/daily-cycle.md` — Daily versioning
- `02-knowledge/entity-schemas.md` — Schema versioning

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
