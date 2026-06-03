#ifndef FXTR1_RISK_RISKDECISION_MQH
#define FXTR1_RISK_RISKDECISION_MQH

#include <FXTR1/Core/TradeRequest.mqh>

class CFXTR1RiskDecision
{
public:
   bool                Approved;
   string              RejectReason;
   CFXTR1TradeRequest  Request;

   CFXTR1RiskDecision()
   {
      Clear();
   }

   void Clear()
   {
      Approved = false;
      RejectReason = "";
      Request.Clear();
   }

   bool CanExecute()
   {
      return Approved && Request.CanExecute();
   }
};

#endif
