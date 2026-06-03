#ifndef FXTR1_CORE_TRADEREQUEST_MQH
#define FXTR1_CORE_TRADEREQUEST_MQH

#include <FXTR1/Core/TradeDirection.mqh>

class CFXTR1TradeRequest
{
public:
   bool                       IsValid;
   ENUM_FXTR1_TRADE_DIRECTION Direction;
   double                     Volume;
   double                     EntryPrice;
   double                     StopLoss;
   double                     TakeProfit;
   string                     Symbol;
   string                     Reason;

   CFXTR1TradeRequest()
   {
      Clear();
   }

   void Clear()
   {
      IsValid = false;
      Direction = FXTR1_DIRECTION_NONE;
      Volume = 0.0;
      EntryPrice = 0.0;
      StopLoss = 0.0;
      TakeProfit = 0.0;
      Symbol = "";
      Reason = "";
   }

   bool CanExecute()
   {
      return IsValid
             && (Direction == FXTR1_DIRECTION_BUY || Direction == FXTR1_DIRECTION_SELL)
             && Volume > 0.0
             && StringLen(Symbol) > 0;
   }
};

#endif
