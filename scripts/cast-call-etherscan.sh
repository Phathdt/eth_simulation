#!/bin/bash

# Foundry Cast Call Script with Etherscan ABI fetching
# Edit the variables below to customize the call

set -e

# =============================================================================
# CONFIGURATION - Edit these values as needed
# =============================================================================

# Contract configuration
CONTRACT_ADDRESS=""  # Replace with your contract address
FUNCTION_CALLDATA=""

# Network configuration
FROM_ADDRESS=""  # Replace with your from address
RPC_URL=""  # Replace with your RPC URL

# Etherscan configuration
ETHERSCAN_API_KEY=""  # Replace with your Etherscan API key

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
if [[ "$CONTRACT_ADDRESS" == "" ]]; then
    print_warning "Using default contract address. Please update CONTRACT_ADDRESS in the script."
fi

if [[ "$ETHERSCAN_API_KEY" == "YOUR_ETHERSCAN_API_KEY" ]]; then
    error_exit "Please set your Etherscan API key in the ETHERSCAN_API_KEY variable"
fi

# Validate Ethereum address format (basic check)
if [[ ! "$CONTRACT_ADDRESS" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
    error_exit "Invalid contract address format: $CONTRACT_ADDRESS"
fi

if [[ ! "$FROM_ADDRESS" =~ ^0x[a-fA-F0-9]{40}$ ]]; then
    error_exit "Invalid from address format: $FROM_ADDRESS"
fi

# Print configuration
echo -e "${BLUE}=== Foundry Cast Call Configuration (Etherscan ABI) ===${NC}"
echo "From Address: $FROM_ADDRESS"
echo "Contract Address: $CONTRACT_ADDRESS"
echo "Function Call Data: $FUNCTION_CALLDATA"
echo "RPC URL: $RPC_URL"
echo ""

# Check if Docker container is running
if ! docker-compose ps foundry | grep -q "Up"; then
    print_info "Foundry container is not running. Starting it..."
    docker-compose up -d foundry
    sleep 2
fi

# Build the cast call command
CAST_CMD="cast call --trace $CONTRACT_ADDRESS '$FUNCTION_CALLDATA'"

# Add contract ABI for better decoding
CAST_CMD="$CAST_CMD --etherscan-api-key $ETHERSCAN_API_KEY"

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