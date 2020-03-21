
#include <stderror.mqh>
#include <stdlib.mqh>

class CCMD
{
   public:
      string   GetTimes();
      void     Error( string str_place );
};

string CCMD::GetTimes()
{
   MqlDateTime times ;
   TimeToStruct( TimeLocal(), times );
   
   return (string)times.year + (string)times.mon + (string)times.day + (string)times.hour + (string)times.min + (string)times.sec;
}

void CCMD::Error( string str_place )
{
   if( GetLastError() != ERR_NO_ERROR && ERR_OBJECT_ALREADY_EXISTS )
      Alert( "Place : " + str_place + "\nErrorCode : " + (string)GetLastError() + "\nDetails : " + ErrorDescription( GetLastError() ) );
}