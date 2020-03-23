
#include "../Common/Common.mqh"

class CLineOrder
{
   public:
      bool  check();
      bool  GetLine();
      
      bool  create( string str_name, double d_param );
      bool  reCreate( string str_name, int i_type );
      
      bool  exitCheck();
      bool  exit( int i_ticket );
};

bool CLineOrder::check()
{
   if( ObjectFind( ChartID(), "LineOrder0" ) != -1 )
      b_check0 = true;
   else
      b_check0 = false;
   
   if( ObjectFind( ChartID(), "LineOrder1" ) != -1 )
      b_check1 = true;
   else
      b_check1 = false;

   
   return true;
}

bool CLineOrder::create( string str_name, double d_param )
{
   int      i_sub;
   datetime dt_x;
   double   d_y;
   ChartXYToTimePrice( ChartID(), 0, d_param, i_sub, dt_x, d_y );
   
   if( !ObjectCreate( str_name, OBJ_HLINE, 0, Time[0], NormalizeDouble( d_y, Digits() ) ) ) return false;
   
   
   return true;
}

bool CLineOrder::GetLine()
{
   double DigitsValue = MathPow( 10, Digits() - 1 );
   
   double d_line0 = ObjectGet( "LineOrder0", OBJPROP_PRICE1 );
   double d_line1 = ObjectGet( "LineOrder1", OBJPROP_PRICE1 );
   
   double d_pips0 = ( d_line0 - Close[0] ) * DigitsValue;
   double d_pips1 = ( d_line1 - Close[0] ) * DigitsValue;

   double d_profit0 = ( d_pips0 * (double)AppWindow.m_editLots.Text() ) * 1000;
   double d_profit1 = ( d_pips1 * (double)AppWindow.m_editLots.Text() ) * 1000;
   
   
   AppWindow.m_labelProfit0.Text( DoubleToString( d_profit0, 0 ) + " yen" );
   AppWindow.m_labelProfit1.Text( DoubleToString( d_profit1, 0 ) + " yen" );
   
   AppWindow.m_labelPips0.Text( DoubleToString( d_pips0, 0 ) + " pips" );
   AppWindow.m_labelPips1.Text( DoubleToString( d_pips1, 0 ) + " pips" );
      
   return true;
}

bool CLineOrder::reCreate( string str_name, int i_type )
{
   double d_line0 = ObjectGet( str_name, OBJPROP_PRICE1 );
   ObjectDelete( ChartID(), str_name );
      
   string str_type;
     
   if( i_type == 0 )
   {
      if( d_line0 > Close[0] )
         str_type = "LongProfit";
      else
         str_type = "LongLoss";
   }else{
      if( d_line0 < Close[0] )
         str_type = "SellProfit";
      else
         str_type = "SellLoss";   
   }
   
   if( OrderSelect( OrdersTotal() - 1, SELECT_BY_POS, MODE_TRADES ) )
   {
      string str_exName = "KEG_" + Symbol() + "_" + (string)OrderTicket() + "_" + str_type;
      if( !ObjectCreate( ChartID(), str_exName, OBJ_HLINE, 0, 0, d_line0 ) ) return false;
   }else{
      return false;
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