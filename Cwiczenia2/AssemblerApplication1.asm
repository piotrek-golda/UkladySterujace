 #include "m32def.inc"
/*
 * AssemblerApplication1.asm
 *
 *  Created: 2014-10-22 17:39:47
 *   Author: student
 */ 



 .CSEG // blok kodu
/* //.ORG 0// w jakim miejscu startowac
 LDI R18, 1
 LOOP:
 INC R16
 ADD R17, R18
 RJMP LOOP
 LOOP:
 LDI XL, LOW(tab)
 LDI XH, HIGH(tab)
 LD R16, X
 RJMP LOOP

 .DSEG // segment danych
 .ORG 0x01FF
 tab: .BYTE 4*/

 LDI XL, LOW(tab1)
 LDI XH, HIGH(tab1)

 LDI YL, LOW(tab2)
 LDI YH, HIGH(tab2)

 LDI ZL, LOW(LEN)
 LDI ZH, HIGH(LEN)

 LDI R19, 0
 
 CP R30, R1
 BRNE STARTLOOP
 CP R31, R1
 BRNE STARTLOOP
  jmp END


 STARTLOOP:
 CLC ; clear carry
 LOOP:
 
 LD R16, X+
 LD R17, Y
 ADC R17, R16
 ST Y+, R17

 SBIW R30, 1
 BREQ LOOP


  END: JMP END


 .DSEG // segment danych
 .EQU LEN = 100
 tab1: .BYTE LEN
 tab2: .BYTE LEN