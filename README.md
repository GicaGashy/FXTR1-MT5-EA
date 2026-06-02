# FXTR1 MT5 Expert Advisor

FXTR1 is a source-first MQL5 Expert Advisor project. The repository contains the EA entry file, shared include modules, documentation, and tooling placeholders for a future MetaTrader 5 build and backtest workflow.

MetaTrader 5 is only the compile and backtest runtime. The live terminal `MQL5` folder should be treated as an output target, not as the source workspace.

Codex and other development work should happen inside this repository. Do not edit the live MetaTrader terminal `MQL5` folder directly unless a future task explicitly defines a controlled copy or build step.

## Repository Layout

```text
src/Experts/FXTR1_EA.mq5
src/Include/FXTR1/
docs/
tools/
```

Source files live under `src/`. The final EA entry file lives at `src/Experts/FXTR1_EA.mq5`. Shared include files live under `src/Include/FXTR1/`.

## Future Workflow

1. Edit source files in this repository.
2. Copy `src/Experts` and `src/Include` into the configured MT5 `MQL5` folder.
3. Compile the EA with MetaEditor or a scripted build step.
4. Backtest in MetaTrader 5 Strategy Tester.

The copy and build scripts are placeholders for now. They intentionally do not guess the local MT5 installation path.
