
name "4 Em Linha"

ORG 100h

JMP start
    
    
    title1 DB "||  ||    ||||||  ||\\  //||    ||      ||||||  |\   ||  ||  ||  ||||||$"
    title2 DB "||  ||    ||      || \\// ||    ||        ||    ||\  ||  ||  ||  ||  ||$"
    title3 DB "||||||    ||||||  ||  \/  ||    ||        ||    ||\\ ||  ||||||  ||||||$"
    title4 DB "    ||    ||      ||      ||    ||        ||    || \\||  ||  ||  ||  ||$"
    title5 DB "    ||    ||||||  ||      ||    ||||||  ||||||  ||  \\|  ||  ||  ||  ||$"
             
    tabuleiro DB 81 DUP(' ')     ; 1 -> pecas do p1 & 2 -> pecas do p2

    turn DB " "                  ; vez do jogador: 0 -> p1, 1 -> p2

    nc DB 0, 0
    nl DB 0, 0

    p1_nome DB "Jogador 1 (",1,") -           $"
    p2_nome DB "Jogador 2 (",2,") -           $"

    last_position DB 2 DUP(-1)    ; posicao da ultima peca colocada

    jog_max DB 0, 0

include macros.inc

DEFINE_CLEAR_SCREEN

include check.asm

include interface.asm

include play.asm

start:

    CALL CLEAR_SCREEN
    
    CALL imprimir_titulo
    
    CALL perguntar_dimensoes

    MOV AL, [nc]
    MUL [nl]
    MOV [jog_max], AL

    CALL CLEAR_SCREEN

    CALL perguntar_nomes

    CALL CLEAR_SCREEN

    CALL imprimir_moldura

    CALL imprimir_nomes

    CALL RANDSTART  ;escolhe ordem dos jogadores

    MOV CX, w.[jog_max]
    
    loop_jogo:
        PUSH CX
    
        CALL jogada
        
        CALL check_horizontal
        CALL check_vertical
        CALL check_diagonal
        
        CMP [turn], 0
        JE p2
        
        DEC [turn]
        JMP cont_loop_jogo
        
        p2:
            INC [turn]
        
        cont_loop_jogo:
        
        POP CX
    LOOP loop_jogo
    
    CALL empate
;//////////////////////////////////


RANDSTART:          ; gera numero aleatorio entre 0 e 1

   MOV AH, 00h
   INT 1AH

   MOV  AX, DX
   XOR  DX, DX
   MOV  CX, 2
   DIV  CX
   
   MOV [turn], DL  ;guarda a vez ("turn")
RET

END