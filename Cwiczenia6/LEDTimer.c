/*
 * LEDTimer.c
 *
 * Created: 2014-12-01 13:01:59
 *  Author: Piotr
 */ 


#include <avr/io.h>
#include "cooperative_scheduler.h"

unsigned char ledMask[] = {
	~0b00111111,//0
	~0b00000110,//1
	~0b01011011,//2
	~0b01001111,//3
	~0b01100110,//4
	~0b01101101,//5
	~0b01111101,//6
	~0b00000111,//7
	~0b01111111,//8
	~0b01101111//9
};

unsigned char dot = 0;
unsigned char log = 0;
unsigned char LED[5]={0,0,0,0,0};
	
unsigned char jumper()
{
	static k[] = 
		{0b011110111,
		 0b101111011,
		 0b110111101,
		 0b111011110};
	static int iter = -1;
	iter = (iter+1)%4;

	if(iter == 1)
	PORTA = ledMask[LED[iter+log]] & ~(dot);
	else
	PORTA= ledMask[LED[iter+log]];


	return k[iter];

}


void display(void * param){

	PORTB = jumper();
}


void updateTimer(void * param)
{
	LED[0] +=1;
	if (LED[0] >= 10)
	{
		dot = 0b10000000;
		LED[0] = 0;
		++LED[1];
		if (LED[1] >= 10)
		{
			LED[1] = 0;
			++LED[2];
			if (LED[2] >= 10)
			{
				LED[2] = 0;
				++LED[3];
				if (LED[3] >= 10)
				{
					LED[3] = 0;
					LED[4] = LED[4]%10;
				}
				if(LED[3]==10 && LED[2]==9 && LED[1]==9 && LED[0]==9)
				{
					//addTask(1,1000,updateTimer,0);
					log=1;
				}

			}
		}
	}
}

ISR(TIMER0_COMP_vect){
	schedule();
}
int main(void)
{
	DDRA = 0xff;
	DDRB = 0xff;
	PORTA = ledMask[0];

	init_scheduler();
	init_timer_irq();
	AddTask(0,1,display,NULL);
	AddTask(1,100,updateTimer,NULL);
	init_timer_irq();
	execute();
	while(1)
	{
		//TODO:: Please write your application code
	}
}
