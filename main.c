#include <main.h>
#include <def_877a.h>
#use delay(clock=4000000)
#FUSES NOWDT,HS,NOPUT,NOPROTECT,NODEBUG,NOBROWNOUT,NOLVP,
signed int i;
void main()
{
// set d=output 
trisd=0x00;

   while(true)
   {
   //set rd0=1
      portd=0b00000001;
      delay_ms(500);
      for (i=8;i>=1;i--){
//dich bit cuoi sang trai 
//dich 8 lan nen lan cuoi so 1 se out-> tat 1 nhip 
portd=portd<<1;
delay_ms(500);
   }
   }

}
