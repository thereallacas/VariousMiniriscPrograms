DEF LD   0x80                ; LED adatregiszter                    (írható/olvasható)
DEF BT   0x84                ; Nyomógomb adatregiszter              (csak olvasható)
DEF BTIE 0x85                ; Nyomógomb megszakítás eng. regiszter (írható/olvasható)
DEF BTIF 0x86                ; Nyomógomb megszakítás flag regiszter (olvasható és a bit 1 beírásával törölhetõ)
DEF DIG0 0x90                ; Kijelzõ DIG0 adatregiszter           (írható/olvasható)
DEF DIG1 0x91                ; Kijelzõ DIG1 adatregiszter           (írható/olvasható)
DEF DIG2 0x92                ; Kijelzõ DIG2 adatregiszter           (írható/olvasható)
DEF DIG3 0x93                ; Kijelzõ DIG3 adatregiszter           (írható/olvasható)
DEF COL0 0x94                ; Kijelzõ COL0 adatregiszter           (írható/olvasható)
DEF COL1 0x95                ; Kijelzõ COL1 adatregiszter           (írható/olvasható)
DEF COL2 0x96                ; Kijelzõ COL2 adatregiszter           (írható/olvasható)
DEF COL3 0x97                ; Kijelzõ COL3 adatregiszter           (írható/olvasható)
DEF COL4 0x98                ; Kijelzõ COL4 adatregiszter           (írható/olvasható)
DEF SW   0x81                ; Kapcsoló adatregiszter

DATA
    POINTS:
        DB  0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F 
    ;a pontok hétszegmenses "kódjai"
    LIVES:
        DB  0x7F, 0x3F, 0x1F, 0x0F, 0x07, 0x03, 0x01, 0x00, 0x00
    ;a pontmátrix kódja (ez megoldható lenne egy egymásból való kiszámolással is) 
CODE
    start:                  ;a program a start-ra ugrik
    jmp newgame             ;a program a newgame-re ugrik
    jmp pause               ;megszakításra ugorjon a pause interruptra
                            
    newgame:                ;itt indul a játék
    mov r0, BT              ;"elõtét loop"
    and r0, #0x02           ;várunk a BT1 lenyomására
    jz newgame              ;ha ez nem történik meg, akkor maradunk a hurokban
    
    jsr clrscr              ;a clrscr szubrutin letakarítja a képernyõt
    
    jsr IE_sub              ;az IE_sub beállítja a megszakítás engedélyezését a BT3-as gombra
    
    sti                     ;start interrupt
    mov r8, #POINTS         ;az r8-as regisztert a pontokra...
    mov r9, #LIVES          ;...az r9-es regisztert az életekre állítjuk (adatpointerek)
    jsr display             ;a display a státusz kivillantását intézi a továbbiakban
    mov r1, #0              ;kezdetben 0 pont
    mov r2, #7              ;kezdetben 7 labda
    mov r0, #0x80           ;kezdetben a labda a bal szélen van
    mov LD, r0              ;ez a ledre villantást jelzi a továbbiakban
    jsr lassito_game        ;ez meg a lassító loopot 
    
shift_right:                ;játsszunk!
    sr0 r0                  ;jobbra shiftelünk 0 beléptetésével
    jsr lassito_game
    mov LD, r0
    cmp r0, #0x01           ;elért a jobb szélére?
    jz btntst               ;ha igen, a nyomógombot ellenõrizzük
    jsr cheat_test          ;ha nem, csalást ellenõrzünk
jmp shift_right             ;amúgy minden a régi kerékvágásban folytatódik

shift_left:
    sl0 r0                  ;balra shiftelünk 0 beléptetésével
    jsr lassito_game
    mov LD, r0
    cmp r0, #0x80           ;megnézzük elért e a bal szélére?
    jz shift_right          ;ha igen visszapattan
    jmp shift_left          ;ha nem hát nem, folytatjuk a shiftelést
    
btntst:
    mov r3, BT              ;Buttont bemozgatjuk az r3-as regiszterbe késõbbi vizsgálódás céljából
    tst r3, #0x01           ;le van nyomva a BT0 gomb?
    jnz win                 ;ha igen, nyertünk (hacsak nem csaltunk, de ez majd kiderül)
    jmp lose                ;ha nem, vesztettünk
    
win:
    cmp r10, #1             ;megnézzük nem-e csalt a játékos (a gomb folyamatos nyomvatartásával)
    jz lose                 ;akkor bizony vesztett!
    add r1, #1              ;amúgy a pontot növeljük
    add r8, #1              ;a pont-pointert léptetjük
    jsr display
    cmp r1, #9              ;megnézzük, nem e 9 a pont?
    jz endgame              ;ha igen, vége a játéknak
    jmp shift_left          ;amúgy visszapattan a labda
    
lose:
    add r9, #1              ;a labda-pointer növelése
    sub r2, #1              ;labdák számát csökkenteni kell
    jz endgame              ;ha nulla, vesztettünk
    jsr display 
    mov r0, #0x80           ;új labda érkezik balszélrõl...
    mov LD, r0
    jsr lassito_game
    jmp shift_right         ;...és megy jobbra
    
endgame:
    jsr clrscr              ;üres kijelzõ
    jsr write               ;SCORE
    jsr lassito_1S          ;1 mp
    jsr lassito_1S          ;1 mp
    
    jsr clrscr              ;üres kijelzõ
    jsr display             ;pontok kiírása
    jsr lassito_1S          ;háromszori villanás
    jsr clrscr
    jsr lassito_1S
    
    jsr display
    jsr lassito_1S
    jsr clrscr
    jsr lassito_1S
    
    jsr display
    jsr lassito_1S
    jsr lassito_1S
  
    jmp start               ;a start programrészre ugrunk

cheat_test:                 ;Aki folyamatosan lenyomva tartja a gombot, az nem nyerhet!
    mov r10, #0             ;a "cheatregiszter" kinullázódik
    mov r3, BT              ;Buttont bemozgatjuk az r3-as regiszterbe késõbbi vizsgálódás céljából
    tst r3, #0x01           ;le van nyomva a BT0 gomb?
    jz endtest              ;ha nem, akkor vége is a tesztnek
    mov r10, #1             ;ha viszont igen, akkor a cheatregiszter egyest kap
    endtest:
rts

display:
    mov r7, (r9)            ;a pontmátrix kijelzõ 0. oszlopán
    mov COL0, r7            ;a játékos labdái
    mov r7, (r8)            ;míg a hétszegmenses kijelzõ 4.digitjén
    mov DIG3, r7            ;a játékos pontjai láthatók
    mov r7, #0x40           ;-
    mov DIG2, r7            
    mov r7, #0xF3           ;P.
    mov DIG1, r7            ;x-P.
rts

lassito_1S:            ;szoftveres idõzítés, kb 1 másodperc
    mov r13, #0        ; a 24 bites számláló beállítása
    mov r14, #0
    mov r15, #0
    loop_arena_1S:     ;a hurok 
        add r13, #12
        adc r14, #0
        adc r15, #0
    jnc loop_arena_1S
rts    

lassito_game:           ;a játék lassítója
    mov r13, #0         ;a SW perifériával 
    mov r14, #0         ;tetszõlegesen állítható
    mov r15, #0
    mov r12, SW
    loop_arena_game:
        add r13, r12
        adc r14, #0
        adc r15, #0
    jnc loop_arena_game
rts

clrscr:                 ;a kijelzõ letisztítása
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
    mov r7, #0x26       ;S betû a pontmátrixra
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
    mov BTIE, r6            ;A BT3 gomb megszakító tevékenységének engedélyezése
rts 
    
pause:
    mov r7, #0x7F           ;P betû a pontmátrixra
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
    mov r3, BT              ;Buttont bemozgatjuk az r3-as regiszterbe késõbbi vizsgálódás céljából
    tst r3, #0x02           ;le van nyomva a BT1 gomb?
    jz pause_loop           ;ha nincs, akkor marad a loop-ban
    mov r4, #0xFF           ;a button interrupt flag feltöltése,
    mov BTIF, r4            ;így mûködött
    jsr clrscr
    jsr display
    rti                     ;ha meg van nyomva, visszatérés a megszakításból
    