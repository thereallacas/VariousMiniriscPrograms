DEF LD 0x80



;; adatvektor betöltése
;DATA

;DIGIT_CODE:
;DB 0x3A, 0x7B, 0x4A, 0x68, 0x27, 0x56, 0x10

;;A HF2_2014: Adatvektor 1 értékû bitjeinek megszámolása
;; Regiszter használat: r0-Adatpointer, r1-Adatelem számláló, r2-bitszámláló
;; r8-r15-Munkaregiszterek
 ;CODE
;mov r0, #DIGIT_CODE
;mov r2, #0

;read: 
    ;mov r8, (r0)        ;a dereferált r0-t bepakolja r8 ba, késõbbi vizsgálat céljából
    ;cmp r8, #0          ;ha már nulla, vagyis nincs elem akkor ugrás a végére
    ;jz end              ;ugrás a végére
    ;bit_shifter:        ;elindul a shifter
    ;cmp r8, #0          ;elõvizsgálat, r8 nem lett e a sok shifteléstõl 0?
    ;jz pointeradder     ;ha igen, akkor léptessük az r0 pointert
    ;SL0 r8              ;ha nem, akkor viszont folytassuk és shifteljük r8-at balra 0 behozásával
    ;jnc bit_shifter    ;ha a shiftelés miatt nem pottyant ki egyes, akkor újra bit_shifter
    ;adder:
        ;add r2, #1      ;hozzáadja a bitszámlálóhoz az egyet    
        ;jmp bit_shifter ;ugrik a shiftelõbe megint
     ;pointeradder:
     ;add r0, #1         ;léptetjük az adatpointert
     ;jmp read           ;újra a tetejére (read)
    ;end:                ;ha vége van, ledre pakolunk
    ;mov LD, r2   
    
    
    
    
    
    
    
    
;az adatvektor elemek számának táblázatos kiolvasásával

;DATA
    ;SUM_LUT:    DB 0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4 ; 
    ;DIGIT_CODE: DB 0x3A, 0x7B, 0x4A, 0x68, 0x27, 0x56, 0x10	; adatok betoltese ujfennt
        

;CODE
;mov r0, #DIGIT_CODE	    ;r0-át a digitkód kezdõcímére, 
;;mov r1, #SUM_LUT        ;r1-et a táblázatra állítjuk, (bár késõbb egyszer sem használjuk...)
;mov r2, #0		        ;r2-be 0 át pakolunk
;loop_start:		        ;elkezdjük a ciklust
    ;mov r8, (r0)	    ;r0 alapján kikeresi a digitkódból az azon a helyen álló értéket, és berámolja r8ba
    ;cmp r8, #0		    ;megnézzük nem-e jutott már a végére
    ;jz loop_end         ; mert akkor ugrás a végére
    ;AND r8, #0x0F       ; ha nem, kimaszkoljuk az alsó 4 bitet
    ;mov r3, (r8)        ;r3 ba pakoljuk a megújult r8 által mutatott értéket a DATA-ban. 
    ;ADD r2, r3          ;r3 at meg r2 be
    ;mov r8, (r0)        ;az aktuális digitkódrészlet ismét r8ba megy, 
    ;SWP r8              ;és mehet az alsó és a felsõ bitek cseréje
    ;AND r8, #0x0F       ;és minden elõlröl!
    ;mov r3, (r8)        
    ;ADD r2, r3          
    ;ADD r0, #1          ;léptetjük a pointert
    ;jmp loop_start		
;loop_end:               ;a végén a villogtatás
;mov LD, r2








DATA
DIGIT_CODE: DB 0x3A, 0x7B, 0x4A, 0x68, 0x27, 0x56, 0x10	; 

CODE
mov r0, #DIGIT_CODE	   
mov r2, #0		;Ismert inicializáló mûveletek
loop_start:		;elkezdjük a ciklust
    mov r8, (r0)		;az x. helyen álló értéket a digitkódból berámoljuk r8-ba
    cmp r8, #0		    ;elõvizsgálat-nem e jutottunk el a kódsorozat végére
    jz loop_end         ;mert akkor végére ugrunk!
    mov r9, (r0)        ;r9 be megint azt az x. helyen állót pakoljuk
    AND r8, #0x55       ;az r8at maszkoljuk a páros bitekre (1010101)
    AND r9, #0xaa       ;a másolatát meg páratlan bitekre és-eljük (0101010)
    SR0 r9              ;a páratlanat eltoljuk, ekkor csak minden páros helyen van érték
    ADD r8, r9          ;összeadjuk õket
    mov r9, #0          ;0-át pakoluk r9-be
    OR r9, r8           ;vagyoljuk r8-al, ahol egy van ott lesz valami
    AND r8, #0x33       ;maszkoljuk 110011 el
    AND r9, #0xcc       ;r9 et meg 11001100-el
    SR0 r9              ;kétszer shifteljük jobbra r9 et
    SR0 r9
    ADD r8, r9          ;hozzáadjuk r8hoz
    mov r9, #0          ;r9-be 0-át pakolunk
    or r9, r8           ;vagyoljuk r9 el
    AND r8, #0x0f       ;1111-el maszkolunk
    AND r9, #0xf0        ;11110000 val maszkoljuk a másolatot
    SWP r9              ;felsõ alsó bit csere
    ADD r8, r9          ;összeadjuk õket
    ADD r2, r8          ;r2 be pakoljuk r8 at
    ADD r0, #1          ;léptetjük az adatpointert
jmp loop_start		    ;ugrás az elejére
loop_end:               ;szokásos ledre villantás
mov LD, r2

