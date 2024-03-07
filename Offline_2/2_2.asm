.MODEL SMALL
.STACK 100H
.DATA
INPUT DB 5 DUP (0)
MSG1 DB "ENTER THE VALUE OF N: $" 
MSG2 DB 0DH, 0AH, "SUM OF THE DIGITS: $"

.CODE 
MAIN PROC
    ;INITIALIZE DATA SEGMENT
    MOV AX, @DATA
    MOV DS, AX
    
    ;SHOW INPUT PROMPT
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    
    ;TAKE INPUT IN A LOOP
    MOV AH, 1
    MOV CX, 5
    LEA SI, INPUT
    INPUT_LOOP:
        MOV AH, 1
         INT 21H
         SUB AL, 30H
         
         CMP AL, 0
         JB INPUT_END
         CMP AL, 9
         JA INPUT_END
         
         MOV [SI], AL
         ADD SI, 1
         
         LOOP INPUT_LOOP
         
    INPUT_END:
    MOV BX, 5
    SUB BX, CX  ; BX HAS THE LENGTH OF THE ARRAY 
    ; push parameters to stack
    
    LEA SI, INPUT
    PUSH SI
    PUSH BX
    CALL FIND_DIGIT_SUM
    
    ;RESULT IS IN AL. CONVERT TO DEC AND PRINT IT
    
    XOR CX, CX
    MOV BX, 10D
    
    CONVERT_TO_DEC:
        MOV AH, 0
        DIV BL
        MOV DL, AH
        MOV DH, 0
        PUSH DX
        INC CX
        
        CMP AL, 0
        JA CONVERT_TO_DEC 
        
    ;SHOW OUTPUT PROMPT
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    
    ;SHOW RESULT
    MOV AH, 2
    PRINT_RESULT:
        POP DX
        OR DL, 30H
        INT 21H
        LOOP PRINT_RESULT
    
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H
    
    MAIN ENDP
             
FIND_DIGIT_SUM:
    PUSH BP
    MOV BP, SP
    
    CMP [BP + 4], 1
    JA ELSE
    MOV BX, [BP + 6]
    MOV AL, INPUT[BX]
    JMP RETURN_RESULT
    
    ELSE:
        MOV BX, [BP + 6]
        INC BX
        PUSH BX
        MOV BX, [BP + 4]
        DEC BX  ; DECREMENT SIZE
        PUSH BX
        CALL FIND_DIGIT_SUM
        
        MOV BX, [BP + 6]
        ADD AL, INPUT[BX]
    
    
    RETURN_RESULT:
    POP BP
    RET 4
    
    
END MAIN
         
         
    

