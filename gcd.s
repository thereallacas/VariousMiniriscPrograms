DEF LD   0x80                ; LED adatregiszter                    (�rhat�/olvashat�)
DEF SW   0x81                ; DIP kapcsol� adatregiszter           (csak olvashat�)
DEF BT   0x84                ; Nyom�gomb adatregiszter              (csak olvashat�)
DEF BTIE 0x85                ; Nyom�gomb megszak�t�s eng. regiszter (�rhat�/olvashat�)
DEF BTIF 0x86                ; Nyom�gomb megszak�t�s flag regiszter (olvashat� �s a bit 1 be�r�s�val t�r�lhet�)
DEF DIG0 0x90                ; DIG0 adatregiszter 0x90 R/W 0x00
DEF DIG1 0x91                ; DIG1 adatregiszter 0x91 R/W 0x00
DEF DIG2 0x92                ; DIG2 adatregiszter 0x92 R/W 0x00
DEF DIG3 0x93                ; DIG3 adatregiszter 0x93 R/W 0x00



reada:
    mov r4, #0x00
    mov r5, #0x00
    mov r6, #0x00
    mov DIG1, r4 
    mov DIG2, r5
    mov DIG3, r6
    mov r0, BT
    and r0, #0x08
    jz reada
    mov r8, SW
    mov LD, r8
readb:
    mov r0, BT
    and r0, #0x04
    jz readb
    mov r9, SW
    mov LD, r9
wait:
    mov r0, BT
    and r0, #0x02
    jz wait



iter:
    ;jsr lassito_loop_1S
    cmp r8, r9
    jz RDY
    jc ALTB
AGTB:
    sub r8, r9
    mov LD, r8
    jmp iter
ALTB:
    sub r9, r8
    mov LD, r9
    jmp iter
RDY:
    mov LD, r8
    mov r0, #0x5E
    mov DIG1, r0 
    mov r0, #0x54
    mov DIG2, r0
    mov r0, #0x79 
    mov DIG3, r0
    end:
    mov r0, BT
    and r0, #0x01
    jz end 
    mov r0, #0x00
    mov LD, r0
    jmp reada
    
    
    
    
lassito_loop_1S:
    mov r13, #0
    mov r14, #0
    mov r15, #0
loop_arena:
    add r13, #12
    adc r14, #0
    adc r15, #0
    jnc loop_arena
    rts

    