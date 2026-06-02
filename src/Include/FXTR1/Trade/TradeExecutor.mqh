#ifndef FXTR1_TRADE_TRADEEXECUTOR_MQH
#define FXTR1_TRADE_TRADEEXECUTOR_MQH

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
};

#endif
