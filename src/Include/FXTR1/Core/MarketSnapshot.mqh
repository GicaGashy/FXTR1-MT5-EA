#ifndef FXTR1_CORE_MARKETSNAPSHOT_MQH
#define FXTR1_CORE_MARKETSNAPSHOT_MQH

class CFXTR1MarketSnapshot
{
public:
   bool            IsValid;
   string          Symbol;
   ENUM_TIMEFRAMES Timeframe;
   datetime        ServerTime;
   double          Bid;
   double          Ask;
   int             SpreadPoints;
   double          Point;
   int             Digits;
   double          TickSize;
   double          TickValue;

   CFXTR1MarketSnapshot()
   {
      Clear();
   }

   void Clear()
   {
      IsValid = false;
      Symbol = "";
      Timeframe = PERIOD_CURRENT;
      ServerTime = 0;
      Bid = 0.0;
      Ask = 0.0;
      SpreadPoints = 0;
      Point = 0.0;
      Digits = 0;
      TickSize = 0.0;
      TickValue = 0.0;
   }

   bool HasValidPrices() const
   {
      return Bid > 0.0
             && Ask > 0.0
             && Ask >= Bid
             && Point > 0.0;
   }

   bool HasValidSymbol() const
   {
      return StringLen(Symbol) > 0;
   }
};

#endif
