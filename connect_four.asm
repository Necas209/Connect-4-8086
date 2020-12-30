include emu8086.inc

JMP start

MOV AX, 0b800h
MOV DS, AX

MOV CX, 16 
MOV SI, 1
MOV BL, 00h
teste:
MOV DS:[SI], BL
ADD SI, 2
ADD BL, 10h
LOOP teste 

RET

    linha1 DB 7 DUP(' ')    ;|      ; 1 -> pecas do p1
    linha2 DB 7 DUP(' ')    ;|      ; 2 -> pecas do p2
    linha3 DB 7 DUP(' ')    ;|
    linha4 DB 7 DUP(' ')    ;|
    linha5 DB 7 DUP(' ')    ;V
    linha6 DB 7 DUP(' ')    ;da fila mais baixa para a mais alta
    
      
    frame2 DB 204,205,206,205,206,205,206,205,206,205,206,205,206,205,185,"$"  ;lateral c/ lig    
    frame3 DB 200,205,202,205,202,205,202,205,202,205,202,205,202,205,188,"$"  ;inferior    
    frame4 DB 186," ",186," ",186," ",186," ",186," ",186," ",186," ",186,"$" ;lateral s/ lig 

    turn DB " "      ; vez do jogador: 0 -> p1, 1 -> p2
    
    msg_p1 DB "Jogador 1$"
    msg_p2 DB "Jogador 2$" 
    msg_jogada DB "Indique a coluna: $"
    
    p1_nome DB "Jogador 1 (",1,") -           $"
    p2_nome DB "Jogador 2 (",2,") -           $"
    msg_ask_p1 DB "Nome do jogador 1: $"
    msg_ask_p2 DB "Nome do jogador 2: $"
    
    msg_fim_1 DB "O jogo terminou! O jogador 1 ganhou.$"
    msg_fim_2 DB "O jogo terminou! O jogador 2 ganhou.$"
    
    msg_erro DB "Erro.$"
    
    last_position DB 2 DUP(-1)     ; posicao da ultima peca colocada
    
DEFINE_CLEAR_SCREEN


start:
    
    MOV AX, 0B800h
    MOV ES, AX
	
    CALL perguntar_nomes
    
    CALL CLEAR_SCREEN
    
    CALL imprimir_moldura
    
    CALL imprimir_nomes
    
    CALL RANDSTART  ;escolhe ordem dos jogadores
    
    LEA BX, turn    ;guarda a vez ("turn")
    MOV [BX], AL
    
    CMP AL, 0       ;turn=0 => p1 seguido de p2
    JE p1_p2
    
    CMP AL, 1       ;turn=1 => p2 seguido de p1
    JE p2_p1
     
    p1_p2:            
        MOV CX, 3
        loop_inicial12:
            PUSH CX
            
            CALL jogada
   
            LEA BX, turn
            MOV [BX], 1
    
            CALL jogada
 
            LEA BX, turn
            MOV [BX], 0
            
            POP CX    
        LOOP loop_inicial12
        
        loop_final12:
            CALL jogada
  
            CALL check_horizontal
        
            CALL check_vertical
            
            CALL check_diagonal
            
            LEA BX, turn
            MOV [BX], 1
    
            CALL jogada
    
            CALL check_horizontal
        
            CALL check_vertical
            
            CALL check_diagonal
            
            LEA BX, turn
            MOV [BX], 0      
        JMP loop_final12
    
    p2_p1:            
        MOV CX, 3
        loop_inicial21:
            PUSH CX
            
            CALL jogada
   
            LEA BX, turn
            MOV [BX], 0
    
            CALL jogada
 
            LEA BX, turn
            MOV [BX], 1
            
            POP CX    
        LOOP loop_inicial21
        
        loop_final21:
            CALL jogada
  
            CALL check_horizontal
        
            CALL check_vertical
            
            CALL check_diagonal
            
            LEA BX, turn
            MOV [BX], 0
    
            CALL jogada
    
            CALL check_horizontal
        
            CALL check_vertical
            
            CALL check_diagonal
            
            LEA BX, turn
            MOV [BX], 1      
        JMP loop_final21    
    

;////////////////////////////////// 


RANDSTART:          ; gera numero aleatorio entre 0 e 1
   
   MOV AH, 00h       
   INT 1AH     

   MOV  AX, DX
   XOR  DX, DX
   MOV  CX, 2    
   DIV  CX
   MOV  AH, 0 
   MOV  AL, DH   

RET


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


check_diagonal PROC
    
    MOV AL, turn[0]
    INC AL
    
    MOV SI, 0
    MOV CX, 7
    
    diag_loop1:
        CMP [linha4+SI], AL
        JNE diag_si
        
        MOV AH, 1
        JMP diag_cont
        
        diag_si:
            INC SI
    LOOP diag_loop1
    
    diag_cont:
    
    RET
    
check_diagonal ENDP


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


coord:

    MOV AX, SI
    
    LEA BP, last_position
    
    MOV [BP], BL             ; x = BL (pois BH = 0)
    
    SUB AX, 7                ; AX = SI -7
    MOV BL, 7               
    DIV BL                   ; AX = n.o linha (AL, pois AH = 0)
    
    MOV [BP+1], AL           ; y = AL 
    
    RET
    
        
erro:

    GOTOXY 20, 4
    
    MOV AH, 9
    LEA DX, msg_erro
    INT 21h
    
    RET


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


ler_nome:
    
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


imprimir_nomes:
    
    GOTOXY 2, 14
    
    LEA DX, p1_nome
    MOV AH, 9
    INT 21h
    
    GOTOXY 2, 16
    
    LEA DX, p2_nome
    MOV AH, 9
    INT 21h
    
    RET
    

imprimir_moldura:
    
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
            MOV ES:[9Fh+SI], 0000_1001b   ; mudar o tab. para azul
            
            ADD SI, 2    
        LOOP m2
        
        POP SI
        POP CX 
        
        ADD SI, 9Eh         
    LOOP m1    
    
    RET
 
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

END