# Entity Schemas

**Document ID**: 02.2
**Domain**: Knowledge
**Status**: Draft

---

## Purpose

Provides JSON Schema definitions for all knowledge entities. These schemas serve as machine-readable contracts for validation, storage, and interoperability between components.

## Audience

- Engineers implementing data models
- Data engineers writing validation logic
- API designers building integrations

## Schema Conventions

All schemas follow these conventions:

1. **JSON Schema Draft 2020-12** format
2. **$id** URIs for schema identification
3. **$defs** for reusable components
4. **Examples** for every schema
5. **Descriptions** for all fields

---

## Core Entity Schemas

### Entity Base Schema

All entities inherit from this base:

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://ros.example.com/schemas/entity-base/v1",
  "title": "EntityBase",
  "description": "Base schema for all knowledge entities",
  "type": "object",
  "required": ["id", "entityType", "createdAt", "updatedAt"],
  "properties": {
    "id": {
      "type": "string",
      "format": "uri",
      "description": "Unique identifier following URI pattern"
    },
    "entityType": {
      "$ref": "#/$defs/EntityType"
    },
    "name": {
      "type": "string",
      "description": "Primary display name"
    },
    "aliases": {
      "type": "array",
      "items": { "type": "string" },
      "description": "Alternative names or abbreviations"
    },
    "description": {
      "type": "string",
      "description": "Human-readable description"
    },
    "properties": {
      "type": "object",
      "description": "Type-specific properties"
    },
    "createdAt": {
      "type": "string",
      "format": "date-time"
    },
    "updatedAt": {
      "type": "string",
      "format": "date-time"
    },
    "validFrom": {
      "type": "string",
      "format": "date-time",
      "description": "When this entity became valid"
    },
    "validUntil": {
      "type": "string",
      "format": "date-time",
      "description": "When this entity stopped being valid (null = current)"
    },
    "confidence": {
      "$ref": "#/$defs/Confidence"
    },
    "sources": {
      "type": "array",
      "items": { "$ref": "#/$defs/Source" }
    }
  }
}
```

---

### Solution Schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://ros.example.com/schemas/solution/v1",
  "title": "Solution",
  "description": "A product, service, or system providing solutions in any domain",
  "type": "object",
  "allOf": [
    { "$ref": "#/$defs/EntityBase" }
  ],
  "required": ["properties"],
  "properties": {
    "properties": {
      "type": "object",
      "required": ["category"],
      "properties": {
        "category": {
          "type": "string",
          "description": "Solution category (defined in domain taxonomy, e.g., platform, service, tool)"
        },
        "ecosystem": {
          "type": "string",
          "description": "Platform or environment (domain-specific)"
        },
        "launchDate": {
          "type": "string",
          "format": "date"
        },
        "status": {
          "enum": ["active", "paused", "deprecated", "acquired"]
        },
        "metrics": {
          "type": "object",
          "description": "Domain-specific key metrics (e.g., TVL for Web3, MAU for SaaS)"
        },
        "domainProperties": {
          "type": "object",
          "description": "Domain-specific properties from domains/<domain>/schemas/solution.md"
        }
      }
    }
  },
  "examples": [
    {
      "id": "https://ros.example.com/entities/solution/acme-platform",
      "entityType": "solution",
      "name": "Acme Platform",
      "aliases": ["Acme"],
      "description": "Enterprise collaboration platform",
      "properties": {
        "category": "platform",
        "ecosystem": "cloud",
        "launchDate": "2020-01-15",
        "status": "active",
        "metrics": {
          "mau": 500000,
          "revenue": 10000000
        }
      },
      "createdAt": "2024-01-15T10:00:00Z",
      "updatedAt": "2024-01-15T10:00:00Z",
      "confidence": {
        "value": 0.95,
        "method": "verified"
      },
      "sources": [
        {
          "type": "webpage",
          "url": "https://acme.com/about",
          "retrievedAt": "2024-01-15T09:55:00Z"
        }
      ]
    }
  ]
}
```

---

### Opportunity Schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://ros.example.com/schemas/opportunity/v1",
  "title": "Opportunity",
  "description": "A potential business opportunity",
  "type": "object",
  "allOf": [
    { "$ref": "#/$defs/EntityBase" }
  ],
  "required": ["properties"],
  "properties": {
    "properties": {
      "type": "object",
      "required": ["type", "score"],
      "properties": {
        "type": {
          "$ref": "#/$defs/OpportunityType"
        },
        "phase": {
          "$ref": "#/$defs/OpportunityPhase"
        },
        "score": {
          "$ref": "#/$defs/OpportunityScore"
        },
        "targetMarkets": {
          "type": "array",
          "items": { "type": "string" }
        },
        "evidenceSummary": {
          "type": "string"
        },
        "riskFactors": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "factor": { "type": "string" },
              "severity": { "enum": ["low", "medium", "high", "critical"] }
            }
          }
        }
      }
    },
    "relationships": {
      "type": "array",
      "items": { "$ref": "#/$defs/Relationship" }
    }
  }
}
```

---

## Enumerated Types

### EntityType

```json
{
  "$defs": {
    "EntityType": {
      "type": "string",
      "enum": [
        "solution",
        "project",
        "person",
        "organization",
        "concept",
        "event",
        "opportunity",
        "trend",
        "threat"
      ]
    }
  }
}
```

### SolutionCategory

Domain-agnostic categories. Domain-specific categories (e.g., DEX, Lending for Web3) are defined in `domains/<domain>/schemas/solution.md`.

```json
{
  "$defs": {
    "SolutionCategory": {
      "type": "string",
      "enum": [
        "platform",
        "service",
        "tool",
        "infrastructure",
        "application",
        "other"
      ]
    }
  }
}
```

### OpportunityType

```json
{
  "$defs": {
    "OpportunityType": {
      "type": "string",
      "enum": [
        "market_entry",
        "integration",
        "partnership",
        "investment",
        "acquisition",
        "product_extension",
        "geographic_expansion",
        "user_segment",
        "creation"
      ]
    }
  }
}
```

### OpportunityPhase

```json
{
  "$defs": {
    "OpportunityPhase": {
      "type": "string",
      "enum": [
        "emerging",
        "growing",
        "mature",
        "declining",
        "unknown"
      ]
    }
  }
}
```

---

## Supporting Schemas

### Confidence

```json
{
  "$defs": {
    "Confidence": {
      "type": "object",
      "required": ["value", "method"],
      "properties": {
        "value": {
          "type": "number",
          "minimum": 0,
          "maximum": 1
        },
        "method": {
          "type": "string",
          "enum": ["verified", "calculated", "estimated", "inferred"]
        },
        "factors": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "name": { "type": "string" },
              "contribution": { "type": "number" }
            }
          }
        }
      }
    }
  }
}
```

### Source

```json
{
  "$defs": {
    "Source": {
      "type": "object",
      "required": ["type", "retrievedAt"],
      "properties": {
        "type": {
          "type": "string",
          "enum": ["api", "webpage", "document", "study", "manual", "derived"]
        },
        "url": { "type": "string", "format": "uri" },
        "title": { "type": "string" },
        "retrievedAt": { "type": "string", "format": "date-time" },
        "accessedBy": { "type": "string" }
      }
    }
  }
}
```

### ValueWithCurrency

```json
{
  "$defs": {
    "ValueWithCurrency": {
      "type": "object",
      "required": ["value", "currency"],
      "properties": {
        "value": { "type": "number" },
        "currency": { "type": "string" },
        "timestamp": { "type": "string", "format": "date-time" }
      }
    }
  }
}
```

### Relationship

```json
{
  "$defs": {
    "Relationship": {
      "type": "object",
      "required": ["type", "targetId"],
      "properties": {
        "type": { "type": "string" },
        "targetId": { "type": "string", "format": "uri" },
        "weight": { "type": "number", "minimum": 0, "maximum": 1 },
        "direction": { "type": "string", "enum": ["outbound", "inbound", "bidirectional"] }
      }
    }
  }
}
```

### OpportunityScore

```json
{
  "$defs": {
    "OpportunityScore": {
      "type": "object",
      "required": ["total", "dimensions"],
      "properties": {
        "total": {
          "type": "number",
          "minimum": 0,
          "maximum": 100
        },
        "dimensions": {
          "type": "object",
          "properties": {
            "marketSize": { "type": "number", "maximum": 100 },
            "feasibility": { "type": "number", "maximum": 100 },
            "timing": { "type": "number", "maximum": 100 },
            "competition": { "type": "number", "maximum": 100 },
            "risk": { "type": "number", "maximum": 100 }
          }
        },
        "methodology": { "type": "string" },
        "calculatedAt": { "type": "string", "format": "date-time" }
      }
    }
  }
}
```

---

## Schema Versioning

| Version | Date | Changes |
|---------|------|---------|
| 1.1.0 | 2026-07-12 | Abstracted for multi-domain use |
| 1.0.0 | 2026-06-29 | Initial schema definitions |

## Dependencies

- `knowledge-model.md` — Conceptual model these schemas implement
- `graph-schema.md` — Relationship type definitions
- `domain-config.md` — Domain schema extension mechanism

## Related Documents

- `scoring-model.md` — How scores are calculated
- `evidence-model.md` — Source and evidence handling

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.2.0 | 2026-07-12 | Abstracted for multi-domain use |
| 0.1.0 | 2026-06-29 | Initial draft |
