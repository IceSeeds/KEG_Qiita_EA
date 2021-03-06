
#include "../Common/Common.mqh"

class CLineOrder
{
   public:
      bool  check();
      bool  exitCheck();
      bool  getLine( string str_lineName );
      
      bool  create( string str_name, double d_param );
      bool  reCreate( string str_name, int i_type );
      
      bool  reset( string str_lineName );
  private:
      bool  exit( int i_ticket );
};


bool CLineOrder::check()
{
   if( ObjectFind( ChartID(), str_lineName0 ) != -1 )
      b_check0 = true;
   else
      b_check0 = false;

   if( ObjectFind( ChartID(), str_lineName1 ) != -1 )
      b_check1 = true;
   else
      b_check1 = false;


   return true;
}
bool  CLineOrder::reset( string str_lineName )
{
   if( str_lineName == str_lineName0 )
   {
      AppWindow.m_labelPips0.Text( "" );
      AppWindow.m_labelProfit0.Text( "" );
   }else if( str_lineName == str_lineName1 ) 
   {
      AppWindow.m_labelPips1.Text( "" );
      AppWindow.m_labelProfit1.Text( "" );
   }
   
   
   return true;
}

bool CLineOrder::create( string str_name, double d_param )
{
   int      i_sub;
   datetime dt_x;
   double   d_y;
   ChartXYToTimePrice( ChartID(), 0, (int)d_param, i_sub, dt_x, d_y );
   
   if( !ObjectCreate( str_name, OBJ_HLINE, 0, Time[0], NormalizeDouble( d_y, Digits() ) ) ) 
      return false;
   ObjectSet( str_name, OBJPROP_STYLE, STYLE_DASHDOTDOT );
   ObjectSet( str_name, OBJPROP_COLOR, clrRed );
   ObjectSet( str_name, OBJPROP_HIDDEN, true );
   ObjectSet( str_name, OBJPROP_SELECTED, true );
   
   
   return true;
}
bool CLineOrder::reCreate( string str_name, int i_type )
{
   double d_line = ObjectGet( str_name, OBJPROP_PRICE1 );
   ObjectDelete( ChartID(), str_name );
   
   string   str_type;
   color    c_line;
   
   if( i_type == 0 )
   {
      if( d_line > Close[0] )
      {
         str_type = "LongProfit";
         c_line = clrRoyalBlue;
      }else{
         str_type = "LongLoss";
         c_line = clrDeepPink;
      }
   }else{
      if( d_line < Close[0] )
      {
         str_type = "SellProfit";
         c_line = clrRoyalBlue;
      }else{
         str_type = "SellLoss";
         c_line = clrDeepPink;
      }
   }
   
   if( !OrderSelect( OrdersTotal() - 1, SELECT_BY_POS, MODE_TRADES ) )
   {
      return false;
   }else{
      string str_exName = "KEG_" + Symbol() + "_" + (string)OrderTicket() + "_" + str_type;
      if( !ObjectCreate( ChartID(), str_exName, OBJ_HLINE, 0, 0, d_line ) ) 
         return false;
      ObjectSet( str_exName, OBJPROP_WIDTH, 2 );
      ObjectSet( str_exName, OBJPROP_COLOR, c_line );
      ObjectSet( str_exName, OBJPROP_HIDDEN, true );
      ObjectSet( str_exName, OBJPROP_SELECTED, true );
   }
   
   
   return true;
}

bool CLineOrder::getLine( string str_lineName )
{
   double DigitsValue = MathPow( 10, Digits() - 1 );
   
   double d_line     = ObjectGet( str_lineName, OBJPROP_PRICE1 );
   double d_pips     = ( d_line - Close[0] ) * DigitsValue;
   double d_profit   = ( d_pips * (double)AppWindow.m_editLots.Text() ) * 1000;
   
   if( str_lineName == str_lineName0 )
   {
      AppWindow.m_labelPips0.Text( DoubleToString( d_pips, 0 ) + " pips" );
      AppWindow.m_labelProfit0.Text( DoubleToString( d_profit, 0 ) + " yen" );
   }else if( str_lineName == str_lineName1 ) 
   {
      AppWindow.m_labelPips1.Text( DoubleToString( d_pips, 0 ) + " pips" );
      AppWindow.m_labelProfit1.Text( DoubleToString( d_profit, 0 ) + " yen" );
   }


   return true;
}

bool CLineOrder::exitCheck()
{
   string objGet[];
   
   if( ObjectsTotal() >= 1 )
   {
      for( int i = 0; i < ObjectsTotal(); i++ )
      {
         if( StringSplit( ObjectName( i ), '_', objGet ) != 0 && objGet[0] == "KEG" )
         {
            double objPrice = NormalizeDouble( ObjectGet( ObjectName( i ), OBJPROP_PRICE1 ), Digits() );
            
            if( ( objGet[3] == "LongLoss" && objPrice >= Close[ 0 ] ) || ( objGet[3] == "LongProfit" && objPrice <= Close[ 0 ] ) || 
                ( objGet[3] == "SellLoss" && objPrice <= Close[ 0 ] ) || ( objGet[3] == "SellProfit" && objPrice >= Close[ 0 ] ) )
            {
               if( !exit( (int)objGet[2] ) ) return false;
               ObjectsDeleteAll( ChartID(), objGet[0] + "_" + objGet[1] + "_" + objGet[2] ); 
            }
         }
      }
   }
   
   
   return true;
}
bool CLineOrder::exit( int i_ticket )
{
   for( int i = OrdersTotal() - 1; i >= 0; i-- )
   {
      if( !OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) continue;
      if( OrderSymbol() != Symbol() ) continue;
      if( OrderTicket() != i_ticket ) continue;
      if( !OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), 0 ) ) return false;
   }
   Sleep( 500 );
   
   
   return true;
}
