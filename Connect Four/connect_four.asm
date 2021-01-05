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
    
    msg_empate DB "O jogo terminou em empate!$"
    
    msg_erro DB "Erro.$"
    
    last_position DB 2 DUP(-1)     ; posicao da ultima peca colocada    

DEFINE_CLEAR_SCREEN

include check.asm

include interface79x24.asm  ;include interface80x25.asm

include play.asm

start:
    
    MOV AX, 0B800h
    MOV ES, AX
	
    CALL perguntar_nomes
    
    CALL CLEAR_SCREEN
    
    CALL imprimir_moldura
    
    CALL imprimir_nomes
    
    CALL RANDSTART  ;escolhe ordem dos jogadores
    
    LEA BX, turn    ;guarda a vez ("turn")
    MOV [BX], DL
    
    CMP DL, 0       ;turn=0 => p1 seguido de p2
    JE p1_p2
    
    CMP DL, 1       ;turn=1 => p2 seguido de p1
    JE p2_p1
;////////////////////////////////////    
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
        
        MOV CX, 18
        loop_final12:
            PUSH CX
            
            CALL jogada
  
            CALL check_horizontal
        
            CALL check_vertical
            
            CALL check_diagonalv2   ;check_diagonalv1
            
            LEA BX, turn
            MOV [BX], 1
    
            CALL jogada
    
            CALL check_horizontal
        
            CALL check_vertical
            
            CALL check_diagonalv2   ;check_diagonalv1
            
            LEA BX, turn
            MOV [BX], 0 
            
            POP CX     
        LOOP loop_final12
        
        CALL empate
;//////////////////////////////////////    
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
        
        MOV CX, 18
        loop_final21:
            PUSH CX
            
            CALL jogada
  
            CALL check_horizontal
        
            CALL check_vertical
            
            CALL check_diagonalv2   ;check_diagonalv1
            
            LEA BX, turn
            MOV [BX], 0
    
            CALL jogada
    
            CALL check_horizontal
        
            CALL check_vertical
            
            CALL check_diagonalv2   ;check_diagonalv1
            
            LEA BX, turn
            MOV [BX], 1
            
            POP CX      
        JMP loop_final21    
    
        CALL empate
;////////////////////////////////// 


RANDSTART:          ; gera numero aleatorio entre 0 e 1
   
   MOV AH, 00h       
   INT 1AH     

   MOV  AX, DX
   XOR  DX, DX
   MOV  CX, 2    
   DIV  CX  

RET

END