#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Controls\ComboBox.mqh>


class CPanelDialog : public CAppDialog
{
   public:
       CPanelDialog();
      ~CPanelDialog();
   
      /* create */
      virtual bool      Create( const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2 );
      /* chart event handler */
      virtual bool      OnEvent( const int id, const long &lparam, const double &dparam, const string &sparam );
      
      CEdit             m_editLots;
      CButton           m_btnBuy;
      CButton           m_btnSell;
      CButton           m_btnUp;
      CButton           m_btnDown;
      CComboBox         m_combCreate;
      CButton           m_btnComb;
      
   protected:
      bool              CreateEditLots();
      bool              CreateBtnBuy();
      bool              CreateBtnSell();
      bool              CreateBtnUp();
      bool              CreateBtnDown();
      bool              CreateCombCreate();
      bool              CreateBtnComb();
      
      void              OnClickBtnUp();
      void              OnClickBtnDown();
};


EVENT_MAP_BEGIN( CPanelDialog )
ON_EVENT( ON_CLICK, m_btnUp,     OnClickBtnUp )
ON_EVENT( ON_CLICK, m_btnDown,   OnClickBtnDown )
EVENT_MAP_END( CAppDialog )

CPanelDialog::CPanelDialog(){}
CPanelDialog::~CPanelDialog(){}

bool CPanelDialog::Create( const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2 )
{
   if( !CAppDialog::Create( chart, name, subwin, x1, y1, x2, y2 ) )
      return false;
   
   if( !CreateEditLots() )    return false;
   if( !CreateBtnUp() )       return false;
   if( !CreateBtnDown() )     return false;
   if( !CreateBtnBuy() )      return false;
   if( !CreateBtnSell() )     return false;
   if( !CreateCombCreate() )  return false;
   if( !CreateBtnComb() )     return false;
   
   return true;
}

bool CPanelDialog::CreateEditLots()
{
   int widths = ClientAreaWidth() / 5;
   int x1 = widths;
   int y1 = 0;
   int x2 = widths * 4;
   int y2 = 20;
   
   if( !m_editLots.Create( m_chart_id, m_name + "Edit", m_subwin, x1, y1, x2, y2 ) ) return false;
   if( !m_editLots.ReadOnly( false ) ) return false;
   if( !Add( m_editLots ) ) return false;
   m_editLots.TextAlign( ALIGN_CENTER );
   m_editLots.Text( "0.10" );
   
   return true;
}

bool CPanelDialog::CreateBtnUp()
{
   int widths = ClientAreaWidth() / 5;
   int x1 = widths * 4;
   int y1 = 0;
   int x2 = ClientAreaWidth();
   int y2 = 20;
   
   if( !m_btnUp.Create( m_chart_id, m_name + "btnUp", m_subwin, x1, y1, x2, y2 ) ) return false;
   if( !m_btnUp.Text( "UP" ) ) return false;
   if( !Add( m_btnUp ) ) return false;
   
   return true;
}

bool CPanelDialog::CreateBtnDown()
{
   int x1 = 0;
   int y1 = 0;
   int x2 = ClientAreaWidth() / 5;
   int y2 = 20;
   
   if( !m_btnDown.Create( m_chart_id, m_name + "btnDown", m_subwin, x1, y1, x2, y2 ) ) return false;
   if( !m_btnDown.Text( "DOWN" ) ) return false;
   if( !Add( m_btnDown ) ) return false;
   
   return true;
}

bool CPanelDialog::CreateBtnBuy()
{
   int x1 = ClientAreaWidth() / 2;
   int y1 = 20;
   int x2 = ClientAreaWidth();
   int y2 = ClientAreaHeight() - 20;
   
   if( !m_btnBuy.Create( m_chart_id, m_name + "btnBuy", m_subwin, x1, y1, x2, y2 ) ) return false;
   if( !m_btnBuy.Text( "Buy" ) ) return false;
   if( !Add( m_btnBuy ) ) return false;
   
   return true;
}

bool CPanelDialog::CreateBtnSell()
{
   int x1 = 0;
   int y1 = 20;
   int x2 = ClientAreaWidth() / 2;
   int y2 = ClientAreaHeight() - 20;
   
   if( !m_btnSell.Create( m_chart_id, m_name + "btnSell", m_subwin, x1, y1, x2, y2 ) ) return false;
   if( !m_btnSell.Text( "Sell" ) ) return false;
   if( !Add( m_btnSell ) ) return false;
   
   return true;
}

bool CPanelDialog::CreateCombCreate()
{
   int widths = ClientAreaWidth() / 5;
   int x1 = 0;
   int y1 = ClientAreaHeight() - 20;
   int x2 = widths * 4;
   int y2 = ClientAreaHeight();
   
   if( !m_combCreate.Create( m_chart_id, m_name + "comboCreate", m_subwin, x1, y1, x2, y2 ) ) return false;
   m_combCreate.AddItem( "All Exit", 0 );
   m_combCreate.AddItem( "This Exit", 1 );
   m_combCreate.AddItem( "Line Order", 2 );
   
   if( !Add( m_combCreate ) ) return false;
   
   return true;
}

bool CPanelDialog::CreateBtnComb()
{
   int widths = ClientAreaWidth() / 5;
   int x1 = widths * 4;
   int y1 = ClientAreaHeight() - 20;
   int x2 = ClientAreaWidth();
   int y2 = ClientAreaHeight();
   
   if( !m_btnComb.Create( m_chart_id, m_name + "btnComb", m_subwin, x1, y1, x2, y2 ) ) return false;
   if( !m_btnComb.Text( "Push" ) ) return false;
   if( !Add( m_btnComb ) ) return false;
   
   return true;
}


/* Event Handle */
void CPanelDialog::OnClickBtnUp()
{
   m_btnUp.Pressed( false );
   
   string str_editText = m_editLots.Text();
   double d_lots = StringToDouble( str_editText );
   d_lots += 0.01;
   m_editLots.Text( DoubleToStr( d_lots, 2 ) );
}
void CPanelDialog::OnClickBtnDown()
{
   m_btnDown.Pressed( false );
   
   string str_editText = m_editLots.Text();
   double d_lots = StringToDouble( str_editText );
   if( d_lots > 0.01 )
   {
      d_lots -= 0.01;
      m_editLots.Text( DoubleToStr( d_lots, 2 ) );
   }
}
