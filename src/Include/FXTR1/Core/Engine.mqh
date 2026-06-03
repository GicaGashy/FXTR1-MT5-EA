#ifndef FXTR1_CORE_ENGINE_MQH
#define FXTR1_CORE_ENGINE_MQH

#include <FXTR1/Core/Settings.mqh>
#include <FXTR1/Risk/RiskDecision.mqh>
#include <FXTR1/Risk/RiskManager.mqh>
#include <FXTR1/Strategy/NullStrategy.mqh>
#include <FXTR1/Trade/TradeExecutor.mqh>
#include <FXTR1/Utils/Logger.mqh>

class CFXTR1Engine
{
private:
   CFXTR1Logger        m_logger;
   CFXTR1Settings      m_settings;
   CFXTR1RiskManager   m_risk_manager;
   CFXTR1NullStrategy  m_strategy;
   CFXTR1TradeExecutor m_trade_executor;
   bool                m_initialized;

   string BoolText(const bool value) const
   {
      return value ? "true" : "false";
   }

public:
   CFXTR1Engine()
   {
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
      m_settings.MaxSpreadPoints = settings.MaxSpreadPoints;
      m_settings.StrategyMode = settings.StrategyMode;
   }

   int OnInit()
   {
      m_logger.Info("Initializing FXTR1 engine");
      m_logger.Info("Expert name=" + m_settings.ExpertName);
      m_logger.Info("Symbol=" + m_settings.Symbol);
      m_logger.Info("Timeframe=" + EnumToString(m_settings.Timeframe));
      m_logger.Info("Magic number=" + StringFormat("%I64u", m_settings.MagicNumber));
      m_logger.Info("Trading enabled=" + BoolText(m_settings.TradingEnabled));
      m_logger.Info("Allow new entries=" + BoolText(m_settings.AllowNewEntries));
      m_logger.Info("Strategy mode=" + FXTR1StrategyModeToString(m_settings.StrategyMode));

      if(m_settings.StrategyMode != FXTR1_STRATEGY_MODE_NULL)
      {
         m_logger.Error("Unsupported strategy mode: " + FXTR1StrategyModeToString(m_settings.StrategyMode));
         m_initialized = false;
         return INIT_FAILED;
      }

      if(!m_strategy.Initialize())
      {
         m_logger.Error("Strategy initialization failed");
         m_initialized = false;
         return INIT_FAILED;
      }

      m_initialized = true;
      return INIT_SUCCEEDED;
   }

   void OnDeinit(const int reason)
   {
      m_logger.Info("Deinitializing FXTR1 engine, reason=" + IntegerToString(reason));
      m_strategy.Deinitialize();
      m_initialized = false;
   }

   void OnTick()
   {
      if(!m_initialized)
         return;

      CFXTR1StrategySignal signal = m_strategy.Evaluate();
      if(!signal.HasSignal())
         return;

      if(!m_settings.CanOpenNewTrades())
      {
         m_logger.Info("New trade blocked by runtime settings: trading_enabled="
                       + BoolText(m_settings.TradingEnabled)
                       + ", allow_new_entries="
                       + BoolText(m_settings.AllowNewEntries)
                       + ", symbol="
                       + m_settings.Symbol);
         return;
      }

      CFXTR1RiskDecision decision = m_risk_manager.EvaluateSignal(signal);
      if(!decision.CanExecute())
      {
         m_logger.Info("Risk rejected signal: " + decision.RejectReason);
         return;
      }

      CFXTR1ExecutionResult execution_result = m_trade_executor.Execute(decision.Request);
      if(!execution_result.IsSuccess())
         m_logger.Error("Trade execution failed: " + execution_result.Message);
   }
};

#endif
