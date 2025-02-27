#!/bin/bash

# Check if request arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <network> <wallet_address>"
    echo "Example: $0 BASE-SEPOLIA 0x85E094B259718Be1AF0D8CbBD41dd7409c2200aa"
    exit 1
fi

# Retrieve request arguments
NETWORK=$1
WALLET_ADDRESS=$2

# Validate NETWORK against supported chains
case "$NETWORK" in
"ETH-SEPOLIA" | "AVAX-FUJI" | "MATIC-AMOY" | "SOL-DEVNET" | "ARB-SEPOLIA" | "UNI-SEPOLIA" | "BASE-SEPOLIA")
    # Network is valid, proceed
    ;;
*)
    echo "Unsupported network '$NETWORK'. Supported networks are:"
    echo "ETH-SEPOLIA, AVAX-FUJI, MATIC-AMOY, SOL-DEVNET, ARB-SEPOLIA, UNI-SEPOLIA"
    exit 1
    ;;
esac

# Configuration fields
# API_KEY: Circle API key, get it from https://console.circle.com/api-keys
# URL: Circle faucet API endpoint
# TIMESTAMP: Timestamp of the request
API_KEY=""
URL="https://api.circle.com/v1/faucet/drips"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Check if API_KEY is set
if [ -z "$API_KEY" ]; then
    echo "Error: API_KEY is not set"
    exit 1
fi

# Define payload as a clean JSON string using heredoc
read -r -d '' PAYLOAD <<EOF
{
    "address": "$WALLET_ADDRESS",
    "blockchain": "$NETWORK",
    "native": true,
    "usdc": true,
    "eurc": false
}
EOF

# Log the exact payload for debugging
echo "[$TIMESTAMP] Sending payload: $PAYLOAD" >>~/faucet_request.log

# Make the request and capture the response
RESPONSE=$(curl -s \
    --request POST \
    --url "$URL" \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer $API_KEY" \
    --data "$PAYLOAD")

# Check if RESPONSE is empty and set the proper message
if [ -z "$RESPONSE" ]; then
    MESSAGE="Success: Tokens requested successfully (Response is empty)"
else
    MESSAGE="Response: $RESPONSE"
fi

# Optional: Print to console if running manually
echo "[$TIMESTAMP] Request sent to $URL"
echo "Chain: $NETWORK"
echo "Address: $WALLET_ADDRESS"
echo "Response: $RESPONSE"
