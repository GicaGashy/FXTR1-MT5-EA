#ifndef FXTR1_STRATEGY_ISTRATEGY_MQH
#define FXTR1_STRATEGY_ISTRATEGY_MQH

class IFXTR1Strategy
{
public:
   virtual bool Initialize()
   {
      return true;
   }

   virtual void Deinitialize()
   {
   }

   virtual void OnTick()
   {
   }
};

#endif
