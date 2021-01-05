
imprimir_nomes PROC
    
    GOTOXY 2, 14
    
    LEA DX, p1_nome
    MOV AH, 9
    INT 21h
    
    GOTOXY 2, 16
    
    LEA DX, p2_nome
    MOV AH, 9
    INT 21h
    
    RET

imprimir_nomes ENDP


perguntar_nomes PROC
    
    GOTOXY 2, 2
    
    MOV AH, 9
    LEA DX, msg_ask_p1
    INT 21h
    
    LEA BX, p1_nome
    ADD BX, 16
    
    CALL ler_nome
    
    GOTOXY 2, 4
    
    MOV AH, 9
    LEA DX, msg_ask_p2
    INT 21h
    
    LEA BX, p2_nome
    ADD BX, 16
    
    CALL ler_nome
    
    RET

perguntar_nomes ENDP


ler_nome PROC
    
    MOV DI, 0
    MOV CX, 10 
    
    ler_char:        
       MOV AH, 1
       INT 21h
       
       MOV [BX+DI], AL
       
       INC DI
       
       CMP AL, 13       
    LOOPNE ler_char 
    
    DEC DI
    
    MOV [BX+DI], ' '
    
    RET

ler_nome ENDP


imprimir_moldura PROC
    
    MOV BL, 1    
    MOV CX, 5
    
    c1:         
        GOTOXY 0, BL
        
        LEA DX, frame4
        MOV AH, 9
        INT 21h
        
        INC BL
        
        GOTOXY 0, BL
        
        LEA DX, frame2
        MOV AH, 9
        INT 21h
        
        INC BL        
    LOOP c1
    
    GOTOXY 0, BL
    
    LEA DX, frame4
    MOV AH, 9
    INT 21h
    
    INC BL
    
    GOTOXY 0, BL
    
    LEA DX, frame3
    MOV AH, 9
    INT 21h
    
    MOV SI, 0    
    MOV CX, 13
    
    m1: 
        PUSH CX
        PUSH SI
        
        MOV CX, 15              
        
        m2: 
            MOV ES:[0A1h+SI], 0000_1001b   ; mudar o tab. para azul
            
            ADD SI, 2    
        LOOP m2
        
        POP SI
        POP CX 
        
        ADD SI, 0A0h         
    LOOP m1    
    
    RET

imprimir_moldura ENDP


atualizar_tabuleiro PROC
    
    MOV AL, last_position[0]    
    MOV BL, 2
    MUL BL    
    ADD AL, 1
    MOV CL, AL
    
    MOV AL, last_position[1]
    MOV BL, 2
    MUL BL
    MOV BL, 11
    SUB BL, AL
    
    GOTOXY CL, BL
        
    MOV AL, turn[0]
    INC AL
    
    CMP AL, 1
    JE amarelo
    
    MOV BL, 0000_1100b ; 1100b = vermelho claro
    JMP update_cont
    
    amarelo:
    MOV BL, 0000_1110b ; 1110b = amarelo
    
    update_cont:
    
    MOV AH, 09h
    MOV BH, 0
    MOV CX, 1 
    INT 10h
    
    RET
    
atualizar_tabuleiro ENDP