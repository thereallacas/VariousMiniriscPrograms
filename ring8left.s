;*******************************************************************************
;* 8 bites gy�r�s sz�ml�l� demonstr�ci�s program. Az R1 regiszterbe bet�ltj�k a* 
;* 0x01 �rt�ket �s a ROL Rotate Left utas�t�sassal l�ptetj�k v�gtelen ciklusban*
;*******************************************************************************
DEF LD  0x80                ; LED regiszter          (�rhat�/olvashat�)
DEF SW  0x81                ; DIP kapcsol�k          (csak olvashat�)
DEF BT  0x84                ; BT nyom�gomb regiszter (4 bit, csak olvashat�)
    
    CODE
start:

    mov     r1, #1          ; Gy�r�s sz�ml�l� kezd��rt�ke
loop:  
    mov     LD, r1          ; Ki�rjuk az aktu�lis �rt�ket
    
    jsr lassito_loop_1S
    sl0     r1              ; L�ptetj�k barra
    
    cmp r1, #128
    jz      loopback
    
    jmp     loop        
    
    
    
    loopback:
    mov r4, #255
    mov r5, #255
    
    mov     LD, r1          ; Ki�rjuk az aktu�lis �rt�ket
    
    jsr lassito_loop_1S
    sr0     r1          ;l�ptety�k jobra
    
    cmp r1, #1
    jz loop   
    
    jmp     loopback
    
jmp start 
    
    lassito_loop_1S:
mov r13, #0
mov r14, #0
mov r15, #0
loop_arena:
add r13, #255
adc r14, #0
adc r15, #0
jnc loop_arena
rts
    
    