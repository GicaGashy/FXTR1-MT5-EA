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

## SignalResolver

`CFXTR1SignalResolver` decides which strategy signal, if any, survives before runtime settings and risk checks are evaluated. The current resolver is only a safe single-signal pass-through: no signal returns quietly, and one valid signal is accepted unchanged.

Future voting, priority, and conflict handling belong in `CFXTR1SignalResolver`, not in the engine, risk manager, or trade executor.

## NullStrategy

`CFXTR1NullStrategy` is the current engine strategy implementation. It exists only to wire and compile-test the engine flow safely while the real architecture is being defined.

`CFXTR1NullStrategy` must never produce trade signals. Its `Evaluate()` method returns an empty `CFXTR1StrategySignal`, so the engine stops before risk evaluation or trade execution during normal ticks.

## Runtime Settings and Safety Switches

Runtime settings are centralized in `CFXTR1Settings` and are passed from `src/Experts/FXTR1_EA.mq5` inputs into the core engine during initialization. The engine stores this configuration and uses it as an explicit gate before any future signal can proceed to risk evaluation.

`TradingEnabled` and `AllowNewEntries` both default to `false`. A future strategy signal may only proceed when both switches are enabled and a symbol is configured.

These defaults protect against accidental future execution while the project is still a skeleton. They ensure new strategy, risk, or execution modules must opt in through reviewable runtime settings before trade flow can advance.

## Market Snapshot

The engine captures market data once per tick through `CFXTR1MarketDataProvider` and passes a `CFXTR1MarketSnapshot` into strategy evaluation. Strategies receive explicit market context instead of reaching out to scattered direct market-data calls.

This keeps strategy modules cleaner and makes future strategy inputs easier to review, test, and constrain.

### Symbol Trading Constraints

`CFXTR1MarketSnapshot` also captures broker symbol constraints such as volume limits, volume step, stop level, freeze level, and trade mode. These constraints will later be used by lot sizing and stop-distance validation.

Strategies should not hardcode volume limits, stop levels, or broker rules.

## Core Trading Flow

The planned future trading flow is intentionally staged so that each module has one clear responsibility:

1. Engine captures a `CFXTR1MarketSnapshot`.
2. StrategyManager collects or produces strategy signals from the active strategy module using the snapshot.
3. Strategy returns a `CFXTR1StrategySignal`.
4. SignalResolver decides which signal, if any, survives.
5. Runtime settings and safety switches gate any accepted signal before risk evaluation.
6. Engine builds a `CFXTR1RiskEvaluationRequest` from the resolved signal, market snapshot, and runtime settings.
7. Risk manager evaluates the request into a `CFXTR1RiskDecision`.
8. Risk decision records whether the signal was approved or rejected and why.
9. Risk manager eventually transforms or approves the signal into a `CFXTR1TradeRequest`.
10. Trade executor executes only approved executable trade requests.
11. Trade executor returns a `CFXTR1ExecutionResult`.
12. Position manager manages open trades after execution.

`CFXTR1StrategySignal` is not executed directly. It is an intent object from a strategy, and future risk checks must approve or prepare it before it can become a `CFXTR1TradeRequest`.

`CFXTR1RiskEvaluationRequest` makes risk inputs explicit: risk evaluation requires the resolved strategy signal, the current market snapshot, and runtime settings. This avoids hidden global state and prepares the EA for future spread, symbol, stop-loss, take-profit, and lot-size validation without scattering those checks across strategy, engine, or execution code.

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

### Signal Validator

`CFXTR1SignalValidator` checks entry signal structure before risk approval. Entry signals must have a valid buy or sell direction and a defined stop loss.

Take profit is optional for now, but when provided it must be on the correct side of the entry reference. Passing `CFXTR1SignalValidator` does not approve a trade yet.

### Trade Mode Validator

`CFXTR1TradeModeValidator` checks whether the broker symbol trade mode allows the intended trade direction. Disabled and close-only modes reject new entries, long-only permits buys, short-only permits sells, and full mode permits both directions.

Passing this validator still does not approve a trade.

### Stop Distance Validator

`CFXTR1StopDistanceValidator` validates stop-loss and optional take-profit distances against broker stop-level constraints. BUY validation uses Bid as the close/reference price, and SELL validation uses Ask as the close/reference price.

This validator currently assumes future market-order execution only. Passing it still does not approve a trade.

### Spread Filter

`CFXTR1SpreadFilter` is the first modular risk check. It validates the current market spread against `MaxSpreadPoints` from runtime settings.

`MaxSpreadPoints` defaults to `0`, which disables the spread filter. Passing the spread filter does not approve a trade yet because lot sizing and stop-loss/take-profit validation are not implemented.

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
