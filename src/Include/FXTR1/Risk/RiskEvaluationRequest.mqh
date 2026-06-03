#ifndef FXTR1_RISK_RISKEVALUATIONREQUEST_MQH
#define FXTR1_RISK_RISKEVALUATIONREQUEST_MQH

#include <FXTR1/Core/Settings.mqh>
#include <FXTR1/Core/MarketSnapshot.mqh>
#include <FXTR1/Core/PositionSnapshot.mqh>
#include <FXTR1/Core/StrategySignal.mqh>

class CFXTR1RiskEvaluationRequest
{
public:
   CFXTR1Settings       Settings;
   CFXTR1MarketSnapshot Market;
   CFXTR1PositionSnapshot Positions;
   CFXTR1StrategySignal Signal;

   CFXTR1RiskEvaluationRequest()
   {
      Clear();
   }

   void Clear()
   {
      Settings.Clear();
      Market.Clear();
      Positions.Clear();
      Signal.Clear();
   }

   bool HasSignal() const
   {
      return Signal.HasSignal();
   }

   bool HasValidMarket() const
   {
      return Market.IsValid;
   }

   bool HasValidPositions() const
   {
      return Positions.IsValid;
   }

   bool CanEvaluate() const
   {
      return HasSignal()
             && HasValidMarket()
             && Settings.HasValidSymbol();
   }
};

#endif
