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
   MSG_RIS DB 0Dh, 0Ah, '+--------------------------+ $'
   MSG_ERR1 DB 0Dh, 0Ah, 'Operatore errato, inserirne un operatore valido: $'
   CONTORNO DB '------------------------CALCOLATRICE------------------------$'    
   
    
   
.CODE
.STARTUP 
    MOV AX, @DATA
    MOV DS, AX 
    
    MOV AH, 09H
    LEA DX, CONTORNO
    INT 21H      
    
;-------------------------------------------------------------------------------
;Richiesta operatore per operazione
;-------------------------------------------------------------------------------

Richiedi_Operatore:
    MOV AH, 09H
    LEA DX, MSG_OPP1
    INT 21H  
    
    MOV AH, 09H
    LEA DX, MSG_OPP2
    INT 21H 
    
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
    
    MOV AH, 01H
    INT 21H
    MOV OPERATORE, AL    
    
    CMP AL, '1'
    JE Leggi_Numeri
     
    CMP AL, '2'
    JE Leggi_Numeri
    
    CMP AL, '3'
    JE Leggi_Numeri 
    
    CMP AL, '4'
    JE Leggi_Numeri 
      
    CMP AL, '5'
    JE Leggi_Numeri
      
    CMP AL, '6'
    JE Leggi_Numeri
      
    CMP AL, '7'
    JE Leggi_Numeri
      
    CMP AL, '8'
    JE Esponenziale
    
    MOV AH, 09H
    LEA DX, MSG_ERR1
    INT 21H
    JMP Richiedi_Operatore
    
;-------------------------------------------------------------------------------
;Lettura dei numeri e rispettivo segno 
;-------------------------------------------------------------------------------

Leggi_Numeri:
    MOV AH, 09H
    LEA DX, MSG3
    INT 21H
    
    MOV AH, 01H
    INT 21H
    MOV SEGNO1, AL

    MOV AH, 09H
    LEA DX, MSG1
    INT 21H
    CALL LeggiNumero
    MOV VAR1, AX
    
    CMP OPERATORE, '5'
    JE Radice2
    CMP OPERATORE, '6'
    JE Radice3
    
    MOV AH, 09H
    LEA DX, MSG4
    INT 21H
    
    MOV AH, 01H
    INT 21H
    MOV SEGNO2, AL     
    
    MOV AH, 09H
    LEA DX, MSG2
    INT 21H
    CALL LeggiNumero
    MOV VAR2, AX
    
    MOV AL, OPERATORE
    
    CMP OPERATORE, '1'
    JE Addizione 
    
    CMP OPERATORE, '2'
    JE Sottrazione
    
    CMP OPERATORE, '3'
    JE Moltiplicazione 
    
    CMP OPERATORE, '4'
    JE Divisione 
    
;-------------------------------------------------------------------------------
;Addizione
;-------------------------------------------------------------------------------

Addizione: 
    PUSH CX
    PUSH BX
    MOV CX, 0 
    MOV BX, 0
    
    MOV BX, VAR1
    MOV CX, VAR2
    CMP SEGNO1, '-'
    JE PrimoNegativo
    CMP SEGNO2, '-'
    JE SecondoNegativo
    
    ; Caso 1: Entrambi positivi
    ADD BX, CX 
    MOV RIS1, BX
    JMP FineAddizione
    
PrimoNegativo:
    CMP SEGNO2, '-'
    JE EntrambiNegativi
    
    ; Caso 2: Primo negativo, secondo positivo 
    NEG BX
    ADD CX, BX
    MOV RIS1, CX
    JMP FineAddizione
    
SecondoNegativo:
    ; Caso 3: Primo positivo, secondo negativo 
    NEG CX
    ADD BX, CX 
    MOV RIS1, BX
    JMP FineAddizione
    
EntrambiNegativi:
    ; Caso 4: Entrambi negativi 
    NEG BX 
    NEG CX
    ADD BX, CX
    MOV RIS1, BX
    
FineAddizione: 
    POP BX
    POP CX
    JMP Conv_opp  
    
;-------------------------------------------------------------------------------
;Sottrazione
;------------------------------------------------------------------------------- 
      
Sottrazione:  
    PUSH CX
    PUSH BX
    MOV BX, 0
    MOV CX, 0
    
    MOV BX, VAR1 
    MOV CX, VAR2
    CMP SEGNO1, '-'
    JE PrimoNegativo2
    CMP SEGNO2, '-'
    JE SecondoNegativo2
    
    ; Caso 1: Entrambi positivi
    SUB BX, CX 
    MOV RIS1, BX
    JMP FineSottrazione
    
PrimoNegativo2:
    CMP SEGNO2, '-'
    JE EntrambiNegativi2
    
    ; Caso 2: Primo negativo, secondo positivo 
    NEG BX
    SUB CX, BX
    NEG CX
    MOV RIS1, CX
    JMP FineSottrazione
    
SecondoNegativo2:
    ; Caso 3: Primo positivo, secondo negativo 
    ADD BX, CX 
    MOV RIS1, BX
    JMP FineSottrazione
    
EntrambiNegativi2:
    ; Caso 4: Entrambi negativi 
    NEG BX
    ADD BX, CX
    MOV RIS1, BX
    
FineSottrazione: 
    POP BX
    POP CX
    JMP Conv_opp  
    
;-------------------------------------------------------------------------------
;Moltiplicazione
;------------------------------------------------------------------------------- 
  
Moltiplicazione:
    PUSH BX
    PUSH CX
 
    MOV BX, 0
    MOV CX, 0
    
    MOV BX, VAR1 
    MOV CX, VAR2 
    CMP SEGNO1, '-'
    JE PrimoNegativo3
    CMP SEGNO2, '-'
    JE SecondoNegativo3 
    
    ; Caso 1: Entrambi positivi
    MOV AX, BX       
    IMUL CX      
    MOV RIS1, AX     
    JMP FineMoltiplicazione
    
     ; Caso 2: Primo negativo, secondo positivo
PrimoNegativo3:
    CMP SEGNO2, '-'   
    JE EntrambiNegativi3

    NEG BX            
    MOV AX, BX        
    IMUL CX       
    MOV RIS1, AX     
    JMP FineMoltiplicazione 
    
    ; Caso 3: Primo positivo, secondo negativo
SecondoNegativo3:

    NEG BX            
    MOV AX, BX        
    IMUL CX       
    MOV RIS1, AX     
    JMP FineMoltiplicazione 
    
    ; Caso 4: Entrambi negativi
EntrambiNegativi3:
    MOV AX, BX        
    IMUL CX        
    MOV RIS1, AX      
    
FineMoltiplicazione:
    POP BX
    POP CX
         
    JMP Conv_opp
    
;-------------------------------------------------------------------------------                                         
;Divisione
;------------------------------------------------------------------------------- 
   
Divisione:
    PUSH BX
    PUSH CX

    MOV BX, 0
    MOV CX, 0
    MOV DX, 0  

    MOV BX, VAR1 
    MOV CX, VAR2 
    CMP SEGNO1, '-'
    JE PrimoNegativo4
    CMP SEGNO2, '-'
    JE SecondoNegativo4
    
    ; Caso 1: Entrambi positivi      
    MOV AX, BX
    IDIV CX
    MOV RIS1, AX
    JMP FineDivisione
    
    ; Caso 2: Primo negativo, secondo positivo 
PrimoNegativo4:
    CMP SEGNO2, '-'   
    JE EntrambiNegativi4
            
    MOV AX, BX        
    IDIV CX
    NEG AX       
    MOV RIS1, AX     
    JMP FineDivisione
    
    ; Caso 3: Primo positivo, secondo negativo
SecondoNegativo4:    
    NEG CX            
    MOV AX, BX        
    IDIV CX       
    MOV RIS1, AX     
    JMP FineDivisione

    ; Caso 4: Entrambi negativi
EntrambiNegativi4:
    MOV AX, BX        
    IDIV CX        
    MOV RIS1, AX      
    
FineDivisione:
    POP BX
    POP CX
         
    JMP Conv_opp
 
;-------------------------------------------------------------------------------  
; Operazoini avanzate
;------------------------------------------------------------------------------- 
; Radici 
;------------------------------------------------------------------------------- 
; Procedura per calcolare la radice quadrata
Radice2:
    PUSH BX          ; Salva i registri che useremo
    PUSH CX
    PUSH DX
    
    MOV AX, VAR1     ; Numero di cui calcolare la radice
    MOV BX, 1        ; Contatore che incrementeremo (la nostra X)
    
Ciclo_Radice:
    MOV AX, BX       ; Metti il contatore in AX per la moltiplicazione
    IMUL BX          ; AX = AX * BX (il quadrato del contatore)
    
    CMP AX, VAR1     ; Confronta il quadrato con il numero originale
    JA Trovato       ; Se è maggiore, abbiamo superato la radice
    JE Trovato_Esatto; Se è uguale, abbiamo trovato la radice esatta
    
    INC BX           ; Incrementa il contatore
    JMP Ciclo_Radice ; Continua il ciclo
    
Trovato_Esatto:
    MOV RIS1, BX     ; Salva il risultato
    JMP Fine_Radice
    
Trovato:
    DEC BX           ; Decrementa BX per ottenere l'ultimo valore valido
    MOV RIS1, BX     ; Salva il risultato
    
Fine_Radice:
    POP DX           ; Ripristina i registri
    POP CX
    POP BX
    JMP Stampa_ris_radice   ; Vai alla stampa del risultato

; Procedure per la radice cubica
    
Radice3:
    PUSH BX          ; Salva i registri che useremo
    PUSH CX
    PUSH DX
    
    MOV AX, VAR1     ; Numero di cui calcolare la radice cubica
    MOV BX, 1        ; Contatore che incrementeremo (la nostra X)
    
Ciclo_Radice3:
    MOV AX, BX       ; Metti il contatore in AX per la moltiplicazione
    IMUL BX          ; AX = BX * BX (quadrato del contatore)
    IMUL BX          ; AX = BX * BX * BX (cubo del contatore)
    
    CMP AX, VAR1     ; Confronta il cubo con il numero originale
    JA Trovato3      ; Se è maggiore, abbiamo superato la radice
    JE Trovato3_Esatto; Se è uguale, abbiamo trovato la radice esatta
    
    INC BX           ; Incrementa il contatore
    JMP Ciclo_Radice3 ; Continua il ciclo
    
Trovato3_Esatto:
    MOV RIS1, BX     ; Salva il risultato
    JMP Fine_Radice3
    
Trovato3:
    DEC BX           ; Decrementa BX per ottenere l'ultimo valore valido
    MOV RIS1, BX     ; Salva il risultato
    
Fine_Radice3:
    POP DX           ; Ripristina i registri
    POP CX
    POP BX
    JMP Stampa_ris_radice   ; Vai alla stampa del risultato

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
    CMP OPERATORE, '1'
    JE AD
    
    CMP OPERATORE, '2'
    JE SO
    
    CMP OPERATORE, '3'
    JE MU
    
    CMP OPERATORE, '4'
    JE DV
    
AD:
    MOV AL, '+'
    MOV OPERATORE, AL
    JMP Stampa_ris
SO: 
    MOV AL, '-'
    MOV OPERATORE, AL
    JMP Stampa_ris
MU:
    MOV AL, '*'
    MOV OPERATORE, AL 
    JMP Stampa_ris
DV:    
    MOV AL, '/'
    MOV OPERATORE, AL
    JMP Stampa_ris
    
Stampa_ris:
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

    MOV DL, SEGNO1  
    MOV AH, 02h   
    INT 21h       
    
    MOV AX, VAR1
    CALL Conversione
    
    ; Stampa uno spazio
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa lo spazio 
    
    MOV DL, OPERATORE  
    MOV AH, 02h  
    INT 21h 
    
    ; Stampa uno spazio
    MOV DL, 20h       ; Carattere ASCII per lo spazio (20h)
    MOV AH, 02h       ; Funzione di stampa
    INT 21h           ; Stampa lo spazio     
    
    MOV DL, SEGNO2  
    MOV AH, 02h   
    INT 21h       
    
    MOV AX, VAR2
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

Fine:
    MOV AH, 4CH        
    INT 21h  


;-------------------------------------------------------------------------------
;Procedure di supporto 
;-------------------------------------------------------------------------------   

; Procedura per leggere i numeri
    
LeggiNumero PROC 
    PUSH BX         
    PUSH CX
    
    MOV BX, 0       
    
LeggiCifra:
    MOV AH, 01h     
    INT 21h
    
    CMP AL, 13      
    JE FineLeggi
    
    SUB AL, '0'     
    MOV CL, AL
    
    MOV AX, 10      
    MUL BX
    MOV BX, AX
    
    ADD BL, CL      
    JMP LeggiCifra
    
FineLeggi:
    MOV AX, BX      
    
    POP CX          
    POP BX
    RET
LeggiNumero ENDP

; Procedura per stampare numeri negativo

Conversione PROC 
    PUSH BX           
    PUSH CX
    PUSH DX
    
    TEST AX, 8000h    
    JZ NumeroPositivo    
    
    PUSH AX           
    MOV DL, '-'       
    MOV AH, 02h       
    INT 21h           
    POP AX            
    NEG AX            
    
NumeroPositivo:    
    XOR CX, CX       
    MOV BX, 10       
    
DividiNum:
    XOR DX, DX       
    DIV BX           
    ADD DX, 48       
    PUSH DX          
    INC CX           
    OR AX, AX        
    JNZ DividiNum    
    
StampaNum:    
    POP DX           
    MOV AH, 02h      
    INT 21h          
    LOOP StampaNum   
    
    POP DX           
    POP CX
    POP BX
    RET              
Conversione ENDP
