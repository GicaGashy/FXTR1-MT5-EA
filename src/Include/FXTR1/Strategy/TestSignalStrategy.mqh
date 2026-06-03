#ifndef FXTR1_STRATEGY_TESTSIGNALSTRATEGY_MQH
#define FXTR1_STRATEGY_TESTSIGNALSTRATEGY_MQH

#include <FXTR1/Strategy/IStrategy.mqh>
#include <FXTR1/Core/Settings.mqh>
#include <FXTR1/Core/MarketSnapshot.mqh>
#include <FXTR1/Core/StrategySignal.mqh>
#include <FXTR1/Core/TradeDirection.mqh>
#include <FXTR1/Core/SignalType.mqh>

class CFXTR1TestSignalStrategy : public IFXTR1Strategy
{
private:
   CFXTR1Settings m_settings;
   int            m_tick_counter;
   bool           m_initialized;

public:
   CFXTR1TestSignalStrategy()
   {
      m_tick_counter = 0;
      m_initialized = false;
   }

   void Configure(const CFXTR1Settings &settings)
   {
      m_settings.ExpertName = settings.ExpertName;
      m_settings.Symbol = settings.Symbol;
      m_settings.Timeframe = settings.Timeframe;
      m_settings.MagicNumber = settings.MagicNumber;
      m_settings.TradingEnabled = settings.TradingEnabled;
      m_settings.AllowNewEntries = settings.AllowNewEntries;
      m_settings.RiskApprovalEnabled = settings.RiskApprovalEnabled;
      m_settings.MaxSpreadPoints = settings.MaxSpreadPoints;
      m_settings.MaxOpenPositions = settings.MaxOpenPositions;
      m_settings.FixedVolume = settings.FixedVolume;
      m_settings.StrategyMode = settings.StrategyMode;
      m_settings.TestSignalEveryTicks = settings.TestSignalEveryTicks;
      m_settings.TestSignalDirection = settings.TestSignalDirection;
      m_settings.TestSignalStopLossPoints = settings.TestSignalStopLossPoints;
      m_settings.TestSignalTakeProfitPoints = settings.TestSignalTakeProfitPoints;
   }

   bool Initialize()
   {
      m_tick_counter = 0;
      m_initialized = true;
      return true;
   }

   void Deinitialize()
   {
      m_initialized = false;
      m_tick_counter = 0;
   }

   CFXTR1StrategySignal Evaluate(const CFXTR1MarketSnapshot &market)
   {
      CFXTR1StrategySignal signal;

      if(!m_initialized)
         return signal;

      if(!market.IsValid)
         return signal;

      if(market.Point <= 0.0)
         return signal;

      if(m_settings.TestSignalEveryTicks <= 0)
         return signal;

      if(m_settings.TestSignalDirection != FXTR1_DIRECTION_BUY
         && m_settings.TestSignalDirection != FXTR1_DIRECTION_SELL)
         return signal;

      if(m_settings.TestSignalStopLossPoints <= 0)
         return signal;

      m_tick_counter++;
      if(m_tick_counter < m_settings.TestSignalEveryTicks)
         return signal;

      m_tick_counter = 0;

      signal.Type = FXTR1_SIGNAL_ENTRY;
      signal.Direction = m_settings.TestSignalDirection;
      signal.Reason = "Test signal generated for pipeline validation.";

      if(signal.Direction == FXTR1_DIRECTION_BUY)
      {
         signal.EntryPrice = market.Ask;
         signal.StopLoss = market.Bid - m_settings.TestSignalStopLossPoints * market.Point;
         if(m_settings.TestSignalTakeProfitPoints > 0)
            signal.TakeProfit = market.Bid + m_settings.TestSignalTakeProfitPoints * market.Point;
         else
            signal.TakeProfit = 0.0;
      }
      else
      {
         signal.EntryPrice = market.Bid;
         signal.StopLoss = market.Ask + m_settings.TestSignalStopLossPoints * market.Point;
         if(m_settings.TestSignalTakeProfitPoints > 0)
            signal.TakeProfit = market.Ask - m_settings.TestSignalTakeProfitPoints * market.Point;
         else
            signal.TakeProfit = 0.0;
      }

      return signal;
   }
};

#endif
