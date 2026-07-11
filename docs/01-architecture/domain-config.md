# Domain Configuration Architecture

**Document ID**: 01.7
**Domain**: Architecture
**Status**: Draft

---

## Purpose

Defines the structure, loading mechanism, and conventions for domain configurations in the Research Operating System. Domains are pluggable knowledge areas that allow the ROS to research any vertical beyond Web3.

## Audience

- Architects designing domain plugins
- Contributors adding new domains
- Runtime developers implementing the domain loader

---

## Overview

A **domain** is a self-contained configuration unit that defines how the ROS researches a specific vertical. Each domain owns:

- Its entity schemas and types
- Its taxonomy and categorization system
- Its integration adapters (if external systems differ from defaults)
- Its research templates and prompts

Domains live under `domains/` at the repository root:

```
nav-research-engine/
├── domains/
│   ├── web3/              # Web3 domain (existing content)
│   │   ├── domain.yaml
│   │   ├── schemas/
│   │   ├── taxonomy.md
│   │   ├── integrations/
│   │   └── templates/
│   └── <new-domain>/      # Future domains
│       ├── domain.yaml
│       └── ...
```

---

## Required Files

### domain.yaml

Every domain must have a `domain.yaml` at its root. This is the single source of truth for domain metadata.

**Schema:**

```yaml
domain:
  name: string              # Unique identifier (e.g., "web3", "fintech")
  version: semver            # Domain config version (e.g., "1.0.0")
  display_name: string       # Human-readable name (e.g., "Web3")
  description: string        # Brief description of the domain

entities:
  - name: string            # Entity type name
    plural: string           # Plural form for display
    required_fields:          # Fields every entity must have
      - string
    optional_fields:          # Additional fields for this type
      - string

taxonomies:
  primary: string            # Name of primary taxonomy file
  files:
    - string                 # List of taxonomy file paths

integrations:
  enabled: boolean           # Whether domain has custom integrations
  adapters: []               # List of adapter names (if custom)

templates:
  research: string           # Path to research prompt template
  extraction: string         # Path to extraction template
```

**Example (minimal):**

```yaml
domain:
  name: "blank"
  version: "1.0.0"
  display_name: "Blank Domain"
  description: "Minimal domain for testing"

entities:
  - name: "Entity"
    plural: "Entities"
    required_fields:
      - "id"
      - "name"
    optional_fields:
      - "description"

taxonomies:
  primary: "taxonomy.md"
  files:
    - "taxonomy.md"

integrations:
  enabled: false
  adapters: []

templates:
  research: "templates/research.md"
  extraction: "templates/extraction.md"
```

---

## Optional Directories

### schemas/

Custom entity schemas for domain-specific validation.

```
schemas/
├── entity.schema.yaml      # Core entity schema
├── signal.schema.yaml      # Signal schema
└── insight.schema.yaml     # Insight schema
```

Files here extend or override the base schemas defined in `docs/04-knowledge/`.

### integrations/

Domain-specific integration adapters.

```
integrations/
├── adapters/
│   └── <adapter-name>.sh   # Adapter scripts
└── config.yaml            # Adapter configuration
```

### templates/

Domain-specific research and extraction prompts.

```
templates/
├── research.md            # Research prompt template
├── extraction.md          # Knowledge extraction template
└── validation.md          # Quality gate template
```

### taxonomy.md

The primary taxonomy file (referenced in `domain.yaml`).

```
taxonomy.md
```

Contains domain-specific categorization hierarchies (see `docs/04-knowledge/taxonomy.md`).

---

## Web3 Domain Handling

The existing Web3 content in the repository will be archived, not migrated:

> **Decision**: Web3 domain configs will be created as `domains/web3/` with fresh configurations. Existing docs under `docs/04-knowledge/`, `docs/03-departments/`, and related areas will remain in place until explicitly migrated. This preserves the current working state while establishing the new structure.

**Migration path:**
1. Create `domains/web3/domain.yaml` with Web3-specific entity types and taxonomies
2. Move Web3-specific taxonomies to `domains/web3/taxonomy.md`
3. Update references in runtime layer to load from domain config
4. Archive old docs after migration is complete

---

## Domain Loading Mechanism

### Runtime Behavior

When the ROS starts with a domain flag:

```bash
/research --domain web3
```

The runtime performs these steps:

1. **Discovery**: Scan `domains/` for directories containing `domain.yaml`
2. **Validation**: Parse and validate `domain.yaml` against the schema
3. **Loading**: Load domain config into runtime state
4. **Composition**: Merge domain-specific config with base configuration
5. **Initialization**: Initialize domain adapters if configured

### Loading Algorithm

```
function load_domain(domain_name):
    domain_path = "domains/" + domain_name + "/domain.yaml"
    
    if not exists(domain_path):
        raise DomainNotFoundError(domain_name)
    
    config = parse_yaml(domain_path)
    
    if not validate_domain_config(config):
        raise InvalidDomainConfig(domain_name)
    
    base_config = load_base_config()
    merged = merge_configs(base_config, config)
    
    return DomainContext(name, merged)
```

### Fallback Behavior

| Scenario | Behavior |
|----------|----------|
| No `--domain` flag | Use default domain (currently Web3) |
| Unknown domain | Error with available domains listed |
| Invalid domain.yaml | Error with validation details |
| Missing optional dirs | Use empty defaults |

---

## Discovery and Registration

Domains are self-registering via the directory structure:

1. Runtime scans `domains/` at startup
2. Each subdirectory with `domain.yaml` is a valid domain
3. Domain list is available via `/loop domains` command

**Validation on load:**
- `domain.yaml` must be valid YAML
- `name` field must be unique across all domains
- `version` must be valid semver
- Referenced files must exist (for taxonomies and templates)

---

## Dependencies

- `runtime/specifications/` — Runtime specs that consume domain config
- `docs/04-knowledge/knowledge-model.md` — Core entity definitions (extended by domains)
- `docs/04-knowledge/taxonomy.md` — Base taxonomy (domain taxonomies extend this)

## Related Documents

- `system-context.md` — System boundaries where domains fit
- `component-contracts.md` — Runtime component interfaces
- `runtime/commands/` — Command layer that passes domain flags

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-07-12 | Initial draft |
