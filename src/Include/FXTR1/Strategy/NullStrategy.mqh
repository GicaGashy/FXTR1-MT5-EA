#ifndef FXTR1_STRATEGY_NULLSTRATEGY_MQH
#define FXTR1_STRATEGY_NULLSTRATEGY_MQH

#include <FXTR1/Strategy/IStrategy.mqh>

class CFXTR1NullStrategy : public IFXTR1Strategy
{
public:
   bool Initialize()
   {
      return true;
   }

   void Deinitialize()
   {
   }

   CFXTR1StrategySignal Evaluate()
   {
      CFXTR1StrategySignal signal;
      return signal;
   }
};

#endif
