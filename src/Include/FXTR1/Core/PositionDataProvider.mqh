#ifndef FXTR1_CORE_POSITIONDATAPROVIDER_MQH
#define FXTR1_CORE_POSITIONDATAPROVIDER_MQH

#include <FXTR1/Core/Settings.mqh>
#include <FXTR1/Core/PositionSnapshot.mqh>

class CFXTR1PositionDataProvider
{
public:
   CFXTR1PositionSnapshot Capture(const CFXTR1Settings &settings)
   {
      CFXTR1PositionSnapshot snapshot;
      snapshot.Symbol = settings.Symbol;
      snapshot.MagicNumber = settings.MagicNumber;

      if(!settings.HasValidSymbol())
         return snapshot;

      const int total_positions = PositionsTotal();
      for(int index = 0; index < total_positions; index++)
      {
         const ulong ticket = PositionGetTicket(index);
         if(ticket == 0)
            continue;

         const string position_symbol = PositionGetString(POSITION_SYMBOL);
         if(position_symbol != settings.Symbol)
            continue;

         const long position_magic = PositionGetInteger(POSITION_MAGIC);
         if((ulong)position_magic != settings.MagicNumber)
            continue;

         const long position_type = PositionGetInteger(POSITION_TYPE);
         const double position_volume = PositionGetDouble(POSITION_VOLUME);

         snapshot.TotalOpenPositions++;
         snapshot.TotalVolume += position_volume;

         if(position_type == POSITION_TYPE_BUY)
            snapshot.BuyPositions++;
         else if(position_type == POSITION_TYPE_SELL)
            snapshot.SellPositions++;
      }

      snapshot.IsValid = true;
      return snapshot;
   }
};

#endif
