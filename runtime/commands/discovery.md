# Adaptive Discovery Engine

> **Purpose:** Determines when and what clarifying questions to ask when a research query is ambiguous or incomplete.

The discovery engine runs after domain parsing but before research execution. It ensures every research mission has sufficient context to produce actionable results.

---

## Trigger Conditions

Discovery activates when ANY of these conditions are true:

| Condition | Detection | Action |
|-----------|-----------|--------|
| **Empty domain** | Domain flag missing or unrecognized | Ask "What domain are you researching?" |
| **Vague purpose** | Query lacks action verbs or outcome language | Ask "What are you trying to learn/accomplish?" |
| **Unclear scope** | No mention of specific entities, sectors, or concepts | Ask "What should be in scope?" |
| **Missing timeframe** | No time boundary (current, Q1 2026, historical) | Ask "What time period matters?" |
| **No output preference** | No mention of desired format or depth | Ask "What format do you need?" |

### Detection Logic

```
IF domain == empty THEN trigger(discovery, "domain")
IF query matches vague_indicators AND domain != "general" THEN trigger(discovery, "purpose")
IF query_entity_count < 2 THEN trigger(discovery, "scope")
IF !has_time_indicator(query) THEN trigger(discovery, "timeframe")
IF !has_output_preference(query) THEN trigger(discovery, "output")
```

---

## Question Categories

### Category 1: Purpose (Intent)
**Goal:** Understand the researcher's objective and success criteria.

- "What decision will this research inform?"
- "What would a successful answer look like?"
- "What problem are you trying to solve?"
- "Who will use this research and why?"

### Category 2: Audience (Context)
**Goal:** Calibrate depth and framing for the end consumer.

- "Who is the audience for this research?"
- "How familiar are they with this topic?"
- "What level of detail do they need?"
- "Are there stakeholders who need to approve or validate findings?"

### Category 3: Scope (Boundaries)
**Goal:** Define what is in and out of bounds.

- "Should this include [sector/region/technology]?"
- "Are there competitors, projects, or frameworks to exclude?"
- "What geographic scope applies?"
- "Are there budget, timeline, or resource constraints?"

### Category 4: Timeframe (Temporal Bounds)
**Goal:** Set the temporal window for evidence.

- "Does current state suffice, or do you need trends?"
- "How far back should historical context go?"
- "Is there a launch date, event, or deadline driving this?"
- "Should projections or forecasts be included?"

### Category 5: Output (Delivery Format)
**Goal:** Clarify how results should be packaged.

- "Do you need a summary, detailed report, or raw findings?"
- "Should findings be prioritized or ranked?"
- "Do you need specific artifacts (comparisons, matrices, timelines)?"
- "Should recommendations or next steps be included?"

---

## Decision Tree

```
START
  │
  ├─► Is domain specified?
  │     ├─ NO  ──► Ask: "What domain?" → GOTO SCOPE
  │     └─ YES ──► GOTO PURPOSE
  │
  ├─► Is purpose clear?
  │     ├─ NO  ──► Ask: "What decision/problem?"
  │     │           Wait for response → GOTO AUDIENCE
  │     └─ YES ──► GOTO AUDIENCE
  │
  ├─► Is audience defined?
  │     ├─ NO  ──► Ask: "Who needs this?"
  │     │           Wait for response → GOTO SCOPE
  │     └─ YES ──► GOTO SCOPE
  │
  ├─► Is scope bounded?
  │     ├─ NO  ──► Ask: "What should be included/excluded?"
  │     │           Wait for response → GOTO TIMEFRAME
  │     └─ YES ──► GOTO TIMEFRAME
  │
  ├─► Is timeframe specified?
  │     ├─ NO  ──► Ask: "What time period?"
  │     │           Wait for response → GOTO OUTPUT
  │     └─ YES ──► GOTO OUTPUT
  │
  ├─► Is output format clear?
  │     ├─ NO  ──► Ask: "What format/depth?"
  │     │           Wait for response → END
  │     └─ YES ──► END
  │
  └─► END (all questions answered or max iterations reached)
```

---

## Exit Criteria

Discovery is complete (stop asking questions) when ANY of:

1. **All five categories answered** — Purpose, Audience, Scope, Timeframe, Output all have values
2. **User says "proceed"** — Explicit signal to move forward with current info
3. **User declines to answer** — "I don't know" or "any" treated as "default/general"
4. **Max iterations reached** — After 3 rounds, summarize what's known and suggest defaults
5. **Query becomes clear** — Subsequent input resolves all ambiguities

### Exit Protocol

When exiting due to max iterations:

```
SUMMARIZE:
  "Based on our conversation, I'll research: [domain] about [query]
   for [audience]. Scope: [scope]. Timeframe: [timeframe].
   Output: [format]."

DEFAULT ASSUMPTIONS:
  - Audience: "general"
  - Scope: "broad but focused on key elements"
  - Timeframe: "current state and recent developments"
  - Output: "structured summary with key findings"

ASK: "Shall I proceed with these defaults, or do you want to refine something?"
```

---

## Example Dialogues

### Example 1: Vague Query → Full Discovery

**Input:** `/nav:research find opportunities`

**Discovery Flow:**

```
System: What domain are you researching?
User:  web3

System: What are you trying to learn or accomplish?
User:  Find DeFi opportunities for Q3

System: Who is this research for?
User:  My investment team

System: Should this cover lending, derivatives, or yield?
User:  Lending and yield strategies

System: Does Q3 2026 suffice, or do you need historical trends?
User:  Q3 projections mainly

System: Do you need a ranked list, comparison matrix, or detailed analysis?
User:  Ranked opportunities with risk assessment

System: I'll research: Web3 DeFi lending and yield opportunities
         for investment team. Scope: Q3 2026 projections with risk assessment.
         Output: Ranked list with risk factors.

Proceed? [yes/default]
```

### Example 2: Clear Query → Minimal Discovery

**Input:** `/nav:research --domain ai "Analyze LLM model comparison for enterprise buyers"`

**Discovery Flow:**

```
System: (Detects sufficient context)
  - Domain: ai ✓
  - Purpose: Analyze LLM model comparison ✓
  - Audience: Enterprise buyers ✓
  - Scope: implied (LLM models) ✓
  - Timeframe: current (implied) ✓

System: "I have enough context. Proceeding with research on
        LLM model comparison for enterprise buyers with
        current market focus."

Proceed? [yes/default]
```

### Example 3: Partial Clarity → Targeted Questions

**Input:** `/nav:research --domain web3 "Layer 2 ecosystems"`

**Discovery Flow:**

```
System: (Partially complete)

System: What are you trying to learn about Layer 2 ecosystems?
User:  Which has the most developer activity

System: Is developer activity measured by GitHub commits, TVL, or ecosystem projects?
User:  GitHub activity and documentation updates

System: Current snapshot or trend over time?
User:  Last 6 months

System: "Researching: Layer 2 ecosystems developer activity
         Scope: GitHub commits and docs updates, last 6 months
         Output: Comparison with activity metrics"

Proceed? [yes/default]
```

### Example 4: User Declines to Answer

**Input:** `/nav:research --domain ai "anything interesting"`

**Discovery Flow:**

```
System: What are you trying to learn?
User:  I don't know, just find interesting things

System: (User declined purpose. Apply defaults.)

System: "I'll research current AI developments with a broad
        scan for notable trends and breakthroughs.
        I'll surface the most significant findings."

Proceed? [yes/default]
```

---

## Integration with Command Layer

The discovery engine is invoked from `research.sh` when:

1. Domain is missing or unrecognized
2. The `--discover` flag is passed explicitly
3. Automatic detection identifies vague queries

```bash
# From research.sh
DOMAIN=$(echo "$PARSE_RESULT" | cut -d'|' -f1 | cut -d'=' -f2)
QUERY=$(echo "$PARSE_RESULT" | cut -d'|' -f2 | cut -d'=' -f2-)

if [ -z "$DOMAIN" ] || [ "$FORCE_DISCOVER" = "true" ]; then
  echo "Starting discovery mode..."
  # Invoke discovery questions, capture responses
  # Re-parse with full context
fi
```

---

## Quality Gates

- Discovery responses must be captured in `runtime/state/discovery-context.json`
- The research prompt must include the discovery context as background
- If discovery was skipped, the prompt must note "domain/context assumed"

---

## Anti-Patterns

1. **Never skip discovery for "efficiency"** — Incomplete context produces wasted research
2. **Never assume intent** — Ask even obvious-seeming questions
3. **Never force answers** — "I don't know" is valid; use defaults
4. **Never skip exit summary** — User must confirm before proceeding
