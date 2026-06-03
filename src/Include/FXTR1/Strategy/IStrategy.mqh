#ifndef FXTR1_STRATEGY_ISTRATEGY_MQH
#define FXTR1_STRATEGY_ISTRATEGY_MQH

#include <FXTR1/Core/MarketSnapshot.mqh>
#include <FXTR1/Core/StrategySignal.mqh>

class IFXTR1Strategy
{
public:
   virtual bool Initialize()
   {
      return true;
   }

   virtual void Deinitialize()
   {
   }

   virtual void OnTick()
   {
   }

   virtual CFXTR1StrategySignal Evaluate(const CFXTR1MarketSnapshot &market)
   {
      CFXTR1StrategySignal signal;
      return signal;
   }
};

#endif
