

    MOV AX, 0b800h
    MOV DS, AX           ; carrega para DS a zona da memoria de video
    
    MOV SI, 1
    
    MOV BL, 0000_0000b   ; inicia BL com a 1a cor, preto
    
    MOV CX, 16
    
    teste:
        
        MOV DS:[SI], BL  ; carrega para a memoria de video o valor de BL da cor
        
        ADD SI, 2
        
        ADD BL, 0001_0000b ; avanca para a cor de fundo seguinte
    
    LOOP teste 

    RET

END