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
This interface allows direct execution of contract write functions via MetaMask, exposing the full transaction lifecycle from initiation to confirmation.

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
| Hosting | Vercel |

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

Core XRPL EVM systems plus related public product and AI repositories from the same portfolio.

<table>
  <thead>
    <tr>
      <th>Project</th>
      <th>Description</th>
      <th>Status</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><a href="https://github.com/zrt219/Zuc-Mine-Command-Center">ZUC Mine Command Center</a></td>
      <td>On-chain uranium mining operations dashboard with real-time reserve tracking, miner registry, and direct contract interaction through a frontend-only control surface.</td>
      <td><a href="https://zuc-mine-command-center.vercel.app/">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/-U235-Fuel-Cycle-">U235 Fuel Cycle</a></td>
      <td>Deterministic XRPL EVM fuel-cycle pipeline that tracks uranium batches from ore to enriched fuel rod with full on-chain traceability.</td>
      <td><a href="https://u235-fuel-cycle.vercel.app/">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/ISR-Network">ISR Network</a></td>
      <td>In-situ recovery control system with on-chain asset tracking, lifecycle state transitions, and operator-facing industrial simulation.</td>
      <td><a href="https://isr-network.vercel.app/">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/Dark-Matter-Farm">Dark Matter Farm</a></td>
      <td>XRPL EVM staking protocol with three orbit tiers, lock-period yield mechanics, and event-driven reward emissions.</td>
      <td><a href="https://dark-matter-farm.vercel.app/">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/Cohr-Lab">Cohr Lab</a></td>
      <td>Semiconductor laser fabrication lifecycle modeled as an immutable on-chain state machine from crystal growth to final pigtail.</td>
      <td><a href="https://cohr-lab.vercel.app">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/ForgeX">ForgeX</a></td>
      <td>Foundry-powered XRPL EVM deployment console that combines a natural-language UI, Node CLI orchestration, and realtime shader-based visuals.</td>
      <td><a href="https://forgex-theta.vercel.app">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/DatumX">DatumX</a></td>
      <td>Verification protocol for AI-transformed industrial data with deterministic lineage, validator review, and XRPL EVM finalization.</td>
      <td><a href="https://datumx.vercel.app">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/Ethex-Lottery-Game">Ethex Lottery Game</a></td>
      <td>Foundry plus Next.js betting workflow that modernizes the EthexLoto lifecycle for XRPL EVM reviewer-facing execution.</td>
      <td>Public Repo</td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/3DMoonX">3DMoonX</a></td>
      <td>Cinematic lunar industrial-base experience that combines Blender source assets with a React Three Fiber web runtime.</td>
      <td><a href="https://3dmoonx.vercel.app">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/Unknown002">Unknown002</a></td>
      <td>Browser-based 3D engineering viewer for a nuclear-electric propulsion spacecraft concept with staged prompt-pack support.</td>
      <td>Public Repo</td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/AI-Engineering-Evidence-Engine">AI Engineering Evidence Engine</a></td>
      <td>Interactive evidence dashboard that turns local engineering proof into a reviewer-facing systems narrative.</td>
      <td><a href="https://zhane-grey-evidence-dashboard.vercel.app/">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/Build-Doctor">Build Doctor</a></td>
      <td>Codex-style build diagnosis harness for failed Next.js and Vercel builds with deterministic failure analysis.</td>
      <td><a href="https://vercel-build-doctor-agent.vercel.app">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/ai-gateway-failover-playground">AI Gateway Failover Playground</a></td>
      <td>Public-facing sandbox for request routing, provider fallback, and resilient AI gateway behavior.</td>
      <td><a href="https://ai-gateway-failover-playground.vercel.app">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/enterprise-agent-workflow-studio">Enterprise Agent Workflow Studio</a></td>
      <td>Public-facing studio for approval-gated enterprise agent workflows, risk scoring, and audit-oriented design.</td>
      <td><a href="https://enterprise-agent-workflow-studio.vercel.app">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/resume-evidence-rag-auditor">Resume Evidence RAG Auditor</a></td>
      <td>Public-facing proof surface for claim verification, evidence retrieval, and grounded resume bullet generation.</td>
      <td><a href="https://resume-evidence-rag-auditor.vercel.app">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/AI-resume-tailor-service-">AI Resume Tailor Service</a></td>
      <td>Static Vercel-ready application for evidence-backed resume, cover-letter, and job-packet tailoring.</td>
      <td><a href="https://ai-resume-tailor-service.vercel.app">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/Fuji">Fuji</a></td>
      <td>Cinematic Next.js Fuji gallery atlas for portfolio storytelling and visual system design.</td>
      <td><a href="https://fuji-byzrt.vercel.app">Live</a></td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/ld-2-0-website">LD 2.0 Website</a></td>
      <td>Next.js speaker website for Lornette Daye.</td>
      <td>Public Repo</td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/ai-agents-for-beginners">AI Agents for Beginners</a></td>
      <td>Lesson repository for getting started building AI agents.</td>
      <td>Public Repo</td>
    </tr>
    <tr>
      <td><a href="https://github.com/zrt219/agentic-rag-memory-digital-twin-edge-system">Agentic RAG Memory Digital Twin Edge System</a></td>
      <td>Public-facing landing page for an agentic RAG, memory, and digital-twin edge-system portfolio project.</td>
      <td><a href="https://agentic-rag-memory-digital-twin-edg.vercel.app">Live</a></td>
    </tr>
  </tbody>
</table>


## License

MIT — see [LICENSE](LICENSE)
