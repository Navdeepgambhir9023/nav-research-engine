---
name: research
description: Execute the daily Web3 research mission
---

# /research

Execute the Research Operating System daily mission.

## Usage

```
/research
/research --resume
/research --mission <id>
```

## What It Does

1. Load execution state
2. Determine or generate mission
3. Generate research prompt
4. Await your research
5. Extract and validate knowledge
6. Update knowledge base
7. Queue tomorrow's mission

## Prerequisites

- Read `docs/` for architecture specifications
- Read `runtime/state/loop-state.json` for state

## Next Steps

Run `/research` to begin today's mission.
