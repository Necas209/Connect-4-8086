
check_diagonal PROC
    
    MOV CL, last_position[0]         ;diagonal \
    MOV CH, last_position[1]

    MOV DH, [nl]
    DEC DH           ;nl-1 pois {0...nl-1}
    MOV DL, [nc]
    DEC DL           ;nc-1 pois {0...nc-1}

    test_loop:
        CMP CL, DL
        JE test_cont 
        CMP CH, 0
        JE test_cont
        INC CL
        DEC CH
    JMP test_loop      

    test_cont:       ; (CL,CH) = ultima posicao da diagonal                           
    
    MOV AH, 0
    MOV AL, CH
    MUL [nc]         ;dimensao maxima de nc
    MOV SI, AX       ; SI = offset de linha
    
    XOR BX, BX
    MOV BL, CL       ; BX = offset de coluna

    MOV AL, [turn]
    INC AL
    MOV AH, 0

    left_right:
        CMP [linha1+BX+SI], AL
        JE left_right_cont
        
        MOV AH, 0
        JMP left_right_cont2
        
        left_right_cont:
        
        INC AH
        CMP AH, 4
        JE diag_fim1
        
        left_right_cont2:        
        
        CMP CL, 0
        JE left_right_cont3
        
        CMP CH, DH
        JE left_right_cont3
        
        ADD SI, w.[nc]
        INC CH
        DEC BX
        DEC CL
    JMP left_right
    
    diag_fim1:
    
    CALL FIM_DO_JOGO
    
    left_right_cont3:     ;diagonal /
    
    MOV CL, last_position[0]
    MOV CH, last_position[1]

    test2_loop:
        CMP CL, 0    ;nc-1
        JE test2_cont 
        CMP CH, 0
        JE test2_cont
        DEC CL
        DEC CH        
    JMP test2_loop
    
    test2_cont:
    
    MOV AH, 0
    MOV AL, CH
    MUL [nc]
    MOV SI, AX       ; SI = offset de linha
    
    XOR BX, BX
    MOV BL, CL       ; BX = offset de coluna

    MOV AL, [turn]
    INC AL
    MOV AH, 0

    right_left:
        CMP [linha1+BX+SI], AL
        JE right_left_cont
        
        MOV AH, 0
        JMP right_left_cont2
        
        right_left_cont:
        
        INC AH
        CMP AH, 4
        JE diag_fim2
        
        right_left_cont2:        
        
        CMP CL, DL
        JE right_left_cont3
        
        CMP CH, DH
        JE right_left_cont3
        
        ADD SI, w.[nc]
        INC CH
        INC BX
        INC CL
    JMP right_left
    
    diag_fim2:
    
    CALL FIM_DO_JOGO
    
    right_left_cont3:
    
    RET

check_diagonal ENDP


check_vertical PROC
    
    CMP last_position[1], 3
    JGE vertical
    
    RET 
    
    vertical:
        
        MOV AH, 0
        MOV AL, last_position[1]
        MUL [nc]        
        MOV SI, AX
        
        ;AH = 0 => contador de pecas
        MOV AL, turn[0]    
        INC AL                   ;AL = peca

        MOV BL, last_position[0] 
        MOV BH, 0
        
        MOV CX, 4
        v_loop:
            CMP [linha1+BX+SI], AL
            JE inc_v
            MOV AH, 0
            JMP v_loop_end
            
            inc_v:
                INC AH
                CMP AH, 4
                JE fim_do_jogo_v
            
            v_loop_end:
                SUB SI, nc[0]                    
        LOOP v_loop
            
    RET
    
    fim_do_jogo_v:
        CALL FIM_DO_JOGO
        
    RET

check_vertical ENDP


check_horizontal PROC
    
    MOV AH, 0              ;AH = contador de pecas
    MOV AL, last_position[1]
    MUL [nc]        
    MOV SI, AX             ;SI = linha
    
    MOV BX, 0              ;BX = offset na linha (coluna)
    
    MOV AL, turn[0]    
    INC AL                 ;AL = peca
        
    MOV CX, w.[nc]
      
    h_loop:
        CMP [linha1+BX+SI], AL
        JE inc_h
        MOV AH, 0
        JMP h_loop_terminar
    
        inc_h:
            INC AH    
            CMP AH, 4
            JE fim_do_jogo_h    
    
        h_loop_terminar:
            INC BX
    LOOP h_loop
   
    RET
    
    fim_do_jogo_h:
        CALL FIM_DO_JOGO
        
    RET
    
check_horizontal ENDP