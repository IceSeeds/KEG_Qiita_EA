
#include "../AppWindow.mqh"
#include "CMD.mqh"

CPanelDialog   AppWindow;
CCMD           CMD;


bool b_lineCreate0;
bool b_lineCreate1;

bool b_check0;
bool b_check1;

string str_lineName0 = "LineOrder0";
string str_lineName1 = "LineOrder1";

string str_alertName0 = "LineAlert0";
string str_alertName1 = "LineAlert1";

extern string str_upMess   = "upupTEST";
extern string str_downMess = "dodownTEST";
