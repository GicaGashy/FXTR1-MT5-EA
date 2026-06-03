#ifndef FXTR1_CORE_SETTINGS_MQH
#define FXTR1_CORE_SETTINGS_MQH

#include <FXTR1/Core/TradeDirection.mqh>
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
   bool            RiskApprovalEnabled;
   int             MaxSpreadPoints;
   int             MaxOpenPositions;
   double          FixedVolume;
   ENUM_FXTR1_STRATEGY_MODE StrategyMode;
   int             TestSignalEveryTicks;
   ENUM_FXTR1_TRADE_DIRECTION TestSignalDirection;
   int             TestSignalStopLossPoints;
   int             TestSignalTakeProfitPoints;

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
      RiskApprovalEnabled = false;
      MaxSpreadPoints = 0;
      MaxOpenPositions = 1;
      FixedVolume = 0.0;
      StrategyMode = FXTR1_STRATEGY_MODE_NULL;
      TestSignalEveryTicks = 100;
      TestSignalDirection = FXTR1_DIRECTION_BUY;
      TestSignalStopLossPoints = 500;
      TestSignalTakeProfitPoints = 1000;
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
