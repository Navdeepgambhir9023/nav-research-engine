#!/bin/bash
#
# research.sh - Research command entry point with domain support
#
# Usage: research.sh [args...]
#
# Parses --domain <domain> <query> format and routes to appropriate domain config.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PARSE_SCRIPT="$SCRIPT_DIR/parse-input.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Load state
STATE_DIR="$PROJECT_ROOT/runtime/state"
LOOP_STATE="$STATE_DIR/loop-state.json"

# Parse input
parse_input() {
    if [[ ! -f "$PARSE_SCRIPT" ]]; then
        echo "Error: parse-input.sh not found at $PARSE_SCRIPT" >&2
        exit 1
    fi

    local result
    result="$(bash "$PARSE_SCRIPT" "$@")"

    # Extract domain and query from result
    domain="$(echo "$result" | sed -n 's/^domain=\([^|]*\).*/\1/p')"
    query="$(echo "$result" | sed -n 's/.*|query=\(.*\)$/\1/p')"

    export DOMAIN="$domain"
    export QUERY="$query"
}

# Show usage/help
show_usage() {
    echo "Usage: /nav:research --domain <domain> <query>"
    echo ""
    echo "Required arguments:"
    echo "  --domain <domain>    Research domain (ai, web3, pmf, market, tech)"
    echo "  <query>              The research question or task"
    echo ""
    echo "Examples:"
    echo "  /nav:research --domain ai find pmf for developer tooling"
    echo "  /nav:research --domain web3 analyze defi lending protocols"
    echo "  /nav:research --domain pmf validate b2b saas hypothesis"
    echo ""
    echo "Available domains:"
    echo "  ai      - AI/ML startups, models, infrastructure"
    echo "  web3    - Blockchain protocols, DeFi, NFTs, DAOs"
    echo "  pmf     - Product-market-fit analysis"
    echo "  market  - Market research, competitive analysis"
    echo "  tech    - Technical deep-dives, architecture reviews"
}

# Validate domain
validate_domain() {
    local domain="$1"
    local valid_domains="ai web3 pmf market tech"

    if [[ -z "$domain" ]]; then
        echo -e "${RED}Error: Domain is required${NC}" >&2
        echo "" >&2
        show_usage >&2
        exit 1
    fi

    if [[ ! " $valid_domains " =~ " $domain " ]]; then
        echo -e "${RED}Error: Invalid domain '$domain'${NC}" >&2
        echo "" >&2
        echo -e "${YELLOW}Available domains:${NC}" >&2
        echo "  ai      - AI/ML startups, models, infrastructure" >&2
        echo "  web3    - Blockchain protocols, DeFi, NFTs, DAOs" >&2
        echo "  pmf     - Product-market-fit analysis" >&2
        echo "  market  - Market research, competitive analysis" >&2
        echo "  tech    - Technical deep-dives, architecture reviews" >&2
        exit 1
    fi
}

# Load domain configuration
load_domain_config() {
    local domain="$1"
    local domain_dir="$PROJECT_ROOT/runtime/domains/$domain"

    if [[ -d "$domain_dir" ]]; then
        export DOMAIN_CONFIG="$domain_dir/config.yaml"
        export DOMAIN_DIR="$domain_dir"
    else
        # Domain directory doesn't exist yet - will use defaults
        export DOMAIN_CONFIG=""
        export DOMAIN_DIR=""
    fi
}

# Execute research for domain
execute_research() {
    local domain="$1"
    local query="$2"

    echo -e "${GREEN}Research Engine${NC}"
    echo -e "${GREEN}================${NC}"
    echo ""
    echo -e "${YELLOW}Domain:${NC} $domain"
    echo -e "${YELLOW}Query:${NC} $query"
    echo ""

    # Create state checkpoint
    mkdir -p "$STATE_DIR"

    # Save execution state
    cat > "$LOOP_STATE" <<EOF
{
  "status": "ready",
  "domain": "$domain",
  "query": "$query",
  "timestamp": "$(date -Iseconds)",
  "phase": "awaiting_research"
}
EOF

    echo -e "${GREEN}State saved.${NC}"
    echo ""
    echo "Ready for research execution."
    echo ""
    echo "Next steps:"
    echo "  1. Execute research based on the query"
    echo "  2. Use /nav:research --resume to process results"
}

# Main execution
main() {
    # Parse command line arguments
    parse_input "$@"

    # Validate domain is provided
    validate_domain "$DOMAIN"

    # Load domain configuration
    load_domain_config "$DOMAIN"

    # Execute research
    execute_research "$DOMAIN" "$QUERY"
}

# Show help if no args or --help
if [[ $# -eq 0 ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    show_usage
    exit 0
fi

# Run main
main "$@"
