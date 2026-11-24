<p align="center"><img src="assets/logo.png" width="140" alt="LunariumCoin logo"/></p>

<p align="center">
  <a href="https://galaxia.lunariumcoin.com/?coin=xln"><img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fgalaxia.lunariumcoin.com%2Fapi%2Fv1%2Fcoins%2Fxln&query=%24.data.market_cap_usd&prefix=%24&label=market%20cap&color=1f6feb&cacheSeconds=1800" alt="XLN market cap (live)"/></a>
  <a href="https://galaxia.lunariumcoin.com/?coin=xln"><img src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fgalaxia.lunariumcoin.com%2Fapi%2Fv1%2Fcoins%2Fxln&query=%24.data.price_usd&prefix=%24&label=price&color=1f6feb&cacheSeconds=1800" alt="XLN price (live)"/></a>
  <br/><sub>Live data from the <a href="https://galaxia.lunariumcoin.com/?coin=xln">GaláxiaLunarium</a> aggregator</sub>
</p>

LunariumCoin wallet repository 
=====================================

Windows — recommended: use the installer (see [Releases](https://github.com/Lunariumcoin-Labs/LunariumCoin/releases)).

### Coin Specs

• PoW Algorithm: Scrypt  
• Premine: 51,000,000 XLN (block 1)
• PoW Blocks: 1 - 250  
• PoS Blocks: Starting from 251  
• Block Time: 60 Seconds    
• Maturity: 100 Confirmations  
• Prefix: XLN addresses start with the capital letter "L" (before block 1,280,000 the same addresses were shown starting with "X")   
• Ports: 13990 (p2p) / 13980 (rpc)    
• Explorer [explorerxln.com](https://explorerxln.com/)
• Website [lunariumcoin.com](https://lunariumcoin.com/)

### Rewards Breakdown

Masternode reward share is 75% of the block reward (staker share 25%) for all blocks after height 250.

---
| Block       | Collateral | Block Reward | MN Reward | Staker Reward | Notes    |
| ----------- | ---------- | ------------- | --------- | -------------- | -------- |
| 0           | \-         | 50            | \-        | \-             | Genesis  |
| 1           | \-         | 51,000,000    | \-        | \-             | Premine  |
| 2           | 250,000    | 1             | 0         | 1              | PoW      |
| 14,401      | 250,000    | 12            | 9         | 3              |          |
| 340,001     | 300,000    | 12            | 9         | 3              |          |
| 621,702     | 1,000,000  | 10            | 7.5       | 2.5            |          |
| 2,724,102   | 1,000,000  | 5             | 3.75      | 1.25           |          |
| 4,826,502   | 1,000,000  | 2             | 1.5       | 0.5            |          |
| 6,928,902   | 1,000,000  | 1             | 0.75      | 0.25           |          |
---

Masternode collateral is currently **1,000,000 XLN** (in effect since block 621,702).

### Blockchain Bootstrap

To skip syncing from scratch, download the bootstrap and extract `blocks/`,
`chainstate/` and `sporks/` into your data directory (`%APPDATA%\LunariumCoin`
on Windows, `~/.lunariumcoin` on Linux):

[mundolunariumcoin.explorerxln.com/bootstrap/bootstrap-latest.tar.gz](https://mundolunariumcoin.explorerxln.com/bootstrap/bootstrap-latest.tar.gz)

The Windows installer (see [Releases](https://github.com/Lunariumcoin-Labs/LunariumCoin/releases)) can do this automatically during setup.

### Media Coverage

Third-party coverage of Lunarium Coin. Entries marked *sponsored* are paid placements.

- Chainquiry (sponsored): [Project listing](https://chainquiry.com/projects/lunarium-coin/) · [Research article](https://chainquiry.com/insights/what-is-lunarium-coin/) · [Medium feature](https://medium.com/@chainquiry/lunarium-coin-xln-why-this-2018-blockchain-is-still-building-a2abc3f4c120)

### Core Team

• Lunarium Coin XLN  
• Core_XLN

### License

LunariumCoin Core is released under the [MIT license](COPYING), like the Bitcoin, Dash and PIVX code it builds on.
