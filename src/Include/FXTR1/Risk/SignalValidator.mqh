#ifndef FXTR1_RISK_SIGNALVALIDATOR_MQH
#define FXTR1_RISK_SIGNALVALIDATOR_MQH

#include <FXTR1/Risk/RiskEvaluationRequest.mqh>
#include <FXTR1/Risk/RiskCheckResult.mqh>
#include <FXTR1/Core/TradeDirection.mqh>
#include <FXTR1/Core/SignalType.mqh>

class CFXTR1SignalValidator
{
public:
   CFXTR1RiskCheckResult Check(const CFXTR1RiskEvaluationRequest &request)
   {
      CFXTR1RiskCheckResult result;

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

      if(request.Signal.Type != FXTR1_SIGNAL_ENTRY)
      {
         result.Fail("Only entry signals are supported by risk evaluation.");
         return result;
      }

      if(request.Signal.Direction != FXTR1_DIRECTION_BUY
         && request.Signal.Direction != FXTR1_DIRECTION_SELL)
      {
         result.Fail("Invalid trade direction.");
         return result;
      }

      if(request.Signal.StopLoss <= 0.0)
      {
         result.Fail("Entry signal must define a stop loss.");
         return result;
      }

      double reference_entry_price = request.Signal.EntryPrice;
      if(reference_entry_price <= 0.0)
      {
         if(request.Signal.Direction == FXTR1_DIRECTION_BUY)
            reference_entry_price = request.Market.Ask;
         else
            reference_entry_price = request.Market.Bid;
      }

      if(reference_entry_price <= 0.0)
      {
         result.Fail("Invalid entry reference price.");
         return result;
      }

      if(request.Signal.Direction == FXTR1_DIRECTION_BUY)
      {
         if(request.Signal.StopLoss >= reference_entry_price)
         {
            result.Fail("Buy stop loss must be below entry reference price.");
            return result;
         }

         if(request.Signal.TakeProfit > 0.0
            && request.Signal.TakeProfit <= reference_entry_price)
         {
            result.Fail("Buy take profit must be above entry reference price.");
            return result;
         }
      }
      else
      {
         if(request.Signal.StopLoss <= reference_entry_price)
         {
            result.Fail("Sell stop loss must be above entry reference price.");
            return result;
         }

         if(request.Signal.TakeProfit > 0.0
            && request.Signal.TakeProfit >= reference_entry_price)
         {
            result.Fail("Sell take profit must be below entry reference price.");
            return result;
         }
      }

      result.Pass("Signal structure is valid.");
      return result;
   }
};

#endif
