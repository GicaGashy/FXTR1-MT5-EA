#ifndef FXTR1_CORE_ENGINE_MQH
#define FXTR1_CORE_ENGINE_MQH

#include <FXTR1/Core/MarketDataProvider.mqh>
#include <FXTR1/Core/PositionDataProvider.mqh>
#include <FXTR1/Core/Settings.mqh>
#include <FXTR1/Risk/RiskDecision.mqh>
#include <FXTR1/Risk/RiskEvaluationRequest.mqh>
#include <FXTR1/Risk/RiskManager.mqh>
#include <FXTR1/Strategy/SignalResolver.mqh>
#include <FXTR1/Strategy/StrategyManager.mqh>
#include <FXTR1/Trade/TradeExecutor.mqh>
#include <FXTR1/Utils/Logger.mqh>

class CFXTR1Engine
{
private:
   CFXTR1Logger        m_logger;
   CFXTR1Settings      m_settings;
   CFXTR1MarketDataProvider m_market_data;
   CFXTR1PositionDataProvider m_position_data;
   CFXTR1RiskManager   m_risk_manager;
   CFXTR1StrategyManager m_strategy_manager;
   CFXTR1SignalResolver m_signal_resolver;
   CFXTR1TradeExecutor m_trade_executor;
   bool                m_initialized;

   string BoolText(const bool value) const
   {
      return value ? "true" : "false";
   }

   string TradeDirectionText(const ENUM_FXTR1_TRADE_DIRECTION direction) const
   {
      if(direction == FXTR1_DIRECTION_BUY)
         return "BUY";

      if(direction == FXTR1_DIRECTION_SELL)
         return "SELL";

      return "Unknown";
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
      m_settings.RiskApprovalEnabled = settings.RiskApprovalEnabled;
      m_settings.MaxSpreadPoints = settings.MaxSpreadPoints;
      m_settings.MaxOpenPositions = settings.MaxOpenPositions;
      m_settings.FixedVolume = settings.FixedVolume;
      m_settings.StrategyMode = settings.StrategyMode;
      m_settings.TestSignalEveryTicks = settings.TestSignalEveryTicks;
      m_settings.TestSignalDirection = settings.TestSignalDirection;
      m_settings.TestSignalStopLossPoints = settings.TestSignalStopLossPoints;
      m_settings.TestSignalTakeProfitPoints = settings.TestSignalTakeProfitPoints;

      m_strategy_manager.Configure(settings);
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
      m_logger.Info("Risk approval enabled=" + BoolText(m_settings.RiskApprovalEnabled));
      m_logger.Info("Max open positions=" + IntegerToString(m_settings.MaxOpenPositions));
      m_logger.Info("Fixed volume=" + DoubleToString(m_settings.FixedVolume, 8));
      m_logger.Info("Strategy mode=" + FXTR1StrategyModeToString(m_settings.StrategyMode));
      if(m_settings.StrategyMode == FXTR1_STRATEGY_MODE_TEST_SIGNAL)
      {
         m_logger.Info("Test signal every ticks=" + IntegerToString(m_settings.TestSignalEveryTicks));
         m_logger.Info("Test signal direction=" + TradeDirectionText(m_settings.TestSignalDirection));
         m_logger.Info("Test signal stop loss points=" + IntegerToString(m_settings.TestSignalStopLossPoints));
         m_logger.Info("Test signal take profit points=" + IntegerToString(m_settings.TestSignalTakeProfitPoints));
      }

      if(!m_strategy_manager.Initialize())
      {
         m_logger.Error("Strategy manager initialization failed: " + m_strategy_manager.LastError());
         m_initialized = false;
         return INIT_FAILED;
      }

      m_initialized = true;
      return INIT_SUCCEEDED;
   }

   void OnDeinit(const int reason)
   {
      m_logger.Info("Deinitializing FXTR1 engine, reason=" + IntegerToString(reason));
      m_strategy_manager.Deinitialize();
      m_initialized = false;
   }

   void OnTick()
   {
      if(!m_initialized)
         return;

      CFXTR1MarketSnapshot market = m_market_data.Capture(m_settings);
      if(!market.IsValid)
         return;

      CFXTR1StrategySignal raw_signal = m_strategy_manager.Evaluate(market);
      CFXTR1SignalResolutionResult resolution = m_signal_resolver.Resolve(raw_signal);

      if(!raw_signal.HasSignal())
         return;

      if(!resolution.HasAcceptedSignal())
      {
         m_logger.Info("Signal rejected by resolver: " + resolution.RejectReason);
         return;
      }

      CFXTR1StrategySignal signal = resolution.Signal;

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

      CFXTR1RiskEvaluationRequest risk_request;
      CFXTR1PositionSnapshot positions = m_position_data.Capture(m_settings);
      risk_request.Settings = m_settings;
      risk_request.Market = market;
      risk_request.Positions = positions;
      risk_request.Signal = signal;

      CFXTR1RiskDecision decision = m_risk_manager.Evaluate(risk_request);
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
