MODULE Module1
      
    ! ================== INTEGRANTES ==================
    ! Nomes:
    ! Ana Laura Belotto Claudio - R.A: 11035315
    ! Gilmar Correia Jeronimo - R.A: 11014515
    ! Lucas Barboza Moreira Pinheiro - R.A: 11017015
    ! =================================================
     
    PERS robtarget pHome:=[[807.94,22.13,949.61],[2.82776E-8,-0.236102,-0.971728,7.69646E-9],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    
    VAR num novamente := 1; !Variável que verifica se será jogado novamente, se for = 1, o while continua executando
    VAR num vencedor:=0; !Verifica  jogador vencedor
    VAR num vitoriasPlayer1:=0; !Contabiliza as vitórias do player1
    VAR num vitoriasPlayer2:=0; !Contabiliza as vitórias do player2
    
    VAR num pecasJogo{qtdPecas,2}; !Array que guarda as peças do jogo
    VAR num pecasCompra{qtdPecas,2}; !Array que guarda as peças compradas
    VAR num pecasCompradas:=14; !Define a quantidade de peças compradas
    VAR num maior:=-1; !Inicializa para achar o maior
    VAR bool empate := FALSE; !Se for empate, não conta vitória para nenhum dos jogadores
    
    VAR pos centroD; !Variável que atualiza o centro da extrema direita do jogo
    VAR pos centroE; !Variável que atualiza o centro da extrema esquerda do jogo
    PERS bool primVezD:=FALSE; !Variável que define se o jogo virou para a vertical na extremidade direita
    PERS bool primVezE:=FALSE; !Variável que define se o jogo virou para a vertical na extremidade esquerda
    PERS bool prevDobreD := FALSE; !Variável que guarda se a peça anterior da direita foi dobre 
    PERS bool prevDobreE := FALSE; !Variável que guarda se a peça anterior da esquerda foi dobre
    
    
    PROC main()
        MoveL pHome,vel,zone,tool0;
        
        WHILE novamente = 1 DO
            TPErase;
            clear;
            
            %"setarTela"%;
            TPReadFK novamente, "Deseja jogar novamente?","Sim", "Não",stEmpty,stEmpty,stEmpty;
            
            IF vencedor =1 THEN
                vitoriasPlayer1 := vitoriasPlayer1 + 1;
            ELSEIF vencedor =2 THEN
                vitoriasPlayer2 := vitoriasPlayer2 + 1;
            ENDIF
            
        ENDWHILE
        
        TPWrite "";
        TPWrite "Placar final-> Jogador: "+NumToStr(vitoriasPlayer1,0)+" PC:"+NumToStr(vitoriasPlayer2,0);
        WaitTime 2.0;
    ENDPROC
    
    
    !Limpa as variáveis para iniciar um novo jogo
    PROC clear()
        pecasCompra := pecasJogo;
        centroD.x:=0;
        centroD.y:=0;
        centroD.z:=0;
        centroE.x:=0;
        centroE.y:=0;
        centroE.z:=0;
        pecasCompradas :=14;
        maior := -1;
        empate := FALSE;
        primVezD:=TRUE;
        primVezE:=TRUE;
        prevDobreD := FALSE;
        prevDobreE := FALSE;
        !pHome := Offs(pHome,0,0,50);
    ENDPROC
    
ENDMODULE


