DEF DIG0 0x90                ; Kijelz� DIG0 adatregiszter (�rhat�/olvashat�)
DEF DIG1 0x91                ; Kijelz� DIG1 adatregiszter (�rhat�/olvashat�)
DEF DIG2 0x92                ; Kijelz� DIG2 adatregiszter (�rhat�/olvashat�)
DEF DIG3 0x93                ; Kijelz� DIG3 adatregiszter (�rhat�/olvashat�)
DEF COL0 0x94                ; Kijelz� COL0 adatregiszter (�rhat�/olvashat�)
DEF COL1 0x95                ; Kijelz� COL1 adatregiszter (�rhat�/olvashat�)
DEF COL2 0x96                ; Kijelz� COL2 adatregiszter (�rhat�/olvashat�)
DEF COL3 0x97                ; Kijelz� COL3 adatregiszter (�rhat�/olvashat�)
DEF COL4 0x98                ; Kijelz� COL4 adatregiszter (�rhat�/olvashat�)


DATA       ;DOTS
    COL0DATA:
        DB 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A
    COL1DATA:
        DB 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55
    COL2DATA:
        DB 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A
    COL3DATA:
        DB 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55
    COL4DATA:
        DB 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A, 0x55, 0x2A
        

CODE
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
