/*
 * AssemblerApplication.asm
 *
 *  Created: 2014-10-25 19:36:21
 *   Author: Piotrek Golda
 */ 
  #include "m32def.inc"


 .CSEG //segment kodu
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

 CALL IRQ

 END: JMP END


 DODAJ:
	  ; ustawiam wartosc pomocnicza zero do jednego z rejestrow
	  PUSH R19
	  PUSH R17
	  PUSH R16
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

		 ;if - zeby zachowac wartosc flagi carry
		 BRCS IF
			; zmniejszam licznik o 1
			SBIW R30, 1
			; przywracam wartosc carry
			CLC
		 JMP ELSE
		 IF:
			; zmniejszam licznik o 1
			SBIW R30, 1
			; przywracam wartosc carry
			SEC
		 ELSE:

		 ; i jezeli zero flag = 0 skacze na poczatek petli
	 BRNE LOOP

	 END_DODAJ:
	 POP R16
	 POP R17
	 POP R19
 RET

 IRQ:
 PUSH XL
 PUSH XH
 PUSH R19
	LDI XL, LOW(TCCR0)
	LDI XH, HIGH(TCCR0)
	LDI R19, CS00
	ST X, R19

	LDI XL, LOW(TIMSK)
	LDI XH, HIGH(TIMSK)
	LDI R19, TOIE0
	ST X, R19
	SEI
 POP R19
 POP XH
 POP XL
	CALL DODAJ
 RET


 .DSEG // segment danych

 .EQU LEN = 2 // dlugosc tablic

 // deklaracja tablic
 tab1: .BYTE LEN
 tab2: .BYTE LEN