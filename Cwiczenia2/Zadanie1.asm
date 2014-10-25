/*
 * AssemblerApplication.asm
 *
 *  Created: 2014-10-25 19:36:21
 *   Author: Piotrek Golda
 */ 
  #include "m32def.inc"


 .CSEG //segment kodu

 ; ustawiam wartosc rejestru X na adres pierwszej tablicy zawierajacej liczby
 LDI XL, LOW(tab1)
 LDI XH, HIGH(tab1)
 ; ustawiam wartosc rejestru Y na adres drugiej tablicy zawierajacej liczby
 LDI YL, LOW(tab2)
 LDI YH, HIGH(tab2)
 ; rejestr Z staje sie licznikiem petli. Iterujemy od dlugosci tablicy do zera
 LDI ZL, LOW(LEN)
 LDI ZH, HIGH(LEN)

 ; ustawiam wartosc pomocnicza zero do jednego z rejestrow
 LDI R19, 0
 
 ; sprawdzam, czy Z (dlugosc tablicy) nie jest zerem
 CP R30, R19
 BRNE STARTLOOP
 CP R31, R19
 BRNE STARTLOOP

 ; jezeli zero, to koncze
 jmp END

 ; wpp startuje petle

 STARTLOOP:

 CLC ; clear carry - gdyby bylo ustawione, pierwsza liczba wyniku bylaby o 1 za duza

 LOOP:
 
 ; przepisuje wartosc z (LEN-Z)-tej komorki tab1 do rejestru arytmetycznego i przesuwam sie komorke dalej
 LD R16, X+
 ; z (LEN-Z)-tej komorki tab2 do kolejnego rejestru arytmetycznego
 LD R17, Y
 ; dodaje obie liczby i carry (przy ew przepelnieniu ustawiam carry = 1)
 ADC R17, R16
 ; i wynik zapisuje do komorki (LEN-Z)-tej tab2, przesuwajac sie dalej
 ST Y+, R17

 ; zmniejszam licznik o 1
 SBIW R30, 1
 ; i jezeli zero flag = 0 skacze na poczatek petli
 BRNE LOOP

 ; petla konca
 END: JMP END


 .DSEG // segment danych

 .EQU LEN = 10 // dlugosc tablic

 // deklaracja tablic
 tab1: .BYTE LEN
 tab2: .BYTE LEN