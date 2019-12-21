MODULE Module1
      
    ! ================== INTEGRANTES ==================
    ! Nomes:
    ! Ana Laura Belotto Claudio - R.A: 11035315
    ! Gilmar Correia Jeronimo - R.A: 11014515
    ! Lucas Barboza Moreira Pinheiro - R.A: 11017015
    ! =================================================
     
    PERS robtarget pHome:=[[807.94,22.13,949.61],[2.82776E-8,-0.236102,-0.971728,7.69646E-9],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    
    VAR num novamente := 1; !Vari�vel que verifica se ser� jogado novamente, se for = 1, o while continua executando
    VAR num vencedor:=0; !Verifica  jogador vencedor
    VAR num vitoriasPlayer1:=0; !Contabiliza as vit�rias do player1
    VAR num vitoriasPlayer2:=0; !Contabiliza as vit�rias do player2
    
    VAR num pecasJogo{qtdPecas,2}; !Array que guarda as pe�as do jogo
    VAR num pecasCompra{qtdPecas,2}; !Array que guarda as pe�as compradas
    VAR num pecasCompradas:=14; !Define a quantidade de pe�as compradas
    VAR num maior:=-1; !Inicializa para achar o maior
    VAR bool empate := FALSE; !Se for empate, n�o conta vit�ria para nenhum dos jogadores
    
    VAR pos centroD; !Vari�vel que atualiza o centro da extrema direita do jogo
    VAR pos centroE; !Vari�vel que atualiza o centro da extrema esquerda do jogo
    PERS bool primVezD:=FALSE; !Vari�vel que define se o jogo virou para a vertical na extremidade direita
    PERS bool primVezE:=FALSE; !Vari�vel que define se o jogo virou para a vertical na extremidade esquerda
    PERS bool prevDobreD := FALSE; !Vari�vel que guarda se a pe�a anterior da direita foi dobre 
    PERS bool prevDobreE := FALSE; !Vari�vel que guarda se a pe�a anterior da esquerda foi dobre
    
    
    PROC main()
        MoveL pHome,vel,zone,tool0;
        
        WHILE novamente = 1 DO
            TPErase;
            clear;
            
            %"setarTela"%;
            TPReadFK novamente, "Deseja jogar novamente?","Sim", "N�o",stEmpty,stEmpty,stEmpty;
            
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
    
    
    !Limpa as vari�veis para iniciar um novo jogo
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


