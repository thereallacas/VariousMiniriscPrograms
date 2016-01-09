DEF LD 0x80

DATA
DIGIT_CODE: DB 0x13, 0x25, 0x37, 0x49, 0x5B, 0x6D, 0x70	; int DIGIT_CODE[7] = {0x13....};

CODE
mov r0, #DIGIT_CODE	;r0 = DIGIT_CODE
mov r2, #0		;r2 = 0;
loop_start:		;while(*r0 != 0) {
mov r8, (r0)		;r8 = *r0;
cmp r8, #0		;*r0 != 0
jz loop_end
;----- Ciklus belseje-----
loop_shifter_start:	;while (r8 != 0) {
cmp r8, #0
jz loop_shifter_end
;------ Shifter ciklus belseje
SL0 r8			; SHIFT balra, 0 behozatalával
ADC r2, #0		;r2 = r2 + 0 + C
jmp loop_shifter_start
loop_shifter_end:	;}
add r0, #1		;r0++;
jmp loop_start		;}
loop_end:
mov LD, r2