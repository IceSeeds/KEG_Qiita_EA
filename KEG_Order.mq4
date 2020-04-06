#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


#include "Event.mqh"
CEvent         Event;


int i_reason;

int OnInit()
{
   if( i_reason != REASON_CHARTCHANGE  )
   {
      if( !AppWindow.Create( 0, "KEG_Order", 0, 0, 0, 250, 160 ) )
         return( INIT_FAILED );
      if( !AppWindow.Run() )
         return ( INIT_FAILED );
      
      EventSetMillisecondTimer( 900 );
   }


   return( INIT_SUCCEEDED );
}

void OnDeinit( const int reason )
{
   if( reason != REASON_CHARTCHANGE  )
   {
      EventKillTimer();
      AppWindow.Destroy( reason );
   }
   i_reason = reason;
}

void OnTimer()
{
   LineOrder.check();
   
   if( b_check0 )
      LineOrder.getLine( str_lineName0 );
   else if( AppWindow.m_labelPips0.Text() != "" )
      LineOrder.reset( str_lineName0 );
      
   if( b_check1 )
      LineOrder.getLine( str_lineName1 );
   else if( AppWindow.m_labelPips1.Text() != "" )
      LineOrder.reset( str_lineName1 );      
   
   LineOrder.exitCheck();
   

   static int bars_total = Bars;
   if( Bars != bars_total )
   {     
       Alerts.check();
      bars_total = Bars;
   }
}

void OnChartEvent( const int     id,
                   const long    &lparam,
                   const double  &dparam,
                   const string  &sparam )
{
   AppWindow.ChartEvent( id, lparam, dparam, sparam );
   Event.OnEvent(        id, lparam, dparam, sparam );
}
