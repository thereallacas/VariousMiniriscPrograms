DEF LD   0x80                ; LED adatregiszter                    (�rhat�/olvashat�)
DEF BT   0x84                ; Nyom�gomb adatregiszter              (csak olvashat�)
DEF BTIE 0x85                ; Nyom�gomb megszak�t�s eng. regiszter (�rhat�/olvashat�)
DEF BTIF 0x86                ; Nyom�gomb megszak�t�s flag regiszter (olvashat� �s a bit 1 be�r�s�val t�r�lhet�)
DEF DIG0 0x90                ; Kijelz� DIG0 adatregiszter           (�rhat�/olvashat�)
DEF DIG1 0x91                ; Kijelz� DIG1 adatregiszter           (�rhat�/olvashat�)
DEF DIG2 0x92                ; Kijelz� DIG2 adatregiszter           (�rhat�/olvashat�)
DEF DIG3 0x93                ; Kijelz� DIG3 adatregiszter           (�rhat�/olvashat�)
DEF COL0 0x94                ; Kijelz� COL0 adatregiszter           (�rhat�/olvashat�)
DEF COL1 0x95                ; Kijelz� COL1 adatregiszter           (�rhat�/olvashat�)
DEF COL2 0x96                ; Kijelz� COL2 adatregiszter           (�rhat�/olvashat�)
DEF COL3 0x97                ; Kijelz� COL3 adatregiszter           (�rhat�/olvashat�)
DEF COL4 0x98                ; Kijelz� COL4 adatregiszter           (�rhat�/olvashat�)
DEF SW   0x81                ; Kapcsol� adatregiszter

DATA
    POINTS:
        DB  0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F 
    ;a pontok h�tszegmenses "k�djai"
    LIVES:
        DB  0x7F, 0x3F, 0x1F, 0x0F, 0x07, 0x03, 0x01, 0x00, 0x00
    ;a pontm�trix k�dja (ez megoldhat� lenne egy egym�sb�l val� kisz�mol�ssal is) 
CODE
    start:                  ;a program a start-ra ugrik
    jmp newgame             ;a program a newgame-re ugrik
    jmp pause               ;megszak�t�sra ugorjon a pause interruptra
                            
    newgame:                ;itt indul a j�t�k
    mov r0, BT              ;"el�t�t loop"
    and r0, #0x02           ;v�runk a BT1 lenyom�s�ra
    jz newgame              ;ha ez nem t�rt�nik meg, akkor maradunk a hurokban
    
    jsr clrscr              ;a clrscr szubrutin letakar�tja a k�perny�t
    
    jsr IE_sub              ;az IE_sub be�ll�tja a megszak�t�s enged�lyez�s�t a BT3-as gombra
    
    sti                     ;start interrupt
    mov r8, #POINTS         ;az r8-as regisztert a pontokra...
    mov r9, #LIVES          ;...az r9-es regisztert az �letekre �ll�tjuk (adatpointerek)
    jsr display             ;a display a st�tusz kivillant�s�t int�zi a tov�bbiakban
    mov r1, #0              ;kezdetben 0 pont
    mov r2, #7              ;kezdetben 7 labda
    mov r0, #0x80           ;kezdetben a labda a bal sz�len van
    mov LD, r0              ;ez a ledre villant�st jelzi a tov�bbiakban
    jsr lassito_game        ;ez meg a lass�t� loopot 
    
shift_right:                ;j�tsszunk!
    sr0 r0                  ;jobbra shiftel�nk 0 bel�ptet�s�vel
    jsr lassito_game
    mov LD, r0
    cmp r0, #0x01           ;el�rt a jobb sz�l�re?
    jz btntst               ;ha igen, a nyom�gombot ellen�rizz�k
    jsr cheat_test          ;ha nem, csal�st ellen�rz�nk
jmp shift_right             ;am�gy minden a r�gi ker�kv�g�sban folytat�dik

shift_left:
    sl0 r0                  ;balra shiftel�nk 0 bel�ptet�s�vel
    jsr lassito_game
    mov LD, r0
    cmp r0, #0x80           ;megn�zz�k el�rt e a bal sz�l�re?
    jz shift_right          ;ha igen visszapattan
    jmp shift_left          ;ha nem h�t nem, folytatjuk a shiftel�st
    
btntst:
    mov r3, BT              ;Buttont bemozgatjuk az r3-as regiszterbe k�s�bbi vizsg�l�d�s c�lj�b�l
    tst r3, #0x01           ;le van nyomva a BT0 gomb?
    jnz win                 ;ha igen, nyert�nk (hacsak nem csaltunk, de ez majd kider�l)
    jmp lose                ;ha nem, vesztett�nk
    
win:
    cmp r10, #1             ;megn�zz�k nem-e csalt a j�t�kos (a gomb folyamatos nyomvatart�s�val)
    jz lose                 ;akkor bizony vesztett!
    add r1, #1              ;am�gy a pontot n�velj�k
    add r8, #1              ;a pont-pointert l�ptetj�k
    jsr display
    cmp r1, #9              ;megn�zz�k, nem e 9 a pont?
    jz endgame              ;ha igen, v�ge a j�t�knak
    jmp shift_left          ;am�gy visszapattan a labda
    
lose:
    add r9, #1              ;a labda-pointer n�vel�se
    sub r2, #1              ;labd�k sz�m�t cs�kkenteni kell
    jz endgame              ;ha nulla, vesztett�nk
    jsr display 
    mov r0, #0x80           ;�j labda �rkezik balsz�lr�l...
    mov LD, r0
    jsr lassito_game
    jmp shift_right         ;...�s megy jobbra
    
endgame:
    jsr clrscr              ;�res kijelz�
    jsr write               ;SCORE
    jsr lassito_1S          ;1 mp
    jsr lassito_1S          ;1 mp
    
    jsr clrscr              ;�res kijelz�
    jsr display             ;pontok ki�r�sa
    jsr lassito_1S          ;h�romszori villan�s
    jsr clrscr
    jsr lassito_1S
    
    jsr display
    jsr lassito_1S
    jsr clrscr
    jsr lassito_1S
    
    jsr display
    jsr lassito_1S
    jsr lassito_1S
  
    jmp start               ;a start programr�szre ugrunk

cheat_test:                 ;Aki folyamatosan lenyomva tartja a gombot, az nem nyerhet!
    mov r10, #0             ;a "cheatregiszter" kinull�z�dik
    mov r3, BT              ;Buttont bemozgatjuk az r3-as regiszterbe k�s�bbi vizsg�l�d�s c�lj�b�l
    tst r3, #0x01           ;le van nyomva a BT0 gomb?
    jz endtest              ;ha nem, akkor v�ge is a tesztnek
    mov r10, #1             ;ha viszont igen, akkor a cheatregiszter egyest kap
    endtest:
rts

display:
    mov r7, (r9)            ;a pontm�trix kijelz� 0. oszlop�n
    mov COL0, r7            ;a j�t�kos labd�i
    mov r7, (r8)            ;m�g a h�tszegmenses kijelz� 4.digitj�n
    mov DIG3, r7            ;a j�t�kos pontjai l�that�k
    mov r7, #0x40           ;-
    mov DIG2, r7            
    mov r7, #0xF3           ;P.
    mov DIG1, r7            ;x-P.
rts

lassito_1S:            ;szoftveres id�z�t�s, kb 1 m�sodperc
    mov r13, #0        ; a 24 bites sz�ml�l� be�ll�t�sa
    mov r14, #0
    mov r15, #0
    loop_arena_1S:     ;a hurok 
        add r13, #12
        adc r14, #0
        adc r15, #0
    jnc loop_arena_1S
rts    

lassito_game:           ;a j�t�k lass�t�ja
    mov r13, #0         ;a SW perif�ri�val 
    mov r14, #0         ;tetsz�legesen �ll�that�
    mov r15, #0
    mov r12, SW
    loop_arena_game:
        add r13, r12
        adc r14, #0
        adc r15, #0
    jnc loop_arena_game
rts

clrscr:                 ;a kijelz� letiszt�t�sa
    mov r7, #0x00
    mov DIG3, r7
    mov DIG2, r7
    mov DIG1, r7
    mov DIG0, r7
    mov COL0, r7
    mov COL1, r7
    mov COL2, r7
    mov COL3, r7
    mov COL4, r7
    mov LD, r7
rts

write:                  ;SCORE
    mov r7, #0x26       ;S bet� a pontm�trixra
    mov COL4, r7
    mov r7, #0x49
    mov COL3, r7
    mov COL2, r7
    mov COL1, r7
    mov r7, #0x32
    mov COL0, r7
    mov r7, #0x39
    mov DIG3, r7        ;C
    mov r7, #0x3F
    mov DIG2, r7        ;O
    mov r7, #0x77
    mov DIG1, r7        ;R
    mov r7, #0x79
    mov DIG0, r7        ;E
rts 

IE_sub:
    mov r6, #0x08
    mov BTIE, r6            ;A BT3 gomb megszak�t� tev�kenys�g�nek enged�lyez�se
rts 
    
pause:
    mov r7, #0x7F           ;P bet� a pontm�trixra
    mov COL4, r7
    mov r7, #0x09
    mov COL3, r7
    mov COL2, r7
    mov COL1, r7
    mov r7, #0x06
    mov COL0, r7
    mov r7, #0x77           
    mov DIG3, r7            ;A
    mov r7, #0x3E       
    mov DIG2, r7            ;U
    mov r7, #0x6D
    mov DIG1, r7            ;S
    mov r7, #0xF9
    mov DIG0, r7            ;E
    
    pause_loop:
    mov r3, BT              ;Buttont bemozgatjuk az r3-as regiszterbe k�s�bbi vizsg�l�d�s c�lj�b�l
    tst r3, #0x02           ;le van nyomva a BT1 gomb?
    jz pause_loop           ;ha nincs, akkor marad a loop-ban
    mov r4, #0xFF           ;a button interrupt flag felt�lt�se,
    mov BTIF, r4            ;�gy m�k�d�tt
    jsr clrscr
    jsr display
    rti                     ;ha meg van nyomva, visszat�r�s a megszak�t�sb�l
    