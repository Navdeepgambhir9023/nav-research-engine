# /nav:research Command

**Entry Point**: Execute research with full verification and honest output.

---

## Purpose

`/nav:research` is the primary entry point for executing research in nav-research-engine. It supports any domain, validates all claims against sources, and produces brutally honest output.

---

## Command Signature

```bash
/nav:research --domain <domain> [options] <query>
```

| Argument | Required | Description |
|----------|----------|-------------|
| `--domain <domain>` | **Yes** | Research domain (ai, market, tech, pmf, bio, legal, etc.) |
| `--deep` | No | Comprehensive 6-axis investigation |
| `--quick` | No | Rapid assessment (5 min max) |
| `<query>` | **Yes** | The research question |

---

## Mode Selection

| Mode | When to Use | Time |
|------|-------------|------|
| Default | Standard research | 10-15 min |
| `--deep` | High-stakes decisions | 15-30 min |
| `--quick` | Gut-check, first-pass | 3-5 min |

---

## Research Modes

Read the mode files to execute research:

1. **First:** Read `modes/_shared.md` for system context
2. **Then:** Read the appropriate mode:
   - `modes/research.md` — Standard research
   - `modes/deep-research.md` — Comprehensive investigation
   - `modes/quick-research.md` — Rapid assessment

---

## Execution Flow

### 1. Parse Input
```
/nav:research --domain ai "is there market for AI coding assistants"
```

### 2. Load Mode
- Read `modes/_shared.md` first
- Then read `modes/research.md` (default)
- Or `modes/deep-research.md` if `--deep` flag
- Or `modes/quick-research.md` if `--quick` flag

### 3. Execute Research
Follow the mode's workflow:
1. Discovery — Find sources
2. Verification — Cross-reference claims
3. Synthesis — Build findings
4. Output — Follow brutal template

### 4. Adaptive Questioning
If query is vague, the mode will ask clarifying questions:
- What decision does this inform?
- Quick scan or deep dive?
- Any specific angles to focus on?

---

## Output Format

All research MUST follow `runtime/specifications/brutal-output-template.md`:

```
# Research Report: {Topic}

## Executive Summary
(3 sentences max — brutal truth)

## Key Findings
- [Finding] [SRC-001] [Confidence: XX%]

## HONEST ASSESSMENT
(Required — even if negative)

## Limitations
(What couldn't be determined)
```

---

## Quality Gates

Every output must have:
- [ ] Source citations `[SRC-XXX]` for all claims
- [ ] Confidence scores (0-100%) for all findings
- [ ] Conflicts explicitly flagged
- [ ] HONEST ASSESSMENT section
- [ ] Limitations clearly stated

---

## Domain Flexibility

Any domain works — specify what you're researching:
- `--domain ai` — AI/ML topics
- `--domain market` — Market research
- `--domain tech` — Technical deep-dives
- `--domain pmf` — Product-market-fit
- `--domain bio` — BioTech/Healthcare
- `--domain legal` — Legal/Compliance

If no domain-specific config exists, use default settings from `modes/_shared.md`.

---

## Error Handling

| Error | Response |
|-------|----------|
| Missing `--domain` | Prompt for domain specification |
| No sources found | Report limitation, suggest alternative angles |
| Sources conflict | Report conflict honestly, don't average |
| Time constraint | Prioritize highest-confidence findings |

---

## Anti-Patterns (MUST NOT)

- Skip source citations
- Overstate confidence
- Hide negative findings
- Skip quality gates
- Fabricate data

---

## Architecture Reference

The mode files implement these specifications:
- `docs/01-architecture/web-research-architecture.md` — Tool integration
- `docs/01-architecture/verification-layer.md` — Evidence validation
- `docs/01-architecture/honesty-framework.md` — Confidence scoring
- `docs/01-architecture/limitations.md` — What cannot be determined

---

## Examples

```bash
# Standard research
/nav:research --domain ai find pmf for developer tooling

# Deep investigation
/nav:research --domain market --deep "should I enter the AI coding assistant market?"

# Quick check
/nav:research --domain tech --quick "is React still popular?"
```
