#property copyright "FXTR1"
#property link      ""
#property version   "1.00"
#property strict

#include <FXTR1/Core/Settings.mqh>
#include <FXTR1/Core/Engine.mqh>

input bool  InpTradingEnabled = false;
input bool  InpAllowNewEntries = false;
input ulong InpMagicNumber = 1001001;
input int   InpMaxSpreadPoints = 0;

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
   settings.MaxSpreadPoints = InpMaxSpreadPoints;

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
