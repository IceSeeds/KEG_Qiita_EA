
class CLineOrder
{
   public:
      bool  lineOrder( string str_name );
      bool  check();
   
   private:
      bool create( string str_name );
};

/* MEMO いらないんじゃない？　....いや使いそうかも??? */ 
bool CLineOrder::lineOrder( string str_name )
{
   if( !create( str_name ) )  return false;
   
   return true;
}

bool CLineOrder::create( string str_name )
{
   if( !ObjectCreate( str_name + "LineOrder0", OBJ_HLINE, 0, Time[0], Close[5] ) ) return false;
   
   if( !ObjectCreate( str_name + "LineOrder1", OBJ_HLINE, 0, Time[0], Close[10] ) ) return false;
   
   
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
