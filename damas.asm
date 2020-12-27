include emu8086.inc

ORG 100h

JMP start

    ind_x DB "   A   B   C   D   E   F   G   H$" 
    ind_y DB "1 $"
    
    L1 DB 4 DUP(6,32)
    L2 DB 4 DUP(32,6)
    L3 DB 4 DUP(6,32)
    L4 DB 8 DUP(32)
    L5 DB 8 DUP(32)
    L6 DB 4 DUP(32,4)
    L7 DB 4 DUP(4,32)
    L8 DB 4 DUP(32,4)
    
    nome DB 10 DUP(32)
    
    pecas DB 12,12
    
    mem DW 03C9h, 04FDh, 0641h, 0775h, 08B9h, 09EDh, 0B31h, 0C65h
    
start:
   
    mov ax, 3
    int 10h          ; modo de video
 
    mov ax, 1003h
    mov bx, 0                      
    int 10h          ; desativar piscar
 
    MOV AX, 0B800h
    MOV ES, AX       ; segmento extra para escrever no ecra

    CALL print_index

    CALL print_tab
    
    MOV AX, 4C00h
    INT 21h

print_tab PROC
    
    
    MOV SI, 0
    MOV DI, 0
    MOV BL, 6
    MOV CX, 8
    
    t:  
        PUSH CX
        GOTOXY 6, BL
        PUSH BX
        MOV BX, [mem+DI]
        MOV CX, 8
        l:                 
            MOV AH, 2
            MOV DL, [L1+SI]
            INT 21h
            
            PRINT "   "  
            
            INC SI  
        LOOP l
        MOV CX, 4
        l_2:
             MOV ES:[BX], 1111_0000b
             ADD BX, 16
        LOOP l_2
        POP BX
        ADD DI, 2
        ADD BL, 2
        POP CX
    LOOP t
    
    RET
print_tab ENDP

 
print_index PROC
    ; imprimir indice A-H 
    GOTOXY 3, 4 

    MOV AH, 9
    LEA DX, ind_x
    INT 21h
    ; imprimir indice 1-8 
    MOV BX, 0306h
    MOV CX, 8

    c:
        GOTOXY BH, BL  

        MOV AH, 9
        LEA DX, ind_y
        INT 21h
  
        ADD BL, 2 
        INC [ind_y]
    LOOP c 

    RET
print_index ENDP