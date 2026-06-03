#ifndef FXTR1_RISK_RISKCHECKRESULT_MQH
#define FXTR1_RISK_RISKCHECKRESULT_MQH

class CFXTR1RiskCheckResult
{
public:
   bool   Passed;
   string Message;

   CFXTR1RiskCheckResult()
   {
      Clear();
   }

   void Clear()
   {
      Passed = false;
      Message = "";
   }

   void Pass(const string message)
   {
      Passed = true;
      Message = message;
   }

   void Fail(const string message)
   {
      Passed = false;
      Message = message;
   }

   bool IsPassed() const
   {
      return Passed;
   }
};

#endif
