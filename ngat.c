#include <bai_2.h>
#include <def_877a.h>
#use delay(clock=4000000)
#FUSES NOWDT, HS, NOPUT, NOPROTECT, NODEBUG, NOBROWNOUT, NOLVP,
const unsigned int LED[10]= {0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f};
 int i=0;int j=0;
#INT_EXT
void NgatINT0(){

i++;
if (i==10){
i=0;
j++;
   if(i==0&&j==2) {
    i=0;j=0;
    }
}
}
void chan_1();
void chan_2();


void hien_thi(int i,int j);
void main()
{
//dn output 
 TRISD=0x00; 
 trise=0x00;
 trisc=0x00;
 trisa=0x00;
 trisb=0xff;
 //gan gia tri 
 PORTD=0x00;
 porta=0b00000010;
 ENABLE_INTERRUPTS(GLOBAL);
 ENABLE_INTERRUPTS(INT_EXT);
 EXT_INT_EDGE(H_TO_L);
   while(TRUE)
   {
    hien_thi(i,j);
 
   }

}
void chan_1(){

                       //portA=  0b00000000;
                      portC=  0x00;
                   portE=  0b00000001;
}
void chan_2(){

                     // portA=  0b00000000;
                      portC=  0x00;
                   portE=  0b00000010;
}
void hien_thi(int i,int j){

            
                
                     chan_1();
                     Portd= LED[i];
                     delay_ms(1);
                     
                     chan_2();
                     portd=LED[j];
                     delay_ms(1);
                     


                   
               
          
}
