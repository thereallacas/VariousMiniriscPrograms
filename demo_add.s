    CODE

mov r9, #NUMBERS
mov r0, (r9)     ; REG[0] = DMEM[0]
mov r1, 1        ; REG[1] = DMEM[1]
add r1, r0       ; REG[1] = REG[1] + REG[0]
mov 3,   r1      ; DMEM[3] = REG[1]
mov r4, 3
    DATA
NUMBERS:
DB    4, 5, 6
