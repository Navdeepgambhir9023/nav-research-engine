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

### Protocol Schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://ros.example.com/schemas/protocol/v1",
  "title": "Protocol",
  "description": "DeFi protocol, L1/L2 blockchain, or infrastructure project",
  "type": "object",
  "allOf": [
    { "$ref": "#/$defs/EntityBase" }
  ],
  "required": ["properties"],
  "properties": {
    "properties": {
      "type": "object",
      "required": ["category", "ecosystem"],
      "properties": {
        "category": {
          "$ref": "#/$defs/ProtocolCategory"
        },
        "ecosystem": {
          "type": "string",
          "description": "Primary blockchain ecosystem"
        },
        "launchDate": {
          "type": "string",
          "format": "date"
        },
        "status": {
          "enum": ["active", "paused", "deprecated", "acquired"]
        },
        "tvl": {
          "$ref": "#/$defs/ValueWithCurrency"
        },
        "token": {
          "type": "object",
          "properties": {
            "symbol": { "type": "string" },
            "address": { "type": "string" },
            "chain": { "type": "string" }
          }
        },
        "audits": {
          "type": "array",
          "items": { "$ref": "#/$defs/Audit" }
        }
      }
    }
  },
  "examples": [
    {
      "id": "https://ros.example.com/entities/protocol/uniswap-v3",
      "entityType": "protocol",
      "name": "Uniswap V3",
      "aliases": ["Uniswap", "UNI"],
      "description": "Automated market maker protocol on Ethereum",
      "properties": {
        "category": "dex",
        "ecosystem": "ethereum",
        "launchDate": "2021-05-05",
        "status": "active",
        "tvl": {
          "value": 4500000000,
          "currency": "USD"
        },
        "token": {
          "symbol": "UNI",
          "address": "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F9840",
          "chain": "ethereum"
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
          "type": "api",
          "url": "https://api.thegraph.com/subgraphs/name/uniswap/uniswap-v3",
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
  "description": "A potential business opportunity in the Web3 ecosystem",
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
        "protocol",
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

### ProtocolCategory

```json
{
  "$defs": {
    "ProtocolCategory": {
      "type": "string",
      "enum": [
        "dex",
        "lending",
        "yield",
        "derivatives",
        "options",
        "stablecoin",
        "nft",
        "gaming",
        "social",
        "infrastructure",
        "bridge",
        "oracle",
        "dao",
        "layer1",
        "layer2",
        "middleware",
        "wallet",
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
        "protocol_creation"
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

### Audit

```json
{
  "$defs": {
    "Audit": {
      "type": "object",
      "required": ["auditor", "date"],
      "properties": {
        "auditor": { "type": "string" },
        "date": { "type": "string", "format": "date" },
        "reportUrl": { "type": "string", "format": "uri" },
        "result": { "enum": ["passed", "failed", "conditional"] }
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
| 1.0.0 | 2026-06-29 | Initial schema definitions |

## Dependencies

- `knowledge-model.md` — Conceptual model these schemas implement
- `graph-schema.md` — Relationship type definitions

## Related Documents

- `scoring-model.md` — How scores are calculated
- `evidence-model.md` — Source and evidence handling

## Change History

| Version | Date | Change |
|---------|------|--------|
| 0.1.0 | 2026-06-29 | Initial draft |
