#ifndef FXTR1_CORE_POSITIONSNAPSHOT_MQH
#define FXTR1_CORE_POSITIONSNAPSHOT_MQH

class CFXTR1PositionSnapshot
{
public:
   bool   IsValid;
   string Symbol;
   ulong  MagicNumber;
   int    TotalOpenPositions;
   int    BuyPositions;
   int    SellPositions;
   double TotalVolume;

   CFXTR1PositionSnapshot()
   {
      Clear();
   }

   void Clear()
   {
      IsValid = false;
      Symbol = "";
      MagicNumber = 0;
      TotalOpenPositions = 0;
      BuyPositions = 0;
      SellPositions = 0;
      TotalVolume = 0.0;
   }

   bool HasOpenPositions() const
   {
      return TotalOpenPositions > 0;
   }
};

#endif
