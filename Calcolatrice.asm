.MODEL SMALL
.STACK 100h
 
.DATA
   ;Dati operazioni + interfaccia grafica 
   VAR1 DW ?            
   VAR2 DW ?            
   SEGNO1 DB ?          
   SEGNO2 DB ?          
   OPERATORE DB ?       
   RIS1 DW ?          
   
   MSG_OPP1 DB 0Dh, 0Ah, 'Inserire quale operazione si vuole eseguire: $'
   MSG_OPP2 DB 0Dh, 0Ah, '[1] Addizione$'
   MSG_OPP3 DB 0Dh, 0Ah, '[2] Sottrazione$'
   MSG_OPP4 DB 0Dh, 0Ah, '[3] Moltiplicazione$'
   MSG_OPP5 DB 0Dh, 0Ah, '[4] Divisione$'
   MSG_OPP6 DB 0Dh, 0Ah, '[5] Radice Quadrata$'
   MSG_OPP7 DB 0Dh, 0Ah, '[6] Radice Cubica$'
   MSG_OPP8 DB 0Dh, 0Ah, '[7] Logaritmo$'
   MSG_OPP9 DB 0Dh, 0Ah, '[8] Esponenziale$'
   MSG1 DB 0Dh, 0Ah, 'Inserire il primo numero: $'
   MSG2 DB 0Dh, 0Ah, 'Inserire il secondo numero: $'
   MSG3 DB 0Dh, 0Ah, 'Inserire il segno del primo numero (+,-): $'
   MSG4 DB 0Dh, 0Ah, 'Inserire il segno del secondo numero (+,-): $'
   MSG5 DB 0Dh, 0Ah, 'Radice quadrata di $' 
   MSG6 DB 0Dh, 0Ah, 'Inserire la base: $'
   MSG7 DB 0Dh, 0Ah, 'Inserire esponente:$'
   MSG8 DB 0Dh, 0Ah, 'elevato a $'   
   MSG9 DB 0Dh, 0Ah, 'Inserire la base del logaritmo: $' 
   MSG10 DB 0Dh, 0Ah, 'Il logaritmo in base $'
   MSG_RIS DB 0Dh, 0Ah, '+--------------------------------+ $'                  ; Contorno
   MSG_ERR1 DB 0Dh, 0Ah, 'Operatore errato, inserirne un operatore valido: $'
   CONTORNO DB '------------------------CALCOLATRICE------------------------$'  ; Titolo della calcolatrice    
   
    
   
.CODE
.STARTUP
     
    MOV AX, @DATA             ; Prende l'indirizzo della memoria dei dati e lo mette in AX
    MOV DS, AX                ; Memorizza l'indirizzo in DS per accedere ai dati
          
    MOV AX,3                  ; Pulisce lo schermo in caso l'utente voglia usare la calcolatrice ancora
    INT 10H                   ; Serve per controllare le funzioni video del BIOS
    
    MOV AH, 09H
    LEA DX, CONTORNO
    INT 21H                   ; Stampa la scritta iniziale della calcolatrice
        
    
;-------------------------------------------------------------------------------
;Richiesta operatore per operazione
;-------------------------------------------------------------------------------

Richiedi_Operatore: 
    
    MOV AH, 09H
    LEA DX, MSG_OPP2
    INT 21H                   ; Stampa le varie scielte delle operazioni
    
    MOV AH, 09H
    LEA DX, MSG_OPP3
    INT 21H 
    
    MOV AH, 09H                             
    LEA DX, MSG_OPP4
    INT 21H 
    
    MOV AH, 09H
    LEA DX, MSG_OPP5
    INT 21H 
    
    MOV AH, 09H
    LEA DX, MSG_OPP6
    INT 21H 
    
    MOV AH, 09H
    LEA DX, MSG_OPP7
    INT 21H  
        
    MOV AH, 09H
    LEA DX, MSG_OPP8
    INT 21H
    MOV AH, 09H
    LEA DX, MSG_OPP9
    INT 21H
    
    MOV AH, 09H
    LEA DX, MSG_OPP1
    INT 21H                   ; Stampa il mesaggio per scegliere l'operazione da eseguire
    
    MOV AH, 01H               ; Funzione per leggere un carattere
    INT 21H                   ; Chiama DOS (il sistema operativo su cui gira il programma) per ottenere il carattere
    MOV OPERATORE, AL         ; Salva il carattere nella variabile   
    
    CMP AL, '1'               ; Controlla se e' presente 1 in AL, in caso ci fosse verra' eseguito JE (jump equal)
    JE Leggi_Numeri           ; Salta alla lettura dei numeri 
     
    CMP AL, '2'               ; Controlla se e' presente 2 in AL, in caso ci fosse verra' eseguito JE (jump equal)
    JE Leggi_Numeri           ; Salta alla lettura dei numeri 
    
    CMP AL, '3'               ; Controlla se e' presente 3 in AL, in caso ci fosse verra' eseguito JE (jump equal)
    JE Leggi_Numeri           ; Salta alla lettura dei numeri 
    
    CMP AL, '4'               ; Controlla se e' presente 4 in AL, in caso ci fosse verra' eseguito JE (jump equal)
    JE Leggi_Numeri           ; Salta alla lettura dei numeri 
      
    CMP AL, '5'               ; Controlla se e' presente 1 in AL, in caso ci fosse verra' eseguito JE (jump equal)
    JE Radice2                ; Salta alla lettura dei numeri 
      
    CMP AL, '6'               ; Controlla se e' presente 1 in AL, in caso ci fosse verra' eseguito JE (jump equal)
    JE Radice3                ; Salta alla lettura dei numeri 
      
    CMP AL, '7'               ; Controlla se e' presente 1 in AL, in caso ci fosse verra' eseguito JE (jump equal)
    JE Log                    ; Salta alla lettura dei numeri 
      
    CMP AL, '8'               ; Controlla se e' presente 1 in AL, in caso ci fosse verra' eseguito JE (jump equal)
    JE Esponenziale           ; Salta al esecuzione del esponenziale 
    
    ; Se nessun JE viene eseguito questo codice per far selezionare di nuovo l'operatore
    MOV AH, 09H               ; Stampa il mesaggio di richesta per inserire di nuovo l'operatore
    LEA DX, MSG_ERR1
    INT 21H
    JMP Richiedi_Operatore
    
;-------------------------------------------------------------------------------
;Lettura dei numeri e rispettivo segno 
;-------------------------------------------------------------------------------

Leggi_Numeri:                 ; Stampa la richiesta del primo segno
    MOV AH, 09H
    LEA DX, MSG3
    INT 21H
                              ; Legge il primo segno
    MOV AH, 01H               ; Chiama DOS per il carattere
    INT 21H                   ; Salva il carattere nella variabile
    MOV SEGNO1, AL

    MOV AH, 09H               ; Stampa la richiesta per il primo numero
    LEA DX, MSG1
    INT 21H
    CALL LeggiNumero          ; Chiamata della funziona LeggiNumero per leggere numeri a piu' cifre
    MOV VAR1, AX              ; Salva il numero nella variabile 
    
    MOV AH, 09H               ; Stampa la richesta del secondo segno
    LEA DX, MSG4
    INT 21H
    
    MOV AH, 01H               ; Legge il secondo segno
    INT 21H                   ; Chiama DOS per il carattere
    MOV SEGNO2, AL            ; Salva il carattere nella variabile
    
    MOV AH, 09H               ; Stampa la richiesta per il secondo numero
    LEA DX, MSG2
    INT 21H
    CALL LeggiNumero          ; Chiamata della funziona LeggiNumero per leggere numeri a piu' cifre
    MOV VAR2, AX              ; Salva il numero nella variabile
    
    CMP OPERATORE, '1'        ; Controlla se e' presente 1 in OPERATORE, in caso ci fosse verra' eseguito JE (jump equal)
    JE Addizione              ; Salta al esecuzione del addizione 
                             
    CMP OPERATORE, '2'        ; Controlla se e' presente 2 in OPERATORE, in caso ci fosse verra' eseguito JE (jump equal)
    JE Sottrazione            ; Salta al esecuzione del sottrazione 
    
    CMP OPERATORE, '3'        ; Controlla se e' presente 3 in OPERATORE, in caso ci fosse verra' eseguito JE (jump equal)
    JE Moltiplicazione        ; Salta al esecuzione del moltiplicazione 
    
    CMP OPERATORE, '4'        ; Controlla se e' presente 4 in OPERATORE, in caso ci fosse verra' eseguito JE (jump equal)
    JE Divisione              ; Salta al esecuzione del divisione 
    
;-------------------------------------------------------------------------------
;Addizione
;-------------------------------------------------------------------------------

Addizione: 
    PUSH CX                   ; Salva lo stato di CX
    PUSH BX                   ; Salva lo stato di BX
    MOV CX, 0                 ; Svuota CX per eseguire le operazioni
    MOV BX, 0                 ; Svuota BX per eseguire le operazioni
    
    MOV BX, VAR1              ; Muove in BX il primo numero per eseguire le operazioni
    MOV CX, VAR2              ; Muove in CX il primo numero per eseguire le operazioni
    CMP SEGNO1, '-'           ; Controlla se il primo numero e' negativo
    JE PrimoNegativo          ; Salta all operazaione con il primo numero negativo
    CMP SEGNO2, '-'           ; Controlla se il secondo numero e' negativo
    JE SecondoNegativo        ; Salta all operazaione con il secodo numero negativo
    
    ; Caso 1: Entrambi positivi
    ADD BX, CX                ; Vengono sommati i due numeri
    MOV RIS1, BX              ; La somma viene salvata in RIS1
    JMP FineAddizione         ; Salta a FineAddizione oer stampare il risultato
    
PrimoNegativo:
    CMP SEGNO2, '-'           ; Controlla se anche il secondo segno e' negativo 
    JE EntrambiNegativi       ; In caso fosse negativo salta all'operazione con entrambi i numeri negativi 
    
    ; Caso 2: Primo negativo, secondo positivo 
    NEG BX                    ; Il primo numero viene reso negativo
    ADD CX, BX                ; I due numeri vengono sommati 
    MOV RIS1, CX              ; La somma viene salvata in RIS1                                                                           
    JMP FineAddizione         ; Salta a FineAddizione per stampare il risultato
    
SecondoNegativo:
    ; Caso 3: Primo positivo, secondo negativo 
    NEG CX                    ; Il secondo numero viene reso negativo
    ADD BX, CX                ; I due numeri vengono sommati
    MOV RIS1, BX              ; La somma viene salvata in RIS1               
    JMP FineAddizione         ; Salta a FineAddizione per stampare il risultato
    
EntrambiNegativi:
    ; Caso 4: Entrambi negativi 
    NEG BX                    ; Il primo numero viene reso negativo
    NEG CX                    ; Il secondo numero viene reso negativo
    ADD BX, CX                ; I due numeri vengono sommati
    MOV RIS1, BX              ; La somma viene salvata in RIS1   
    
FineAddizione:                ; Il salto di fine operazione porta qui 
    POP BX                    ; Viene ripristinato il valore di BX
    POP CX                    ; Viene ripristinato il valore di CX
    JMP Conv_opp              ; Salto per stampare il risultato 
    
;-------------------------------------------------------------------------------
;Sottrazione
;------------------------------------------------------------------------------- 
      
Sottrazione:  
    PUSH CX                   ; Salva lo stato di CX
    PUSH BX                   ; Salva lo stato di BX
    MOV BX, 0                 ; Svuota BX per eseguire le operazioni
    MOV CX, 0                 ; Svuota CX per eseguire le operazioni
    
    MOV BX, VAR1              ; Muove in BX il primo numero per eseguire le operazioni
    MOV CX, VAR2              ; Muove in CX il primo numero per eseguire le operazioni
    CMP SEGNO1, '-'           ; Controlla se il primo numero e' negativo
    JE PrimoNegativo2         ; Salta all operazaione con il primo numero negativo
    CMP SEGNO2, '-'           ; Controlla se il secondo numero e' negativo
    JE SecondoNegativo2       ; Salta all operazaione con il secondo numero negativo
    
    ; Caso 1: Entrambi positivi
    SUB BX, CX                ; Vengono sottratti i due numeri
    MOV RIS1, BX              ; Il risulato viene salvato in RIS1
    JMP FineSottrazione       ; Salta a FineSottrazione per stampare il risultato
    
PrimoNegativo2:               
    CMP SEGNO2, '-'           ; Controlla se anche il secondo segno e' negativo 
    JE EntrambiNegativi2      ; In caso fosse negativo salta all'operazione con entrambi i numeri negativi 
    
    ; Caso 2: Primo negativo, secondo positivo 
    NEG BX                    ; Il primo numero viene reso negativo
    SUB CX, BX                ; Vengono stotratti i due numeri
    NEG CX                    ; Il risultato viene reso negativo 
    MOV RIS1, CX              ; Il risulato viene salvato in RIS1
    JMP FineSottrazione       ; Salta a FineSottrazione per stampare il risultato
    
SecondoNegativo2:
    ; Caso 3: Primo positivo, secondo negativo 
    ADD BX, CX                ; Viene fatta la somma perche' - * - = +
    MOV RIS1, BX              ; Il risultato viene spostatin in RIS1
    JMP FineSottrazione       ; Salta a FineSottrazione per stampare il risultato
    
EntrambiNegativi2:
    ; Caso 4: Entrambi negativi 
    NEG BX                    ; Il primo numero viene reso negativo
    ADD BX, CX                ; I due numeri vengono sommati
    MOV RIS1, BX              ; Il risultato viene salvato in RIS1
    
FineSottrazione:              ; Il salto di fine operazione porta qui 
    POP BX                    ; Viene ripristinato il valore di BX
    POP CX                    ; Viene ripristinato il valore di CX
    JMP Conv_opp              ; Salto per stampare il risultato 
    
;-------------------------------------------------------------------------------
;Moltiplicazione
;------------------------------------------------------------------------------- 
  
Moltiplicazione:
    PUSH BX                   ; Salvo lo stato di BX
    PUSH CX                   ; Salva lo stato di CX

    MOV BX, 0                 ; Svuota BX per eseguire le operazioni
    MOV CX, 0                 ; Svuota CX per eseguire le operazioni

    MOV BX, VAR1              ; Muove in BX il primo numero per eseguire le operazioni
    MOV CX, VAR2              ; Muove in CX il secondo numero per eseguire le operazioni
    CMP SEGNO1, '-'           ; Controlla se il primo numero e' negativo
    JE PrimoNegativo3         ; Salta all'operazione con il primo numero negativo
    CMP SEGNO2, '-'           ; Controlla se il secondo numero e' negativo
    JE SecondoNegativo3       ; Salta all'operazione con il secondo numero negativo

    ; Caso 1: Entrambi positivi
    MOV AX, BX                ; Muove il primo numero in AX per fare la moltiplicazione
    IMUL CX                   ; Moltiplica BX per CX, risultato in AX
    MOV RIS1, AX              ; Muove il risultato in RIS1
    JMP FineMoltiplicazione   ; Salta a FineMoltiplicazione per stampare il risultato

     ; Caso 2: Primo negativo, secondo positivo
PrimoNegativo3:
    CMP SEGNO2, '-'           ; Controlla se il secondo numero e' negativo
    JE EntrambiNegativi3      ; Se anche il secondo numero e' negativo, salta all'operazione con entrambi negativi

    NEG BX                    ; Rende negativo il primo numero
    MOV AX, BX                ; Muove il primo numero in AX per fare la moltiplicazione
    IMUL CX                   ; Moltiplica BX (negativo) per CX (positivo)
    MOV RIS1, AX              ; Muove il risultato in RIS1
    JMP FineMoltiplicazione   ; Salta a FineMoltiplicazione per stampare il risultato

    ; Caso 3: Primo positivo, secondo negativo
SecondoNegativo3:
    NEG BX                    ; Rende negativo il secondo numero
    MOV AX, BX                ; Muove il secondo numero (negativo) in AX per fare la moltiplicazione
    IMUL CX                   ; Moltiplica BX (negativo) per CX (positivo)
    MOV RIS1, AX              ; Muove il risultato in RIS1
    JMP FineMoltiplicazione   ; Salta a FineMoltiplicazione per stampare il risultato

    ; Caso 4: Entrambi negativi
EntrambiNegativi3:
    MOV AX, BX                ; Muove il primo numero in AX per fare la moltiplicazione
    IMUL CX                   ; Moltiplica i due numeri negativi
    MOV RIS1, AX              ; Muove il risultato in RIS1

FineMoltiplicazione:
    POP BX                    ; Ripristina il valore di BX
    POP CX                    ; Ripristina il valore di CX

    JMP Conv_opp              ; Salto per stampare il risultato
    
;-------------------------------------------------------------------------------                                         
;Divisione
;------------------------------------------------------------------------------- 
   
Divisione:
    PUSH BX                   ; Salvo lo stato di BX
    PUSH CX                   ; Salvo lo stato di CX

    MOV BX, 0                 ; Svuota BX per eseguire le operazioni
    MOV CX, 0                 ; Svuota CX per eseguire le operazioni
    MOV DX, 0                 ; Svuota DX per gestire eventuali resto nella divisione

    MOV BX, VAR1              ; Muove il primo numero in BX per eseguire la divisione
    MOV CX, VAR2              ; Muove il secondo numero in CX per eseguire la divisione
    CMP SEGNO1, '-'           ; Controlla se il primo numero e' negativo
    JE PrimoNegativo4         ; Salta all'operazione con il primo numero negativo
    CMP SEGNO2, '-'           ; Controlla se il secondo numero e' negativo
    JE SecondoNegativo4       ; Salta all'operazione con il secondo numero negativo

    ; Caso 1: Entrambi positivi      
    MOV AX, BX                ; Muove il primo numero in AX per eseguire la divisione
    IDIV CX                   ; Esegui la divisione di AX per CX, risultato in AX e resto in DX
    MOV RIS1, AX              ; Muove il quoziente in RIS1
    JMP FineDivisione         ; Salta a FineDivisione per stampare il risultato

    ; Caso 2: Primo negativo, secondo positivo 
PrimoNegativo4:
    CMP SEGNO2, '-'           ; Controlla se il secondo numero e' negativo
    JE EntrambiNegativi4      ; Se anche il secondo numero e' negativo, salta all'operazione con entrambi negativi

    MOV AX, BX                ; Muove il primo numero in AX per eseguire la divisione
    IDIV CX                   ; Esegui la divisione di AX per CX, risultato in AX e resto in DX
    NEG AX                    ; Rende negativo il quoziente
    MOV RIS1, AX              ; Muove il risultato in RIS1
    JMP FineDivisione         ; Salta a FineDivisione per stampare il risultato

    ; Caso 3: Primo positivo, secondo negativo
SecondoNegativo4:
    NEG CX                    ; Rende negativo il secondo numero
    MOV AX, BX                ; Muove il primo numero in AX per eseguire la divisione
    IDIV CX                   ; Esegui la divisione di AX per CX, risultato in AX e resto in DX
    MOV RIS1, AX              ; Muove il quoziente in RIS1
    JMP FineDivisione         ; Salta a FineDivisione per stampare il risultato

    ; Caso 4: Entrambi negativi
EntrambiNegativi4:
    MOV AX, BX                ; Muove il primo numero in AX per eseguire la divisione
    IDIV CX                   ; Esegui la divisione di AX per CX, risultato in AX e resto in DX
    MOV RIS1, AX              ; Muove il quoziente in RIS1

FineDivisione:
    POP BX                    ; Ripristina il valore di BX
    POP CX                    ; Ripristina il valore di CX

    JMP Conv_opp              ; Salto per stampare il risultato
 
;-------------------------------------------------------------------------------  
; Operazoini avanzate
;------------------------------------------------------------------------------- 
; Radici 
;------------------------------------------------------------------------------- 
; Procedura per calcolare la radice quadrata
Radice2:
    MOV AH, 09H            ; Mostra il messaggio
    LEA DX, MSG1           ; Carica l'indirizzo del messaggio in DX
    INT 21H                ; Interrompe per stampare il messaggio
    CALL LeggiNumero       ; Chiede all'utente di inserire un numero
    MOV VAR1, AX           ; Salva il numero inserito in VAR1
    
    PUSH BX                ; Salva lo stato di BX
    PUSH CX                ; Salva lo stato di CX
    PUSH DX                ; Salva lo stato di DX
    
    MOV AX, VAR1           ; Muove il numero di cui calcolare la radice in AX
    MOV BX, 1              ; Inizializza il contatore (X) a 1
    
Ciclo_Radice:
    MOV AX, BX             ; Metti il contatore in AX per la moltiplicazione
    IMUL BX                ; Esegui AX = AX * BX (il quadrato del contatore)
    
    CMP AX, VAR1           ; Confronta il quadrato con il numero originale
    JA Trovato             ; Se il quadrato e' maggiore, abbiamo superato la radice
    JE Trovato_Esatto      ; Se e' uguale, abbiamo trovato la radice esatta
    
    INC BX                 ; Incrementa il contatore
    JMP Ciclo_Radice       ; Continua il ciclo
    
Trovato_Esatto:
    MOV RIS1, BX           ; Se il quadrato e' uguale, salviamo il contatore come risultato
    JMP Fine_Radice        ; Salta alla fine per stampare il risultato
    
Trovato:
    DEC BX                 ; Se il quadrato e' maggiore, decrementa il contatore per ottenere l'ultimo valore valido
    MOV RIS1, BX           ; Salva il risultato in RIS1
    
Fine_Radice:
    POP DX                 ; Ripristina il valore di DX
    POP CX                 ; Ripristina il valore di CX
    POP BX                 ; Ripristina il valore di BX
    JMP Stampa_ris_radice  ; Vai alla procedura per stampare il risultato
; Procedure per la radice cubica
    
Radice3:
    MOV AH, 09H            ; Mostra il messaggio
    LEA DX, MSG1           ; Carica l'indirizzo del messaggio in DX
    INT 21H                ; Interrompe per stampare il messaggio
    CALL LeggiNumero       ; Chiede all'utente di inserire un numero
    MOV VAR1, AX           ; Salva il numero inserito in VAR1
    
    PUSH BX                ; Salva lo stato di BX
    PUSH CX                ; Salva lo stato di CX
    PUSH DX                ; Salva lo stato di DX
    
    MOV AX, VAR1           ; Muove il numero di cui calcolare la radice cubica in AX
    MOV BX, 1              ; Inizializza il contatore (X) a 1
    
Ciclo_Radice3:
    MOV AX, BX             ; Metti il contatore in AX per la moltiplicazione
    IMUL BX                ; Esegui AX = BX * BX (quadrato del contatore)
    IMUL BX                ; Esegui AX = BX * BX * BX (cubo del contatore)
    
    CMP AX, VAR1           ; Confronta il cubo con il numero originale
    JA Trovato3            ; Se il cubo e' maggiore, abbiamo superato la radice cubica
    JE Trovato3_Esatto     ; Se e' uguale, abbiamo trovato la radice esatta
    
    INC BX                 ; Incrementa il contatore
    JMP Ciclo_Radice3      ; Continua il ciclo
    
Trovato3_Esatto:
    MOV RIS1, BX           ; Se il cubo e' uguale, salviamo il contatore come risultato
    JMP Fine_Radice3       ; Salta alla fine per stampare il risultato
    
Trovato3:
    DEC BX                 ; Se il cubo e' maggiore, decrementa il contatore per ottenere l'ultimo valore valido
    MOV RIS1, BX           ; Salva il risultato in RIS1
    
Fine_Radice3:
    POP DX                 ; Ripristina il valore di DX
    POP CX                 ; Ripristina il valore di CX
    POP BX                 ; Ripristina il valore di BX
    JMP Stampa_ris_radice  ; Vai alla procedura per stampare il risultato

;------------------------------------------------------------------------------- 
;Logaritmo
;------------------------------------------------------------------------------- 
Log:
    MOV AH, 09H
    LEA DX, MSG9      ; Messaggio per inserire la base
    INT 21H
    CALL LeggiNumero  ; Legge la base
    MOV VAR1, AX      ; Salva la base in VAR1
    
    MOV AH, 09H
    LEA DX, MSG1      ; Messaggio per inserire il numero
    INT 21H
    CALL LeggiNumero  ; Legge il numero in VAR2
    MOV VAR2, AX      ; Salva il numero in VAR2
    
    ; Inizializzazione
    MOV CX, 0         ; CX sarà l'esponente
    MOV AX, 1         ; AX = 1 (valore iniziale della potenza)
    MOV BX, VAR1      ; BX = base
    
Ciclo_Log:
    CMP AX, VAR2      ; Confronta la potenza attuale con il numero
    JA Fine_Log       ; Se la potenza supera il numero, termina
    JE Fine_Log       ; Se la potenza e' uguale, termina
    
    MUL BX            ; AX = AX * base
    INC CX            ; Incrementa l'esponente
    JMP Ciclo_Log     ; Continua il ciclo
    
Fine_Log:
    MOV RIS1, CX      ; Salva il risultato
    JMP Stampa_ris_log ; Vai alla stampa del risultato

;------------------------------------------------------------------------------- 
;Esponenziale
;-------------------------------------------------------------------------------
Esponenziale:
    MOV AH, 09H
    LEA DX, MSG6      ; Stampa messaggio "Inserisci la base: "
    INT 21H
    CALL LeggiNumero  ; Legge il numero inserito dall'utente
    MOV VAR1, AX      ; Salva la base in VAR1
    
    MOV AH, 09H
    LEA DX, MSG7      ; Stampa messaggio "Inserisci l'esponente: "
    INT 21H
    CALL LeggiNumero  ; Legge il numero inserito dall'utente
    MOV VAR2, AX      ; Salva l'esponente in VAR2

    PUSH BX
    PUSH CX

    ; Inizializzazione
    MOV AX, 1         ; Il risultato parte da 1
    MOV BX, VAR1      ; BX = base
    MOV CX, VAR2      ; CX = esponente

    CMP CX, 0         ; Se esponente = 0, salta alla stampa diretta di "1"
    JE Stampa_ris_esp 

Ciclo_esp:
    MUL BX            ; AX = AX * base
    DEC CX            ; Decrementa CX (esponente)
    JNZ Ciclo_esp     ; Se CX diverso da 0, continua il ciclo
    JMP Stampa_ris_esp
;------------------------------------------------------------------------------- 
;Stampa del risultato
;------------------------------------------------------------------------------- 

;Convertire operatore nel segno adatto
Conv_opp:
    CMP OPERATORE, '1'     ; Controlla se e' stata fatto un addizione
    JE AD                  ; Salta a AD 
    
    CMP OPERATORE, '2'     ; Controlla se e' stata fatto una sottrazione
    JE SO                  ; Salta a SO 
    
    CMP OPERATORE, '3'     ; Controlla se e' stata fatto un moltiplicazioe
    JE MU                  ; Salta a MU
    
    CMP OPERATORE, '4'     ; Controlla se e' stata fatto una divisione
    JE DV                  ; Salta a DV 
    
AD:
    MOV AL, '+'            ; Carica il segno + in AL
    MOV OPERATORE, AL      ; Muove il segno caricato in AL per stamparlo
    JMP Stampa_ris         ; Salta alla stampa del risultato
SO: 
    MOV AL, '-'
    MOV OPERATORE, AL      ; Carica il segno - in AL
    JMP Stampa_ris         ; Muove il segno caricato in AL per stamparlo
MU:                        ; Salta alla stampa del risultato
    MOV AL, '*'
    MOV OPERATORE, AL      ; Carica il segno * in AL
    JMP Stampa_ris         ; Muove il segno caricato in AL per stamparlo
DV:                        ; Salta alla stampa del risultato
    MOV AL, '/'
    MOV OPERATORE, AL      ; Carica il segno / in AL
    JMP Stampa_ris         ; Muove il segno caricato in AL per stamparlo
                           ; Salta alla stampa del risultato
Stampa_ris:
    MOV AH, 09H        ; Stampa il contorno
    LEA DX, MSG_RIS
    INT 21H
    
     ; Vai a capo (Carriage Return + Line Feed)
    MOV DL, 0Dh        ; Carriage Return (CR)
    MOV AH, 02h        ; Funzione di stampa
    INT 21h            ; Stampa il carattere (CR)
    
    MOV DL, 0Ah        ; Line Feed (LF)
    MOV AH, 02h        ; Funzione di stampa
    INT 21h            ; Stampa il carattere (LF)

    MOV DL, SEGNO1     ; Stampa il primo segno
    MOV AH, 02h   
    INT 21h           
    
    MOV AX, VAR1       ; Stampa il primo numero
    CALL Conversione
    
    ; Stampa uno spazio
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa lo spazio 
    
    MOV DL, OPERATORE ; Stampa l'opeatore 
    MOV AH, 02h  
    INT 21h 
    
    ; Stampa uno spazio
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa lo spazio     
    
    MOV DL, SEGNO2    ; Stampa il secondo segno
    MOV AH, 02h   
    INT 21h       
    
    MOV AX, VAR2      ; Stampa il secondo numero
    CALL Conversione
    
    ; Stampa uno spazio
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa lo spazio 
    
    MOV DL, 3Dh       ; Carattere '=' (codice ASCII 3Dh)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa il carattere
    
    ; Stampa uno spazio
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa lo spazio   
    
    MOV AX, RIS1      ; Stampa il risultato
    CALL Conversione 
    
    MOV AH, 09H       ; Stampa il contorno
    LEA DX, MSG_RIS
    INT 21H
    
    JMP Fine 
    
;------------------------------------------------------------------------------- 
;Stampa del risultato per le radici
;-------------------------------------------------------------------------------    
Stampa_ris_radice:
    MOV AH, 09H
    LEA DX, MSG_RIS
    INT 21H
    
    MOV AH, 09H
    LEA DX, MSG5
    INT 21H

    MOV DL, SEGNO1  
    MOV AH, 02h   
    INT 21h       
    
    MOV AX, VAR1
    CALL Conversione
    
    ; Stampa uno spazio
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa lo spazio 

    MOV DL, 3Dh       ; Carattere '=' (codice ASCII 3Dh)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa il carattere
    
    ; Stampa uno spazio
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa lo spazio   
    
    MOV AX, RIS1
    CALL Conversione 
    
    MOV AH, 09H
    LEA DX, MSG_RIS
    INT 21H
    
    JMP Fine

;------------------------------------------------------------------------------- 
;Stampa del risultato per esponenziale
;-------------------------------------------------------------------------------        
Stampa_ris_esp:
    MOV RIS1, AX      ; Salva il risultato

    MOV AH, 09H
    LEA DX, MSG_RIS
    INT 21H
         
    ; Vai a capo (Carriage Return + Line Feed)
    MOV DL, 0Dh        ; Carriage Return (CR)
    MOV AH, 02h        ; Funzione di stampa
    INT 21h            ; Stampa il carattere (CR)
    
    MOV DL, 0Ah        ; Line Feed (LF)
    MOV AH, 02h        ; Funzione di stampa
    INT 21h            ; Stampa il carattere (LF)

    MOV AX, VAR1
    CALL Conversione  ; Stampa la base
    
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa lo spazio 
    
    MOV DL, 5Eh       ; Carattere '^' (codice ASCII 5Eh)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa il carattere
    
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa lo spazio 
    
    MOV AX, VAR2
    CALL Conversione  ; Stampa l'esponente
    
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa lo spazio 
    
    MOV DL, 3Dh       ; Carattere '=' (codice ASCII 3Dh)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa il carattere
    
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa lo spazio  
    
    MOV AX, RIS1
    CALL Conversione  ; Stampa la base
    
    MOV AH, 09H
    LEA DX, MSG_RIS
    INT 21H
    
    JMP Fine
    
;------------------------------------------------------------------------------- 
;Stampa del risultato per logaritmo
;-------------------------------------------------------------------------------
Stampa_ris_log:
    MOV AH, 09H
    LEA DX, MSG_RIS
    INT 21H
    
    MOV AH, 09H
    LEA DX, MSG10
    INT 21H                    
    
    MOV AX, VAR1
    CALL Conversione  ; Stampa la base
    
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h
                       
    MOV DL, 64h       ; Carattere ASCII per d (64h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa lo spazio
    
    MOV DL, 69h       ; Carattere ASCII per i (69h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa lo spazio
    
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h
    
    MOV AX, VAR2
    CALL Conversione  ; Stampa il numero  
    
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h
    
    MOV DL, 3Dh       ; Carattere '=' (codice ASCII 3Dh)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa il carattere
    
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h
    
    MOV AX, RIS1
    CALL Conversione  ; Stampa la base
    
    MOV AH, 09H
    LEA DX, MSG_RIS
    INT 21H
    

Fine:
    MOV AH, 4CH        
    INT 21h  


;-------------------------------------------------------------------------------
;Procedure di supporto 
;-------------------------------------------------------------------------------   

; Procedura per leggere i numeri
    
LeggiNumero PROC 
    PUSH BX         ; Salva il registro BX (usato per accumulare il risultato)
    PUSH CX         ; Salva il registro CX (usato come variabile temporanea)
    
    MOV BX, 0      ; Inizializza BX a 0 (accumulatore per il numero)
    
LeggiCifra:
    MOV AH, 01h    ; Interrompe per leggere un carattere (funzione INT 21h, AH = 01h)
    INT 21h        ; Int 21h, funzione 01h legge un carattere da tastiera
    
    CMP AL, 13     ; Confronta AL (il carattere letto) con il valore 13 (carattere di ritorno a capo, Enter)
    JE FineLeggi   ; Se e' 13 (Enter), finisce la lettura
    
    SUB AL, '0'    ; Converte il carattere ASCII in un numero (es. '5' diventa 5)
    MOV CL, AL     ; Salva la cifra in CL (registro temporaneo)
    
    MOV AX, 10     ; Inizializza AX con 10 per moltiplicare per 10
    MUL BX         ; Moltiplica BX (numero parziale) per 10
    MOV BX, AX     ; Salva il risultato in BX (aggiorna il numero parziale)
    
    ADD BL, CL     ; Aggiunge la cifra letta a BL (l'ultima posizione del numero parziale)
    JMP LeggiCifra ; Continua a leggere la prossima cifra
    
FineLeggi:
    MOV AX, BX     ; Salva il numero finale in AX
    
    POP CX         ; Ripristina il valore di CX
    POP BX         ; Ripristina il valore di BX
    RET            ; Ritorna dalla procedura
LeggiNumero ENDP


; Procedura per stampare numeri negativo

Conversione PROC 
    PUSH BX           ; Salva il registro BX
    PUSH CX           ; Salva il registro CX
    PUSH DX           ; Salva il registro DX
    
    TEST AX, 8000h    ; Testa il bit piu' significativo di AX (se e' 1, il numero e' negativo)
    JZ NumeroPositivo ; Se il bit piu' significativo e' 0, il numero e' positivo, salta al caso positivo
    
    PUSH AX           ; Salva AX (numero negativo) sulla pila
    MOV DL, '-'       ; Carica il carattere '-' in DL (simbolo negativo)
    MOV AH, 02h       ; Funzione INT 21h per stampare un carattere
    INT 21h           ; Stampa il carattere '-'
    POP AX            ; Ripristina AX (numero negativo)
    NEG AX            ; Rende il numero positivo (negativo diventa positivo)
    
NumeroPositivo:    
    MOV CX, 0         ; Azzeramento di CX (contatore per le cifre)
    MOV BX, 10        ; Imposta il divisore a 10 per ottenere le cifre
    
DividiNum:
    MOV DX, 0         ; Azzeramento di DX (necessario per DIV)
    DIV BX            ; Divide AX per 10 (AX = AX / 10, resto in DX)
    ADD DX, 48        ; Converte il resto (digit) in un carattere ASCII (aggiungendo '0')
    PUSH DX           ; Salva il carattere sulla pila
    INC CX            ; Incrementa il contatore delle cifre
    OR AX, AX         ; Verifica se il risultato della divisione e' zero
    JNZ DividiNum     ; Se AX non e' zero, continua a dividere
    
StampaNum:    
    POP DX            ; Preleva il carattere dalla pila
    MOV AH, 02h       ; Funzione INT 21h per stampare un carattere
    INT 21h           ; Stampa il carattere
    LOOP StampaNum    ; Ripete per tutte le cifre (CX = numero di cifre)
    
    POP DX            ; Ripristina il valore di DX
    POP CX            ; Ripristina il valore di CX
    POP BX            ; Ripristina il valore di BX
    RET               ; Ritorna dalla procedura
Conversione ENDP