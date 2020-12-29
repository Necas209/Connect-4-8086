include emu8086.inc

JMP start

    linha1 DB 7 DUP(' ')    ;|      ; 1 -> pecas do p1
    linha2 DB 7 DUP(' ')    ;|      ; 2 -> pecas do p2
    linha3 DB 7 DUP(' ')    ;|
    linha4 DB 7 DUP(' ')    ;|
    linha5 DB 7 DUP(' ')    ;V
    linha6 DB 7 DUP(' ')    ;da fila mais baixa para a mais alta
    
      
    frame2 DB 204,205,206,205,206,205,206,205,206,205,206,205,206,205,185,"$"  ;lateral c/ lig    
    frame3 DB 200,205,202,205,202,205,202,205,202,205,202,205,202,205,188,"$"  ;inferior    
    frame4 DB 186," ",186," ",186," ",186," ",186," ",186," ",186," ",186,"$" ;lateral s/ lig 

    turn DB " "
    
    sim DB 1
    
    msg_p1 DB "Jogador 1$"
    msg_p2 DB "Jogador 2$" 
    msg_jogada DB "Indique a coluna: $"
    
    p1_nome DB "Jogador 1 (",1,") -           $"
    p2_nome DB "Jogador 2 (",2,") -           $"
    msg_ask_p1 DB "Nome do jogador 1: $"
    msg_ask_p2 DB "Nome do jogador 2: $"
    
    msg_erro DB "Erro.$"
    
    last_position DW -1
    
DEFINE_CLEAR_SCREEN
    
check_horizontal PROC
    
    
    RET
    
check_horizontal ENDP


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
    CALL imprimir_tabuleiro
    
    CALL jogada
    
    LEA BX, turn
    MOV [BX], 1
    
    CALL imprimir_tabuleiro
    
    CALL jogada
    
    LEA BX, turn
    MOV [BX], 0  
   
    CMP [sim], 1
    
    LOOPE p1_p2
    
    JMP FIM
    
    p2_p1:
    
    CALL imprimir_tabuleiro
    
    CALL jogada
    
    LEA BX, turn
    MOV [BX], 1
    
    CALL imprimir_tabuleiro
    
    CALL jogada
    
    LEA BX, turn
    MOV [BX], 0  
   
    CMP [sim], 1
    
    LOOPE p1_p2
    
    FIM:
    
    MOV AX, 4C00h
    INT 21h

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
    XOR SI, SI
    
    loop_jog:
    CMP SI, 42
    JE jog_erro
    ADD SI, 7  
    CMP [linha1+BX+SI-7], ' '
    JNE loop_jog
    
    LEA DI, [linha1+BX+SI-7]
    
    LEA BX, last_position
    MOV [BX], DI
    
    CMP turn[0], 0
    JE jogada_p1
    JMP jogada_p2
    
    jogada_p1:
    MOV [DI], 1
    RET
    
    jogada_p2:
    MOV [DI], 2
    RET
    
    jog_erro:
    CALL erro
    JMP jog                                                      
     
jogada ENDP                                                      


erro:

    GOTOXY 20, 4
    
    MOV AH, 9
    LEA DX, msg_erro
    INT 21h
    
    RET


perguntar_nomes PROC

    LEA DX, msg_ask_p1
    GOTOXY 2, 2
    MOV AH, 9
    INT 21h
    
    LEA BX, p1_nome
    ADD BX, 16
    CALL ler_nome
    
    LEA DX, msg_ask_p2
    GOTOXY 2, 4
    MOV AH, 9
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
    
    RET
 
              
imprimir_tabuleiro PROC

    MOV BP, 0
    MOV SI, 35
    MOV CX, 6
    c:  
        PUSH SI
        PUSH CX
        MOV CX, 7
        c2: 
            LEA BX, linha1
            MOV AL, ES:[0A0h+BP]
            MOV AH, [BX+SI]
            CMP AL, AH
            JE avancar_imp
            MOV ES:[0A0h+BP], AH
            avancar_imp:
            ADD BP, 4
            INC SI 
        LOOP c2
        POP CX
        POP SI
        SUB SI, 7
        ADD BP, 120h 
    LOOP c
    
    RET
     
imprimir_tabuleiro ENDP
 

END