#ifndef FXTR1_RISK_RISKMANAGER_MQH
#define FXTR1_RISK_RISKMANAGER_MQH

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
};

#endif
