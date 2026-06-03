#ifndef FXTR1_RISK_TRADEMODEVALIDATOR_MQH
#define FXTR1_RISK_TRADEMODEVALIDATOR_MQH

#include <FXTR1/Risk/RiskEvaluationRequest.mqh>
#include <FXTR1/Risk/RiskCheckResult.mqh>
#include <FXTR1/Core/TradeDirection.mqh>
#include <FXTR1/Core/SignalType.mqh>

class CFXTR1TradeModeValidator
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
         result.Fail("Only entry signals are supported by trade mode validation.");
         return result;
      }

      if(request.Signal.Direction != FXTR1_DIRECTION_BUY
         && request.Signal.Direction != FXTR1_DIRECTION_SELL)
      {
         result.Fail("Invalid trade direction.");
         return result;
      }

      long trade_mode = request.Market.TradeMode;

      if(trade_mode == SYMBOL_TRADE_MODE_DISABLED)
      {
         result.Fail("Symbol trading is disabled.");
         return result;
      }

      if(trade_mode == SYMBOL_TRADE_MODE_CLOSEONLY)
      {
         result.Fail("Symbol is close-only.");
         return result;
      }

      if(trade_mode == SYMBOL_TRADE_MODE_LONGONLY)
      {
         if(request.Signal.Direction == FXTR1_DIRECTION_BUY)
         {
            result.Pass("Symbol trade mode allows this direction.");
            return result;
         }

         result.Fail("Symbol allows long positions only.");
         return result;
      }

      if(trade_mode == SYMBOL_TRADE_MODE_SHORTONLY)
      {
         if(request.Signal.Direction == FXTR1_DIRECTION_SELL)
         {
            result.Pass("Symbol trade mode allows this direction.");
            return result;
         }

         result.Fail("Symbol allows short positions only.");
         return result;
      }

      if(trade_mode == SYMBOL_TRADE_MODE_FULL)
      {
         result.Pass("Symbol trade mode allows this direction.");
         return result;
      }

      result.Fail("Unsupported symbol trade mode: " + IntegerToString((int)trade_mode) + ".");
      return result;
   }
};

#endif
