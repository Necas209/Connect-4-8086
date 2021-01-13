
name "Connect Four"

ORG 100h

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
    
    nc DB 0, 0
    nl DB 0, 0
    
    p1_nome DB "Jogador 1 (",1,") -           $"
    p2_nome DB "Jogador 2 (",2,") -           $"
   
    last_position DB 2 DUP(-1)     ; posicao da ultima peca colocada    
    
    no_jogadas DB 0
    jog_max DB 0

include macros.inc
    
DEFINE_CLEAR_SCREEN

include check.asm

include interface79x24.asm  ;include interface80x25.asm

include play.asm

start:
    
    MOV AX, 0B800h
    MOV ES, AX
    
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
    
    LEA BX, turn    ;guarda a vez ("turn")
    MOV [BX], DL
    
    CMP DL, 0       ;turn=0 => p1 seguido de p2
    JE p1_p2
    
    CMP DL, 1       ;turn=1 => p2 seguido de p1
    JE p2_p1
;////////////////////////////////////    
    p1_p2:                   
       loop1_2:
            CALL jogada                        
            INC [no_jogadas]
            
            CMP [no_jogadas], 7
            JGE check_hvd
            JMP not_check
            
            check_hvd:
            CALL check_horizontal        
            CALL check_vertical            
            CALL check_diagonal   
            
            not_check:
            INC [turn]
            
            CALL jogada           
            INC [no_jogadas]
            
            CMP [no_jogadas], 8
            JGE check_hvd2
            JMP not_check2
            
            check_hvd2:
            CALL check_horizontal        
            CALL check_vertical            
            CALL check_diagonal
            
            not_check2:            
            DEC [turn]
            
            MOV DL, [no_jogadas]
            CMP DL, [jog_max]        
        JNE loop1_2               
        
        CALL empate
;//////////////////////////////////////    
    p2_p1:            
        loop2_1:
            CALL jogada
            INC [no_jogadas]
            
            CMP [no_jogadas], 7
            JGE check_hvd3
            JMP not_check3
                         
            check_hvd3:
            CALL check_horizontal        
            CALL check_vertical            
            CALL check_diagonal
            
            not_check3:
            DEC [turn]

            CALL jogada
            INC [no_jogadas]
            
            CMP [no_jogadas], 8
            JGE check_hvd4
            JMP not_check4
            
            check_hvd4:
            CALL check_horizontal        
            CALL check_vertical            
            CALL check_diagonal
            
            not_check4:
            INC [turn]
            
            MOV DL, [no_jogadas]
            CMP DL, [jog_max]   
        JNE loop2_1 
    
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