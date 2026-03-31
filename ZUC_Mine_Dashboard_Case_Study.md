
# CASE STUDY · FULL-STACK WEB3 DAPP

# ZUC MINE COMMAND CENTER

**Full-stack Web3 mining operations dashboard on XRPL EVM — wallet-connected control surface, real-time analytics, and multi-scene 3D visualization.** fileciteturn1file0

---

## Stack

- XRPL EVM Sidechain (Chain ID: 1449000)
- Solidity (OwnerStorage)
- ethers.js v5 (UMD, synchronous)
- Three.js r128 (3 scenes)
- Chart.js 4.x
- Vanilla HTML/CSS/JS (no build tools)
- Vercel (static deploy)

---

## Deployment

- **App:** https://isr-network.vercel.app/ (pattern reference for Vercel hosting)
- **Contract (OwnerStorage):** 0x236C…3FF (testnet)

---

## Executive Summary

This project evolved in a single session from a small widget into a **production-grade Web3 dashboard** with:

- Full MetaMask lifecycle handling
- 11 contract functions (read/write)
- Real-time analytics (parallel on-chain scans)
- Three independent WebGL scenes (globe, geology, ISR reference)
- Deterministic transaction lifecycle UI

The build surfaces **real integration complexity**: XRPL EVM quirks, script loading races, ABI drift, DOM performance, and WebGL initialization timing.

---

# ⛏ What Was Built

## 1) Smart Contract Interface

**Reads**
- `getMineInfo()`, `getMiner()`, `getReserves()`, `mineNames()`, `mineReserves()`, `miners()`, `owner()`

**Writes (onlyOwner)**
- `addMiner()`, `storeReserves()`, `setMineName()`, `transferOwnership()`

**Transaction lifecycle (UI)**
1. Estimating Gas
2. Broadcasting
3. Mining Block
4. Confirmed

- Preflight gas preview
- Clickable tx hash to explorer

---

## 2) Network Globe (Three.js)

- Geodesic arcs between nodes (slerp-like interpolation)
- Node size proportional to reserves/output
- Animated transaction pulses
- Hover raycasting tooltips
- Orbit controls, zoom, toggles
- Rebuild from live contract data

---

## 3) Subsurface Geology Viewer

- 6 strata layers (procedural displacement)
- Ore veins (TubeGeometry + CatmullRomCurve3)
- Shafts scaled to reserves
- Scan plane animation
- Wireframe / Solid / X-Ray

---

## 4) Phoenix ISR Viewer (Reference)

- 268 wells (typed + color-coded)
- Elliptical footprint
- Freeze wall dome
- Ore body ellipsoid (~490m)
- Lixiviant particle flow
- Chemistry panel (U3O8, DO, pH, Fe2+, Ra-226)

---

## 5) Intelligence Dashboard

- **Parallel scan** via `Promise.all` (5× faster than sequential)
- Progress indicator (live counter)
- Leaderboard, heatmap, bar chart
- Summary metrics (total, avg, top mine, count)

---

## 6) Network Monitor

- Block height + latency polling
- `provider.on('block')` for real-time updates
- Activity feed (connect, tx, confirm)
- Health bar (latency-coded)

---

# ⛏ XRPL EVM Constraints (Impacting Design)

- No `eth_estimateGas`, `eth_gasPrice`
- Legacy tx only
- Silent failures in ethers/Foundry

**Mitigation (frontend)**
```js
gasLimit: 300000
gasPrice: ethers.utils.parseUnits("100", "gwei")
```

---

# ⛏ Frontend Architecture

## Script Loading (critical)

- Use **UMD build** (`ethers.umd.min.js`)
- **Synchronous** load in `<head>`
- App script at bottom of `<body>`
- No `async`/`defer`/dynamic injection

## Rendering Model

- Pre-render containers
- Update via `textContent` and style mutations
- Avoid `innerHTML` in hot loops

## WebGL Init

- `window.load` + double `requestAnimationFrame`
- Ensures non-zero `clientWidth/Height`

---

# ⛏ War Diary — 20+ Issues (Expanded)

> Total attempts: **23**. Session length: ~**12 hours**. 

## Issue 1 — `ethers is not defined` (7 attempts)

**Stages**
1. Wrong CDN (ESM) → no `window.ethers`
2. Dynamic injection → async race
3. Polling loader → scope break (init inside closure)

**Final Fix**
- UMD build, sync load
- No wrapper (`initApp`) closure
- Flat globals

**Rule**
> Library load order is application correctness, not HTML detail.

---

## Issue 2 — 3D Scenes Blank (3 attempts)

**Root Causes**
- `clientWidth = 0` at `DOMContentLoaded`
- Functions trapped in closure
- File truncation removing viewers

**Fix**
- `window.load` + double rAF
- Move functions to global scope
- Restore from known-good source

**Rule**
> Separate **init timing**, **scope visibility**, and **asset integrity**.

---

## Issue 3 — Wrong Chain ID

- Used `1440002` vs required `1449000`
- MetaMask rejected connection

**Fix**
- Update constants + explorer + logs

**Rule**
> Chain ID is a hard gate; validate before any write.

---

## Issue 4 — Globe Wiring (4 attempts)

- Removed lines (wrong)
- Added straight lines (wrong topology)
- Bad splice from reference
- Final: geodesic arcs restored (normalized interpolation)

**Rule**
> Visual correctness requires geometric correctness, not patching.

---

## Issue 5 — DOM Reflow / Jitter

- `innerHTML` in loops → layout thrash

**Fix**
- Pre-render slots
- Mutate only leaf nodes

**Rule**
> Mutate, don’t rebuild, on high-frequency updates.

---

## Issue 6 — Compliance Panel Rebuild Loop

- Reconstructed panel each tick

**Fix**
- One-time build guard
- Update text only

**Rule**
> Split **initial render** from **update path**.

---

## Issue 7 — BigNumber Conversion Errors

- `toNumber()` overflow

**Fix**
```js
parseInt(x.toString(), 10)
```

**Rule**
> Treat all `uint256` as unsafe for JS numbers.

---

## Issue 8 — ABI Drift (missing `addWell` equivalent)

- Runtime: “not a function”

**Fix**
- Regenerate ABI from artifact

**Rule**
> ABI is generated, never handwritten.

---

## Issue 9 — Zero Address Contract

- Placeholder used → silent read failures

**Fix**
- Wire deployed address first

**Rule**
> Wrong address mimics logic bugs.

---

## Issue 10 — Sequential Scans Too Slow

- `await` in loop → N round trips

**Fix**
```js
await Promise.all([...])
```

**Rule**
> Parallelize independent RPC calls.

---

## Issue 11 — Canvas Resize Issues

- Zero-size canvas on init

**Fix**
- `ResizeObserver`

**Rule**
> WebGL must react to layout, not assume it.

---

## Issue 12 — Animation Loop Leaks

- Reconnect created multiple loops

**Fix**
- Track + cancel prior loop

**Rule**
> Own your render loop lifecycle.

---

## Issue 13 — Button Double-Submit

- Multiple tx broadcasts

**Fix**
- Disable during lifecycle

**Rule**
> UI must enforce idempotency.

---

## Issue 14 — Missing Gas Preview

- No user feedback pre-send

**Fix**
- Explicit estimate step (or fixed override)

**Rule**
> Expose cost before action.

---

## Issue 15 — Explorer Linking

- No tx traceability

**Fix**
- Link hash to explorer

**Rule**
> Every tx should be externally verifiable.

---

## Issue 16 — Account / Chain Change Handling

- App desynced after wallet change

**Fix**
- Listen to `accountsChanged`, `chainChanged`

**Rule**
> Wallet is mutable state; subscribe to it.

---

## Issue 17 — Race Between UI and Provider

- Calls before provider ready

**Fix**
- Gate init after provider + ethers ready

**Rule**
> Boot sequence must be deterministic.

---

## Issue 18 — File Truncation via Script

- Python splice removed sections

**Fix**
- Use known-good base, apply transforms

**Rule**
> Automations need verification passes.

---

## Issue 19 — Brace Mismatch (SyntaxError)

- Patch stacking broke structure

**Fix**
- Programmatic brace counter

**Rule**
> Use tooling for large-file integrity.

---

## Issue 20 — Globe Data Not Reflecting Contract

- Static mock vs live data

**Fix**
- Rebuild graph after load

**Rule**
> Visual layer must be data-driven.

---

## Issue 21 — Latency / Health Visibility

- No network insight

**Fix**
- Poll + color-coded health

**Rule**
> Surface infra health in UI.

---

## Issue 22 — UX Iteration Debt (v1→v4)

- Missing lifecycle, analytics, 3D

**Fix**
- Iterative layering with checkpoints

**Rule**
> Ship increments, not monoliths.

---

## Issue 23 — Architecture Reset

- Patch layering became unmaintainable

**Fix**
- Full rewrite: flat globals, sync load, verified braces

**Rule**
> When entropy is high, rewrite > patch.

---

# ⛏ Engineering Decisions (Signals)

| Decision | Why | Signal |
|---|---|---|
| Sync UMD load | eliminate races | understands browser execution |
| Flat globals | cross-scope access | understands JS scope/hoisting |
| Double rAF init | ensure layout | understands render pipeline |
| Promise.all | parallel IO | async systems thinking |
| ResizeObserver | real layout events | production WebGL experience |
| Chain checks | prevent mis-send | Web3 failure awareness |
| Tooling (brace counter) | debug scale | builds tools, not guesses |

---

# ⛏ Industry Mapping (Abbreviated)

- Cameco: reserve ledger + custody chain
- NexGen: environmental monitoring + investor visualization
- Denison: ISR wellfield telemetry + compliance logs
- ATHA: capital deployment + discovery visualization
- Energy Fuels: multi-commodity custody + audit trails

---

# ⛏ Outcome

Single-file (~1900 LOC) app that:

- Connects to XRPL EVM testnet
- Handles full MetaMask lifecycle
- Executes contract reads/writes
- Renders **3 simultaneous WebGL scenes**
- Aggregates and visualizes on-chain data in real time
- Passes automated syntax integrity checks
- Deploys on Vercel with **zero build step**

---

## Summary

ZUC Mine demonstrates:

- end-to-end Web3 product engineering
- real-world debugging under non-standard EVM constraints
- performant frontend architecture without frameworks
- 3D data visualization tied to live on-chain state
- disciplined handling of async, scope, and rendering

It is not a demo.  
It is a **system-level execution proof**.
