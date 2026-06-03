#ifndef FXTR1_STRATEGY_SIGNALRESOLVER_MQH
#define FXTR1_STRATEGY_SIGNALRESOLVER_MQH

#include <FXTR1/Core/StrategySignal.mqh>
#include <FXTR1/Strategy/SignalResolutionResult.mqh>

class CFXTR1SignalResolver
{
public:
   CFXTR1SignalResolutionResult Resolve(const CFXTR1StrategySignal &signal)
   {
      CFXTR1SignalResolutionResult result;

      if(!signal.HasSignal())
         return result;

      result.Accepted = true;
      result.Signal.Type = signal.Type;
      result.Signal.Direction = signal.Direction;
      result.Signal.EntryPrice = signal.EntryPrice;
      result.Signal.StopLoss = signal.StopLoss;
      result.Signal.TakeProfit = signal.TakeProfit;
      result.Signal.Reason = signal.Reason;

      return result;
   }
};

#endif
