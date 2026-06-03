#ifndef FXTR1_RISK_POSITIONLIMITVALIDATOR_MQH
#define FXTR1_RISK_POSITIONLIMITVALIDATOR_MQH

#include <FXTR1/Risk/RiskEvaluationRequest.mqh>
#include <FXTR1/Risk/RiskCheckResult.mqh>

class CFXTR1PositionLimitValidator
{
public:
   CFXTR1RiskCheckResult Check(const CFXTR1RiskEvaluationRequest &request)
   {
      CFXTR1RiskCheckResult result;

      if(!request.HasValidPositions())
      {
         result.Fail("Invalid position snapshot.");
         return result;
      }

      if(request.Settings.MaxOpenPositions <= 0)
      {
         result.Fail("Max open positions must be greater than zero.");
         return result;
      }

      if(request.Positions.TotalOpenPositions >= request.Settings.MaxOpenPositions)
      {
         result.Fail("Max open positions reached. Current="
                     + IntegerToString(request.Positions.TotalOpenPositions)
                     + ", Max="
                     + IntegerToString(request.Settings.MaxOpenPositions)
                     + ".");
         return result;
      }

      result.Pass("Position limit allows new entry.");
      return result;
   }
};

#endif
