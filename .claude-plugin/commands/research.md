# /nav:research Command

**Entry Point**: Execute research across multiple domains (AI, Web3, PMF, etc.)

---

## Purpose

`/nav:research` is the primary entry point for executing research in the nav-research-engine. It supports multiple domains, allowing you to research AI startups, Web3 protocols, product-market-fit opportunities, and more.

---

## Command Signature

```bash
/nav:research --domain <domain> <query>
```

| Argument | Required | Description |
|----------|----------|-------------|
| `--domain <domain>` | **Yes** | The research domain (ai, web3, pmf, custom) |
| `<query>` | **Yes** | The research query or question |

### Domain Values

| Domain | Description |
|--------|-------------|
| `ai` | AI/ML startups, models, infrastructure, applications |
| `web3` | Blockchain protocols, DeFi, NFTs, DAOs |
| `pmf` | Product-market-fit analysis, customer discovery |
| `market` | Market research, competitive analysis |
| `tech` | Technical deep-dives, architecture reviews |

---

## Behavior

### Domain Flag (Required)

The `--domain` flag is **required**. It determines:
1. Which domain configuration to load
2. How to parse and structure the research query
3. What knowledge schemas to use for entity extraction

### Without Domain Flag

If you call `/nav:research` without `--domain`, the system will prompt you to specify a domain.

---

## Usage Examples

```bash
# Research AI startup opportunities
/nav:research --domain ai find pmf for developer tooling startups

# Research Web3 protocol opportunities
/nav:research --domain web3 analyze defi lending protocols

# Research product-market-fit
/nav:research --domain pmf validate b2b saas hypothesis

# Market research
/nav:research --domain market competitive analysis for fintech

# Technical research
/nav:research --domain tech evaluate langchain alternatives
```

---

## Discovery Mode

If your query is vague or missing key information, the system will enter **Discovery Mode** to ask clarifying questions:

- Purpose: What are you trying to learn?
- Audience: Who is this for?
- Scope: How broad or narrow?
- Timeframe: Current state or future trend?
- Output: What format do you need?

The system proceeds to research once it has enough context, or when you confirm.

---

## Domain Configuration

Each domain has a configuration in:
```
runtime/domains/<domain>/
├── config.yaml       # Domain settings
├── schemas/          # Knowledge schemas
└── prompts/          # Domain-specific prompts
```

---

## Error Handling

| Error | Response |
|-------|----------|
| Missing `--domain` | Display guidance with examples |
| Invalid domain | Show available domains |
| Empty query | Prompt for research question |
| State corrupted | Attempt rollback, prompt user |

---

## Anti-Patterns

This command MUST NOT:

- Execute research without a domain
- Skip quality gates
- Generate arbitrary output formats
- Store state outside runtime/state/

---

## Next Steps After Command

The command outputs:

1. Domain configuration loaded
2. Research prompt (for LLM)
3. Instructions for resuming with results
