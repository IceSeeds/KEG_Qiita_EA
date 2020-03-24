
class CExitCurrency
{
   public:
      bool exit();
      bool exit( string str_symbol );
};

bool CExitCurrency::exit()
{
   if( OrdersTotal() == 0 )
      Alert( "not Order" );
   else
   {
      for( int i = OrdersTotal() - 1; i >= 0; i-- )
      {
         if( !OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) continue;
         if( !OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), 0 ) ) return false;
         Sleep( 10 );
      }
   }   
   
   
   return true;
}

bool CExitCurrency::exit( string str_symbol )
{
   for( int i = OrdersTotal() - 1; i >= 0; i-- )
   {
      if( !OrderSelect( i, SELECT_BY_POS, MODE_TRADES ) ) continue;
      if( OrderSymbol() != str_symbol ) continue;
      if( !OrderClose( OrderTicket(), OrderLots(), OrderClosePrice(), 0 ) ) return false;
      Sleep( 10 );
   }
   
   
   return true;
}
