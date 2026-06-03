#ifndef FXTR1_CORE_STRATEGYSIGNAL_MQH
#define FXTR1_CORE_STRATEGYSIGNAL_MQH

#include <FXTR1/Core/SignalType.mqh>
#include <FXTR1/Core/TradeDirection.mqh>

class CFXTR1StrategySignal
{
public:
   ENUM_FXTR1_SIGNAL_TYPE      Type;
   ENUM_FXTR1_TRADE_DIRECTION Direction;
   double                     EntryPrice;
   double                     StopLoss;
   double                     TakeProfit;
   string                     Reason;

   CFXTR1StrategySignal()
   {
      Clear();
   }

   bool HasSignal()
   {
      return Type != FXTR1_SIGNAL_NONE;
   }

   bool IsEntrySignal()
   {
      return Type == FXTR1_SIGNAL_ENTRY && Direction != FXTR1_DIRECTION_NONE;
   }

   void Clear()
   {
      Type = FXTR1_SIGNAL_NONE;
      Direction = FXTR1_DIRECTION_NONE;
      EntryPrice = 0.0;
      StopLoss = 0.0;
      TakeProfit = 0.0;
      Reason = "";
   }
};

#endif
