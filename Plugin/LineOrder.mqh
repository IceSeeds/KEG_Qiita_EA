
#include "../AppWindow.mqh";
CPanelDialog   AppWindow;

class CLineOrder
{
   public:
      bool  check();
      bool  GetLine();
      bool  create( string str_name, double d_param );
};

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

/* TODO ObjectFindで、特定の文字列が含まれていたら。。。
      全Objectを検索対象にする。
*/
bool CLineOrder::check()
{
   if( ObjectFind( ChartID(), "LineOrder0" ) )  return false;
   if( ObjectFind( ChartID(), "LineOrder1" ) )  return false;
      
   return true;
}