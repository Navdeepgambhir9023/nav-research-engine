#!/bin/bash
#
# parse-input.sh - Extract domain and query from command arguments
#
# Usage: parse-input.sh [args...]
#
# Examples:
#   parse-input.sh --domain ai find pmf           # -> domain=ai|query=find pmf
#   parse-input.sh "find market"                  # -> domain=|query=find market
#   parse-input.sh --domain=web3 defi analysis   # -> domain=web3|query=defi analysis

set -euo pipefail

# Default values
domain=""
query=""

# Process arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --domain)
            if [[ -z "${2:-}" ]]; then
                echo "Error: --domain requires a value" >&2
                exit 1
            fi
            domain="$2"
            shift 2
            ;;
        --domain=*)
            domain="${1#*=}"
            shift
            ;;
        *)
            # If no domain flag was provided, this could be the query
            if [[ -z "$domain" ]] && [[ "$1" != --* ]]; then
                query="$*"
                break
            else
                # Remaining args form the query
                query="$*"
                break
            fi
            ;;
    esac
done

# Output in specified format
echo "domain=${domain}|query=${query}"
