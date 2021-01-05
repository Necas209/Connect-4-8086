
jogada PROC
    
    jog:
    GOTOXY 20, 2
    
    CMP turn[0], 0
    JE jogada_msg_p1
    
    JMP jogada_msg_p2
    
    jogada_msg_p1:
        MOV AH, 9
        LEA DX, msg_p1
        INT 21h
        
        JMP jogada_aux
    
    jogada_msg_p2:
        MOV AH, 9
        LEA DX, msg_p2
        INT 21h
    
    jogada_aux:    
        GOTOXY 20, 4
    
    MOV AH, 9
    LEA DX, msg_jogada
    INT 21h
    
    MOV AH, 1
    INT 21h
    
    CMP AL, "1"
    JL jog_erro
    
    CMP AL, "7"
    JG jog_erro
    
    SUB AL, "1"
    MOV AH, 0
    MOV BX, AX      ; offset dentro da linha, ou seja, a coluna
    
    MOV SI, 0
    
    loop_jog:
        CMP SI, 42
        JE jog_erro
        
        ADD SI, 7  
        
        CMP [linha1+BX+SI-7], ' '
    JNE loop_jog
    
    LEA DI, [linha1+BX+SI-7]
    
    CALL coord
    
    CMP turn[0], 0
    JE jogada_p1
    
    JMP jogada_p2
    
    jogada_p1:
        MOV [DI], 1
        
        JMP fim_jogada
    
    jogada_p2:
        MOV [DI], 2
    
    fim_jogada:
        CALL atualizar_tabuleiro
        
        RET
        
    jog_erro:
        CALL erro
        
        JMP jog                                                      
     
jogada ENDP                                                      


empate PROC
    
    GOTOXY 20, 8
    
    LEA DX, msg_empate
    MOV AH, 9
    INT 21h
    
    MOV AX, 4C00h
    INT 21h
       
empate ENDP


FIM_DO_JOGO PROC
        
    GOTOXY 20, 8
    
    CMP turn[0], 0
    JE fim_1
    
    JMP fim_2
    
    fim_1:
        LEA DX, msg_fim_1
        MOV AH, 9
        INT 21h
    
    JMP fim_g
    
    fim_2:
        LEA DX, msg_fim_2
        MOV AH, 9
        INT 21h
    
    fim_g: 
        MOV AX, 4C00h
        INT 21h
    
    RET
    
FIM_DO_JOGO ENDP
   
   
coord PROC

    MOV AX, SI
    
    LEA BP, last_position
    
    MOV [BP], BL             ; x = BL (pois BH = 0)
    
    SUB AX, 7                ; AX = SI -7
    MOV BL, 7               
    DIV BL                   ; AX = n.o linha (AL, pois AH = 0)
    
    MOV [BP+1], AL           ; y = AL 
    
    RET
    
coord ENDP


erro PROC

    GOTOXY 20, 4
    
    MOV AH, 9
    LEA DX, msg_erro
    INT 21h
    
    RET

erro ENDP