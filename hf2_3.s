DEF LD 0x80

DATA
SUM_LUT:    DB 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4 
DIGIT_CODE: DB 0x13, 0x25, 0x37, 0x49, 0x5B, 0x6D, 0x70	; int DIGIT_CODE[7] = {0x13....};

CODE
mov r0, #DIGIT_CODE	;r0 = DIGIT_CODE
mov r1, #SUM_LUT    ;r1 = SUM_LUT
mov r2, #0		;r2 = 0;
loop_start:		;while(*r0 != 0) {
;----- Ciklus belseje-----
mov r8, (r0)		;r8 = *r0;
cmp r8, #0		;*r0 != 0
jz loop_end
mov r9, (r0)
AND r8, #85
AND r9, #170
SR0 r9
ADD r8, r9
mov r9, #0
OR r9, r8
AND r8, #51
AND r9, #204
SR0 r9
SR0 r9
ADD r8, r9
mov r9, #0
or r9, r8
AND r8, #15
AND r9, #240
SWP r9
ADD r8, r9
ADD r2, r8
ADD r0, #1
jmp loop_start		;}
loop_end:
mov LD, r2