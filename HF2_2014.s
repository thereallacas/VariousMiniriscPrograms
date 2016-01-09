DEF LD 0x80



;; adatvektor bet�lt�se
;DATA

;DIGIT_CODE:
;DB 0x3A, 0x7B, 0x4A, 0x68, 0x27, 0x56, 0x10

;;A HF2_2014: Adatvektor 1 �rt�k� bitjeinek megsz�mol�sa
;; Regiszter haszn�lat: r0-Adatpointer, r1-Adatelem sz�ml�l�, r2-bitsz�ml�l�
;; r8-r15-Munkaregiszterek
 ;CODE
;mov r0, #DIGIT_CODE
;mov r2, #0

;read: 
    ;mov r8, (r0)        ;a derefer�lt r0-t bepakolja r8 ba, k�s�bbi vizsg�lat c�lj�b�l
    ;cmp r8, #0          ;ha m�r nulla, vagyis nincs elem akkor ugr�s a v�g�re
    ;jz end              ;ugr�s a v�g�re
    ;bit_shifter:        ;elindul a shifter
    ;cmp r8, #0          ;el�vizsg�lat, r8 nem lett e a sok shiftel�st�l 0?
    ;jz pointeradder     ;ha igen, akkor l�ptess�k az r0 pointert
    ;SL0 r8              ;ha nem, akkor viszont folytassuk �s shiftelj�k r8-at balra 0 behoz�s�val
    ;jnc bit_shifter    ;ha a shiftel�s miatt nem pottyant ki egyes, akkor �jra bit_shifter
    ;adder:
        ;add r2, #1      ;hozz�adja a bitsz�ml�l�hoz az egyet    
        ;jmp bit_shifter ;ugrik a shiftel�be megint
     ;pointeradder:
     ;add r0, #1         ;l�ptetj�k az adatpointert
     ;jmp read           ;�jra a tetej�re (read)
    ;end:                ;ha v�ge van, ledre pakolunk
    ;mov LD, r2   
    
    
    
    
    
    
    
    
;az adatvektor elemek sz�m�nak t�bl�zatos kiolvas�s�val

;DATA
    ;SUM_LUT:    DB 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4 ; 
    ;DIGIT_CODE: DB 0x3A, 0x7B, 0x4A, 0x68, 0x27, 0x56, 0x10	; adatok betoltese ujfennt
        

;CODE
;mov r0, #DIGIT_CODE	    ;r0-�t a digitk�d kezd�c�m�re, 
;;mov r1, #SUM_LUT        ;r1-et a t�bl�zatra �ll�tjuk, (b�r k�s�bb egyszer sem haszn�ljuk...)
;mov r2, #0		        ;r2-be 0 �t pakolunk
;loop_start:		        ;elkezdj�k a ciklust
    ;mov r8, (r0)	    ;r0 alapj�n kikeresi a digitk�db�l az azon a helyen �ll� �rt�ket, �s ber�molja r8ba
    ;cmp r8, #0		    ;megn�zz�k nem-e jutott m�r a v�g�re
    ;jz loop_end         ; mert akkor ugr�s a v�g�re
    ;AND r8, #0x0F       ; ha nem, kimaszkoljuk az als� 4 bitet
    ;mov r3, (r8)        ;r3 ba pakoljuk a meg�jult r8 �ltal mutatott �rt�ket a DATA-ban. 
    ;ADD r2, r3          ;r3 at meg r2 be
    ;mov r8, (r0)        ;az aktu�lis digitk�dr�szlet ism�t r8ba megy, 
    ;SWP r8              ;�s mehet az als� �s a fels� bitek cser�je
    ;AND r8, #0x0F       ;�s minden el�lr�l!
    ;mov r3, (r8)        
    ;ADD r2, r3          
    ;ADD r0, #1          ;l�ptetj�k a pointert
    ;jmp loop_start		
;loop_end:               ;a v�g�n a villogtat�s
;mov LD, r2








DATA
DIGIT_CODE: DB 0x3A, 0x7B, 0x4A, 0x68, 0x27, 0x56, 0x10	; 

CODE
mov r0, #DIGIT_CODE	   
mov r2, #0		;Ismert inicializ�l� m�veletek
loop_start:		;elkezdj�k a ciklust
    mov r8, (r0)		;az x. helyen �ll� �rt�ket a digitk�db�l ber�moljuk r8-ba
    cmp r8, #0		    ;el�vizsg�lat-nem e jutottunk el a k�dsorozat v�g�re
    jz loop_end         ;mert akkor v�g�re ugrunk!
    mov r9, (r0)        ;r9 be megint azt az x. helyen �ll�t pakoljuk
    AND r8, #0x55       ;az r8at maszkoljuk a p�ros bitekre (1010101)
    AND r9, #0xaa       ;a m�solat�t meg p�ratlan bitekre �s-elj�k (0101010)
    SR0 r9              ;a p�ratlanat eltoljuk, ekkor csak minden p�ros helyen van �rt�k
    ADD r8, r9          ;�sszeadjuk �ket
    mov r9, #0          ;0-�t pakoluk r9-be
    OR r9, r8           ;vagyoljuk r8-al, ahol egy van ott lesz valami
    AND r8, #0x33       ;maszkoljuk 110011 el
    AND r9, #0xcc       ;r9 et meg 11001100-el
    SR0 r9              ;k�tszer shiftelj�k jobbra r9 et
    SR0 r9
    ADD r8, r9          ;hozz�adjuk r8hoz
    mov r9, #0          ;r9-be 0-�t pakolunk
    or r9, r8           ;vagyoljuk r9 el
    AND r8, #0x0f       ;1111-el maszkolunk
    AND r9, #0xf0        ;11110000 val maszkoljuk a m�solatot
    SWP r9              ;fels� als� bit csere
    ADD r8, r9          ;�sszeadjuk �ket
    ADD r2, r8          ;r2 be pakoljuk r8 at
    ADD r0, #1          ;l�ptetj�k az adatpointert
jmp loop_start		    ;ugr�s az elej�re
loop_end:               ;szok�sos ledre villant�s
mov LD, r2

