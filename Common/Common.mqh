
#include "../AppWindow.mqh"
#include "CMD.mqh"

#include "../Plugin/ExitCurrency.mqh"
#include "../Plugin/LineOrder.mqh"

CPanelDialog   AppWindow;
CCMD           CMD;

CExitCurrency  ExitCurrency;
CLineOrder     LineOrder;

bool b_lineOrder = false;