; *******************************************************************
; *** This software is copyright 2004 by Michael H Riley          ***
; *** You have permission to use, modify, copy, and distribute    ***
; *** this software so long as this copyright notice is retained. ***
; *** This software may not be used in commercial applications    ***
; *** without express written permission from the author.         ***
; *******************************************************************

include    bios.inc
include    kernel.inc

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

start:     lda     ra                  ; move past any spaces
           smi     ' '
           lbz     start
           dec     ra                  ; move back to non-space character
           ldn     ra                  ; get byte
           lbz     disp                ; jump if no command line argument
           mov     rf,ra               ; move address to rf
           sep     scall               ; call BIOS to convert to hex
           dw      f_hexin
           ghi     rd                  ; check page
           smi     030h                ; do not allow setting below 3000h
           lbdf    ok                  ; jump if ok
           sep     scall               ; otherwise display error
           dw      o_inmsg
           db      'Cannot set high memory below 3000h',10,13,0
           lbr     o_wrmboot           ; return to Elf/OS
ok:        sep     scall               ; get end of RAM
           dw      f_freemem
           inc     rf
           ghi     rf                  ; get page
           str     r2                  ; store for comparison
           ghi     rd 
           sm
           lbnf    good                ; jump if below end of memory
           sep     scall               ; otherwise display error
           dw      o_inmsg
           db      'Cannot set high memory above end of RAM',10,13,0
           lbr     o_wrmboot           ; return to Elf/OS
good:      mov     rf,0442h            ; point to high memory pointer
           ghi     rd                  ; and write new value
           str     rf
           inc     rf
           glo     rd
           str     rf
disp:      mov     rf,0442h            ; address of high memory pointer
           lda     rf                  ; retrieve it into RD
           phi     rd
           lda     rf
           plo     rd
           mov     rf,buffer           ; point to output buffer
           sep     scall               ; convert address to ASCII hex
           dw      f_hexout4
           mov     rf,buffer           ; point to output buffer
           sep     scall               ; and display it
           dw      o_msg
           lbr     o_wrmboot           ; and return to Elf/OS
buffer:    db      0,0,0,0,10,13,0

endrom:    equ     $


