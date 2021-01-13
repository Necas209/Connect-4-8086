
jogada PROC
    
    jog:
    GOTOXY 20, 2
    
    CMP turn[0], 0
    JE jogada_msg_p1
    
    JMP jogada_msg_p2
    
    jogada_msg_p1:
        PRINTM "Jogador 1"         
        JMP jogada_aux
    
    jogada_msg_p2:
        PRINTM "Jogador 2"
    
    jogada_aux:    
        GOTOXY 20, 4
    
    PRINTM "Indique a coluna: "
    
    MOV AH, 1
    INT 21h
    
    SUB AL, '0'
    
    CMP AL, 1
    JL jog_erro
    
    CMP AL, nc[0]
    JG jog_erro
    
    SUB AL, 1
    MOV AH, 0
    MOV BX, AX      ; offset dentro da linha, ou seja, a coluna
    
    MOV SI, 0
    
    MOV CX, w.[nl]
    loop_jog:
            
        CMP [linha1+BX+SI], ' '
        JE jog_cont
        
        ADD SI, [nc]
    LOOP loop_jog
    
    JMP jog_erro
    
    jog_cont:
    
    CALL coord
    
    CMP turn[0], 0
    JE jogada_p1
    
    JMP jogada_p2
    
    jogada_p1:
        MOV [linha1+BX+SI], 1
        
        JMP fim_jogada
    
    jogada_p2:
        MOV [linha1+BX+SI], 2
    
    fim_jogada:
        CALL atualizar_tabuleiro
        
        RET
        
    jog_erro:
        GOTOXY 20, 4    
        PRINTM "Erro."
        JMP jog                                                      
     
jogada ENDP                                                      


empate PROC
    
    GOTOXY 20, 8
       
    PRINTM "O jogo terminou em empate!"
    
    MOV AX, 4C00h
    INT 21h
       
empate ENDP


FIM_DO_JOGO PROC
        
    GOTOXY 20, 8
    
    CMP turn[0], 0
    JE fim_1
    
    JMP fim_2
    
    fim_1:          
        PRINTM "O jogo terminou! O jogador 1 ganhou."    
        JMP fim_g
    
    fim_2:
        PRINTM "O jogo terminou! O jogador 2 ganhou."
            
    fim_g: 
        MOV AX, 4C00h
        INT 21h
    
    RET
    
FIM_DO_JOGO ENDP
   
   
coord PROC                             ; DI = linha1 + BX + SI
    
    MOV last_position[0], BL           ; x = BL (pois BH = 0)
    
    MOV AX, SI                            
    MOV BL, nc[0]               
    DIV BL                             ; AX = AL = n.o linha (pois AH = 0)
    
    MOV last_position[1], AL           ; y = AL 
    
    RET
    
coord ENDP