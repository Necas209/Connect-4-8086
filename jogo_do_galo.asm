
JMP jogo_do_galo

galo1 DB 3 DUP(' ')     ; 1 -> p1
galo2 DB 3 DUP(' ')     ; 2 -> p2
galo3 DB 3 DUP(' ')

frame1 DB 32, 32, 179, 32, 179, 32, 32, "$"
frame2 DB 196, 196, 197, 196, 197, 196, 196, "$"

turn DB 1
jogo_do_galo:
    
    MOV CX, 2
    c1:            ; p1 -> p2 -> p1 -> p2...
    
    CALL jogada
    CALL update_screen

    LEA BX, turn
    ADD [BX], 1
    
    
    CALL jogada
    CALL update_screen
    
    LEA BX, turn
    SUB [BX], 1
    
    LOOP c1
    
    MOV CX, 2
    
    c2:            ; p1 -> p2 -> p1 -> p2...
    
    CALL jogada
    CALL update_screen
    CALL verificar
    
    LEA BX, turn
    ADD [BX], 1
    
    
    CALL jogada
    CALL update_screen
    CALL verificar
    
    LEA BX, turn
    SUB [BX], 1
    
    LOOP c2
    
    CALL jogada
    CALL update_screen
    CALL verificar
    
    RET

msg_x DB "Insira o X: "
msg_y DB "Insira o Y: "

verificar:
    
    MOV CX, 3
    v_h1:
        
    RET
    
jogada:
    start_jogada:
    GOTOXY 10, 2
    
    LEA DX, msg_x
    MOV AH, 9
    
    MOV AH, 1
    INT 21h
    
    CMP AL, '1'
    JL erro
    
    CMP AL, '3'
    JG erro
    
    MOV AH, 0
    SUB AL, '1'
    MOV SI, AL
    
    GOTOXY 10, 4
    
    LEA DX, msg_y
    MOV AH, 9
    
    MOV AH, 1
    INT 21h
    
    CMP AL, '1'
    JL erro
                              ;AL SI = ( y , x )
    CMP AL, '3'
    JG erro
    
    MOV AH, 0
    SUB AL, '1'
    
    CMP AL, 0
    JE j_l1
    
    CMP AL, 1
    JE j_l2
    
    JMP j_l3
    
    j_l1:
    LEA BX, galo1 
    JMP j_avancar
    
    j_l2:
    LEA BX, galo2
    JMP j_avancar
    
    j_l3:
    LEA BX, galo3
    
    j_avancar:
    CMP [BX+SI], ' '
    JNE erro
    MOV [BX+SI], turn[0]
    RET
    
    erro:
    GOTOXY 10, 6
    
    LEA DX, msg_erro
    MOV AH, 9
    INT 21h
    
    JMP start_jogada
    RET
 
msg_erro DB "Erro.$"      