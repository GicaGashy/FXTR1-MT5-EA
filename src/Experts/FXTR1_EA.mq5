#property copyright "FXTR1"
#property link      ""
#property version   "1.00"
#property strict

#include <FXTR1/Core/Settings.mqh>
#include <FXTR1/Core/Engine.mqh>

input bool  InpTradingEnabled = false;
input bool  InpAllowNewEntries = false;
input bool  InpRiskApprovalEnabled = false;
input ulong InpMagicNumber = 1001001;
input int   InpMaxSpreadPoints = 0;
input int   InpMaxOpenPositions = 1;
input double InpFixedVolume = 0.0;
input ENUM_FXTR1_STRATEGY_MODE InpStrategyMode = FXTR1_STRATEGY_MODE_NULL;
input int InpTestSignalEveryTicks = 100;
input ENUM_FXTR1_TRADE_DIRECTION InpTestSignalDirection = FXTR1_DIRECTION_BUY;
input int InpTestSignalStopLossPoints = 500;
input int InpTestSignalTakeProfitPoints = 1000;

CFXTR1Engine g_engine;

int OnInit()
{
   CFXTR1Settings settings;
   settings.ExpertName = "FXTR1";
   settings.Symbol = _Symbol;
   settings.Timeframe = (ENUM_TIMEFRAMES)_Period;
   settings.MagicNumber = InpMagicNumber;
   settings.TradingEnabled = InpTradingEnabled;
   settings.AllowNewEntries = InpAllowNewEntries;
   settings.RiskApprovalEnabled = InpRiskApprovalEnabled;
   settings.MaxSpreadPoints = InpMaxSpreadPoints;
   settings.MaxOpenPositions = InpMaxOpenPositions;
   settings.FixedVolume = InpFixedVolume;
   settings.StrategyMode = InpStrategyMode;
   settings.TestSignalEveryTicks = InpTestSignalEveryTicks;
   settings.TestSignalDirection = InpTestSignalDirection;
   settings.TestSignalStopLossPoints = InpTestSignalStopLossPoints;
   settings.TestSignalTakeProfitPoints = InpTestSignalTakeProfitPoints;

   g_engine.Configure(settings);
   return g_engine.OnInit();
}

void OnDeinit(const int reason)
{
   g_engine.OnDeinit(reason);
}

void OnTick()
{
   g_engine.OnTick();
}
