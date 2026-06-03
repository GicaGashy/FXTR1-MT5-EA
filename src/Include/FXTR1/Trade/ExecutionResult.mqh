#ifndef FXTR1_TRADE_EXECUTIONRESULT_MQH
#define FXTR1_TRADE_EXECUTIONRESULT_MQH

class CFXTR1ExecutionResult
{
public:
   bool  Success;
   string Message;
   uint  Retcode;
   ulong OrderTicket;
   ulong DealTicket;
   ulong PositionTicket;

   CFXTR1ExecutionResult()
   {
      Clear();
   }

   void Clear()
   {
      Success = false;
      Message = "";
      Retcode = 0;
      OrderTicket = 0;
      DealTicket = 0;
      PositionTicket = 0;
   }

   bool IsSuccess()
   {
      return Success;
   }

   bool HasAnyTicket()
   {
      return OrderTicket > 0 || DealTicket > 0 || PositionTicket > 0;
   }
};

#endif
