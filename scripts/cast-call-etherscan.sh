#!/bin/bash

# Foundry Cast Call Script with Etherscan ABI fetching
# Loads configuration from .env file

set -e

# =============================================================================
# LOAD CONFIGURATION FROM .env
# =============================================================================

# Find project root (parent directory of scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$PROJECT_ROOT/.env"

# Check if .env exists, fallback to .env.example
if [[ ! -f "$ENV_FILE" ]]; then
    ENV_FILE="$PROJECT_ROOT/.env.example"
    if [[ ! -f "$ENV_FILE" ]]; then
        echo "Error: .env file not found. Please create one from .env.example"
        exit 1
    fi
    echo "Warning: Using .env.example as fallback. Please copy it to .env"
fi

# Load environment variables from .env
export $(grep -v '^#' "$ENV_FILE" | grep -v '^$' | xargs)

# =============================================================================
# SCRIPT LOGIC - Don't edit below this line unless you know what you're doing
# =============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print error and exit
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    exit 1
}

# Function to print info
print_info() {
    echo -e "${BLUE}Info: $1${NC}"
}

# Function to print success
print_success() {
    echo -e "${GREEN}Success: $1${NC}"
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}Warning: $1${NC}"
}


# Validate configuration
if [[ -z "$CONTRACT_ADDRESS" ]]; then
    error_exit "CONTRACT_ADDRESS not set in .env file"
fi

if [[ -z "$FROM_ADDRESS" ]]; then
    error_exit "FROM_ADDRESS not set in .env file"
fi

if [[ -z "$RPC_URL" ]]; then
    error_exit "RPC_URL not set in .env file"
fi

# Validate Ethereum address format (basic check)
if [[ ! "$CONTRACT_ADDRESS" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
    error_exit "Invalid contract address format: $CONTRACT_ADDRESS"
fi

if [[ ! "$FROM_ADDRESS" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
    error_exit "Invalid from address format: $FROM_ADDRESS"
fi

# Print configuration
echo -e "${BLUE}=== Foundry Cast Call Configuration ===${NC}"
echo "From Address: $FROM_ADDRESS"
echo "Contract Address: $CONTRACT_ADDRESS"
echo "RPC URL: $RPC_URL"
if [[ -n "$ETHERSCAN_API_KEY" ]]; then
    echo "Etherscan API: Enabled"
else
    echo "Etherscan API: Disabled"
fi
echo ""

# Check if Docker container is running
if ! docker-compose ps foundry | grep -q "Up"; then
    print_info "Foundry container is not running. Starting it..."
    docker-compose up -d foundry
    sleep 2
fi

# Build the cast call command
CAST_CMD="cast call --trace $CONTRACT_ADDRESS '$FUNCTION_CALLDATA'"

# Add block explorer API for better decoding
if [[ -n "$ETHERSCAN_API_KEY" ]]; then
    CAST_CMD="$CAST_CMD --etherscan-api-key $ETHERSCAN_API_KEY"
fi

# Add from and rpc-url parameters
CAST_CMD="$CAST_CMD --from $FROM_ADDRESS --rpc-url $RPC_URL"

print_info "Executing: $CAST_CMD"
echo ""

# Execute the command
if docker-compose exec -T foundry sh -c "$CAST_CMD"; then
    print_success "Cast call completed successfully"
else
    error_exit "Cast call failed"
fi 