
#include "Common/Common.mqh";

#include "Plugin/ExitCurrency.mqh"
#include "Plugin/LineOrder.mqh"

CExitCurrency  ExitCurrency;
CLineOrder     LineOrder;


class CEvent
{
   public:
      bool  OnEvent( const int id, const long lparam, const double dparam, const string sparam );
      
   private:
      bool  btnOrder( const int id, const long lparam, const double dparam, const string sparam );
      bool  order( int i_type, double d_lots );
      bool  combSelect( const int id, const long lparam, const double dparam, const string sparam );
      bool  btnLine( const int id, const long lparam, const double dparam, const string sparam );
   
};

bool CEvent::OnEvent( const int id, const long lparam, const double dparam, const string sparam )
{
   if( !btnOrder( id, lparam, dparam, sparam ) )
      CMD.Error( "btnOrder" );
   if( !combSelect( id, lparam, dparam, sparam ) )
      CMD.Error( "combSelect" );
   if( !btnLine( id, lparam, dparam, sparam ) )
      CMD.Error( "btnLine" );
   
   
   return true;
}

bool CEvent::btnOrder( const int id, const long lparam, const double dparam, const string sparam )
{
   if( id == CHARTEVENT_OBJECT_CLICK )
   {
      if( StringFind( sparam, "btnBuy", 4 ) != -1 )
      {
         if( !order( 0, (double)AppWindow.m_editLots.Text() ) )
            Alert( "Error : " + (string)GetLastError() );
      }else if( StringFind( sparam, "btnSell", 4 ) != -1 )
      {
         if( !order( 1, (double)AppWindow.m_editLots.Text() ) )
            Alert( "Error : " + (string)GetLastError() );
      }
   }
   
   
   return true;
}

bool CEvent::order( int i_type, double d_lots )
{
   
   
   if( OrderSend( Symbol(), i_type, d_lots, Close[0], 0, 0, 0, "GUISample", 999, 0, clrRed ) == -1 )
   {
      CMD.Error( "Order" );
   }else{
      Alert( "OrderSend Success!!\n Lots = " + (string)d_lots + "\n type = " + (string)i_type );
      
      LineOrder.check();
      
      if( b_check0 )
         LineOrder.reCreate( str_lineName0, i_type );
      if( b_check1 )
         LineOrder.reCreate( str_lineName1, i_type );
   }
   
   
   return true;
}

bool CEvent::combSelect( const int id, const long lparam, const double dparam, const string sparam )
{
   if( ( StringFind( sparam, "btnComb", 4 ) != -1 ) && id == CHARTEVENT_OBJECT_CLICK ) 
   {
      switch( (int)AppWindow.m_combCreate.Value() )
      {
         case 0: // to All Exit
            if( !ExitCurrency.exit() )
               CMD.Error( "combSelect : All Exit" );
            break;
         case 1: // to This Exit
            if( !ExitCurrency.exit( Symbol() ) )
               CMD.Error( "combSelect : This Exit" );
            break;
         default:
            Alert( "not select" );
      }
   }
   
   
   return true;
}

bool CEvent::btnLine( const int id, const long lparam, const double dparam, const string sparam )
{
   if( id == 1000 && ( !b_lineCreate0 || !b_lineCreate1 ) ) // 1000ってなに。。。ｗ
   {
      if( StringFind( sparam, "btnLine0", 4 ) != -1 )
         b_lineCreate0 = true;
      if( StringFind( sparam, "btnLine1", 4 ) != -1 )
         b_lineCreate1 = true;   
   }

   if( id == CHARTEVENT_CLICK )
   {
      if( b_lineCreate0 )
         if( !LineOrder.create( str_lineName0, dparam ) )
            CMD.Error( "LineOrder : Create" );
         else
            b_lineCreate0 = false;
      
      if( b_lineCreate1 )
         if( !LineOrder.create( str_lineName1, dparam ) )
            CMD.Error( "LineOrder : Create" );
         else
            b_lineCreate1 = false;
   }
   
   
   return true;
}
