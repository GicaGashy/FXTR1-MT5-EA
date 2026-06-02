# Codex Rules for FXTR1

This repository is the source workspace for the FXTR1 MQL5 Expert Advisor. Work inside this repository, not inside the live MetaTrader terminal `MQL5` folder.

## Project Boundaries

- Keep source files under `src/`.
- Keep the EA entry point at `src/Experts/FXTR1_EA.mq5`.
- Keep shared includes under `src/Include/FXTR1/`.
- Do not write directly to a live MT5 terminal folder.
- Do not add real account credentials, broker logins, investor passwords, API keys, or secrets.

## MQL5 Design Rules

- Keep `OnInit`, `OnTick`, and `OnDeinit` thin.
- Put behavior in modular classes.
- Keep strategy behavior behind an explicit strategy contract.
- Keep risk checks separate from trade execution.
- Keep logging centralized.
- Prefer syntactically valid placeholders over prose-only code stubs.

## Trading Safety Rules

- Do not implement strategy logic until explicitly requested.
- Do not add martingale logic.
- Do not add grid logic.
- Do not add unsafe lot scaling or recovery sizing.
- Do not place live orders from placeholder code.
- Any future trading change must make risk behavior explicit and reviewable.

## Tooling Rules

- Treat MT5 as the compile and backtest runtime.
- Future scripts should copy from `src/` to a user-provided MT5 `MQL5` path.
- Do not guess local MetaTrader installation paths.
