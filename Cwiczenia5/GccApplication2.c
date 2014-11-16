/*
 * GccApplication2.c
 *
 * Created: 2014-11-12 17:54:33
 *  Author: Piotr Golda
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
#include "cooperative_scheduler.h"
#include <stdio.h>


int T[10];


void keyboardTask(void * params)
{
	int x = 10;
	x -= 10;
	x = 10/x;
}
void serialReceiveTask(void * params){}
void watchDogTask(void * params){}

ISR(TIMER0_COMP_vect)
{
	schedule();
}

int main(int argc, char * argv[])
{
	init_scheduler();
	init_timer_irq();
	AddTask(0,1, keyboardTask, NULL);
	AddTask(9, 2, serialReceiveTask, NULL);
	AddTask(7, 500, watchDogTask, NULL);

	execute();
}

