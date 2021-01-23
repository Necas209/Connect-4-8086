
perguntar_dimensoes PROC
    
    GOTOXY 2, 2    
    PRINTM "Dimensoes minimas: 5x5"
     
    GOTOXY 2, 4    
    PRINTM "Dimensoes maximas: 9x9" 
    
    dim_nl:
    GOTOXY 2, 6
    PRINTM "Introduza o numero de linhas: "
     
    MOV AH, 1
    INT 21h
    
    CMP AL, '5'
    JL dim_nl_erro
    
    CMP AL, '9'
    JG dim_nl_erro
    
    SUB AL, '0' 
    MOV nl[0], AL
    
    GOTOXY 2, 10
    PRINTM "                                 "
    
    dim_nc:
    GOTOXY 2, 8
    PRINTM "Introduza o numero de colunas: "
    
    MOV AH, 1
    INT 21h
    
    CMP AL, '5'
    JL dim_nc_erro
    
    CMP AL, '9'
    JG dim_nc_erro
    
    SUB AL, '0'
    MOV nc[0], AL
    
    RET
    
    dim_nl_erro:
        GOTOXY 2, 10
        PRINTM "Erro: numero de linhas invalido!"
        JMP dim_nl
    dim_nc_erro:
        GOTOXY 2, 10 
        PRINTM "Erro: numero de colunas invalido!"
        JMP dim_nc
    
perguntar_dimensoes ENDP


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
    
    PRINTM "Nome do jogador 1: " 
    
    LEA BX, p1_nome
    ADD BX, 16
    
    CALL ler_nome
    
    GOTOXY 2, 4
    
    PRINTM "Nome do jogador 2: "
    
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
            MOV ES:[0A1h+SI], 0000_1001b   ; mudar o tab. para azul 09Fh
            
            ADD SI, 2    
        LOOP m2
        
        POP SI
        POP CX 
        
        ADD SI, 0A0h ;09Eh        
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
    MOV CH, 11
    SUB CH, AL
    
    GOTOXY CL, CH     ;2x+1 2*nl-(2y+1)
        
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