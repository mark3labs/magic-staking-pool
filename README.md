# $MAGIC Pooled Staking ✨

Solidity smart contract for pooled staking in the Bridgeworld Atlas Mine contract

## Getting Started

### Step 1: Install Rust
Follow the instructions for your system [here](https://www.rust-lang.org/learn/get-started).

### Step 2: Install [Foundry](https://github.com/gakonst/foundry)

Run the following commands:
```bash
curl -L https://foundry.paradigm.xyz | bash
```
```bash
foundryup
```

### Step 3: Install Dependencies

From the root directory of this repo run the following command:
```
forge install
```

### Setp 4: Setup Config

Copy `.env.example` to `.env` and fill in the missing RPC_URL with an RPC endpoint for Arbitrum. You can get one for free from [Alchemy](https://alchemyapi.io)

## Local development

This project uses [Foundry](https://github.com/gakonst/foundry) as the development framework.

### Updating Dependencies

```
make update
```

### Compilation

```
make build
```

### Testing

```
make test
```
