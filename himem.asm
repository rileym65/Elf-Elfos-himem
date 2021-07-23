; *******************************************************************
; *** This software is copyright 2004 by Michael H Riley          ***
; *** You have permission to use, modify, copy, and distribute    ***
; *** this software so long as this copyright notice is retained. ***
; *** This software may not be used in commercial applications    ***
; *** without express written permission from the author.         ***
; *******************************************************************

include    ../bios.inc
include    ../kernel.inc

           org     8000h
           lbr     0ff00h
           db      'himem',0
           dw      9000h
           dw      endrom+7000h
           dw      2000h
           dw      endrom-2000h
           dw      2000h
           db      0
 
           org     2000h
           br      start

include    date.inc
include    build.inc
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
           lbr     o_wrmboot           ; and return to Elf/OS
buffer:    db      0,0,0,0,10,13,0

endrom:    equ     $


