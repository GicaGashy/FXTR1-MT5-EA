#ifndef FXTR1_RISK_STOPDISTANCEVALIDATOR_MQH
#define FXTR1_RISK_STOPDISTANCEVALIDATOR_MQH

#include <FXTR1/Risk/RiskEvaluationRequest.mqh>
#include <FXTR1/Risk/RiskCheckResult.mqh>
#include <FXTR1/Core/TradeDirection.mqh>
#include <FXTR1/Core/SignalType.mqh>

class CFXTR1StopDistanceValidator
{
private:
   string DistanceMessage(const string label, const double distance_points, const int min_stop_points) const
   {
      return label
             + " Distance="
             + DoubleToString(distance_points, 1)
             + ", Min="
             + IntegerToString(min_stop_points)
             + ".";
   }

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

      if(request.Market.Point <= 0.0)
      {
         result.Fail("Invalid point size.");
         return result;
      }

      if(!request.Market.HasValidStopConstraints())
      {
         result.Fail("Invalid stop constraint data.");
         return result;
      }

      if(request.Signal.Type != FXTR1_SIGNAL_ENTRY)
      {
         result.Fail("Only entry signals are supported by stop-distance validation.");
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

      int min_stop_points = request.Market.StopsLevelPoints;
      if(min_stop_points <= 0)
      {
         result.Pass("No minimum stop distance required.");
         return result;
      }

      double distance_points = 0.0;

      if(request.Signal.Direction == FXTR1_DIRECTION_BUY)
      {
         if(request.Signal.StopLoss >= request.Market.Bid)
         {
            result.Fail("Buy stop loss is not below Bid.");
            return result;
         }

         distance_points = (request.Market.Bid - request.Signal.StopLoss) / request.Market.Point;
         if(distance_points < min_stop_points)
         {
            result.Fail(DistanceMessage("Stop loss is too close.", distance_points, min_stop_points));
            return result;
         }

         if(request.Signal.TakeProfit > 0.0)
         {
            if(request.Signal.TakeProfit <= request.Market.Bid)
            {
               result.Fail("Buy take profit is not above Bid.");
               return result;
            }

            distance_points = (request.Signal.TakeProfit - request.Market.Bid) / request.Market.Point;
            if(distance_points < min_stop_points)
            {
               result.Fail(DistanceMessage("Take profit is too close.", distance_points, min_stop_points));
               return result;
            }
         }
      }
      else
      {
         if(request.Signal.StopLoss <= request.Market.Ask)
         {
            result.Fail("Sell stop loss is not above Ask.");
            return result;
         }

         distance_points = (request.Signal.StopLoss - request.Market.Ask) / request.Market.Point;
         if(distance_points < min_stop_points)
         {
            result.Fail(DistanceMessage("Stop loss is too close.", distance_points, min_stop_points));
            return result;
         }

         if(request.Signal.TakeProfit > 0.0)
         {
            if(request.Signal.TakeProfit >= request.Market.Ask)
            {
               result.Fail("Sell take profit is not below Ask.");
               return result;
            }

            distance_points = (request.Market.Ask - request.Signal.TakeProfit) / request.Market.Point;
            if(distance_points < min_stop_points)
            {
               result.Fail(DistanceMessage("Take profit is too close.", distance_points, min_stop_points));
               return result;
            }
         }
      }

      result.Pass("Stop distances are valid.");
      return result;
   }
};

#endif
