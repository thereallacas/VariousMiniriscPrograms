;*******************************************************************************
;* 8 bites gyûrûs számláló demonstrációs program. Az R1 regiszterbe betöltjük a* 
;* 0x01 értéket és a ROL Rotate Left utasításassal léptetjük végtelen ciklusban*
;*******************************************************************************
DEF LD  0x80                ; LED regiszter          (írható/olvasható)
DEF SW  0x81                ; DIP kapcsolók          (csak olvasható)
DEF BT  0x84                ; BT nyomógomb regiszter (4 bit, csak olvasható)
    
    CODE
start:

    mov     r1, #1          ; Gyûrûs számláló kezdõértéke
loop:  
    mov     LD, r1          ; Kiírjuk az aktuális értéket
    
    jsr lassito_loop_1S
    sl0     r1              ; Léptetjük barra
    
    cmp r1, #128
    jz      loopback
    
    jmp     loop        
    
    
    
    loopback:
    mov r4, #255
    mov r5, #255
    
    mov     LD, r1          ; Kiírjuk az aktuális értéket
    
    jsr lassito_loop_1S
    sr0     r1          ;léptetyük jobra
    
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
    
    