#ifndef FXTR1_UTILS_LOGGER_MQH
#define FXTR1_UTILS_LOGGER_MQH

class CFXTR1Logger
{
private:
   string m_prefix;

public:
   CFXTR1Logger()
   {
      m_prefix = "FXTR1";
   }

   void Info(const string message)
   {
      Print(m_prefix + " INFO: " + message);
   }

   void Error(const string message)
   {
      Print(m_prefix + " ERROR: " + message);
   }
};

#endif
