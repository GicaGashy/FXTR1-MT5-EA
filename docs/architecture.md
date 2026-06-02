# FXTR1 Architecture

This document captures the initial high-level architecture for FXTR1. The current project is a skeleton only; no strategy or trading logic is implemented yet.

## Main EA Entry

`src/Experts/FXTR1_EA.mq5` is the MetaTrader Expert Advisor entry point. It should keep `OnInit`, `OnTick`, and `OnDeinit` thin by delegating lifecycle work to the core engine.

## Core Engine

The core engine coordinates EA lifecycle events. It owns startup, tick handling, shutdown flow, and the wiring between future modules.

Initial responsibilities:

- Initialize shared services.
- Delegate tick events.
- Keep module interactions explicit.
- Avoid embedding strategy-specific rules.

## Strategy Contract

The strategy contract defines the interface future strategies must implement. Strategies should produce decisions or signals only through this contract.

Current status:

- Interface placeholder exists.
- No concrete strategy is implemented.
- No signal generation is implemented.

## Risk Manager

The risk manager will own risk validation before any future trade action is allowed.

Initial constraints:

- No martingale.
- No grid.
- No unsafe lot scaling.
- No hidden recovery sizing.

## Trade Executor

The trade executor will isolate order placement and trade modification mechanics from strategies and risk rules.

Current status:

- Class placeholder exists.
- No order placement is implemented.

## Position Manager

The position manager is a planned module for tracking and managing open positions. It is documented here as part of the architecture, but no file is created yet because the first skeleton only includes the requested files.

Future responsibilities may include:

- Position lookup.
- Exposure summaries.
- Stop or target update coordination.
- Position lifecycle state.

## Logger

The logger centralizes project log output so future modules do not write directly to `Print` everywhere.

Initial responsibilities:

- Provide a simple info log helper.
- Provide a simple error log helper.
- Keep log messages consistently prefixed.

## Future Backtesting Workflow

The expected future workflow is:

1. Edit source under `src/`.
2. Copy source into a user-configured MT5 `MQL5` folder.
3. Compile with MetaEditor.
4. Run backtests in MT5 Strategy Tester.
5. Record assumptions, settings, and results in repository documentation.
