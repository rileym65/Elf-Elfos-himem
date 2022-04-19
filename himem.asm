; *******************************************************************
; *** This software is copyright 2004 by Michael H Riley          ***
; *** You have permission to use, modify, copy, and distribute    ***
; *** this software so long as this copyright notice is retained. ***
; *** This software may not be used in commercial applications    ***
; *** without express written permission from the author.         ***
; *******************************************************************

.op "PUSH","N","9$1 73 8$1 73"
.op "POP","N","60 72 A$1 F0 B$1"
.op "CALL","W","D4 H1 L1"
.op "RTN","","D5"
.op "MOV","NR","9$1 B$2 8$1 A$2"
.op "MOV","NW","F8 H2 B$1 F8 L2 A$1"

include    ../bios.inc
include    ../kernel.inc

           org     2000h
begin:     br      start
           eever
           db      'Written by Michael H. Riley',0

start:     mov     rf,K_HEAP           ; address of high memory pointer
           lda     rf                  ; retrieve it into RD
           phi     rd
           lda     rf
           plo     rd
           dec     rd                  ; himem is defined as 1 byte before heap
           mov     rf,buffer           ; point to output buffer
           sep     scall               ; convert address to ASCII hex
           dw      f_hexout4
           mov     rf,buffer           ; point to output buffer
           sep     scall               ; and display it
           dw      o_msg
           ldi     0
           sep     sret                ; and return to Elf/OS
buffer:    db      0,0,0,0,10,13,0

endrom:    equ     $

           end     begin
