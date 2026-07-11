# Mode: research — Standard Research Execution

<!-- ============================================================
     Read modes/_shared.md FIRST for system context.
     ============================================================ -->

## Purpose

Execute a research query with full verification, source tracking, and honest output.

---

## Command Signature

```
/nav:research --domain <domain> <query>
```

| Argument | Required | Description |
|----------|----------|-------------|
| `--domain` | Yes | ai, market, tech, pmf, bio, legal, or any domain |
| `<query>` | Yes | The research question |

---

## Execution Workflow

### Phase 1: Parse & Validate

1. Extract domain from `--domain` flag
2. Load domain context:
   - `runtime/domains/{domain}/config.yaml` (if exists)
   - Default to `modes/_shared.md` settings
3. Validate query is actionable (not just "research this")

**If query is vague:**
→ Enter Discovery Mode (see below)

---

### Phase 2: Discovery

1. **Search for relevant sources**
   - Use WebSearch with domain-specific queries
   - Target 5-10 relevant sources minimum
   - Note: Results may be 1-7 days stale

2. **Classify sources by type:**
   | Type | Examples | Reliability |
   |------|----------|-------------|
   | Primary | Official docs, press releases | High |
   | Secondary | News articles, analyses | Medium |
   | Tertiary | Social media, forums | Low |
   | Opinion | Blog posts, opinion pieces | Flag separately |

3. **Fetch key pages**
   - WebFetch primary sources for direct content
   - Use Playwright for dynamic pages (SPAs)

---

### Phase 3: Verification

For each claim in your research:

1. **Cross-reference** with at least 2 sources when possible
2. **Check for consensus** — do sources agree?
3. **Flag conflicts** — when sources disagree, report honestly
4. **Assess recency** — note data age
5. **Assign confidence** per scale in `_shared.md`

**Verification Status:**
| Status | Meaning |
|--------|---------|
| `VERIFIED` | 2+ independent sources agree |
| `CONFLICTING` | Sources disagree on this point |
| `UNVERIFIED` | Single source or no verification |
| `LIMITATION` | Cannot determine with available data |

---

### Phase 4: Synthesis

1. **Extract key insights** with evidence chains
2. **Quantify confidence** for each insight
3. **Identify knowledge gaps** — what couldn't you determine?
4. **Generate HONEST assessment** — direct, no sugarcoating

---

### Phase 5: Output

Follow `runtime/specifications/brutal-output-template.md`:

```
# Research Report: {Topic}
Generated: {date}
Domain: {domain}
Confidence: {overall-score}%

## Executive Summary
(3 sentences max — the brutal truth)

## Key Findings
- [Finding 1] [SRC-001] [Confidence: XX%]
- [Finding 2] [SRC-002] [Confidence: XX%]

## Source Analysis
### Primary Sources
- {list with reliability ratings}

### Conflicts Detected
- {any disagreements between sources}

## Evidence Chain
{how you verified each claim}

## HONEST ASSESSMENT
(Required — even if negative)
What this really means for the user.

## Limitations
(What you couldn't determine and why)

## Next Steps
(Actionable recommendations)
```

---

## Discovery Mode (Adaptive Questioning)

When query is vague, enter Discovery Mode:

### Required Questions

Ask until you have:

1. **Purpose**: "What decision will this research inform?"
2. **Scope**: "How deep should this go? Quick scan or deep dive?"
3. **Audience**: "Who is this for? Technical or business?"
4. **Timeframe**: "Current state or future projection?"
5. **Constraints**: "Any specific angles or red lines?"

### Question Strategy

- Ask ONE question at a time
- Start with PURPOSE — most clarifying
- If user gives vague answer, ask a specific follow-up
- After 3-5 questions, propose a research direction
- User confirms or adjusts before proceeding

### Example Flow

```
You: What decision will this research inform?
User: I'm deciding whether to enter the AI coding assistant market

You: Quick scan or deep dive?
User: Quick — I need to decide by Friday

You: Got it. So by Friday you'll know:
     - If there's real demand or hype
     - Who the players are and their moats
     - Estimated market size
     - Key risks

     Should I proceed with this scope?
User: Yes, but also check if GitHub Copilot is eating the market
```

---

## Source Tracking

**Format:** `[SRC-XXX]` where XXX is a sequential number

**Source entry format:**
```
[SRC-001] {Title}
URL: {url}
Type: {primary/secondary/tertiary}
Date: {publication date or "unknown"}
Reliability: {high/medium/low}
```

**In-text citation:**
"According to [SRC-001], the market grew 40% YoY."

---

## Domain Configuration

### AI Research
```yaml
sources:
  - name: arxiv
    url: https://arxiv.org
    type: primary
  - name: huggingface
    url: https://huggingface.co
    type: primary
  - name: techcrunch
    url: https://techcrunch.com
    type: secondary
```

### Market Research
```yaml
sources:
  - name: statista
    url: https://statista.com
    type: secondary
  - name: crunchbase
    url: https://crunchbase.com
    type: secondary
```

### Tech Research
```yaml
sources:
  - name: github
    url: https://github.com
    type: primary
  - name: docs
    url: {product docs}
    type: primary
```

---

## Quality Gates

Before outputting, verify:

- [ ] Every factual claim has a `[SRC-XXX]`
- [ ] Every claim has a confidence score
- [ ] Conflicts are explicitly flagged
- [ ] Limitations are stated upfront
- [ ] HONEST ASSESSMENT is present and direct

---

## Error Handling

| Situation | Action |
|-----------|--------|
| No sources found | Report limitation, suggest alternative angles |
| All sources disagree | Report conflict, don't average — let user decide |
| Source page 404s | Mark source as INACCESSIBLE, continue with others |
| Query too broad | Narrow scope, confirm with user |
| Time constraint | Prioritize highest-confidence findings |

---

## Tools Reference

| Tool | When to Use |
|------|-------------|
| `WebSearch` | Initial discovery, finding sources |
| `WebFetch` | Extracting specific page content |
| `Playwright` | Dynamic pages, interactive content |
| `Read` | Local files (configs, docs) |

---

## Integration with Architecture

This mode implements the specifications in:
- `docs/01-architecture/web-research-architecture.md` — Tool integration
- `docs/01-architecture/verification-layer.md` — Verification workflow
- `docs/01-architecture/honesty-framework.md` — Confidence scoring
- `docs/01-architecture/limitations.md` — What we cannot determine

Read these for deeper context on why decisions were made.
