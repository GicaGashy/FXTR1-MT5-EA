#ifndef FXTR1_RISK_TRADEREQUESTBUILDRESULT_MQH
#define FXTR1_RISK_TRADEREQUESTBUILDRESULT_MQH

#include <FXTR1/Core/TradeRequest.mqh>

class CFXTR1TradeRequestBuildResult
{
public:
   bool               Success;
   string             Message;
   CFXTR1TradeRequest Request;

   CFXTR1TradeRequestBuildResult()
   {
      Clear();
   }

   void Clear()
   {
      Success = false;
      Message = "";
      Request.Clear();
   }

   void Pass(const CFXTR1TradeRequest &request, const string message)
   {
      Success = true;
      Message = message;
      Request.IsValid = request.IsValid;
      Request.Direction = request.Direction;
      Request.Volume = request.Volume;
      Request.EntryPrice = request.EntryPrice;
      Request.StopLoss = request.StopLoss;
      Request.TakeProfit = request.TakeProfit;
      Request.Symbol = request.Symbol;
      Request.Reason = request.Reason;
   }

   void Fail(const string message)
   {
      Success = false;
      Message = message;
      Request.Clear();
   }

   bool IsSuccess() const
   {
      return Success;
   }
};

#endif
