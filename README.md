# MQL4 Grid Trading EA ( with Martingale & Custom Sequence Money Management ) 

## Overview

This Expert Advisor (EA) implements a **basic grid trading strategy** without using any technical indicator for entry signals. It opens both Buy and Sell trades directly based on user configuration and adds grid orders as price moves against the position. It supports **custom martingale scaling**, **configurable grid distance**, and **profit-target-based group closing**.

## Key Features

- 🔁 **Grid logic**: adds positions when price moves against active trades
- 📈 **Martingale scaling**: lot size increases per repeat cycle
- 🎯 **Profit-based close**: closes all trades in one direction once net profit exceeds a defined threshold
- ⚖️ Supports **dual direction** trading (Buy and Sell separately or together)

## How It Works

1. **Order Entry**:
   - If `open_buy` or `open_sell` is enabled and no trades exist in that direction, the EA opens a position immediately.
   - If trades already exist and price moves by at least `grid_*` points from last max/min price, a new order is opened with a calculated lot size based on `repeat_*` and `mul_*`.

2. **Order Exit**:
   - Once total floating profit (including swap and commission) in one direction exceeds `close_profit_*`, all trades in that direction are closed at once.

## Inputs

| Parameter               | Description                                          |
|------------------------|------------------------------------------------------|
| `magic`                | Magic number to distinguish orders                   |
| `open_buy`             | Enable Buy grid trading                              |
| `lot_buy`              | Initial lot size for Buy                             |
| `mul_buy`              | Lot multiplier per repeat_buy orders                 |
| `repeat_buy`           | Number of Buy orders before increasing lot size      |
| `grid_buy`             | Price gap (points) between Buy grid orders           |
| `close_profit_buy`     | Profit (in currency) to close all Buy orders         |
| `open_sell`            | Enable Sell grid trading                             |
| `lot_sell`             | Initial lot size for Sell                            |
| `mul_sell`             | Lot multiplier per repeat_sell orders                |
| `repeat_sell`          | Number of Sell orders before increasing lot size     |
| `grid_sell`            | Price gap (points) between Sell grid orders          |
| `close_profit_sell`    | Profit (in currency) to close all Sell orders        |

## Strategy Notes

- Works best in **sideways markets** with price oscillation.
- Martingale and grid-based strategies carry **high risk** in trending markets.
- Always test in a **demo environment** and use proper risk management.

## Installation

1. Copy the `.mq4` file into your MetaTrader 4 `Experts/` directory.
2. Restart MT4 or refresh the Navigator window.
3. Attach the EA to your desired chart.
4. Set your parameters and enable AutoTrading.

## Disclaimer

This EA uses grid and martingale logic which can incur large drawdowns. Use with caution, especially in live trading environments.

