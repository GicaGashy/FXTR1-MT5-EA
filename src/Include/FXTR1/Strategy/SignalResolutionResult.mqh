#ifndef FXTR1_STRATEGY_SIGNALRESOLUTIONRESULT_MQH
#define FXTR1_STRATEGY_SIGNALRESOLUTIONRESULT_MQH

#include <FXTR1/Core/StrategySignal.mqh>

class CFXTR1SignalResolutionResult
{
public:
   bool                 Accepted;
   string               RejectReason;
   CFXTR1StrategySignal Signal;

   CFXTR1SignalResolutionResult()
   {
      Clear();
   }

   void Clear()
   {
      Accepted = false;
      RejectReason = "";
      Signal.Clear();
   }

   bool HasAcceptedSignal() const
   {
      return Accepted && Signal.HasSignal();
   }
};

#endif
