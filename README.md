# Cast Call Script with Etherscan ABI

A bash script for making contract calls with automatic ABI fetching from Etherscan. The script loads configuration from a `.env` file for easy management.

## Prerequisites

- Docker
- Docker Compose
- Etherscan API key

## Quick Start

### 1. Setup Environment File

Copy the example environment file and configure it:

```bash
cp .env.example .env
```

Edit `.env` with your configuration:

```bash
# Contract Configuration
CONTRACT_ADDRESS=0xYourContractAddress
FUNCTION_CALLDATA=0xYourCalldata

# Network Configuration
FROM_ADDRESS=0xYourFromAddress
RPC_URL=https://your-rpc-url

# Etherscan API Configuration
ETHERSCAN_API_KEY=your_api_key
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

### Environment Variables

All configuration is stored in `.env` file:

| Variable | Description | Example |
|----------|-------------|---------|
| `CONTRACT_ADDRESS` | The deployed contract address you want to call | `0xF3fB...4f96` |
| `FUNCTION_CALLDATA` | Raw calldata (hex string) for the function call | `0x289350d3...` |
| `FROM_ADDRESS` | The address to call from | `0x78Bdc...5A051` |
| `RPC_URL` | RPC endpoint URL | `https://ethereum-sepolia-rpc.publicnode.com` |
| `ETHERSCAN_API_KEY` | Your Etherscan API key | `your_api_key` |

**Note:** The `.env` file is gitignored. Never commit sensitive data like API keys to the repository.

### Getting Your Etherscan API Key

1. Go to [etherscan.io](https://etherscan.io/apis)
2. Create an account or sign in
3. Generate a new API key
4. Copy the API key to your `.env` file

## Features

- **Environment-Based Configuration**: Loads settings from `.env` file
- **Automatic ABI Fetching**: Automatically retrieves contract ABI from Etherscan
- **Function Decoding**: Provides decoded function names and parameters in traces
- **Error Decoding**: Displays custom error names (e.g., `NotPreLiquidatable()`)
- **Docker Integration**: Works with the Foundry Docker container
- **Comprehensive Validation**: Error checking for all configuration variables
- **Colored Output**: Easy-to-read colored terminal output

## How It Works

1. **Load Configuration**: Reads variables from `.env` file (falls back to `.env.example` if not found)
2. **Validation**: Checks that all required variables are set and valid
3. **Docker Check**: Ensures the Foundry container is running
4. **Execute Call**: Runs `cast call` with `--trace` and `--etherscan-api-key` flags
5. **Display Results**: Shows decoded trace with contract names, function names, and error names

## Troubleshooting

### Common Issues

**".env file not found"**
- Run `cp .env.example .env` to create your environment file
- The script will fallback to `.env.example` if `.env` doesn't exist

**"CONTRACT_ADDRESS not set in .env file"**
- Ensure all required variables are configured in your `.env` file
- Check that there are no typos in variable names

**"Invalid contract address format"**
- Ensure the contract address is a valid 40-character hex string starting with `0x`

**"Contract is not verified on Etherscan"**
- The contract must be verified on Etherscan for ABI fetching to work
- You can verify contracts at [etherscan.io/verifyContract](https://etherscan.io/verifyContract)

**"Cast call failed"**
- Check your RPC URL and network connectivity
- Verify the contract address and calldata are correct
- Ensure the Foundry container is running

### Getting Help

- Check the script output for specific error messages
- Ensure all configuration variables in `.env` are properly set
- Verify your Etherscan API key is valid and has sufficient quota
- Make sure Docker and the Foundry container are running

## Example Output

### Successful Call

```
=== Foundry Cast Call Configuration ===
From Address: 0x78Bdc100555672a193359bd3e9CD68F23015A051
Contract Address: 0xF3fB62E0CC08eB1fE9fa090aa4f18A09B49e4f96
RPC URL: https://ethereum-sepolia-rpc.publicnode.com
Etherscan API: Enabled

Info: Executing: cast call --trace 0xF3fB... --etherscan-api-key ...

Traces:
  [249423] AccountPositionManagerFactory::createAccountPositionManager(...)
    ├─ [9031] → new AccountPositionManager@0x4B3D...8E6D
    │   └─ ← [Return] 45 bytes of code
    └─ ← [Return] 0x4B3D9D0679C679096F1a307262373954E88a8E6D

Success: Cast call completed successfully
```

### Failed Call with Custom Error

```
=== Foundry Cast Call Configuration ===
From Address: 0x78Bdc100555672a193359bd3e9CD68F23015A051
Contract Address: 0xF3fB62E0CC08eB1fE9fa090aa4f18A09B49e4f96
RPC URL: https://ethereum-sepolia-rpc.publicnode.com
Etherscan API: Enabled

Traces:
Error: Transaction failed.
  [180887] MorphoLiquidationGateway::payment(...)
    ├─ [2537] OWUSDC::balanceOf(MorphoLiquidationGateway) [staticcall]
    │   └─ ← [Return] 0
    ├─ [95858] MorphoPreLiquidator::preLiquidate(...)
    │   ├─ [5084] Morpho::position(...) [staticcall]
    │   │   └─ ← [Return] 0, 0, 0
    │   └─ ← [Revert] NotPreLiquidatable()
    └─ ← [Revert] NotPreLiquidatable()

Error: Cast call failed
```

The trace shows decoded contract names, function names, and custom error names automatically! 