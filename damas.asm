include emu8086.inc

ORG 100h

JMP start

    frame1 DB 201
    frame2 DB 7 DUP (205, 203)
    frame3 DB 205, 187, "$"
    
    frame4 DB 204
    frame5 DB 7 DUP (205, 206)
    frame6 DB 205, 185, "$"
    
    frame7 DB 200
    frame8 DB 7 DUP (205, 202)
    frame9 DB 205, 188, "$"
    
    frame10 DB 186
    frame11 DB 7 DUP (' ', 186)
    frame12 DB " ", 186,"$"
    
    L1 DB 4 DUP (219, 4)
    L2 DB 4 DUP (4, 219)
    L3 DB 4 DUP (219, 4)
    L4 DB 4 DUP (0, 219)
    L5 DB 4 DUP (219, 0)
    L6 DB 4 DUP (6, 219)
    L7 DB 4 DUP (219, 6)
    L8 DB 4 DUP (6, 219)

    nome DB 10 DUP(32)
    
    perguntar_nome DB "Introduza o nome: $"
    
    pecas DB 12,12
    
    fim DB 0

    turn DB " "
    
    mem DW 01E0h, 31Ch, 0458h, 0594h, 06D0h, 080Ch, 0948h, 0A84h

start:

    MOV AX, 3
    INT 10h          ; modo de video

    MOV AX, 1003h
    MOV BX, 0
    INT 10h          ; desativar piscar

    MOV AX, 0B800h
    MOV ES, AX       ; segmento extra para escrever no ecra
    
    CALL ask_name

    CALL print_tab
    
    CALL RANDSTART
    
    CMP [turn], 0
    JE p1_p2
    JMP p2_p1
    
    p1_p2:
    loop1:
    CALL p_turn
    INC turn[0]
    CALL p_turn
    DEC turn[0]
    CMP  [fim], 0
    LOOPNE loop1
    JMP ending
    
    p2_p1:
    loop2:
    CALL p_turn
    DEC turn[0]
    CALL p_turn
    INC turn[1]
    CMP  [fim], 0
    LOOPNE loop2
    
    ending:
    MOV AX, 4C00h
    INT 21h

msg_ask_move DB "Insira a posicao da peca que pretende mover:$"
msg_erro DB "Peca/jogada invalida.$"
msg_x DB "X: $"
msg_y DB "Y: $"
possible_moves DW 4 DUP(-1)

p_turn PROC 
    turn_restart:
    GOTOXY 12, 2
    LEA DX, msg_ask_move
    MOV AH, 9
    INT 21h
    
    GOTOXY 12, 4 
    LEA DX, msg_x
    MOV AH, 9
    INT 21h
    
    GOTOXY 12, 6
    MOV BH, DL
    LEA DX, msg_y
    MOV AH, 9
    INT 21h
    
    MOV BL, DL
    CALL convert_coord
    
    CMP turn[0], 0
    JE p1
    CMP turn[1], 1
    JE p2
    
    p2:
        CMP [L1+BX], 4
        JE p2_peao
        CMP [L1+BX], 3
        JE p2_dama
        JMP erro
        
    p1:
        CMP [L1+BX], 6
        JE p1_peao
        CMP [L1+BX], 5
        JE p1_dama
        
    erro:
    GOTOXY 12, 8
    MOV AH, 9
    LEA DX, msg_erro
    INT 21h
    JMP turn_restart
    
    p1_peao:
        CMP BX, 9
        JNL     
p_turn PROC
    
check_eatable PROC
            
check_eatable ENDP

convert_coord PROC  ; recebe coordenadas (x,y) em BX e converte-as para um offset no tabuleiro
    DEC BH
    DEC BL
    MOV AX, BX
    MUL AL, 8
    ADD AH, AL
    XOR BX, BX
    MOV BL, AH
    RET
convert_coord ENDP
             
p_turn ENDP    
        
RANDSTART:          ; gera numero aleatorio entre 0 e 1
   MOV AH, 00h       
   INT 1AH     

   mov  ax, dx
   xor  dx, dx
   mov  cx, 2    
   div  cx
   MOV  [turn], DH   
RET

print_line MACRO addr
    PUSH AX
    PUSH DX
    MOV AH, 9
    LEA DX, addr
    INT 21h
    POP DX
    POP AX
ENDM

   
print_tab PROC
    
    CALL CLEAR_SCREEN
    
    GOTOXY 2, 2            ;moldura
    print_line frame1
    GOTOXY 2, 3
    print_line frame10
    
    MOV AL, 4
    MOV CX, 7
    
    lados:
    GOTOXY 2, AL
    print_line frame4
    INC AL
    GOTOXY 2, AL
    print_line frame10 
    INC AL
    LOOP lados
    
    GOTOXY 2, 18
    print_line frame7    ;fim da moldura
    
    MOV SI, 0
    MOV BP, 0
    MOV CX, 8
    t:   
        MOV BX, [mem+BP]  
        MOV DI, 0
        PUSH CX
        MOV CX, 8
        l:  
            MOV AH, [L1+SI]
            MOV ES:[BX+DI], AH
             
            ADD DI, 4       
            INC SI
        LOOP l
        ADD BP, 2
        POP CX
    LOOP t

    RET
print_tab ENDP

ask_name PROC
    GOTOXY 3, 3  
    
    MOV AH, 9
    LEA DX, perguntar_nome
    INT 21h
    
    MOV DI, 0
    
    r:
    MOV AH, 1
    INT 21h 
    
    MOV [nome+DI], AL
    
    INC DI
    
    CMP AL, 13
    LOOPNE r
    
    RET
ask_name ENDP


DEFINE_CLEAR_SCREEN

END start