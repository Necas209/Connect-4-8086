
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
    
    GOTOXY 20, 14
    
    LEA DX, p1_nome
    MOV AH, 9
    INT 21h
    
    GOTOXY 20, 16
    
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

    MOV DH, 1     ;linha
    MOV DL, 0     ;coluna
    
    MOV CX, w.[nl]
    
    c1:                    ; verticais por linha
        PUSH CX
        MOV CX, w.[nc]
        INC CX
        c1_1:              ; verticais numa so linha
        PUSH CX
        
        MOV BH, 0
	    MOV AH, 2
	    INT 10h
	    
        MOV AH, 9
        MOV AL, 186
        MOV BH, 0
        MOV BL, 0000_1001b
        MOV CX, 1
        INT 10h
        
        ADD DL, 2         
        POP CX
        LOOP c1_1
        ADD DH, 2
        MOV DL, 0
        POP CX
    LOOP c1
    
    MOV DH, 2     ;linha
    MOV DL, 0     ;coluna
    
    MOV CX, w.[nl]
    DEC CX
    
    c2:               
    
    PUSH CX
    
    MOV BH, 0
	MOV AH, 2
	INT 10h
	
	MOV AH, 9
    MOV AL, 204         ;extremo esquerdo
    MOV BH, 0
    MOV BL, 0000_1001b
    MOV CX, 1
    INT 10h 
    
    
    MOV CX, w.[nc]
    DEC CX 
    
    c2_1:              ; intermedios
        PUSH CX
     
        INC DL
        MOV BH, 0
	    MOV AH, 2
	    INT 10h
	
        MOV AH, 9
        MOV AL, 205
        MOV BH, 0
        MOV BL, 0000_1001b
        MOV CX, 1
        INT 10h
    
        INC DL
        MOV BH, 0
	    MOV AH, 2
	    INT 10h
	
        MOV AH, 9
        MOV AL, 206
        MOV BH, 0
        MOV BL, 0000_1001b
        MOV CX, 1
        INT 10h 
    
        POP CX 
    LOOP c2_1
    
    INC DL
    MOV BH, 0
	MOV AH, 2
	INT 10h
	
    MOV AH, 9
    MOV AL, 205
    MOV BH, 0
    MOV BL, 0000_1001b
    MOV CX, 1
    INT 10h
    
    INC DL
    MOV BH, 0
	MOV AH, 2
	INT 10h
	
    MOV AH, 9
    MOV AL, 185
    MOV BH, 0
    MOV BL, 0000_1001b     ;extremo direito
    MOV CX, 1
    INT 10h
    
    MOV DL, 0
    ADD DH, 2
    
    POP CX
    LOOP c2
    
    
    ; DH = ultima linha por causa do loop c2
    MOV DL, 0     ;coluna

    MOV BH, 0
	MOV AH, 2
	INT 10h
	
    MOV AH, 9
    MOV AL, 200
    MOV BH, 0
    MOV BL, 0000_1001b
    MOV CX, 1
    INT 10h
        
    MOV CX, w.[nc]
    DEC CX
    
    c3:
    PUSH CX
    
    INC DL
    MOV BH, 0
	MOV AH, 2
	INT 10h
	
    MOV AH, 9
    MOV AL, 205
    MOV BH, 0
    MOV BL, 0000_1001b
    MOV CX, 1
    INT 10h
    
    INC DL
    MOV BH, 0
	MOV AH, 2
	INT 10h
	
    MOV AH, 9
    MOV AL, 202
    MOV BH, 0
    MOV BL, 0000_1001b
    MOV CX, 1
    INT 10h
    
    POP CX
    LOOP c3
    
    INC DL
    MOV BH, 0
	MOV AH, 2
	INT 10h
	
    MOV AH, 9
    MOV AL, 205
    MOV BH, 0
    MOV BL, 0000_1001b
    MOV CX, 1
    INT 10h
    
    INC DL
    MOV BH, 0
	MOV AH, 2
	INT 10h
	
    MOV AH, 9
    MOV AL, 188
    MOV BH, 0
    MOV BL, 0000_1001b
    MOV CX, 1
    INT 10h
    
    RET
    
imprimir_moldura ENDP


atualizar_tabuleiro PROC
    
    MOV AL, last_position[0]  ;2x+1 = x da peca na consola 
    MOV BL, 2
    MUL BL    
    ADD AL, 1
    MOV CL, AL
    
    MOV AL, last_position[1]  ;2*nl-(2y+1) = y da peca na consola
    MOV BL, 2
    MUL BL
    INC AL
    MOV CH, [nl]
    ADD CH, [nl]
    SUB CH, AL
    
    GOTOXY CL, CH   ;(x,y) da peca na consola   
        
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