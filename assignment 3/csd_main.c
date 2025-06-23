#include <stdio.h>


#define switch_adder ((unsigned int*)0x41210000)	//switch address in mem

void led_delay(void){

	unsigned int s = *switch_adder;					// switch address in s
	unsigned int msec;								// msec value will set by switches

	if(s & 0x80) 		msec = 100;					// if SW7 switch on = 100
	else if (s & 0x40)	msec = 200;					// if SW6 switch on = 200
	else if (s & 0x20) 	msec = 300;					// if SW5 switch on = 300
	else if (s & 0x10) 	msec = 400;					// if SW4 switch on = 400
	else if (s & 0x08) 	msec = 500;					// if SW3 switch on = 500
	else if (s & 0x04) 	msec = 600;					// if SW2 switch on = 600
	else if (s & 0x02) 	msec = 700;					// if SW1 switch on = 700
	else if (s & 0x01) 	msec = 800;					// if SW0 switch on = 800
	else 				msec = 1000;				// default = 1000


	unsigned int count = msec * 111116;
	// CPU frequency is approximately 667MHz, for 1 sec, we have to multiply 667000. but there are 6 instructions executed in while(), so multiply (667000/6 = 111116)

	while(count--){
		asm("");									// do nothing for delay
	}
}
