#ifndef FXTR1_RISK_RISKMANAGER_MQH
#define FXTR1_RISK_RISKMANAGER_MQH

#include <FXTR1/Risk/FixedVolumeSizer.mqh>
#include <FXTR1/Risk/RiskDecision.mqh>
#include <FXTR1/Risk/RiskEvaluationRequest.mqh>
#include <FXTR1/Risk/SignalValidator.mqh>
#include <FXTR1/Risk/StopDistanceValidator.mqh>
#include <FXTR1/Risk/SpreadFilter.mqh>
#include <FXTR1/Risk/TradeModeValidator.mqh>
#include <FXTR1/Risk/TradeRequestBuilder.mqh>
#include <FXTR1/Risk/TradeRequestBuildResult.mqh>

class CFXTR1RiskManager
{
private:
   CFXTR1SignalValidator m_signal_validator;
   CFXTR1TradeModeValidator m_trade_mode_validator;
   CFXTR1StopDistanceValidator m_stop_distance_validator;
   CFXTR1SpreadFilter m_spread_filter;
   CFXTR1FixedVolumeSizer m_fixed_volume_sizer;
   CFXTR1TradeRequestBuilder m_trade_request_builder;

public:
   CFXTR1RiskManager()
   {
   }

   bool IsTradeAllowed()
   {
      // No real risk model is implemented yet.
      return false;
   }

   CFXTR1RiskDecision Evaluate(const CFXTR1RiskEvaluationRequest &request)
   {
      CFXTR1RiskDecision decision;

      if(!request.HasSignal())
      {
         decision.RejectReason = "No strategy signal.";
         return decision;
      }

      if(!request.HasValidMarket())
      {
         decision.RejectReason = "Invalid market snapshot.";
         return decision;
      }

      if(!request.Settings.HasValidSymbol())
      {
         decision.RejectReason = "Invalid settings symbol.";
         return decision;
      }

      CFXTR1RiskCheckResult signal_check = m_signal_validator.Check(request);
      if(!signal_check.IsPassed())
      {
         decision.RejectReason = signal_check.Message;
         return decision;
      }

      CFXTR1RiskCheckResult trade_mode_check = m_trade_mode_validator.Check(request);
      if(!trade_mode_check.IsPassed())
      {
         decision.RejectReason = trade_mode_check.Message;
         return decision;
      }

      CFXTR1RiskCheckResult stop_distance_check = m_stop_distance_validator.Check(request);
      if(!stop_distance_check.IsPassed())
      {
         decision.RejectReason = stop_distance_check.Message;
         return decision;
      }

      CFXTR1RiskCheckResult spread_check = m_spread_filter.Check(request);
      if(!spread_check.IsPassed())
      {
         decision.RejectReason = spread_check.Message;
         return decision;
      }

      CFXTR1PositionSizeResult size_result = m_fixed_volume_sizer.Calculate(request);
      if(!size_result.IsSuccess())
      {
         decision.RejectReason = size_result.Message;
         return decision;
      }

      CFXTR1TradeRequestBuildResult build_result = m_trade_request_builder.Build(request, size_result.Volume);
      if(!build_result.IsSuccess())
      {
         decision.RejectReason = build_result.Message;
         return decision;
      }

      decision.Request = build_result.Request;
      decision.Approved = false;
      decision.RejectReason = "Trade approval is not implemented yet.";

      return decision;
   }
};

#endif
