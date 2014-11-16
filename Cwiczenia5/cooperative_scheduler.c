/*
 * cooperative_scheduler.c
 *
 * Created: 2014-11-12 17:58:28
 *  Author: Piotr Golda
 */ 


#include "cooperative_scheduler.h"


// wstawienie taska do tablicy taskow.
void AddTask(int p_prioriy, int p_period, void (*p_func_ptr)(void*), void* p_params)
{
		tasksPool[ p_prioriy ].m_funcPtr =  p_func_ptr;
		tasksPool[ p_prioriy ].m_paramPtr = p_params;
		tasksPool[ p_prioriy ].m_interval = p_period;
		tasksPool[ p_prioriy ].m_ready = 0;
		tasksPool[ p_prioriy ].m_toGo = p_period;
}

void execute()
{
	int i = 0;
	while(1)
	{
		cli();
		// sprawdzenie czy dany task nie powinien zostac wykonany
		if( tasksPool[ i ].m_ready )
		{
			tasksPool[ i ].m_ready = 0;
			// wlaczenie przerwan, zanim zaczne przegladac tablice od poczatku przerwania zostana wylaczone
			sei();
			// wykonanie taska
			tasksPool[ i ].m_funcPtr( tasksPool[ i ].m_paramPtr );
			//reset licznika
			i = 0;
			continue;
		}
		
		i++;
		//reset licznika, gdy dochodze do konca tablicy i wlaczenie przerwan na chwile
		if( i == MAX_NUMBER_OF_TASKS )
		{
			sei();
			i = 0;
		}
	}
}

void schedule()
{
	// petla po ustawionych taskach
	for(int i = 0; i < MAX_NUMBER_OF_TASKS; i++)
		if(tasksPool[ i ].m_funcPtr != NULL)
		{
			//zmniejszanie licznika poszczegolnego taska
			tasksPool[ i ].m_toGo--;
			// i sprawdzanie czy nie powinien zostac juz wykonany
			if( tasksPool[ i ].m_toGo == 0 )
			{
				tasksPool[ i ].m_ready = 1;
				//reset licznika
				tasksPool[ i ].m_toGo = tasksPool[ i ].m_interval;
				//wylaczam przerwania - zostana wznowione, gdy pierwszy z taskow aktywowanych w obiegu tej petli zostanie wykonany
				cli();
			}			
		}	
}


void init_timer_irq()
{
	// 250*64 = 16000, aby zostalo 1000 jako jedna milisekunda
	OCR0 = 250;
	//ustawienie maski na tryb OCIE0
	TIMSK = (1<<OCIE0);
	//ustawienie trybu CTC oraz zegara na skalujacy sie do 64
	TCCR0 = (1<<WGM01) | (1 << CS00) | (1 << CS01);
	sei();
}

void init_scheduler()
{
	// ustawiam taski w tablicy jako 'puste'
	for (int i = 0; i < MAX_NUMBER_OF_TASKS; i++)
	{
		AddTask(0,0,NULL,NULL);
	}
}