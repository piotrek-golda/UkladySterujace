/*
 * cooperative_scheduler.h
 *
 * Created: 2014-11-12 17:58:43
 *  Author: Piotr Golda
 */
 
/*
 * w implementacji zakladam, ze period (parametr AddTask) jest wieksze od 0. Zeby program dzialal poprawnie w wypadku taskow ktore caly czas powinny zostac uruchamiane wymagalby modyfikacji.
 *
 * Odpowiedzi na zagadnienia z tresci zadania
 *
 * 1) Nie trzeba implementowac funkcji usuwajacych zadania - mozna to ominac dodajac taska z pomoca funkcji AddTask o tym samym priorytecie (zaleznie od implementacji). W moim kodzie mozna podac funkcje taska jako Null.
 * 2) Zalezy od rodzaju bledu? np podczas wykonania dzielenia przez 0 w tasku program kopntynuuje swoje dzialanie.
 * 3) W moim przypadku po wykonaniu taska w funkcji execute wystarczy dodac linijke tasksPool[ i ].m_funcPtr = NULL; albo wywolac funkcje AddTask, podajac priorytet = i oraz funkcje = NULL, reszta parametrow dowolna.
 * 4) W mojej implementacji juz nie, przerwania sa wykonywane tylko przed przegladaniem tablicy od pierwszego elementu w funkcji execute, wiec zadna modyfikacja w funkcji schedule nie spowoduje pozniejszych bledow ani nie rozsynchronizuje kolejnosci uruchamiania taskow zgodnie z ich priorytetem.
 */


#ifndef COOPERATIVE_SCHEDULER_H_
#define COOPERATIVE_SCHEDULER_H_

#include <stdio.h>
#include <avr/interrupt.h>

// maksymalnya liczba taskow
#define MAX_NUMBER_OF_TASKS 10

// struktura potrzebna do przechowywania niezbednych informacji o taskach
static struct task
{
	// funkcja - Task do wykonania
	void (*m_funcPtr)(void*);
	// parametry dla funkcji taska
	void *m_paramPtr;
	// czas co jaki ma byc uruchamiany task
	int m_interval;
	// zmienna 'odliczajaca ile czasu pozostalo do wykonania taska
	int m_toGo;
	// flaga pomocnicza okreslajaca czy task powinien zostac w danym momencie wykonany
	unsigned char m_ready;
};

// tablica taskow
static struct task tasksPool[MAX_NUMBER_OF_TASKS];

//funkcje zgodne z trescia zadania 
void AddTask(int, int, void (*)(void*), void* );

void execute();

void schedule();

void init_timer_irq();

void init_scheduler();

#endif /* COOPERATIVE_SCHEDULER_H_ */