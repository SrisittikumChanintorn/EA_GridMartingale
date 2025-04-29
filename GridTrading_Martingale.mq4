#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


input int magic = 1234;

input bool open_buy = true;
input double lot_buy = 0.01;
input double mul_buy = 2.0;
input int repeat_buy = 3;
input double grid_buy = 500;
input double close_profit_buy = 200; //10

input bool open_sell = true;
input double lot_sell = 0.01;
input double mul_sell = 2.0;
input int repeat_sell = 3;
input double grid_sell = 500;
input double close_profit_sell = 200; //10

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   UpdateOrder();  
   Check_SendOrder();
   Check_CloseOrder();  
}
//+------------------------------------------------------------------+
void Check_CloseOrder()
{
   //-----------
   if(profit_buy >= close_profit_buy && close_profit_buy > 0)
   {
      CloseOrder(OP_BUY);
   }
 
   
   if(profit_sell >= close_profit_sell && close_profit_sell > 0)
   {
      CloseOrder(OP_SELL);
   }   
   //-----------
}
//+------------------------------------------------------------------+
void Check_SendOrder()
{
   double bid = SymbolInfoDouble(Symbol(),SYMBOL_BID);
   double ask = SymbolInfoDouble(Symbol(),SYMBOL_ASK);
   double point = SymbolInfoDouble(Symbol(),SYMBOL_POINT);   
   //-----------
   //Buy   
   //-----------
   if(no_buy == 0 && open_buy == true)
   {
      int ticket = OrderSend(Symbol(),OP_BUY,lot_buy,ask,3,0,0,"",magic,0,clrNONE);
   }
   else if(no_buy > 0)
   {
      if(min_buy - ask > grid_buy*point)
      {
         int no = (int)MathFloor(no_buy/repeat_buy);
         double lot = lot_buy*MathPow(mul_buy,no);
      
         int ticket = OrderSend(Symbol(),OP_BUY,lot,ask,3,0,0,"",magic,0,clrNONE);
      }
   }
   //-----------
   //Sell   
   //-----------
   if(no_sell == 0 && open_sell == true)
   {
      int ticket = OrderSend(Symbol(),OP_SELL,lot_sell,bid,3,0,0,"",magic,0,clrNONE);
   }
   else if(no_sell > 0)
   {
      if(bid - max_sell > grid_sell*point)
      {
         int no = (int)MathFloor(no_sell/repeat_sell);
         double lot = lot_sell*MathPow(mul_sell,no);
               
         int ticket = OrderSend(Symbol(),OP_SELL,lot,bid,3,0,0,"",magic,0,clrNONE);
      }
   }  
   //-----------   
}
//+------------------------------------------------------------------+
void CloseOrder(int type)
{
   for(int i=OrdersTotal()-1; i>=0; i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true)
      {
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol())
         {
            if(OrderType() == type)
            {
               bool cmdClose = OrderClose(OrderTicket(),OrderLots(),OrderClosePrice(),3,clrNONE);
            }
         }
      }
   }

}
//+------------------------------------------------------------------+

int no_buy = 0;
double profit_buy = 0;
double max_buy = 0;
double min_buy = 0;

int no_sell = 0;
double profit_sell = 0;
double max_sell = 0;
double min_sell = 0;

void UpdateOrder()
{
   //-----------
   no_buy = 0;
   profit_buy = 0;
   max_buy = 0;
   min_buy = 0;
   
   no_sell = 0;
   profit_sell = 0;
   max_sell = 0;
   min_sell = 0;
   //-----------
   for(int i=OrdersTotal()-1; i>=0; i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == true)
      {
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol())
         {
            if(OrderType() == OP_BUY)
            {
               no_buy++;
               profit_buy = profit_buy + OrderProfit() + OrderCommission() + OrderSwap();
               if(max_buy < OrderOpenPrice() || max_buy == 0)
               {
                  max_buy = OrderOpenPrice();
               }
               if(min_buy > OrderOpenPrice() || min_buy == 0)
               {
                  min_buy = OrderOpenPrice();
               }               
            }
            else if(OrderType() == OP_SELL)
            {
               no_sell++;
               profit_sell = profit_sell + OrderProfit() + OrderCommission() + OrderSwap();
               if(max_sell < OrderOpenPrice() || max_sell == 0)
               {
                  max_sell = OrderOpenPrice();
               }
               if(min_sell > OrderOpenPrice() || min_sell == 0)
               {
                  min_sell = OrderOpenPrice();
               }                 
            }
         }
      }
   
   
   
   
   
   }







}



















