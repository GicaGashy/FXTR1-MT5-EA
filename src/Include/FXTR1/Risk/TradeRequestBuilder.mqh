#ifndef FXTR1_RISK_TRADEREQUESTBUILDER_MQH
#define FXTR1_RISK_TRADEREQUESTBUILDER_MQH

#include <FXTR1/Risk/RiskEvaluationRequest.mqh>
#include <FXTR1/Risk/TradeRequestBuildResult.mqh>
#include <FXTR1/Core/TradeRequest.mqh>
#include <FXTR1/Core/TradeDirection.mqh>
#include <FXTR1/Core/SignalType.mqh>

class CFXTR1TradeRequestBuilder
{
public:
   CFXTR1TradeRequestBuildResult Build(const CFXTR1RiskEvaluationRequest &request,
                                       const double volume)
   {
      CFXTR1TradeRequestBuildResult result;

      if(!request.HasSignal())
      {
         result.Fail("No strategy signal.");
         return result;
      }

      if(!request.HasValidMarket())
      {
         result.Fail("Invalid market snapshot.");
         return result;
      }

      if(!request.Settings.HasValidSymbol())
      {
         result.Fail("Invalid settings symbol.");
         return result;
      }

      if(request.Signal.Type != FXTR1_SIGNAL_ENTRY)
      {
         result.Fail("Only entry signals can build trade requests.");
         return result;
      }

      if(request.Signal.Direction != FXTR1_DIRECTION_BUY
         && request.Signal.Direction != FXTR1_DIRECTION_SELL)
      {
         result.Fail("Invalid trade direction.");
         return result;
      }

      if(volume <= 0.0)
      {
         result.Fail("Trade request volume must be greater than zero.");
         return result;
      }

      if(request.Signal.StopLoss <= 0.0)
      {
         result.Fail("Trade request requires a stop loss.");
         return result;
      }

      double entry_price = request.Signal.EntryPrice;
      if(entry_price <= 0.0)
      {
         if(request.Signal.Direction == FXTR1_DIRECTION_BUY)
            entry_price = request.Market.Ask;
         else
            entry_price = request.Market.Bid;
      }

      if(entry_price <= 0.0)
      {
         result.Fail("Invalid trade request entry price.");
         return result;
      }

      CFXTR1TradeRequest trade_request;
      trade_request.IsValid = true;
      trade_request.Direction = request.Signal.Direction;
      trade_request.Volume = volume;
      trade_request.EntryPrice = entry_price;
      trade_request.StopLoss = request.Signal.StopLoss;
      trade_request.TakeProfit = request.Signal.TakeProfit;
      trade_request.Symbol = request.Settings.Symbol;
      trade_request.Reason = request.Signal.Reason;

      if(!trade_request.CanExecute())
      {
         result.Fail("Built trade request is not executable.");
         return result;
      }

      result.Pass(trade_request, "Trade request built successfully.");
      return result;
   }
};

#endif
