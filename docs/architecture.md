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

## Strategy Selection

The EA exposes a strategy mode input and passes the selected value into `CFXTR1Settings` during initialization. The engine reads that setting before initializing the configured strategy module.

Only `CFXTR1NullStrategy` is currently supported. Any unsupported mode is rejected during engine initialization, and no fallback strategy is selected implicitly.

Future strategies will be added as plug-and-play modules behind the strategy contract. Strategy selection chooses which module is active; it is separate from any future signal resolution, voting, or multi-strategy orchestration.

## StrategyManager

`CFXTR1StrategyManager` owns strategy selection, initialization, deinitialization, and evaluation. The engine delegates strategy lifecycle and signal evaluation to the manager instead of owning strategy implementations directly.

Only `CFXTR1NullStrategy` is currently supported. Future strategies will be plugged into `CFXTR1StrategyManager`, not directly into the engine, so the engine can keep coordinating the safe trading flow without knowing concrete strategy modules.

## NullStrategy

`CFXTR1NullStrategy` is the current engine strategy implementation. It exists only to wire and compile-test the engine flow safely while the real architecture is being defined.

`CFXTR1NullStrategy` must never produce trade signals. Its `Evaluate()` method returns an empty `CFXTR1StrategySignal`, so the engine stops before risk evaluation or trade execution during normal ticks.

## Runtime Settings and Safety Switches

Runtime settings are centralized in `CFXTR1Settings` and are passed from `src/Experts/FXTR1_EA.mq5` inputs into the core engine during initialization. The engine stores this configuration and uses it as an explicit gate before any future signal can proceed to risk evaluation.

`TradingEnabled` and `AllowNewEntries` both default to `false`. A future strategy signal may only proceed when both switches are enabled and a symbol is configured.

These defaults protect against accidental future execution while the project is still a skeleton. They ensure new strategy, risk, or execution modules must opt in through reviewable runtime settings before trade flow can advance.

## Core Trading Flow

The planned future trading flow is intentionally staged so that each module has one clear responsibility:

1. Strategy evaluates the market.
2. Strategy returns a `CFXTR1StrategySignal`.
3. Risk manager evaluates the signal and account constraints into a `CFXTR1RiskDecision`.
4. Risk decision records whether the signal was approved or rejected and why.
5. Risk manager eventually transforms or approves the signal into a `CFXTR1TradeRequest`.
6. Trade executor executes only approved executable trade requests.
7. Trade executor returns a `CFXTR1ExecutionResult`.
8. Position manager manages open trades after execution.

`CFXTR1StrategySignal` is not executed directly. It is an intent object from a strategy, and future risk checks must approve or prepare it before it can become a `CFXTR1TradeRequest`.

`CFXTR1TradeExecutor` should eventually only receive approved requests where the `CFXTR1RiskDecision` is executable.

`CFXTR1ExecutionResult` provides structured execution feedback. Broker retcodes, order tickets, deal tickets, and position tickets will be captured there later when real execution is implemented.

This flow is architectural only at this stage. No concrete strategy, order placement, or position management behavior is implemented yet.

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
