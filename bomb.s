DEF DIG0 0x90
DEF DIG1 0x91
DEF DIG2 0x92
DEF DIG3 0x93

DATA
    NUMBERS:
        DB 0x6F, 0x7F, 0x07, 0x7D, 0x6D, 0x66, 0x4F, 0x5B, 0x06, 0x3F
        

CODE
mov r0,  #0x3F
mov DIG1, r0
mov DIG2, r0
mov DIG3, r0
mov r1, #NUMBERS
counter:
mov r2, (r1)
mov DIG0, r2
add r1, #1
cmp r1, #10
jz end
jsr lassito_loop
jmp counter

lassito_loop:
mov r13, #0
mov r14, #0
mov r15, #0
loop_arena:
add r13, #12
adc r14, #0
adc r15, #0
jnc loop_arena
rts

lassito_loop2:
mov r13, #0
mov r14, #0
mov r15, #0
loop_arena2:
add r13, #120
adc r14, #0
adc r15, #0
jnc loop_arena2
rts

end:
jsr write0
jsr lassito_loop2
jsr clrscr
jsr lassito_loop2
jmp end

write:
mov r0, #0x79
mov DIG3, r0
mov r0, #0x54
mov DIG2, r0
mov r0, #0x5E
mov DIG1, r0
mov r0, #0x00
mov DIG0, r0
rts

write0:
mov r0, #0x3F
mov DIG3, r0
mov DIG2, r0
mov DIG1, r0
mov DIG0, r0
rts


clrscr:
mov r0, #0x00
mov DIG3, r0
mov DIG2, r0
mov DIG1, r0
mov DIG0, r0
rts
