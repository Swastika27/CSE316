.MODEL SMALL 
.STACK 100H
.DATA 
N DW 0
MSG1 DB "ENTER VALUES FOR N AND K: $"
MSG2 DB 0AH, 0DH, "TOTAL NUMBER OF CHOCOLATES SAHIL CAN HAVE IS: $"

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX 
    
    MOV BX, 0H ; BX -> VALUE OF K 
    ; SHOW INPUT PROMPT
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    
    READ_N: ; NEED TO USE A VARIABLE, CANNOT KEEP N IN REGISTER
        MOV AH, 1
        INT 21H
        CMP AL, 30h
        JL READ_K
        CMP AL, 39H
        JA READ_K
    
        SUB AL, 30H
        MOV CL, AL
        MOV CH, 0
        MOV AX, 10
        MOV DX, N
        MUL DX
        MOV DX, AX
        ADD DX, CX
        MOV N, DX
        JMP READ_N
    
     
    ;TAKE INPUT K. KEEP READING A CHAR UNTIL A NON-DIGIT CHARACTER FOUND.  
    READ_K:
        MOV AH, 1
        INT 21H
        CMP AL, 30h
        JL CALCULATE
        CMP AL, 39H
        JA CALCULATE
    
        SUB AL, 30H ;1. SUBTRACT 30H FROM THE CHAR(AL)
        MOV CL, AL  ;2. MOVE AL TO CL
        MOV CH, 0  ;3. MOV 0 TO CL (NOW CX CONTAINS THE INPUT NUMBER)
        MOV AX, 10  ;4. MOV 10 TO AX (PREPARE FOR MULTIPLICATION)
        MUL BX  ;5. MULTIPLY WITH BX (LEAST SIGNIFICANT 16 BITS IN AX, MOST SIGNIFICANT 16 BITS IN DX)
        MOV BX, AX  ;6. MOVE THE RESULT FROM AX TO BX
        ADD BX, CX  ;7. ADD THE NUMBER IN CX WITH BX, AND SAVE THE RESULT IN BX
        JMP READ_K   
    ;SO, AFTER THE LOOP, BX CONTAINS K  
   
          
    CALCULATE: ; NOW WE HAVE N IN CX, AND K IN BX VAR. READY TO CALCULATE
        MOV CX, N
        KEEP_ADDING:
            CMP CX, BX ; CX > BX (N > K)?
            JB PRINT  ; IF NOT, PRINT RESULT (IN N)
            MOV DX, 0  ; MAKE DX 0
            MOV AX, CX ; DIVIDEND 32BIT(DX:AX)
            DIV BX  ; DIVIDE VALUE IN CX BY VALUE IN BX (QUOTIENT->AX, REMAINDER->DX) 
            MOV CX, N  ; MOVE N TO CX
            ADD CX, AX ; ADD THE QUOTIENT TO CX -> TOTAL_CANDY_NUM
            MOV N, CX  ;STORE TOTAL_CANDY_NUM TO N
            MOV CX, AX ; MOVE RESULT TO CX
            ADD CX, DX
            JMP KEEP_ADDING    
    
    
    PRINT: ; OUR RESULT IS IN N
        MOV AX, N
        XOR CX, CX ; SET DX TO ZERO TO START COUNTING DIGIT_NUM (HOW MANY POP) 
        MOV BX, 10D
    CONVERT_TO_DEC: ; DO A 32BIT BY 16 BIT DIVISION
        XOR DX, DX
        DIV BX
        PUSH DX
        INC CX
        
        CMP AX, 0
        JA CONVERT_TO_DEC
    ; NOW POP AND PRINT
    
    ; OUTPUT PROMPT
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    
    MOV AH, 2
    PRINT_RESULT:
        POP DX
        OR DL, 30H
        INT 21H
        LOOP PRINT_RESULT    
    
    ;DOS EXIT
    MOV AX, 4CH
    INT 21H 
MAIN ENDP
END MAIN

    
    