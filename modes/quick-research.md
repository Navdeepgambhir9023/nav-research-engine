# Mode: quick-research — Rapid Assessment

<!-- ============================================================
     Read modes/_shared.md FIRST for system context.
     Time budget: 5 minutes maximum.
     ============================================================ -->

## Purpose

Get a rapid, focused assessment when you need:
- Quick gut-check on a claim
- Surface-level overview
- Whether to go deeper
- First-pass before deep research

**NOT for:** High-stakes decisions, comprehensive analysis

**Time estimate:** 3-5 minutes

---

## Command Signature

```
/nav:research --domain <domain> --quick <query>
```

Or as quick mode:
```
/nav:research --mode quick --domain <domain> <query>
```

---

## Execution Workflow

### Step 1: Fast Search (1 min)

Run ONE targeted search:
```
{query} OR {specific-aspect}
```

Get 3-5 sources maximum. Don't go deep.

---

### Step 2: Quick Scan (2 min)

Scan sources for:
- Key data points
- Contradicting information
- Recency
- Source reliability

Don't read every word. Scan for signals.

---

### Step 3: Rapid Assessment (1 min)

Classify quickly:

| Signal | Confidence |
|--------|------------|
| Multiple sources agree, recent | HIGH (80-100%) |
| Sources agree, older | MEDIUM (60-79%) |
| Single source | LOW (40-59%) |
| Contradicting | FLAG CONFLICT |
| No clear data | UNCERTAIN (<40%) |

---

### Step 4: Quick Output (1 min)

```
# Quick Research: {Topic}

**Confidence:** {overall-score}%
**Time:** {time-spent}

## Verdict
{1-2 sentences. The answer.}

## Key Signal
{Most important finding}

## Source
[SRC-001] {source}

## Confidence Breakdown
- {claim}: {score}%
- {claim}: {score}%

## Limitation
{1 sentence on what wasn't covered}

## Go Deeper?
{Yes/No/Maybe + reason}
```

---

## Quality Bar

Even quick research must:
- [ ] Cite at least 1 source
- [ ] State confidence
- [ ] Acknowledge limitations
- [ ] Not overstate certainty

---

## When to Escalate

Go to `deep-research.md` when:
- High-stakes decision depends on answer
- Multiple factors at play
- Confidence below 60%
- User asks for more detail

---

## Examples

### Quick: "Is Python still popular?"
```
# Quick Research: Python Popularity

**Confidence:** 75%
**Time:** 4 min

## Verdict
Yes, Python remains dominant in AI/ML and data science, but JavaScript leads in web development.

## Key Signal
Stack Overflow 2024 survey shows Python most wanted language for 5th consecutive year.

## Source
[SRC-001] Stack Overflow Developer Survey 2024

## Confidence Breakdown
- Python #1 in AI/ML: 80%
- JavaScript #1 overall: 70%

## Limitation
Stack Overflow surveys skew toward web developers.

## Go Deeper?
Yes — the picture differs significantly by domain.
```

### Quick: "Is now a good time to enter AI coding assistants?"
```
# Quick Research: AI Coding Assistant Market Entry

**Confidence:** 55%
**Time:** 5 min

## Verdict
Market is crowded and GitHub Copilot has strong first-mover advantage, but developer adoption is still <20% — room exists for specialists.

## Key Signal
Analysts estimate 15-18% developer adoption of AI coding tools despite 2+ years on market.

## Sources
[SRC-001] GitHub Copilot adoption stats
[SRC-002] Developer survey on AI tools

## Confidence Breakdown
- Crowded market: 75%
- Room for specialists: 60%
- Exact adoption %: 50%

## Limitation
No reliable market size data available publicly.

## Go Deeper?
Yes — this decision needs deep research on differentiation and positioning.
```

---

## Anti-Patterns

**Don't:**
- Do full research in quick mode
- Skip sources
- Present speculation as fact
- Ignore low confidence
- Take 10+ minutes "just because"

**Do:**
- Stay focused
- Flag uncertainty
- Know when to stop
- Recommend next steps

---

## Integration

For complete specifications, read:
- `modes/research.md` for standard research
- `modes/deep-research.md` for comprehensive analysis
