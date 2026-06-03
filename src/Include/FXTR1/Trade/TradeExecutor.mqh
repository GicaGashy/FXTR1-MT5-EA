#ifndef FXTR1_TRADE_TRADEEXECUTOR_MQH
#define FXTR1_TRADE_TRADEEXECUTOR_MQH

#include <FXTR1/Core/TradeRequest.mqh>
#include <FXTR1/Trade/ExecutionResult.mqh>

class CFXTR1TradeExecutor
{
public:
   CFXTR1TradeExecutor()
   {
   }

   bool HasExecutionLogic()
   {
      // Order placement will be implemented only after strategy and risk rules exist.
      return false;
   }

   CFXTR1ExecutionResult Execute(const CFXTR1TradeRequest &request)
   {
      CFXTR1ExecutionResult result;

      if(!request.CanExecute())
      {
         result.Message = "Trade request is not executable.";
         return result;
      }

      // Real execution will be implemented later after risk and broker constraints are defined.
      result.Message = "Trade execution is not implemented yet.";
      return result;
   }
};

#endif
