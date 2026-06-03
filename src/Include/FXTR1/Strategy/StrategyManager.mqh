#ifndef FXTR1_STRATEGY_STRATEGYMANAGER_MQH
#define FXTR1_STRATEGY_STRATEGYMANAGER_MQH

#include <FXTR1/Core/Settings.mqh>
#include <FXTR1/Strategy/StrategyMode.mqh>
#include <FXTR1/Strategy/NullStrategy.mqh>
#include <FXTR1/Core/StrategySignal.mqh>

class CFXTR1StrategyManager
{
private:
   CFXTR1Settings     m_settings;
   CFXTR1NullStrategy m_null_strategy;
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
      m_settings.MaxSpreadPoints = settings.MaxSpreadPoints;
      m_settings.StrategyMode = settings.StrategyMode;
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

      m_initialized = false;
      m_last_error = "Unsupported strategy mode.";
      return false;
   }

   void Deinitialize()
   {
      if(m_settings.StrategyMode == FXTR1_STRATEGY_MODE_NULL)
         m_null_strategy.Deinitialize();

      m_initialized = false;
   }

   CFXTR1StrategySignal Evaluate()
   {
      CFXTR1StrategySignal signal;

      if(!m_initialized)
         return signal;

      if(m_settings.StrategyMode == FXTR1_STRATEGY_MODE_NULL)
         return m_null_strategy.Evaluate();

      return signal;
   }

   string ActiveStrategyName() const
   {
      if(m_settings.StrategyMode == FXTR1_STRATEGY_MODE_NULL)
         return "Null";

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
