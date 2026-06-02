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

## Local MT5 Setup

The exact MetaTrader paths are local to each user. Do not commit local terminal paths, account details, broker logins, investor passwords, API keys, or secrets.

To find the MT5 data folder:

1. Open MetaTrader 5.
2. Select `File` -> `Open Data Folder`.
3. Use the `MQL5` folder inside that data folder as `Mt5Mql5Path`.

To find `MetaEditor64.exe`, check the MetaTrader 5 installation folder. Common locations are under `C:\Program Files\...`, but the exact path depends on how MT5 was installed.

This workspace can load local defaults from `tools/local-settings.ps1`. That file is ignored by Git and should contain only machine-local paths:

```powershell
$FXTR1_DefaultMt5Mql5Path = "C:\Users\<you>\AppData\Roaming\MetaQuotes\Terminal\<terminal-id>\MQL5"
$FXTR1_DefaultMetaEditorPath = "C:\Program Files\<broker-or-mt5-folder>\MetaEditor64.exe"
```

Copy source files into the MT5 data folder:

```powershell
.\tools\copy-to-mt5.ps1
```

Or override the local default:

```powershell
.\tools\copy-to-mt5.ps1 `
  -Mt5Mql5Path "C:\Users\<you>\AppData\Roaming\MetaQuotes\Terminal\<terminal-id>\MQL5"
```

Build and compile the EA with MetaEditor:

```powershell
.\tools\build.ps1
```

Or override the local defaults:

```powershell
.\tools\build.ps1 `
  -MetaEditorPath "C:\Program Files\<broker-or-mt5-folder>\MetaEditor64.exe" `
  -Mt5Mql5Path "C:\Users\<you>\AppData\Roaming\MetaQuotes\Terminal\<terminal-id>\MQL5"
```

Compiler output is written to `build/FXTR1_EA.log`.
