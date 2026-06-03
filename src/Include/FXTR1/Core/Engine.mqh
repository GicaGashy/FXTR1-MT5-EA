#ifndef FXTR1_CORE_ENGINE_MQH
#define FXTR1_CORE_ENGINE_MQH

#include <FXTR1/Risk/RiskManager.mqh>
#include <FXTR1/Strategy/IStrategy.mqh>
#include <FXTR1/Trade/TradeExecutor.mqh>
#include <FXTR1/Utils/Logger.mqh>

class CFXTR1Engine
{
private:
   CFXTR1Logger        m_logger;
   CFXTR1RiskManager   m_risk_manager;
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
      m_initialized = true;
      return INIT_SUCCEEDED;
   }

   void OnDeinit(const int reason)
   {
      m_logger.Info("Deinitializing FXTR1 engine, reason=" + IntegerToString(reason));
      m_initialized = false;
   }

   void OnTick()
   {
      if(!m_initialized)
         return;

      // Strategy, risk, and execution flow will be added in future tasks.
   }
};

#endif
