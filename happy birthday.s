DEF DIG0 0x90                ; Kijelzõ r5 adatregiszter (írható/olvasható)
DEF DIG1 0x91                ; Kijelzõ r6 adatregiszter (írható/olvasható)
DEF DIG2 0x92                ; Kijelzõ r7 adatregiszter (írható/olvasható)
DEF DIG3 0x93                ; Kijelzõ r8 adatregiszter (írható/olvasható)
DEF COL0 0x94                ; Kijelzõ r0 adatregiszter (írható/olvasható)
DEF COL1 0x95                ; Kijelzõ r1 adatregiszter (írható/olvasható)
DEF COL2 0x96                ; Kijelzõ r2 adatregiszter (írható/olvasható)
DEF COL3 0x97                ; Kijelzõ r3 adatregiszter (írható/olvasható)
DEF COL4 0x98                ; Kijelzõ r4 adatregiszter (írható/olvasható)

CODE

    
    mov r0, #0x7F
    mov r1, #0x08             ;H                    
    mov r2, #0x08     
    mov r3, #0x08
    mov r4, #0x7F 
    
    mov r5, #0x6E             ;A                    
    mov r6, #0x73             ;P                    
    mov r7, #0x73             ;P                      
    mov r8, #0x77             ;Y               
    
jsr KIIRO_subrutin     
jsr lassito_loop_1S

     
    mov r0, #0x36
    mov r1, #0x49             ;H                    B                            ----->EZEKET FOGJA KIÍRNI
    mov r2, #0x49     
    mov r3, #0x49
    mov r4, #0x7F 
    
    mov r5, #0x6E             ;A                    -             
    mov r6, #0x77             ;P                    D             
    mov r7, #0x3F             ;P                    A                
    mov r8, #0x40             ;Y                    Y             

jsr KIIRO_subrutin 
jsr lassito_loop_1S
    
    mov r0, #0x03
    mov r1, #0x01             ;H                    B             T       
    mov r2, #0x7F     
    mov r3, #0x01
    mov r4, #0x03 
    
    mov r5, #0x00             ;A                    -             O       
    mov r6, #0x00             ;P                    D                     
    mov r7, #0x00             ;P                    A                     
    mov r8, #0x3F             ;Y                    Y                     

jsr KIIRO_subrutin 
jsr lassito_loop_1S
    
    mov r0, #0x06
    mov r1, #0x0D             ;H                    B             T       !       ----->EZEKET FOGJA KIÍRNI
    mov r2, #0x5F     
    mov r3, #0x0F
    mov r4, #0x06 
    
    mov r5, #0x63             ;A                    -             O       Y
    mov r6, #0x3E             ;P                    D                     O
    mov r7, #0x3F             ;P                    A                     U
    mov r8, #0x6E             ;Y                    Y                     °
    
jsr KIIRO_subrutin    
    
jsr lassito_loop_1S
jsr lassito_loop_1S
jsr lassito_loop_1S
jsr lassito_loop_1S


KIIRO_subrutin:
    mov COL0, r0
    mov COL1, r1             ;H                    B             T       !       ----->EZEKET FOGJA KIÍRNI
    mov COL2, r2     
    mov COL3, r3
    mov COL4, r4 
    
    mov DIG0, r5             ;A                    -             O       Y
    mov DIG1, r6             ;P                    D                     O
    mov DIG2, r7             ;P                    A                     U
    mov DIG3, r8             ;Y                    Y                     °
rts


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
