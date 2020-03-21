#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://qiita.com/IceSeed"
#property version   "1.00"
#property strict

#include "Common/Common.mqh"
#include "Event.mqh"

CEvent Event;

int i_reason;

int OnInit()
{
   if( i_reason != REASON_CHARTCHANGE && i_reason != REASON_RECOMPILE )
   {
      if( !AppWindow.Create( 0, "SampleTitle", 0, 0, 0, 250, 120 ) )
         return( INIT_FAILED );
      if( !AppWindow.Run() )
         return ( INIT_FAILED );
      
      EventSetMillisecondTimer( 900 );
   }

   return( INIT_SUCCEEDED );
}

void OnDeinit( const int reason )
{
   if( reason != REASON_CHARTCHANGE && reason != REASON_RECOMPILE )
   {
      EventKillTimer();
      AppWindow.Destroy( reason );
   }
   i_reason = reason;
}

void OnTimer()
{
   // あとで使う
}

void OnChartEvent( const int     id,
                   const long    &lparam,
                   const double  &dparam,
                   const string  &sparam )
{
   AppWindow.ChartEvent( id, lparam, dparam, sparam );
   Event.OnEvent( id, lparam, dparam, sparam );
   
   //Alert( "id = " + id + " \nlparam = " + lparam + " \ndparam = " + dparam + " \nsparam = " + sparam );
}
