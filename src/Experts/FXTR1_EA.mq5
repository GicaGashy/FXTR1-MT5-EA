#property copyright "FXTR1"
#property link      ""
#property version   "0.01"
#property strict

#include <FXTR1/Core/Engine.mqh>

CFXTR1Engine g_engine;

int OnInit()
{
   return g_engine.OnInit();
}

void OnDeinit(const int reason)
{
   g_engine.OnDeinit(reason);
}

void OnTick()
{
   g_engine.OnTick();
}
