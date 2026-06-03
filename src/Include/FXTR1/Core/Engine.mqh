#ifndef FXTR1_CORE_ENGINE_MQH
#define FXTR1_CORE_ENGINE_MQH

#include <FXTR1/Risk/RiskDecision.mqh>
#include <FXTR1/Risk/RiskManager.mqh>
#include <FXTR1/Strategy/NullStrategy.mqh>
#include <FXTR1/Trade/TradeExecutor.mqh>
#include <FXTR1/Utils/Logger.mqh>

class CFXTR1Engine
{
private:
   CFXTR1Logger        m_logger;
   CFXTR1RiskManager   m_risk_manager;
   CFXTR1NullStrategy  m_strategy;
   CFXTR1TradeExecutor m_trade_executor;
   bool                m_initialized;

public:
   CFXTR1Engine()
   {
      m_initialized = false;
   }

   int OnInit()
   {
      m_logger.Info("Initializing FXTR1 engine");

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

      CFXTR1RiskDecision decision = m_risk_manager.EvaluateSignal(signal);
      if(!decision.CanExecute())
      {
         m_logger.Info("Risk rejected signal: " + decision.RejectReason);
         return;
      }

      m_trade_executor.Execute(decision.Request);
   }
};

#endif
