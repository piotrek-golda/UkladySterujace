/*
 * Zadanie2.asm
 *
 *  Created: 2014-10-30 16:22:23
 *   Author: Piotrek
 */

   #include "m32def.inc"


 .CSEG //segment kodu
 ;inicjalizacja stosu - ustawienie poczatku stosu na koniec pamieci ram
 LDI R19, HIGH(RAMEND)
 OUT SPH, R19
 LDI R19, LOW(RAMEND)
 OUT SPL, R19



 ; ustawiam wartosc rejestru X na adres pierwszej tablicy zawierajacej liczby
 LDI XL, LOW(tab1)
 LDI XH, HIGH(tab1)
 ; ustawiam wartosc rejestru Y na adres drugiej tablicy zawierajacej liczby
 LDI YL, LOW(tab2)
 LDI YH, HIGH(tab2)
 ; rejestr Z staje sie licznikiem petli. Iterujemy od dlugosci tablicy do zera
 LDI ZL, LOW(LEN)
 LDI ZH, HIGH(LEN)

 ;wywolanie procedury dodaj ()
 CALL DODAJ

 END: JMP END

 ;procedura dodaj
 DODAJ:
	
	;wrzucam na stos rejestry modyfikowane w 
	  PUSH R19
	  PUSH R17
	  PUSH R16

	  //KOD Z POPRZEDNIEGO ZADANIA
	 ; ustawiam wartosc pomocnicza zero do jednego z rejestrow
	 LDI R19, 0
 
	 ; sprawdzam, czy Z (dlugosc tablicy) nie jest zerem
	 CP R30, R19
	 BRNE STARTLOOP
	 CP R31, R19
	 BRNE STARTLOOP

	 ; jezeli zero, to koncze
	 jmp END_DODAJ

	 STARTLOOP:

	 CLC ; clear carry - gdyby bylo ustawione, pierwsza liczba wyniku bylaby o 1 za duza

	 LOOP:
 
		 ; przepisuje wartosc z (LEN-Z)-tej komorki tab1 do rejestru arytmetycznego i przesuwam sie komorke dalej
		 LD R16, Y+
		 ; z (LEN-Z)-tej komorki tab2 do kolejnego rejestru arytmetycznego
		 LD R17, X
		 ; dodaje obie liczby i carry (przy ew przepelnieniu ustawiam carry = 1)
		 ADC R17, R16
		 ; i wynik zapisuje do komorki (LEN-Z)-tej tab2, przesuwajac sie dalej
		 ST X+, R17

		 ; zmniejszam licznik o 1
		 SBIW R30, 1
		 ; i jezeli zero flag = 0 skacze na poczatek petli
	 BRNE LOOP

	 END_DODAJ:
	 //KONIEC KODU Z POPRZEDNIEGO ZADANIA

	 ;zdejuje ze stosu poprzednie wartosci modyfikowanych rejestrow
	 POP R16
	 POP R17
	 POP R19

	 ;koniec procedury dodaj
 RET



 .DSEG // segment danych

 .EQU LEN = 5 // dlugosc tablic

 // deklaracja tablic
 tab1: .BYTE LEN
 tab2: .BYTE LEN