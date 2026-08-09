# ⛏ ZUC Mine Command Center
<img width="1536" height="446" alt="ChatGPT Image Mar 30, 2026, 11_50_04 PM" src="https://github.com/user-attachments/assets/9ae1a64f-dfee-449c-b77c-f3c065828bc2" />


> Real-time uranium mine operations dashboard built on the **XRPL EVM Sidechain Testnet**.
> A fully deployed Solidity contract powering a live Web3 dashboard — no backend, no server, one HTML file.

![XRPL EVM](https://img.shields.io/badge/XRPL%20EVM-Testnet%201449000-00FFB8?style=flat-square)
![Solidity](https://img.shields.io/badge/Solidity-0.8.24-A855F7?style=flat-square)
![Contract](https://img.shields.io/badge/Contract-Deployed-00D4FF?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-FFB830?style=flat-square)

---

## 🔴 Live Demo

**[View Dashboard →](https://zuc-mine-command-center.vercel.app/)**

**Contract on Explorer →** [0x22ACA8...97bE31](https://explorer.testnet.xrplevm.org/address/0x22ACA8269801bF50d96c7e7F296c11799597bE31)

---

## What This Is

ZUC Mine Command Center is the **operational control layer** for a live on-chain uranium mining system deployed on the XRPL EVM Sidechain.

It is not a static dashboard — it is a **direct execution interface over a production Solidity contract**.

Through a single frontend surface, operators can:

- read live on-chain state (miners, reserves, ownership)
- execute contract functions via signed transactions
- monitor network conditions in real time (block height, gas, latency)
- visualize system topology and resource distribution in 3D

The system is built with a strict architecture constraint:

> **No backend. No API. No middleware.**

### Data Flow

UI (index.html)  
→ ethers.js (provider + signer)  
→ XRPL EVM Sidechain (RPC)  
→ ZUCMine.sol (on-chain state + logic)

### Guarantees

- every state update is on-chain truth  
- every action is a signed transaction  
- every visualization reflects live contract state  

In practice, this functions as a **blockchain-native command center**, where the UI is not a wrapper — it is the execution surface of the protocol itself.

![ScreenRecorderProject31](https://github.com/user-attachments/assets/1511e397-650e-4ea2-b92b-0e3476dd36f5)



![ScreenRecorderProject31](https://github.com/user-attachments/assets/1511e397-650e-4ea2-b92b-0e3476dd36f5)



---

## Features & v2.0 Architecture

### Blockchain & Smart Contract (`ZUCMineV2.sol`)
- ✅ **Role-Based Access Control (`RBAC`)**: Flexible `ADMIN_ROLE`, `ORACLE_ROLE`, and `OPERATOR_ROLE` replacing coarse single-owner controls.
- ✅ **Multi-Metric Mine Telemetry**: Tracks reserve tonnage, daily extraction rates, radiation levels (PPM), active labor, and operational status.
- ✅ **$ZUC Raw Ore Tokenomics**: ERC-20 token emissions awarded directly to registered miners upon verified extraction events.
- ✅ **Multicall & Batch Reading**: `getMinersBatch()` and `getAllTelemetry()` APIs eliminate RPC polling exceptions.
- ✅ **Live Contract Interoperability**: Fully backward compatible with deployed `ZUCMine.sol` at `0x22ACA8269801bF50d96c7e7F296c11799597bE31`.

### Dashboard & UI/UX v2.0
- ✅ **Web Audio SFX Synthesizer**: Zero-dependency Web Audio API procedural sound engine providing tactile audio feedback for clicks, scans, tx broadcasts, and block confirmations with a top-bar mute toggle.
- ✅ **Fallback JSON-RPC Provider**: Immediate read-only data auto-hydration on page load without requiring a wallet connection.
- ✅ **Sci-Fi Glassmorphism HUD Modals**: Custom confirmation modals with gas breakdowns replacing native browser popups.
- ✅ **WebGL GPU Throttling**: `IntersectionObserver` canvas monitor to pause off-screen 3D animation loops.
- ✅ **Three.js Visualizations**: Interactive Node Topology Globe, 3D Spatial Mine Map, and Subsurface Geology Wireframe.

---

## Contract Systems — `ZUCMine.sol` & `ZUCMineV2.sol`

**Deployed:** `0x22ACA8269801bF50d96c7e7F296c11799597bE31`  
**Network:** XRPL EVM Sidechain Testnet (Chain ID: `1449000`)  
**Compiler:** Solidity `0.8.24`

### Project Structure

```
zuc-mine-command-center/
├── index.html                     ← Full Command Center v2.0 Dashboard
├── ZUCMine.sol                    ← Deployed V1 Solidity contract
├── ZUCMineV2.sol                  ← Upgraded V2 Solidity contract (RBAC + Telemetry + ERC-20)
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
| **[COHR LAB](https://github.com/zrt219/cohr-lab)** | Semiconductor fabrication lifecycle system — deterministic on-chain state machine tracking irreversible production stages from crystal growth to final pigtail with full auditability | ✅ Live |
---

---

## License

MIT — see [LICENSE](LICENSE)
