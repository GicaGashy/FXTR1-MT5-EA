#ifndef FXTR1_RISK_RISKMANAGER_MQH
#define FXTR1_RISK_RISKMANAGER_MQH

#include <FXTR1/Risk/RiskDecision.mqh>
#include <FXTR1/Risk/RiskEvaluationRequest.mqh>

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

   CFXTR1RiskDecision Evaluate(const CFXTR1RiskEvaluationRequest &request)
   {
      CFXTR1RiskDecision decision;

      if(!request.HasSignal())
      {
         decision.RejectReason = "No strategy signal.";
         return decision;
      }

      if(!request.HasValidMarket())
      {
         decision.RejectReason = "Invalid market snapshot.";
         return decision;
      }

      if(!request.Settings.HasValidSymbol())
      {
         decision.RejectReason = "Invalid settings symbol.";
         return decision;
      }

      decision.RejectReason = "Risk evaluation is not implemented yet.";

      return decision;
   }
};

#endif
