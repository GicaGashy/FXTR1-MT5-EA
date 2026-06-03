#ifndef FXTR1_TRADE_TRADEEXECUTOR_MQH
#define FXTR1_TRADE_TRADEEXECUTOR_MQH

#include <Trade/Trade.mqh>
#include <FXTR1/Core/Settings.mqh>
#include <FXTR1/Core/TradeRequest.mqh>
#include <FXTR1/Trade/ExecutionResult.mqh>

class CFXTR1TradeExecutor
{
private:
   CTrade         m_trade;
   CFXTR1Settings m_settings;
   bool           m_configured;

public:
   CFXTR1TradeExecutor()
   {
      m_configured = false;
   }

   void Configure(const CFXTR1Settings &settings)
   {
      m_settings = settings;
      m_configured = true;

      m_trade.SetExpertMagicNumber(m_settings.MagicNumber);
      if(m_settings.DeviationPoints > 0)
         m_trade.SetDeviationInPoints((ulong)m_settings.DeviationPoints);
      else
         m_trade.SetDeviationInPoints(0);

      if(m_settings.HasValidSymbol())
         m_trade.SetTypeFillingBySymbol(m_settings.Symbol);
   }

   bool HasExecutionLogic()
   {
      return m_configured;
   }

   CFXTR1ExecutionResult Execute(const CFXTR1TradeRequest &request)
   {
      CFXTR1ExecutionResult result;

      if(!m_configured)
      {
         result.Message = "Trade executor is not configured.";
         return result;
      }

      if(!m_settings.ExecutionEnabled)
      {
         result.Message = "Trade execution is disabled.";
         return result;
      }

      if(!request.CanExecute())
      {
         result.Message = "Trade request is not executable.";
         return result;
      }

      if(StringLen(request.Symbol) <= 0)
      {
         result.Message = "Trade request symbol is empty.";
         return result;
      }

      if(request.Volume <= 0.0)
      {
         result.Message = "Trade request volume must be greater than zero.";
         return result;
      }

      if(request.StopLoss <= 0.0)
      {
         result.Message = "Trade request requires a stop loss.";
         return result;
      }

      bool trade_call_succeeded = false;

      if(request.Direction == FXTR1_DIRECTION_BUY)
      {
         trade_call_succeeded = m_trade.Buy(request.Volume,
                                            request.Symbol,
                                            0.0,
                                            request.StopLoss,
                                            request.TakeProfit,
                                            request.Reason);
      }
      else if(request.Direction == FXTR1_DIRECTION_SELL)
      {
         trade_call_succeeded = m_trade.Sell(request.Volume,
                                             request.Symbol,
                                             0.0,
                                             request.StopLoss,
                                             request.TakeProfit,
                                             request.Reason);
      }
      else
      {
         result.Message = "Unsupported trade direction.";
         return result;
      }

      result.Retcode = m_trade.ResultRetcode();
      result.OrderTicket = m_trade.ResultOrder();
      result.DealTicket = m_trade.ResultDeal();
      result.PositionTicket = 0;

      const string retcode_text = IntegerToString((int)result.Retcode);
      const string description = m_trade.ResultRetcodeDescription();

      if(!trade_call_succeeded)
      {
         result.Success = false;
         result.Message = "Trade request failed. Retcode=" + retcode_text
                          + ", Description=" + description + ".";
         return result;
      }

      if(result.Retcode == TRADE_RETCODE_DONE
         || result.Retcode == TRADE_RETCODE_PLACED
         || result.Retcode == TRADE_RETCODE_DONE_PARTIAL)
      {
         result.Success = true;
         result.Message = "Trade executed successfully.";
         return result;
      }

      result.Success = false;
      result.Message = "Trade request returned non-success retcode=" + retcode_text
                       + ", Description=" + description + ".";
      return result;
   }
};

#endif
