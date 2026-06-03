#ifndef FXTR1_STRATEGY_STRATEGYMODE_MQH
#define FXTR1_STRATEGY_STRATEGYMODE_MQH

enum ENUM_FXTR1_STRATEGY_MODE
{
   FXTR1_STRATEGY_MODE_NULL = 0
};

string FXTR1StrategyModeToString(const ENUM_FXTR1_STRATEGY_MODE mode)
{
   switch(mode)
   {
      case FXTR1_STRATEGY_MODE_NULL:
         return "Null";
      default:
         return "Unknown";
   }
}

#endif
