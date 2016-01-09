DEF DIG0 0x90                ; Kijelzõ DIG0 adatregiszter (írható/olvasható)
DEF DIG1 0x91                ; Kijelzõ DIG1 adatregiszter (írható/olvasható)
DEF DIG2 0x92                ; Kijelzõ DIG2 adatregiszter (írható/olvasható)
DEF DIG3 0x93                ; Kijelzõ DIG3 adatregiszter (írható/olvasható)
DEF COL0 0x94                ; Kijelzõ COL0 adatregiszter (írható/olvasható)
DEF COL1 0x95                ; Kijelzõ COL1 adatregiszter (írható/olvasható)
DEF COL2 0x96                ; Kijelzõ COL2 adatregiszter (írható/olvasható)
DEF COL3 0x97                ; Kijelzõ COL3 adatregiszter (írható/olvasható)
DEF COL4 0x98                ; Kijelzõ COL4 adatregiszter (írható/olvasható)


DATA       ;H     A      P     P    Y      B     I     R     T     H     D     A    Y      !    !     !
    COL0DATA:
        DB 0x7F, 0x7E, 0x06, 0x06, 0x07, 0x36, 0x00, 0x46, 0x01, 0x7F, 0x3E, 0x7E, 0x07, 0x00, 0x00, 0x06
    COL1DATA:
        DB 0x08, 0x11, 0x09, 0x09, 0x08, 0x49, 0x41, 0x29, 0x01, 0x08, 0x41, 0x11, 0x08, 0x00, 0x0E, 0x0F
    COL2DATA:
        DB 0x08, 0x11, 0x09, 0x09, 0x70, 0x49, 0x7F, 0x19, 0x7F, 0x08, 0x41, 0x11, 0x70, 0x5F, 0x5F, 0x5F
    COL3DATA:
        DB 0x08, 0x11, 0x09, 0x09, 0x08, 0x49, 0x41, 0x09, 0x01, 0x08, 0x41, 0x11, 0x08, 0x00, 0x0E, 0x0F
    COL4DATA:
        DB 0x7F, 0x7E, 0x7F, 0x7F, 0x07, 0x7F, 0x00, 0x7F, 0x01, 0x7F, 0x7F, 0x7E, 0x07, 0x00, 0x00, 0x06
        

CODE 
st:
    mov r0, #COL0DATA
    mov r1, #COL1DATA
    mov r2, #COL2DATA
    mov r3, #COL3DATA
    mov r4, #COL4DATA
    mov r10, #0 
   
   start:
   jsr muveletsubrutin
   add r10, #1
   cmp r10, #16
   jnz start
   jmp st
   
jsr lassito_loop_1S
jsr lassito_loop_1S
jsr lassito_loop_1S
jsr lassito_loop_1S
jsr lassito_loop_1S
 
muveletsubrutin:
jsr dereferalosubrutin
jsr kirajzolosubrutin
jsr leptetosubrutin
jsr lassito_loop_1S
rts

dereferalosubrutin:
    mov r5, (r0)
    mov r6, (r1)
    mov r7, (r2)
    mov r8, (r3)
    mov r9, (r4)
rts

kirajzolosubrutin:
    mov COL0, r5
    mov COL1, r6
    mov COL2, r7
    mov COL3, r8
    mov COL4, r9
rts

leptetosubrutin:
    add r0, #1
    add r1, #1
    add r2, #1
    add r3, #1
    add r4, #1
rts    

lassito_loop_1S:
mov r13, #0
mov r14, #0
mov r15, #0
loop_arena:
add r13, #30
adc r14, #0
adc r15, #0
jnc loop_arena
rts
