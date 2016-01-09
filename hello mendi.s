DEF DIG0 0x90                ; Kijelz� r5 adatregiszter (�rhat�/olvashat�)
DEF DIG1 0x91                ; Kijelz� r6 adatregiszter (�rhat�/olvashat�)
DEF DIG2 0x92                ; Kijelz� r7 adatregiszter (�rhat�/olvashat�)
DEF DIG3 0x93                ; Kijelz� r8 adatregiszter (�rhat�/olvashat�)
DEF COL0 0x94                ; Kijelz� r0 adatregiszter (�rhat�/olvashat�)
DEF COL1 0x95                ; Kijelz� r1 adatregiszter (�rhat�/olvashat�)
DEF COL2 0x96                ; Kijelz� r2 adatregiszter (�rhat�/olvashat�)
DEF COL3 0x97                ; Kijelz� r3 adatregiszter (�rhat�/olvashat�)
DEF COL4 0x98                ; Kijelz� r4 adatregiszter (�rhat�/olvashat�)

CODE

    
    mov r0, #0x7F
    mov r1, #0x08             ;H                    
    mov r2, #0x08     
    mov r3, #0x08
    mov r4, #0x7F 
    
    mov r5, #0x3F             ;E                    
    mov r6, #0x38             ;L                    
    mov r7, #0x38             ;L                      
    mov r8, #0x79             ;O               
    
jsr KIIRO_subrutin     
jsr lassito_loop_1S

     
    mov r0, #0x7F
    mov r1, #0x02             ;M                    B                            ----->EZEKET FOGJA KI�RNI
    mov r2, #0x04     
    mov r3, #0x02
    mov r4, #0x7F 
    
    mov r5, #0x10             ;E                    -             
    mov r6, #0x5E             ;n                    D             
    mov r7, #0x54             ;d                    A                
    mov r8, #0x79             ;i                    Y             

jsr KIIRO_subrutin   
jsr lassito_loop_1S
jsr lassito_loop_1S



KIIRO_subrutin:
    mov COL0, r0
    mov COL1, r1             ;H                    B             T       !       ----->EZEKET FOGJA KI�RNI
    mov COL2, r2     
    mov COL3, r3
    mov COL4, r4 
    
    mov DIG0, r5             ;A                    -             O       Y
    mov DIG1, r6             ;P                    D                     O
    mov DIG2, r7             ;P                    A                     U
    mov DIG3, r8             ;Y                    Y                     �
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
