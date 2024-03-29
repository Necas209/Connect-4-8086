
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
            GOTOXY 38, 4
            PUTC ' ' 
            GOTOXY 20, 6
            PRINTM "     "
 
        GOTOXY 20, 4
 
    PRINTM "Indique a coluna: "
    
    MOV AH, 1
    INT 21h

    SUB AL, '0'

    CMP AL, 1
    JL jog_erro

    CMP AL, nc[0]
    JG jog_erro

    DEC AL
    MOV AH, 0
    MOV BX, AX      ; offset dentro da linha, ou seja, a coluna

    MOV SI, 0

    MOV CX, w.[nl]
    loop_jog:

        CMP [tabuleiro+BX+SI], ' '
        JE jog_cont

        ADD SI, w.[nc]
    LOOP loop_jog

    JMP jog_erro

    jog_cont:

    LEA DI, [tabuleiro+BX+SI]
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
        GOTOXY 20, 6
        PRINTM "Erro."
        
        MOV CX, 7      
        MOV DX, 0A120h ;7A120h = 500.000 micros = 0.5 s
        MOV AH, 86h    ;WAIT.
        INT 15h
        
        JMP jog

jogada ENDP


empate PROC

    GOTOXY 20, 8

    PRINTM "O jogo terminou em empate!"

    MOV CX, 001Eh      
    MOV DX, 8480h ;1E8480h = 2.000.000 micros = 2.0 s
    MOV AH, 86h    ;WAIT.
    INT 15h
            
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
        MOV CX, 001Eh      
        MOV DX, 8480h ;1E8480h = 2.000.000 micros = 2.0 s
        MOV AH, 86h    ;WAIT.
        INT 15h
        
        MOV AX, 4C00h
        INT 21h

    RET

FIM_DO_JOGO ENDP


coord PROC                             ; DI = tabuleiro + BX + SI

    MOV last_position[0], BL           ; x = BL (pois BH = 0)

    MOV AX, SI
    MOV BL, nc[0]
    DIV BL                             ; AX = AL = n.o linha (pois AH = 0)

    MOV last_position[1], AL           ; y = AL

    RET

coord ENDP