# ⛏ ZUC Mine Command Center

> Real-time uranium mine operations dashboard built on the **XRPL EVM Sidechain Testnet**.
> A fully deployed Solidity contract powering a live Web3 dashboard — no backend, no server, one HTML file.

![XRPL EVM](https://img.shields.io/badge/XRPL%20EVM-Testnet%201449000-00FFB8?style=flat-square)
![Solidity](https://img.shields.io/badge/Solidity-0.8.24-A855F7?style=flat-square)
![Contract](https://img.shields.io/badge/Contract-Deployed-00D4FF?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-FFB830?style=flat-square)

---

## 🔴 Live Demo

**[View Dashboard →](http://zuc-dashboard.surge.sh/)**

**Contract on Explorer →** [0x22ACA8...97bE31](https://explorer.testnet.xrplevm.org/address/0x22ACA8269801bF50d96c7e7F296c11799597bE31)

---

## What This Is

ZUC Mine Command Center is a production-grade Web3 dashboard for a live uranium mining registry contract on the XRPL EVM Sidechain. It demonstrates end-to-end Solidity + frontend integration — connect MetaMask, read on-chain data, and write transactions directly from the UI.

**No backend. No API. No framework. One HTML file reads and writes to the blockchain in real time.**

![ScreenRecorderProject31](https://github.com/user-attachments/assets/1511e397-650e-4ea2-b92b-0e3476dd36f5)



---

## Features

### Blockchain
- ✅ Live contract deployed at `0x22ACA8269801bF50d96c7e7F296c11799597bE31`
- ✅ All read functions queried on wallet connect (miners, reserves, mine names, owner)
- ✅ All write functions exposed with full 4-step transaction lifecycle (estimate gas → broadcast → mine → confirm)
- ✅ Auto chain detection — prompts MetaMask to switch to XRPL EVM Testnet if on wrong network
- ✅ Real-time event feed via ethers.js provider
- ✅ Live block number and gas price monitoring

### Dashboard

- ✅ Three.js interactive globe showing node topology

![ScreenRecorderProject33_1](https://github.com/user-attachments/assets/59b8784e-867c-4c1f-b4e5-0c53335e3365)


- ✅ Three.js 3D mine network map with animated node connection
  
![ScreenRecorderProject34](https://github.com/user-attachments/assets/f67c1198-ab50-4f40-b248-d48a81532643)

- ✅ Three.js geological terrain viewer with ore deposit simulation
  
![ScreenRecorderProject36](https://github.com/user-attachments/assets/3d51411e-790b-453d-a9cf-cabe842b0713)


### 📊 ANALYTICS STATIC
<img width="1419" height="1148" alt="chrome_H72zKAx6lm" src="https://github.com/user-attachments/assets/c9374b88-afb1-4704-a7e5-fd98417255c3" />


- ✅ Chart.js reserve history charts with live updates
- ✅ Cyberpunk dark theme — neon accents, scanlines, beam animations, depth glow
- ✅ Responsive layout (desktop + mobile)
- ✅ On-chain transaction log feed with explorer links
- ✅ Network health indicators (block time, gas, chain ID, RPC status)

## On-Chain Command Execution
<img width="2170" height="1275" alt="chrome_LLmjl54pGL" src="https://github.com/user-attachments/assets/eed28c02-369f-4988-8fad-0b1c1e5a3dd6" />

---

## Contract — `ZUCMine.sol`

**Deployed:** `0x22ACA8269801bF50d96c7e7F296c11799597bE31`
**Network:** XRPL EVM Sidechain Testnet (Chain ID: `1449000`)
**Compiler:** Solidity `0.8.24`

### Write Functions
```solidity
addMiner(string _name, uint256 _oreMined)
// Register a new miner with their cumulative ore production.
// onlyOwner. Emits MinerAdded.

setMineName(uint256 _mineId, string _name)
// Set or update the display name of a mine.
// onlyOwner. Emits MineNameSet.

storeReserves(uint256 _mineID, uint256 _tons)
// Record current ore reserves for a mine in tons.
// onlyOwner. Emits ReservesStored.

transferOwnership(address _newOwner)
// Transfer contract ownership to a new address.
// onlyOwner. Reverts on zero address.
```

### Read Functions
```solidity
getMineInfo(uint256 _mineId) → (uint256 tons, string name)
// Returns reserve tonnage and name for a mine.

getMiner(uint256 _minerID) → Miner(id, name, oreMined)
// Returns full miner struct.

getReserves(uint256 _mineID) → uint256
// Returns ore reserve tonnage.

owner() → address
miners(uint256) → Miner
mineNames(uint256) → string
mineReserves(uint256) → uint256
minerCount() → uint256
```

### Solidity Patterns Used
| Pattern | Implementation |
|---------|---------------|
| `onlyOwner` modifier | Gates all write functions |
| Custom errors | `NotOwner()`, `ZeroAddress()` — gas efficient vs `require` strings |
| Indexed events | `MinerAdded`, `MineNameSet`, `ReservesStored`, `OwnershipTransferred` |
| Struct storage | `Miner` struct in mapping |
| View functions | All reads are `view` — zero gas cost |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Blockchain | XRPL EVM Sidechain Testnet |
| Smart Contract | Solidity 0.8.24 |
| Web3 Provider | Ethers.js v5 (CDN) |
| 3D Visualisation | Three.js r128 (CDN) |
| Charts | Chart.js 4.4.1 (CDN) |
| Frontend | Vanilla HTML/CSS/JS — zero build step |
| Fonts | Orbitron, Rajdhani (Google Fonts) |
| Hosting | GitHub Pages |

---

## Project Structure

```
zuc-mine-command-center/
├── index.html                     ← Full dashboard (single file)
├── ZUCMine.sol                    ← Deployed Solidity contract
├── .github/
│   └── workflows/
│       └── deploy.yml             ← Auto-deploy to GitHub Pages on push
├── LICENSE
└── README.md
```

---

## Running Locally

No install required — just open the file:

```bash
git clone https://github.com/yourusername/zuc-mine-command-center
open index.html
# or: python3 -m http.server 8080
```

---

## Deploying to GitHub Pages

### Automatic (recommended)
The included GitHub Actions workflow auto-deploys on every push to `main`.

1. Push to GitHub
2. Go to **Settings → Pages → Source** → select `GitHub Actions`
3. Push any commit — workflow runs and deploys
4. Live at `https://yourusername.github.io/zuc-mine-command-center`

### Manual
1. Go to **Settings → Pages**
2. Source: `Deploy from a branch`
3. Branch: `main` / `/ (root)`
4. Save

---

## Connecting MetaMask

Add XRPL EVM Testnet to MetaMask:

| Field | Value |
|-------|-------|
| Network Name | XRPL EVM Testnet |
| RPC URL | `https://rpc.testnet.xrplevm.org` |
| Chain ID | `1449000` |
| Symbol | `XRP` |
| Explorer | `https://explorer.testnet.xrplevm.org` |

The dashboard auto-detects your network on connect and prompts a switch if you're on the wrong chain.

Get free testnet XRP: **https://faucet.testnet.xrplevm.org**

---

## Redeploying the Contract (Foundry)

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash && foundryup

# Deploy
forge create ZUCMine.sol:ZUCMine \
  --rpc-url https://rpc.testnet.xrplevm.org \
  --interactive \
  --legacy

# Paste the printed address into index.html:
# var CONTRACT = "0x...";
```

---

## On-Chain Systems Portfolio

| Project | Description | Status |
|---------|-------------|--------|
| **[ZUC Mine Command Center](https://github.com/zrt219/Zuc-Mine-Command-Center)** | On-chain uranium mining operations dashboard — real-time reserve tracking, miner registry, and contract interaction via a fully frontend-driven command interface | ✅ Live |
| **[U235 Fuel Cycle](https://github.com/zrt219/-U235-Fuel-Cycle-)** | Nuclear fuel cycle pipeline — uranium ore to enriched fuel rod, deterministic multi-stage processing with full on-chain traceability | ✅ Live |
| **[ISR Network](https://github.com/zrt219/ISR-Network)** | Intelligence surveillance reconnaissance system — on-chain asset tracking, mission lifecycle state machine, and role-based operator control | ✅ Live |
| **[Dark Matter Farm](https://github.com/zrt219/Dark-Matter-Farm)** | DeFi yield protocol — experimental high-convexity farming system with custom reward mechanics and on-chain state-driven emissions | ✅ Live |
---

---

## License

MIT — see [LICENSE](LICENSE)
