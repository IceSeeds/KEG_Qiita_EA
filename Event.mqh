
#include "AppWindow.mqh"
#include "Plugin/ExitCurrency.mqh"

CPanelDialog   AppWindow;
CExitCurrency  ExitCurrency;


class CEvent
{
   public:
      bool  OnEvent( const int id, const long lparam, const double dparam, const string sparam );
      
   private:
      bool  btnOrder( const int id, const long lparam, const double dparam, const string sparam );
      bool  Order( int i_type, double d_lots );
      bool  combSelect( const int id, const long lparam, const double dparam, const string sparam );
};

bool CEvent::OnEvent( const int id, const long lparam, const double dparam, const string sparam )
{
   if( !btnOrder( id, lparam, dparam, sparam ) )
      Alert( "Error : " + (string)GetLastError() );
   if( !combSelect( id, lparam, dparam, sparam ) )
      Alert( "Error : " + (string)GetLastError() );   
   
   return true;
}

bool CEvent::btnOrder( const int id, const long lparam, const double dparam, const string sparam )
{
   if( ( StringFind( sparam, "btnBuy", 4 ) != -1 ) && id == CHARTEVENT_OBJECT_CLICK ) 
   {
      if( !Order( 0, (double)AppWindow.m_editLots.Text() ) )
         Alert( "Error : " + (string)GetLastError() );
   }else if( ( StringFind( sparam, "btnSell", 4 ) != -1 ) && id == CHARTEVENT_OBJECT_CLICK ) 
   {
      if( !Order( 1, (double)AppWindow.m_editLots.Text() ) )
         Alert( "Error : " + (string)GetLastError() );
   }
   
   return true;
}

bool CEvent::Order( int i_type, double d_lots )
{
   if( OrderSend( Symbol(), i_type, d_lots, Close[0], 0, 0, 0, "GUISample", 999, 0, clrRed ) == -1 )
      return false;
   else
      Alert( "OrderSend Success!!\n Lots = " + (string)d_lots + "\n type = " + (string)i_type );
   
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
               Alert( "Error : " + (string)GetLastError() );
            break;
         case 1: // to This Exit
            if( !ExitCurrency.exit( Symbol() ) )
               Alert( "Error : " + (string)GetLastError() );
            break;
         default:
            Alert( "not select" );
      }
   }
   
   return true;
}
