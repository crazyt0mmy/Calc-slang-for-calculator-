.MODEL SMALL
.STACK 100h
 
;------------------------------------------------------------------------------------------
; SEZIONE DATI
; Qui definiamo tutte le variabili e i messaggi utilizzati nel programma
;------------------------------------------------------------------------------------------

.DATA 
   ; Variabili per i numeri e le operazioni
   VAR1 DW ?            ; Primo numero (16 bit per numeri fino a 65535)
   VAR2 DW ?            ; Secondo numero (16 bit per numeri fino a 65535)
   SEGNO1 DB ?          ; Memorizza il segno del primo numero 
   SEGNO2 DB ?          ; Memorizza il segno del secondo numero
   OPERATORE DB ?       ; Memorizza l'operatore scelto (+, -, *, /)
   RIS1 DW ?            ; Risultato dell'operazione prima della conversione
   RIS2 DW ?            ; Risultato dell'operazione dopo la conversione
   
   ; Messaggi per l'interfaccia utente
   MSG_OPP DB 0Dh, 0Ah, '*Inserire quale operazione si vuole eseguire (+,-,*,/):  $' 
   MSG1 DB 0Dh, 0Ah, '*Inserire il primo numero (65535): $'
   MSG2 DB 0Dh, 0Ah, '*Inserire il secondo numero: $'
   MSG_RIS DB 0Dh, 0Ah, '*Il risultato corrisponde a: $'
   MSG_ERR1 DB 0Dh, 0Ah, '*Operatore errato, inserirne un operatore valido: $'
   CONTORNO DB '------------------------CALCOLATRICE------------------------$'

;------------------------------------------------------------------------------------------
; INIZIO DEL CODICE PRINCIPALE
;------------------------------------------------------------------------------------------

.CODE
.STARTUP 
    ; Inizializzazione del segmento dati
    MOV AX, @DATA
    MOV DS, AX 
    
    ; Visualizza l'interfaccia grafica
    MOV AH, 09H
    LEA DX, CONTORNO
    INT 21H 

;------------------------------------------------------------------------------------------
; SEZIONE SELEZIONE OPERATORE
; Gestisce l'input e la validazione dell'operatore matematico
;------------------------------------------------------------------------------------------ 

Richiedi_Operatore:
    ; Visualizza il messaggio per la scelta dell'operatore
    MOV AH, 09H
    LEA DX, MSG_OPP
    INT 21H 
    
    ; Legge l'operatore    
    MOV AH, 01H
    INT 21H
    MOV OPERATORE, AL    
    
    ; Verifica che l'operatore sia valido
    CMP AL, '+'
    JE Leggi_Numeri
     
    CMP AL, '-'
    JE Leggi_Numeri
    
    CMP AL, '*'
    JE Leggi_Numeri 
    
    CMP AL, '/'
    JE Leggi_Numeri
    
    ; Se l'operatore non e' valido, mostra errore e richiedi nuovo input
    MOV AH, 09H
    LEA DX, MSG_ERR1
    INT 21H
    JMP Richiedi_Operatore

;------------------------------------------------------------------------------------------
; SEZIONE LETTURA NUMERI
; Gestisce l'input dei due numeri su cui eseguire l'operazione
;------------------------------------------------------------------------------------------

Leggi_Numeri:
    ; Lettura primo numero
    MOV AH, 09H
    LEA DX, MSG1
    INT 21H
    CALL LeggiNumero
    MOV VAR1, AX
    
    ; Lettura secondo numero
    MOV AH, 09H
    LEA DX, MSG2
    INT 21H
    CALL LeggiNumero
    MOV VAR2, AX
    
    ; Determina quale operazione eseguire
    MOV AL, OPERATORE
    
    CMP AL, '+'
    JE Addizione 
    
    CMP AL, '-'
    JE Sottrazione
    
    CMP AL, '*'
    JE Moltiplicazione 
    
    CMP AL, '/'
    JE Divisione

;------------------------------------------------------------------------------------------
; SEZIONE OPERAZIONI MATEMATICHE
; Contiene tutte le operazioni matematiche possibili
;------------------------------------------------------------------------------------------

Addizione: 
    MOV AX, VAR1
    ADD AX, VAR2
    MOV RIS1, AX
    JMP Stampa_ris
        
Sottrazione:
    MOV AX, VAR1
    SUB AX, VAR2
    MOV RIS1, AX
    JMP Stampa_ris
    
Moltiplicazione: 
    MOV AX, VAR1
    MUL VAR2        ; Risultato in DX:AX
    MOV RIS1, AX     ; Salva solo la parte bassa
    JMP Stampa_ris
    
Divisione:
    MOV DX, 0       ; Pulisce DX per la divisione
    MOV AX, VAR1
    DIV VAR2        ; Quoziente in AX, resto in DX
    MOV RIS1, AX
    JMP Stampa_ris

;------------------------------------------------------------------------------------------
; PROCEDURE DI SUPPORTO
; Contiene le procedure utilizzate dal programma
;------------------------------------------------------------------------------------------ 

; Procedura per leggere numeri multi-cifra
LeggiNumero PROC 
    PUSH BX         ; Salva i registri
    PUSH CX
    
    MOV BX, 0       ; Inizializza il risultato
    
LeggiCifra:
    MOV AH, 01h     ; Legge un carattere
    INT 21h
    
    CMP AL, 13      ; Se è Invio, termina
    JE FineLeggi
    
    SUB AL, '0'     ; Converte da ASCII a numero
    MOV CL, AL
    
    MOV AX, 10      ; Moltiplica per 10 il numero corrente
    MUL BX
    MOV BX, AX
    
    ADD BL, CL      ; Aggiunge la nuova cifra
    
    JMP LeggiCifra

FineLeggi:
    MOV AX, BX      ; Prepara il risultato
    
    POP CX          ; Ripristina i registri
    POP BX
    RET
LeggiNumero ENDP 


;Procedure per convertire il risultato da ASCII in un risultato numerico
Conversione PROC 
    
    

;------------------------------------------------------------------------------------------
; SEZIONE STAMPA RISULTATO
; Gestisce la visualizzazione del risultato
;------------------------------------------------------------------------------------------

Stampa_ris:
    MOV AH, 09H
    LEA DX, MSG_RIS
    INT 21H   
    
    ;Il risultato viene convertito per stamparlo 
    MOV AX, RIS1
    CALL Conversione 
    
    JMP Fine
    
;------------------------------------------------------------------------------------------
; SEZIONE FINE PROGRAMMA
; Gestisce la terminazione del programma
;------------------------------------------------------------------------------------------ 

Fine:
    MOV AH, 4CH        
    INT 21h   
    
END