#ifndef FXTR1_RISK_RISKMANAGER_MQH
#define FXTR1_RISK_RISKMANAGER_MQH

#include <FXTR1/Core/StrategySignal.mqh>
#include <FXTR1/Risk/RiskDecision.mqh>

class CFXTR1RiskManager
{
public:
   CFXTR1RiskManager()
   {
   }

   bool IsTradeAllowed()
   {
      // No real risk model is implemented yet.
      return false;
   }

   CFXTR1RiskDecision EvaluateSignal(const CFXTR1StrategySignal &signal)
   {
      CFXTR1RiskDecision decision;

      if(signal.Type == FXTR1_SIGNAL_NONE)
         decision.RejectReason = "No strategy signal.";
      else
         decision.RejectReason = "Risk evaluation is not implemented yet.";

      return decision;
   }
};

#endif
