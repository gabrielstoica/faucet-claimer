# Faucet Claimer

This repository contains a Bash script to programmatically request testnet tokens (0.1 ETH, 20 USDC, 20EURC) from Circle's `/v1/faucet/drips` endpoint, designed to run via cron.

## Scope

The script sends a `POST` request to Circle’s testnet faucet API to claim tokens for a specified wallet address on a supported network. It checks for valid networks and handles empty responses (successful requests typically return HTTP 204 with no body).

## Prerequisites

- Bash (Linux/Unix environment)
- `curl` installed (sudo apt install curl on Debian/Ubuntu)
- A Circle API key from the [Circle Developer Dashboard](https://console.circle.com/api-keys)

## Usage

1. **Clone the repository**

```bash
git clone https://github.com/gabrielstoica/faucet-claimer.git
```

2. **Set the API key**

Open `claimer.sh` and replace `API_KEY` with your Circle API key.

3. **Make the script executable**

```bash
chmod +x claimer.sh
```

3. **Run manually**

```bash
./claimer.sh <network> <wallet_address>
```

Example:

```bash
./claimer.sh BASE-SEPOLIA 0x85E094B259718Be1AF0D8CbBD41dd7409c2200aa
```

4. **Run via a cron job (hourly)**

```bash
0 * * * * /path/to/claimer.sh <network> <wallet_address>
```
