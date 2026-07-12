name: research
description: "Execute domain-agnostic research with brutal honesty. Run `/nav:research --domain <domain> <query>` to start. Reads modes/_shared.md and modes/research.md for execution workflow."
metadata:
  version: "1"
  tags: "research,discovery,verification,honesty,domain-agnostic"
  entrypoints: "/nav:research"
  author: "nav-research-engine"
---

# Research Skill — Domain-Agnostic Research with Brutal Honesty

**Purpose**: Execute research queries with full verification, source tracking, and honest output.

---

## Quick Start

```
/nav:research --domain <domain> <query>
```

**Examples:**
```
/nav:research --domain ai "is there market for AI coding assistants"
/nav:research --domain market --deep "should I enter the fintech space?"
/nav:research --domain tech --quick "is Rust replacing C++?"
```

---

## Before You Start — Read System Context

1. **Read `modes/_shared.md`** — Global rules, confidence scale, honesty principles
2. **Read `modes/research.md`** — Standard execution workflow
3. **Read architecture specs** (for context):
   - `docs/01-architecture/web-research-architecture.md`
   - `docs/01-architecture/verification-layer.md`
   - `docs/01-architecture/honesty-framework.md`

---

## Modes

| Mode | Flag | When to Use | Time |
|------|------|-------------|------|
| Standard | (default) | General research | 10-15 min |
| Deep | `--deep` | Comprehensive investigation | 15-30 min |
| Quick | `--quick` | Rapid gut-check | 3-5 min |

---

## Execution Workflow

### Phase 1: Parse & Validate

1. Extract domain from `--domain` flag
2. Validate query is actionable
3. If vague → enter Discovery Mode

### Phase 2: Discovery

1. **Search** — Use WebSearch for 5-10 relevant sources
2. **Classify sources** — Primary (high), Secondary (medium), Tertiary (low)
3. **Fetch key pages** — WebFetch primary sources

### Phase 3: Verification

For each claim:
- Cross-reference with 2+ sources
- Check for consensus
- Flag conflicts honestly
- Assign confidence (0-100%)

### Phase 4: Synthesis

- Extract key insights with evidence chains
- Quantify confidence per insight
- Identify knowledge gaps
- Generate HONEST ASSESSMENT

### Phase 5: Output

Follow `runtime/specifications/brutal-output-template.md`

---

## Adaptive Questioning

If query is vague, ask ONE question at a time:

1. **Purpose**: "What decision will this inform?"
2. **Scope**: "Quick scan or deep dive?"
3. **Audience**: "Technical or business?"
4. **Timeframe**: "Current or future projection?"
5. **Constraints**: "Specific angles or red lines?"

Proceed when scope is clear.

---

## Source Tracking

**Format:** `[SRC-001]`

```
[SRC-001] {Title}
URL: {url}
Type: {primary/secondary/tertiary}
Reliability: {high/medium/low}
```

---

## Confidence Scale

| Score | Level | Meaning |
|-------|-------|---------|
| 90-100% | HIGH | Verified, recent, multiple sources |
| 70-89% | MEDIUM | Supported, minor gaps |
| 50-69% | LOW | Plausible, unverified |
| 0-49% | UNCERTAIN | Speculation, contradictory |

---

## Quality Gates

Before output, verify:
- [ ] Every claim has `[SRC-XXX]`
- [ ] Every claim has confidence score
- [ ] Conflicts flagged
- [ ] HONEST ASSESSMENT present
- [ ] Limitations stated

---

## Anti-Patterns (MUST NOT)

- Skip source citations
- Overstate confidence
- Hide negative findings
- Skip quality gates
- Fabricate data

---

## Relationship to Other Skills

| Skill | Purpose |
|-------|---------|
| `/nav:brainstorm` | Clarify research direction |
| `/nav:goal` | Define research scope and success |
| `/nav:plan` | Plan research execution |
| `/nav:research` | Execute research (this skill) |

---

## Files Reference

**Execution layer:**
- `modes/_shared.md` — System context
- `modes/research.md` — Standard workflow
- `modes/deep-research.md` — Comprehensive mode
- `modes/quick-research.md` — Rapid mode

**Architecture (context):**
- `docs/01-architecture/web-research-architecture.md`
- `docs/01-architecture/verification-layer.md`
- `docs/01-architecture/honesty-framework.md`
- `docs/01-architecture/limitations.md`

**Output spec:**
- `runtime/specifications/brutal-output-template.md`

---

## The Brutal Truth Rule

> "Save users time and money, even when the truth is harsh."

If research shows no opportunity → say it directly.
If risks are high → don't minimize.
If viability is uncertain → flag it.

**Never** invent opportunities or oversell findings.
