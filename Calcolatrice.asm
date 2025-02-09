.MODEL SMALL
.STACK 100h
 
.DATA 
   VAR1 DW ?            
   VAR2 DW ?            
   SEGNO1 DB ?          
   SEGNO2 DB ?          
   OPERATORE DB ?       
   RIS1 DW ?            
   
   MSG_OPP DB 0Dh, 0Ah, '*Inserire quale operazione si vuole eseguire (+,-,*,/):  $' 
   MSG1 DB 0Dh, 0Ah, '*Inserire il primo numero: $'
   MSG2 DB 0Dh, 0Ah, '*Inserire il secondo numero: $'
   MSG3 DB 0Dh, 0Ah, '*Inserire il segno del primo numero (+,-): $'
   MSG4 DB 0Dh, 0Ah, '*Inserire il segno del secondo numero (+,-): $'
   MSG_RIS DB 0Dh, 0Ah, '*Il risultato corrisponde a: $'
   MSG_ERR1 DB 0Dh, 0Ah, '*Operatore errato, inserirne un operatore valido: $'
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
    LEA DX, MSG_OPP
    INT 21H 
    
    MOV AH, 01H
    INT 21H
    MOV OPERATORE, AL    
    
    CMP AL, '+'
    JE Leggi_Numeri
     
    CMP AL, '-'
    JE Leggi_Numeri
    
    CMP AL, '*'
    JE Leggi_Numeri 
    
    CMP AL, '/'
    JE Leggi_Numeri
    
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
    
    CMP AL, '+'
    JE Addizione 
    
    CMP AL, '-'
    JE Sottrazione
    
    CMP AL, '*'
    JE Moltiplicazione 
    
    CMP AL, '/'
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
    JMP Stampa_ris  
    
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
    JMP Stampa_ris  
    
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
    JE PrimoNegativo3 
    
    MOV AX, BX       
    MUL CX      
    MOV RIS1, AX     
    JMP FineMoltiplicazione
    
PrimoNegativo3:
    CMP SEGNO2, '-'   
    JE EntrambiNegativi3

    NEG BX            
    MOV AX, BX        
    MUL CX       
    MOV RIS1, AX     
    JMP FineMoltiplicazione

    
EntrambiNegativi3:
    MOV AX, BX        
    MUL CX        
    MOV RIS1, AX      
    
FineMoltiplicazione:
    POP BX
    POP CX
         
    JMP Stampa_ris
    
;-------------------------------------------------------------------------------
;Divisione
;-------------------------------------------------------------------------------
    
Divisione:
    MOV DX, 0       
    MOV AX, VAR1
    DIV VAR2        
    MOV RIS1, AX
    JMP Stampa_ris

Stampa_ris:
    MOV AH, 09H
    LEA DX, MSG_RIS
    INT 21H   
    
    MOV AX, RIS1
    CALL Conversione 
    
    JMP Fine
                  
Fine:
    MOV AH, 4CH        
    INT 21h  

;-------------------------------------------------------------------------------
;Procedure di supporto 
;-------------------------------------------------------------------------------   
    
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
