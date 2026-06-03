#ifndef FXTR1_RISK_SPREADFILTER_MQH
#define FXTR1_RISK_SPREADFILTER_MQH

#include <FXTR1/Risk/RiskEvaluationRequest.mqh>
#include <FXTR1/Risk/RiskCheckResult.mqh>

class CFXTR1SpreadFilter
{
public:
   CFXTR1RiskCheckResult Check(const CFXTR1RiskEvaluationRequest &request)
   {
      CFXTR1RiskCheckResult result;

      if(!request.HasValidMarket())
      {
         result.Fail("Invalid market snapshot.");
         return result;
      }

      if(request.Settings.MaxSpreadPoints <= 0)
      {
         result.Pass("Spread filter disabled.");
         return result;
      }

      if(request.Market.SpreadPoints <= request.Settings.MaxSpreadPoints)
      {
         result.Pass("Spread within limit.");
         return result;
      }

      result.Fail("Spread too high. Current="
                  + IntegerToString(request.Market.SpreadPoints)
                  + ", Max="
                  + IntegerToString(request.Settings.MaxSpreadPoints)
                  + ".");

      return result;
   }
};

#endif
