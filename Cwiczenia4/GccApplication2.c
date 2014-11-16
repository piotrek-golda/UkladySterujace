/*
 * GccApplication2.c
 *
 * Created: 2014-11-05 18:07:34
 *  Author: student
 */ 
#include <avr/io.h>
#include <avr/interrupt.h>

void foo(void* p_ptr){}
    
struct TASK 
{
    void (*m_fooptr)(void*);
    int m_interval;
    int m_toGo;
    unsigned char m_ready;
    void *m_ptr;
    
};

ISR(TIMER0_COMP_vect)
{
    static int i = 0;
    i++;
    
}

int main(void)
{
    
    OCR0 = 250;
    TIMSK = (1<<OCIE0);
    TCCR0 = (1<<WGM01) | (1 << CS00) | (1 << CS01);
    sei();
    while(1)
    {
        
    }
}
