#ifndef FXTR1_CORE_SETTINGS_MQH
#define FXTR1_CORE_SETTINGS_MQH

#include <FXTR1/Strategy/StrategyMode.mqh>

class CFXTR1Settings
{
public:
   string          ExpertName;
   string          Symbol;
   ENUM_TIMEFRAMES Timeframe;
   ulong           MagicNumber;
   bool            TradingEnabled;
   bool            AllowNewEntries;
   int             MaxSpreadPoints;
   ENUM_FXTR1_STRATEGY_MODE StrategyMode;

   CFXTR1Settings()
   {
      Clear();
   }

   void Clear()
   {
      ExpertName = "FXTR1";
      Symbol = "";
      Timeframe = PERIOD_CURRENT;
      MagicNumber = 1001001;
      TradingEnabled = false;
      AllowNewEntries = false;
      MaxSpreadPoints = 0;
      StrategyMode = FXTR1_STRATEGY_MODE_NULL;
   }

   bool HasValidSymbol() const
   {
      return StringLen(Symbol) > 0;
   }

   bool CanOpenNewTrades() const
   {
      return TradingEnabled && AllowNewEntries && HasValidSymbol();
   }
};

#endif
