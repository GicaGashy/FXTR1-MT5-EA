#ifndef FXTR1_STRATEGY_STRATEGYMANAGER_MQH
#define FXTR1_STRATEGY_STRATEGYMANAGER_MQH

#include <FXTR1/Core/MarketSnapshot.mqh>
#include <FXTR1/Core/Settings.mqh>
#include <FXTR1/Strategy/StrategyMode.mqh>
#include <FXTR1/Strategy/NullStrategy.mqh>
#include <FXTR1/Strategy/TestSignalStrategy.mqh>
#include <FXTR1/Core/StrategySignal.mqh>

class CFXTR1StrategyManager
{
private:
   CFXTR1Settings     m_settings;
   CFXTR1NullStrategy m_null_strategy;
   CFXTR1TestSignalStrategy m_test_signal_strategy;
   bool               m_initialized;
   string             m_last_error;

public:
   CFXTR1StrategyManager()
   {
      m_initialized = false;
      m_last_error = "";
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
      m_settings.ExecutionEnabled = settings.ExecutionEnabled;
      m_settings.MaxSpreadPoints = settings.MaxSpreadPoints;
      m_settings.MaxOpenPositions = settings.MaxOpenPositions;
      m_settings.DeviationPoints = settings.DeviationPoints;
      m_settings.FixedVolume = settings.FixedVolume;
      m_settings.StrategyMode = settings.StrategyMode;
      m_settings.TestSignalEveryTicks = settings.TestSignalEveryTicks;
      m_settings.TestSignalDirection = settings.TestSignalDirection;
      m_settings.TestSignalStopLossPoints = settings.TestSignalStopLossPoints;
      m_settings.TestSignalTakeProfitPoints = settings.TestSignalTakeProfitPoints;

      m_test_signal_strategy.Configure(settings);
   }

   bool Initialize()
   {
      m_last_error = "";

      if(m_settings.StrategyMode == FXTR1_STRATEGY_MODE_NULL)
      {
         const bool result = m_null_strategy.Initialize();
         m_initialized = result;

         if(!result)
            m_last_error = "NullStrategy initialization failed.";

         return result;
      }

      if(m_settings.StrategyMode == FXTR1_STRATEGY_MODE_TEST_SIGNAL)
      {
         const bool result = m_test_signal_strategy.Initialize();
         m_initialized = result;

         if(!result)
            m_last_error = "TestSignalStrategy initialization failed.";

         return result;
      }

      m_initialized = false;
      m_last_error = "Unsupported strategy mode.";
      return false;
   }

   void Deinitialize()
   {
      if(m_settings.StrategyMode == FXTR1_STRATEGY_MODE_NULL)
         m_null_strategy.Deinitialize();
      else if(m_settings.StrategyMode == FXTR1_STRATEGY_MODE_TEST_SIGNAL)
         m_test_signal_strategy.Deinitialize();

      m_initialized = false;
   }

   CFXTR1StrategySignal Evaluate(const CFXTR1MarketSnapshot &market)
   {
      CFXTR1StrategySignal signal;

      if(!m_initialized)
         return signal;

      if(m_settings.StrategyMode == FXTR1_STRATEGY_MODE_NULL)
         return m_null_strategy.Evaluate(market);

      if(m_settings.StrategyMode == FXTR1_STRATEGY_MODE_TEST_SIGNAL)
         return m_test_signal_strategy.Evaluate(market);

      return signal;
   }

   string ActiveStrategyName() const
   {
      if(m_settings.StrategyMode == FXTR1_STRATEGY_MODE_NULL)
         return "Null";

      if(m_settings.StrategyMode == FXTR1_STRATEGY_MODE_TEST_SIGNAL)
         return "TestSignal";

      return "Unknown";
   }

   string LastError() const
   {
      return m_last_error;
   }

   bool IsInitialized() const
   {
      return m_initialized;
   }
};

#endif
