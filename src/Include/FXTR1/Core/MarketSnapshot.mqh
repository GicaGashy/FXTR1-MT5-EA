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
   double          VolumeMin;
   double          VolumeMax;
   double          VolumeStep;
   int             StopsLevelPoints;
   int             FreezeLevelPoints;
   long            TradeMode;

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
      VolumeMin = 0.0;
      VolumeMax = 0.0;
      VolumeStep = 0.0;
      StopsLevelPoints = 0;
      FreezeLevelPoints = 0;
      TradeMode = 0;
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

   bool HasValidVolumeConstraints() const
   {
      return VolumeMin > 0.0
             && VolumeMax >= VolumeMin
             && VolumeStep > 0.0;
   }

   bool HasValidStopConstraints() const
   {
      return Point > 0.0
             && StopsLevelPoints >= 0
             && FreezeLevelPoints >= 0;
   }
};

#endif
