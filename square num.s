    DATA
COLDATA:
        DB 00
   
   CODE
mov r0, #1
mov r1, #COLDATA
loop:
mov r2, r0
mov r3, #0
mov r15, #0
loop2:
add r3, r2
add r15, #1
cmp r15, r0
jnz loop2
write:
mov (r1), r3
add r1, #1
add r0, #1
cmp r0, #11
jnz loop
end:

