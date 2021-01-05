
check_diagonalv1 PROC
    
    MOV AL, turn[0]
    INC AL
    
    MOV SI, 0
    MOV CX, 7
    
    diag_loop1:
        CMP [linha4+SI], AL
        JNE diag_cont
        
        PUSH CX
        PUSH SI
        PUSH AX
        
        CALL id_diag
        
        POP AX
        POP SI
        POP CX
        
        diag_cont:  
        INC SI
    LOOP diag_loop1
    
    RET

check_diagonalv1 ENDP


id_diag PROC
    
    CMP SI, 0
    JE id0
    
    CMP SI, 1
    JE id1
    
    CMP SI, 2
    JE id2
    
    CMP SI, 3
    JE id3
    
    CMP SI, 4
    JE id4
    
    CMP SI, 5
    JE id5
    
    JMP id6
    
    id0:
    CALL diag_1
    RET
    
    id1:
    CALL diag_2
    CALL diag_7
    RET
    
    id2:
    CALL diag_3
    CALL diag_8
    
    id3:
    CALL diag_4
    CALL diag_9
    RET
    
    id4:
    CALL diag_5
    CALL diag_10
    RET
    
    id5:
    CALL diag_6
    CALL diag_11
    RET
    
    id6:
    CALL diag_12
    RET
    
id_diag ENDP

;////////////////////////////
check_diagonalv2 PROC
    
    MOV AL, turn[0]
    INC AL
    
    MOV CX, 7
    MOV SI, 0
    
    loop_linha4:
	    CMP [linha4+SI], AL
        JE check_diag_cont
        
        INC SI
    LOOP loop_linha4
    RET

    check_diag_cont:
    CMP last_position[0], 0
    JE x1    
    CMP last_position[0], 1
    JE x2
    CMP last_position[0], 2
    JE x3    
    CMP last_position[0], 3
    JE x4
    CMP last_position[0], 4
    JE x5
    CMP last_position[0], 5    
    JE x6
    JMP x7
    
    x1:
    CMP last_position[1], 0
    JE x1_y1
    CMP last_position[1], 1
    JE x1_y2
    CMP last_position[1], 2
    JE x1_y3
    CMP last_position[1], 3
    JE x1_y4
    CMP last_position[1], 4
    JE x1_y5
    JMP x1_y6
    
    x2:
    CMP last_position[1], 0
    JE x2_y1
    CMP last_position[1], 1
    JE x2_y2
    CMP last_position[1], 2
    JE x2_y3
    CMP last_position[1], 3
    JE x2_y4
    CMP last_position[1], 4
    JE x2_y5
    JMP x2_y6
    
    x3:
    CMP last_position[1], 0
    JE x3_y1
    CMP last_position[1], 1
    JE x3_y2
    CMP last_position[1], 2
    JE x3_y3
    CMP last_position[1], 3
    JE x3_y4
    CMP last_position[1], 4
    JE x3_y5
    JMP x3_y6
    
    x4:
    CMP last_position[1], 0
    JE x4_y1
    CMP last_position[1], 1
    JE x4_y2
    CMP last_position[1], 2
    JE x4_y3
    CMP last_position[1], 3
    JE x4_y4
    CMP last_position[1], 4
    JE x4_y5
    JMP x4_y6
    
    x5:
    CMP last_position[1], 0
    JE x5_y1
    CMP last_position[1], 1
    JE x5_y2
    CMP last_position[1], 2
    JE x5_y3
    CMP last_position[1], 3
    JE x5_y4
    CMP last_position[1], 4
    JE x5_y5
    JMP x5_y6
    
    x6:
    CMP last_position[1], 0
    JE x6_y1
    CMP last_position[1], 1
    JE x6_y2
    CMP last_position[1], 2
    JE x6_y3
    CMP last_position[1], 3
    JE x6_y4
    CMP last_position[1], 4
    JE x6_y5
    JMP x6_y6
    
    x7:
    CMP last_position[1], 0
    JE x7_y1
    CMP last_position[1], 1
    JE x7_y2
    CMP last_position[1], 2
    JE x7_y3
    CMP last_position[1], 3
    JE x7_y4
    CMP last_position[1], 4
    JE x7_y5
    JMP x7_y6
    
    x1_y1:
    CALL diag_9
    RET
    x1_y2:
    CALL diag_8
    RET
    x1_y3:
    CALL diag_7
    RET
    x1_y4:
    CALL diag_1
    RET
    x1_y5:
    CALL diag_2
    RET
    x1_y6:
    CALL diag_3
    RET
    
    x2_y1:
    CALL diag_10
    RET
    x2_y2:
    CALL diag_9
    RET
    x2_y3:
    CALL diag_8
    CALL diag_1
    RET
    x2_y4:
    CALL diag_7
    CALL diag_2
    RET
    x2_y5:
    CALL diag_3
    RET
    x2_y6:
    CALL diag_4
    RET
    
    x3_y1:
    CALL diag_11
    RET
    x3_y2:
    CALL diag_10
    CALL diag_1
    RET
    x3_y3:
    CALL diag_9
    CALL diag_2
    RET
    x3_y4:
    CALL diag_8
    CALL diag_3
    RET
    x3_y5:
    CALL diag_7
    CALL diag_4
    RET
    x3_y6:
    CALL diag_5
    RET
    
    x4_y1:
    CALL diag_12
    CALL diag_1
    RET
    x4_y2:
    CALL diag_11
    CALL diag_2
    RET
    x4_y3:
    CALL diag_10
    CALL diag_3
    RET
    x4_y4:
    CALL diag_9
    CALL diag_4
    RET
    x4_y5:
    CALL diag_8
    CALL diag_5
    RET
    x4_y6:
    CALL diag_7
    CALL diag_6
    RET
    
    x5_y1:
    CALL diag_2
    RET
    x5_y2:
    CALL diag_12
    CALL diag_3
    RET
    x5_y3:
    CALL diag_11
    CALL diag_4
    RET
    x5_y4:
    CALL diag_10
    CALL diag_5
    RET
    x5_y5:
    CALL diag_9
    CALL diag_6
    RET
    x5_y6:
    CALL diag_8
    RET
    
    x6_y1:
    CALL diag_3
    RET
    x6_y2:
    CALL diag_4
    RET
    x6_y3:
    CALL diag_12
    CALL diag_5
    RET
    x6_y4:
    CALL diag_11
    CALL diag_6
    RET
    x6_y5:
    CALL diag_10
    RET
    x6_y6:
    CALL diag_9
    
    x7_y1:
    CALL diag_4
    RET
    x7_y2:
    CALL diag_5
    RET
    x7_y3:
    CALL diag_6
    RET
    x7_y4:
    CALL diag_12
    RET
    x7_y5:
    CALL diag_11
    RET
    x7_y6:
    CALL diag_10
    RET

check_diagonalv2 ENDP


diag_1 PROC
    
    MOV CX, 4
    MOV SI, 0
    MOV BX, 0

    d1:
        CMP [linha1+BX+SI+3], AL
        JNE fim_d1
        DEC BX
        ADD SI, 7
    LOOP d1
    
    CALL FIM_DO_JOGO
    
    fim_d1:
    RET
       
diag_1 ENDP
  
diag_2 PROC
       
    MOV CX, 5
    MOV SI, 0
    MOV BX, 0
    MOV AH, 0
    
    d2:
        CMP [linha1+BX+SI+4], AL
        JE inc_d2
        MOV AH, 0        
        
        CMP CX, 4
        JLE fim_d2 
        
        JMP cont_d2        
        inc_d2:
            INC AH
            CMP AH, 4
            JE fim_jogo_d2            
        
        cont_d2:
        ADD SI, 7
        DEC BX      
    LOOP d2
    
    fim_d2:
    RET
    
    fim_jogo_d2:
    CALL FIM_DO_JOGO
    
diag_2 ENDP

diag_3 PROC
    
    MOV CX, 6
    MOV SI, 0
    MOV BX, 0
    MOV AH, 0
    
    d3:
        CMP [linha1+BX+SI+5], AL
        JE inc_d3
        MOV AH, 0 
        
        CMP CX, 4
        JLE fim_d3
        
        JMP cont_d3
        inc_d3:
            INC AH
            CMP AH, 4
            JE fim_jogo_d3            
        cont_d3:
        ADD SI, 7
        DEC BX      
    LOOP d3
    
    fim_d3:
    RET
    
    fim_jogo_d3:
    CALL FIM_DO_JOGO
    
diag_3 ENDP

diag_4 PROC
    
    MOV CX, 6
    MOV SI, 0
    MOV BX, 0
    MOV AH, 0
    
    d4:
        CMP [linha1+BX+SI+6], AL
        JE inc_d4
        MOV AH, 0 
        
        CMP CX, 4
        JLE fim_d4
        
        JMP cont_d4
        inc_d4:
            INC AH
            CMP AH, 4
            JE fim_jogo_d4            
        cont_d4:        
        ADD SI, 7
        DEC BX      
    LOOP d4
    
    fim_d4:
    RET
    
    fim_jogo_d4:
    CALL FIM_DO_JOGO
    
diag_4 ENDP

diag_5 PROC
    
    MOV CX, 5
    MOV SI, 0
    MOV BX, 0
    MOV AH, 0
    
    d5:
        CMP [linha2+BX+SI+6], AL
        JE inc_d5
        MOV AH, 0 
        
        CMP CX, 4
        JLE fim_d5        
        JMP cont_d5
        
        inc_d5:
            INC AH
            CMP AH, 4
            JE fim_jogo_d5            

        cont_d5:        
        ADD SI, 7
        DEC BX      
    LOOP d5
    
    fim_d5:
    RET
    
    fim_jogo_d5:
    CALL FIM_DO_JOGO
    
diag_5 ENDP

diag_6 PROC
    
    MOV CX, 4
    MOV SI, 0
    MOV BX, 0

    d6:
        CMP [linha3+BX+SI+6], AL
        JNE fim_d6
        DEC BX
        ADD SI, 7
    LOOP d6
    
    CALL FIM_DO_JOGO
    
    fim_d6:
    RET
       
diag_6 ENDP

diag_7 PROC
    
    MOV CX, 4
    MOV SI, 0
    MOV BX, 0

    d7:
        CMP [linha3+BX+SI], AL
        JNE fim_d7
        INC BX
        ADD SI, 7
    LOOP d7
    
    CALL FIM_DO_JOGO
    
    fim_d7:
    RET
       
diag_7 ENDP

diag_8 PROC
       
    MOV CX, 5
    MOV SI, 0
    MOV BX, 0
    MOV AH, 0
    
    d8:
        CMP [linha2+BX+SI], AL
        JE inc_d8
        MOV AH, 0 
        
        CMP CX, 4
        JLE fim_d8
        
        JMP cont_d8
        inc_d8:
            INC AH
            CMP AH, 4
            JE fim_jogo_d8            
        cont_d8:
        ADD SI, 7
        INC BX      
    LOOP d8
    
    fim_d8:
    RET
    
    fim_jogo_d8:
    CALL FIM_DO_JOGO
    
diag_8 ENDP

diag_9 PROC
       
    MOV CX, 6
    MOV SI, 0
    MOV BX, 0
    MOV AH, 0
    
    d9:
        CMP [linha1+BX+SI], AL
        JE inc_d9
        MOV AH, 0 
        
        CMP CX, 4
        JLE fim_d9
        
        JMP cont_d9
        inc_d9:
            INC AH
            CMP AH, 4
            JE fim_jogo_d9            
        cont_d9:
        ADD SI, 7
        INC BX      
    LOOP d9
    
    fim_d9:
    RET
    
    fim_jogo_d9:
    CALL FIM_DO_JOGO
    
diag_9 ENDP

diag_10 PROC
       
    MOV CX, 6
    MOV SI, 0
    MOV BX, 0
    MOV AH, 0
    
    d10:
        CMP [linha1+BX+SI+1], AL
        JE inc_d10
        MOV AH, 0 
        
        CMP CX, 4
        JLE fim_d10
        
        JMP cont_d10
        inc_d10:
            INC AH
            CMP AH, 4
            JE fim_jogo_d10            
        cont_d10:
        ADD SI, 7
        INC BX      
    LOOP d10
    
    fim_d10:
    RET
    
    fim_jogo_d10:
    CALL FIM_DO_JOGO
    
diag_10 ENDP

diag_11 PROC
       
    MOV CX, 5
    MOV SI, 0
    MOV BX, 0
    MOV AH, 0
    
    d11:
        CMP [linha1+BX+SI+2], AL
        JE inc_d11
        MOV AH, 0 
         
        CMP CX, 4
        JLE fim_d11
        
        JMP cont_d11
        inc_d11:
            INC AH
            CMP AH, 4
            JE fim_jogo_d11            
        cont_d11:
        ADD SI, 7
        INC BX      
    LOOP d11
    
    fim_d11:
    RET
    
    fim_jogo_d11:
    CALL FIM_DO_JOGO
    
diag_11 ENDP 

diag_12 PROC
    
    MOV CX, 4
    MOV SI, 0
    MOV BX, 0

    d12:
        CMP [linha1+BX+SI+3], AL
        JNE fim_d12
        INC BX
        ADD SI, 7
    LOOP d12
    
    CALL FIM_DO_JOGO
    
    fim_d12:
    RET
       
diag_12 ENDP


check_vertical PROC
    
    CMP last_position[1], 3
    JGE vertical
    
    RET 
    
    vertical:
        MOV AH, 0                ;AH = contador de pecas
        MOV AL, turn[0]    
        ADD AL, 1                ;AL = peca
        CALL linha_horizontal    ;BX=linha
        
        XOR CX, CX
        MOV CL, last_position[0] 
        ADD BX, CX ;BX=linha+offset(coluna)
        
        MOV SI, 0
        MOV CX, 4
        
        v_loop:
            CMP [BX+SI], AL
            JE inc_v
            MOV AH, 0
            JMP v_loop_end
            
            inc_v:
                INC AH
                CMP AH, 4
                JE fim_do_jogo_v
            
            v_loop_end:
                SUB SI, 7                    
        LOOP v_loop
            
    RET
    
    fim_do_jogo_v:
        CALL FIM_DO_JOGO
        
    RET

check_vertical ENDP


check_horizontal PROC
    
    MOV AH, 0            ;AH = contador de pecas
    MOV AL, turn[0]    
    ADD AL, 1            ;AL = peca
    
    CALL linha_horizontal  ;BX = linha
    
    MOV CX, 7
    MOV SI, 0            ;SI = coluna
    
    h_loop:
        CMP [BX+SI], AL
        JE inc_h
        MOV AH, 0
        JMP h_loop_terminar
    
        inc_h:
            INC AH    
            CMP AH, 4
            JE fim_do_jogo_h    
    
        h_loop_terminar:
            INC SI
    LOOP h_loop
   
    RET
    
    fim_do_jogo_h:
        CALL FIM_DO_JOGO
        
    RET
    
check_horizontal ENDP


linha_horizontal PROC
    
    CMP last_position[1], 0
    JE h1
    
    CMP last_position[1], 1
    JE h2 
    
    CMP last_position[1], 2
    JE h3 
    
    CMP last_position[1], 3
    JE h4
    
    CMP last_position[1], 4
    JE h5
    
    JMP h6
    
    h1:
        LEA BX, linha1
        
        RET    
    h2:
        LEA BX, linha2
        
        RET    
    h3:
        LEA BX, linha3
        
        RET    
    h4:
        LEA BX, linha4
        
        RET    
    h5:
        LEA BX, linha5
        
        RET    
    h6:
        LEA BX, linha6
        
        RET
    
linha_horizontal ENDP