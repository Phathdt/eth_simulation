# Cast Call Script with Etherscan ABI

A bash script for making contract calls with automatic ABI fetching from Etherscan.

## Prerequisites

- Docker
- Docker Compose
- Etherscan API key

## Quick Start

### 1. Configure the Script

Edit the variables at the top of `scripts/cast-call-etherscan.sh`:

```bash
# Contract configuration
CONTRACT_ADDRESS="0x1234567890123456789012345678901234567890"  # Your contract address
FUNCTION_CALLDATA="0x..."  # Your function calldata

# Network configuration
FROM_ADDRESS="0x1234567890123456789012345678901234567890"  # Your from address
RPC_URL="https://sepolia.infura.io/v3/YOUR_PROJECT_ID"  # Your RPC URL

# Etherscan configuration
ETHERSCAN_API_KEY="YOUR_ETHERSCAN_API_KEY"  # Your Etherscan API key
```

### 2. Make the Script Executable

```bash
chmod +x scripts/cast-call-etherscan.sh
```

### 3. Run the Script

```bash
./scripts/cast-call-etherscan.sh
```

## Configuration

### Required Variables

- **`CONTRACT_ADDRESS`**: The deployed contract address you want to call
- **`FUNCTION_CALLDATA`**: Raw calldata (hex string) for the function call
- **`FROM_ADDRESS`**: The address to call from
- **`RPC_URL`**: RPC endpoint URL
- **`ETHERSCAN_API_KEY`**: Your Etherscan API key

### Getting Your Etherscan API Key

1. Go to [etherscan.io](https://etherscan.io/apis)
2. Create an account or sign in
3. Generate a new API key
4. Copy the API key to the script

### Example Configuration

```bash
# Contract configuration
CONTRACT_ADDRESS=""
FUNCTION_CALLDATA=""

# Network configuration
FROM_ADDRESS=""
RPC_URL=""

# Etherscan configuration
ETHERSCAN_API_KEY=""
```

## Features

- **Automatic ABI Fetching**: Automatically retrieves contract ABI from Etherscan
- **Function Decoding**: Provides decoded function names and parameters in traces
- **Docker Integration**: Works with the Foundry Docker container
- **Error Handling**: Comprehensive error checking and validation
- **Colored Output**: Easy-to-read colored terminal output

## How It Works

1. **Validation**: Checks that all required variables are set and valid
2. **Docker Check**: Ensures the Foundry container is running
3. **ABI Fetching**: Uses Etherscan API to fetch contract ABI
4. **Cast Call**: Executes the cast call command with proper decoding
5. **Output**: Displays the transaction trace with decoded function calls

## Troubleshooting

### Common Issues

**"Invalid contract address format"**
- Ensure the contract address is a valid 40-character hex string starting with `0x`

**"Please set your Etherscan API key"**
- Add your Etherscan API key to the `ETHERSCAN_API_KEY` variable

**"Contract is not verified on Etherscan"**
- The contract must be verified on Etherscan for ABI fetching to work

**"Cast call failed"**
- Check your RPC URL and network connectivity
- Verify the contract address and calldata are correct

### Getting Help

- Check the script output for specific error messages
- Ensure all configuration variables are properly set
- Verify your Etherscan API key is valid and has sufficient quota

## Example Output

```
=== Foundry Cast Call Configuration (Etherscan ABI) ===
From Address: 0xfC9d21706B0f2958119661191E9db593e3C320f2
Contract Address: 0x26763f2464C9EA5Db1f6e691d3AD6CAA8dc25980
Function Call Data: 0x5e4fee91...
RPC URL: https://sepolia.infura.io/v3/...

Info: Executing: cast call --trace 0x26763f2464C9EA5Db1f6e691d3AD6CAA8dc25980 '0x5e4fee91...' --etherscan-api-key {API_KEY} --from 0xfC9d21706B0f2958119661191E9db593e3C320f2 --rpc-url https://sepolia.infura.io/v3/...

Traces:
  [249423] AccountPositionManagerFactory::createAccountPositionManager("BITCOIN_PUBKEY_1", 0xfC9d21706B0f2958119661191E9db593e3C320f2, 0x47b2a86470BaE3d51D62e3A22C1BBDC68a472212)
    ├─ [9031] → new <unknown>@0x4B3D9D0679C679096F1a307262373954E88a8E6D
    │   └─ ← [Return] 45 bytes of code
    └─ ← [Return] 0x4B3D9D0679C679096F1a307262373954E88a8E6D

Success: Cast call completed successfully
``` 