#ifndef FXTR1_CORE_MARKETDATAPROVIDER_MQH
#define FXTR1_CORE_MARKETDATAPROVIDER_MQH

#include <FXTR1/Core/Settings.mqh>
#include <FXTR1/Core/MarketSnapshot.mqh>

class CFXTR1MarketDataProvider
{
public:
   CFXTR1MarketSnapshot Capture(const CFXTR1Settings &settings)
   {
      CFXTR1MarketSnapshot snapshot;

      if(!settings.HasValidSymbol())
         return snapshot;

      snapshot.Symbol = settings.Symbol;
      snapshot.Timeframe = settings.Timeframe;
      snapshot.ServerTime = TimeCurrent();
      snapshot.Bid = SymbolInfoDouble(snapshot.Symbol, SYMBOL_BID);
      snapshot.Ask = SymbolInfoDouble(snapshot.Symbol, SYMBOL_ASK);
      snapshot.Point = SymbolInfoDouble(snapshot.Symbol, SYMBOL_POINT);
      snapshot.TickSize = SymbolInfoDouble(snapshot.Symbol, SYMBOL_TRADE_TICK_SIZE);
      snapshot.TickValue = SymbolInfoDouble(snapshot.Symbol, SYMBOL_TRADE_TICK_VALUE);
      snapshot.Digits = (int)SymbolInfoInteger(snapshot.Symbol, SYMBOL_DIGITS);
      snapshot.SpreadPoints = (int)SymbolInfoInteger(snapshot.Symbol, SYMBOL_SPREAD);
      snapshot.IsValid = snapshot.HasValidSymbol() && snapshot.HasValidPrices();

      return snapshot;
   }
};

#endif
