.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'PLEASE ENTER FIRST LOWERCASE LETTER: $' 
MSG2 DB 0DH, 0AH, 'PLEASE ENTER SECOND LOWERCASE LETTER: $'
MSG3 DB 0DH, 0AH, 'PLEASE ENTER THIRD LOWERCASE LETTER: $'
MSG4 DB 0DH, 0AH, 'THE SECOND HIGHEST LETTER BASED ON ASCII VALUE: $'
MSG5 DB 'ALL LETTERS ARE EQUAL $'
MSG6 DB 0DH, 0AH , 'NOT A LOWERCASE CHARACTER $'


.CODE 
MAIN PROC
    ;INITIALIZE DATA SEGMENT
    MOV AX, @DATA
    MOV DS, AX
    
    ;SHOW PROMPT
    LEA DX, MSG1
    MOV AH, 9
    INT 21H
    ;INPUT FIRST CHARACTER
    MOV AH, 1
    INT 21H
    MOV BL, AL ; BL -> FIRST CHARACTER 
    ;CHECK LOWERCASE
    CMP BL, 'a'
    JB NOTLOWERCASE
    CMP BL, 'z'
    JA NOTLOWERCASE
    
    ;SHOW PROMPT
    LEA DX, MSG2
    MOV AH, 9
    INT 21H
    ;INPUT SECOND CHARACTER
    MOV AH, 1
    INT 21H
    MOV BH, AL ; BH -> SECOND CHARACTER
    ;CHECK LOWERCASE
    CMP BH, 'a'
    JB NOTLOWERCASE
    CMP BH, 'z'
    JA NOTLOWERCASE 
    
    ;SHOW PROMPT
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    ;INPUT THIRD CHARACTER
    MOV AH, 1
    INT 21H
    MOV CL, AL ; CL -> THIRD CHARACTER
    ;CHECK LOWERCASE
    CMP CL, 'a'
    JB NOTLOWERCASE
    CMP CL, 'z'
    JA NOTLOWERCASE     
        
    
    MOV AH, 9
    LEA DX, MSG4
    INT 21H
    
    ;COMPUTE SECOND HIGHEST
    CMP BL, BH ; check 0
    JBE CHECK4
    CMP BH, CL ; check 1
    JAE RESULT2
    CMP BL, CL ; check 2
    JB RESULT1
    CMP BL, CL ; check 3
    JA RESULT3
    JMP RESULT2
    
    CHECK4:
    CMP BH, CL ; check 4
    JB RESULT2          
    CMP BL, CL ; check 5
    JAE CHECK6
    CMP BH, CL ; check 7
    JA RESULT3
    JMP RESULT1
    
    CHECK6:
    CMP BL, BH ; check 6
    JB RESULT1
    CMP BL, CL ; check 8
    JA RESULT3
    JMP RESULT4 

    
    
    
    ;SAVE THE RESULT (CHAR)
    
    RESULT1:
    MOV AH, 2
    MOV DL, BL
    JMP PRINT
    
    RESULT2:
    MOV AH, 2
    MOV DL, BH
    JMP PRINT
    
    RESULT3:
    MOV AH, 2
    MOV DL, CL
    JMP PRINT
    
    RESULT4: ; EQUAL
    MOV AH, 9
    LEA DX, MSG5
    JMP PRINT
    
    ;FINALLY PRINT
    PRINT:
    INT 21H
    JMP END
    
    NOTLOWERCASE:
    LEA DX, MSG6
    MOV AH, 9
    INT 21H
    
    END:    
    
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H
    
    MAIN ENDP
END MAIN
