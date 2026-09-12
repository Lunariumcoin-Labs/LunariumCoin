LunariumCoin wallet repository 
=====================================

### Coin Specs

• PoW Algorithm: Scrypt  
• Premine: 51,000,000 XLN (block 1)
• PoW Blocks: 1 - 250  
• PoS Blocks: Starting from 251  
• Block Time: 60 Seconds    
• Maturity: 100 Confirmations  
• Prefix: XLN addresses start with the capital letter "A"   
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
