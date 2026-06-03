#ifndef FXTR1_RISK_POSITIONSIZERESULT_MQH
#define FXTR1_RISK_POSITIONSIZERESULT_MQH

class CFXTR1PositionSizeResult
{
public:
   bool   Success;
   double Volume;
   string Message;

   CFXTR1PositionSizeResult()
   {
      Clear();
   }

   void Clear()
   {
      Success = false;
      Volume = 0.0;
      Message = "";
   }

   void Pass(const double volume, const string message)
   {
      Success = true;
      Volume = volume;
      Message = message;
   }

   void Fail(const string message)
   {
      Success = false;
      Volume = 0.0;
      Message = message;
   }

   bool IsSuccess() const
   {
      return Success;
   }
};

#endif
