MODULE TELA
   
    ! ================== INTEGRANTES ==================
    ! Nomes:
    ! Ana Laura Belotto Claudio - R.A: 11035315
    ! Gilmar Correia Jeronimo - R.A: 11014515
    ! Lucas Barboza Moreira Pinheiro - R.A: 11017015
    ! =================================================
      
    CONST num qtdPecas:=28;
  
    VAR num tempoDelay:=0.5;
     
    VAR num pecasJogador1{qtdPecas};
    VAR num pecasJogador2{qtdPecas};
    VAR num pecasJogadores{qtdPecas,2};

    VAR bool quemJogaPrimeiro;
    VAR num escolhaPlayer{2};
    VAR num qtdPecasPlayer{2};
    VAR num pecasNaMao{2};
    VAR num pontosNaMao{2};
    VAR num player;
    VAR num vaiEscolherNovamente;
    VAR bool vaiComprar;
    VAR bool direcaoJogada; !Se for true, jogou na direita, se for false, jogou na esquerda.
    
    VAR num pecaD;
    VAR num pecaE;

    !! =======================================================================================================================
    !!                                              FUN��O DE RANDOM - TIRADO DO SITE ()
    !! =======================================================================================================================

    LOCAL VAR num nSeed:=320;
    LOCAL VAR num nSeed_age:=150;

    LOCAL FUNC num Random()
        CONST num nModulus:=625;
        CONST num nMultiplier:=251;
        CONST num nIncrement:=13849;

        IF nSeed_age>140 THEN
            nSeed:=GetTime(\Sec)*GetTime(\Min);
            nSeed_age:=0;
        ENDIF

        nSeed_age:=nSeed_age+1;
        nSeed:=((nMultiplier*Abs(nSeed))+nIncrement) MOD nModulus;

        RETURN Round(((nSeed/nModulus)*27)+1);
    ENDFUNC 

    !! =======================================================================================================================
    !! =======================================================================================================================
    !! =======================================================================================================================

    PROC setarPecas()

        pecasJogo:=[[0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],
                     [1,1],[1,2],[1,3],[1,4],[1,5],[1,6],
                     [2,2],[2,3],[2,4],[2,5],[2,6],
                     [3,3],[3,4],[3,5],[3,6],
                     [4,4],[4,5],[4,6],
                     [5,5],[5,6],
                     [6,6]];
        pecasCompra:=pecasJogo;
    ENDPROC

    ! Essa fun��o sorteia as pe�as para ambos os jogadores no come�o da partida
    FUNC bool sortearPecas()

        ! Seta as vari�veis
        VAR num rand;
        VAR bool quemPossuiMaiorPeca;

        ! Esse for sorteia 7 pe�as e as coloca para o jogador 1. Sorteia mais 7 e coloca para o jogador 2,
        ! Nesta fun��o j� se define quem come�a com a maior pe�a, controlado pela vari�vel maior e quemPossuiMaiorPeca;
        FOR i FROM 1 TO 14 DO
            rand:=Random();

            WHILE pecasCompra{rand,1}=-1 DO
                rand:=Random();
            ENDWHILE

            IF maior<rand THEN
                maior:=rand;
                quemPossuiMaiorPeca:=(i<=7);
            ENDIF

            IF i<=7 THEN
                pecasJogador1{i}:=rand;
            ELSE
                pecasJogador2{i-7}:=rand;
            ENDIF

            pecasCompra{rand,1}:=-1;
            pecasCompra{rand,2}:=-1;
        ENDFOR

        RETURN quemPossuiMaiorPeca;

    ENDFUNC

    PROC imprimePecas(num jogador,num qtdPecasPlayer,num delay)

        VAR string str1 := "#P:";
        VAR string cima := "   ";
        VAR string str2 := "   ";
        VAR string meio := "   ";
        VAR string str3 := "   ";
        VAR string baixo := "   ";
        
        WaitTime delay;
        TPWrite " ";
        
        FOR i FROM 1 TO qtdPecasPlayer DO
            IF pecasCompra{pecasJogadores{i,jogador},1}<>-2 THEN
                str1 := str1 + " "+NumToStr(i,0) + "  ";
                cima := cima +" _  ";
                str2 := str2 + "|" + NumToStr(pecasJogo{pecasJogadores{i,jogador},1},0) + "| ";
                meio := meio +"|-| ";
                str3 := str3 + "|" + NumToStr(pecasJogo{pecasJogadores{i,jogador},2},0) + "| ";
                baixo := baixo +" �  ";
            ENDIF
        ENDFOR
        
        TPWrite "Pe�as do Jogador " + NumToStr(jogador,0);
        TPWrite str1;
        TPWrite cima;
        TPWrite str2;
        TPWrite meio;
        TPWrite str3;
        TPWrite baixo;
        
        WaitTime delay;

    ENDPROC

    PROC defineJogada(num player)

        VAR NUM rand;
        VAR NUM escolhaLado;
        VAR bool podeEscolher := FALSE;

        WHILE escolhaPlayer{player}>qtdPecasPlayer{player} DO
            
            ! VERIFICA SE O PLAYER POSSUI ALGUMA PE�A QUE POSSA SER ENCAIXADO NO JOGO E ESCOLHE ELA CASO SEJA O COMPUTADOR
            FOR peca FROM 1 TO qtdPecasPlayer{player} DO
                IF ((pecasJogo{pecasJogadores{peca,player},1}=pecaD OR pecasJogo{pecasJogadores{peca,player},2}=pecaD) OR (pecasJogo{pecasJogadores{peca,player},1}=pecaE OR pecasJogo{pecasJogadores{peca,player},2}=pecaE)) AND pecasCompra{pecasJogadores{peca,player},1}<>-2 THEN
                    podeEscolher := TRUE;
                    IF player = 2 THEN
                        escolhaPlayer{player}:=peca;
                    ENDIF
                ENDIF
            ENDFOR
                
            IF (player=1) THEN
                ! C�DIGO PARA A PESSOA
                TPWrite "Sua vez";
                imprimePecas player,qtdPecasPlayer{player},1.5;
                WaitTime 0.5;
                
                WHILE escolhaPlayer{player}>qtdPecasPlayer{player} AND podeEscolher DO
                    TPReadNum escolhaPlayer{player},"Selecione a Pe�a para Jogar";
                    IF escolhaPlayer{player}>qtdPecasPlayer{player} OR pecasCompra{pecasJogadores{escolhaPlayer{player},player},1}=-2 THEN
                        TPWrite "N�mero inv�lido, escolha novamente";
                        escolhaPlayer{player}:=100;
                    ENDIF
                ENDWHILE
            ELSE
                ! C�DIGO PARA O COMPUTADOR
                TPWrite "Vez do Computador";
                !imprimePecas player,qtdPecasPlayer{player},1.0;
                !WaitTime 0.5;
            ENDIF
            
            !SE N�O POSSUIR PE�AS QUE POSSAM SER ESCOLHIDAS ENT�O SE SELECIONA UMA PE�A AUTOMATICAMENTE ERRADA, E ASSIM SE REALIZA A COMPRA DA PE�A
            IF (escolhaPlayer{player}>qtdPecasPlayer{player} OR pecasCompra{pecasJogadores{escolhaPlayer{player},player},1}=-2) AND (not podeEscolher) THEN
                FOR peca FROM 1 TO qtdPecasPlayer{player} DO
                    IF pecasCompra{pecasJogadores{peca,player},1}<>-2 THEN
                        escolhaPlayer{player}:=peca;
                    ENDIF
                ENDFOR
            ENDIF

            ! VERIFICA SE � POSS�VEL JOGAR A PE�A DESEJADA, SE N�O REALIZA A COMPRA DE PE�AS
            IF pecasJogo{pecasJogadores{escolhaPlayer{player},player},1}=pecaD OR pecasJogo{pecasJogadores{escolhaPlayer{player},player},2}=pecaD THEN
                IF ((pecasJogo{pecasJogadores{escolhaPlayer{player},player},1}=pecaE OR pecasJogo{pecasJogadores{escolhaPlayer{player},player},2}=pecaE) AND (player=1)) THEN
                    TPReadFK escolhaLado,"Deseja jogar para qual lado ","Direita: "+NumToStr(pecaD,0),"Esquerda: "+NumToStr(pecaE,0),stEmpty,stEmpty,stEmpty;
                    IF escolhaLado=1 THEN
                        IF pecasJogo{pecasJogadores{escolhaPlayer{player},player},1}=pecaD THEN
                            pecaD:=pecasJogo{pecasJogadores{escolhaPlayer{player},player},2};
                        ELSE
                            pecaD:=pecasJogo{pecasJogadores{escolhaPlayer{player},player},1};
                        ENDIF
                        direcaoJogada:=TRUE;
                    ELSE
                        IF pecasJogo{pecasJogadores{escolhaPlayer{player},player},1}=pecaE THEN
                            pecaE:=pecasJogo{pecasJogadores{escolhaPlayer{player},player},2};
                        ELSE
                            pecaE:=pecasJogo{pecasJogadores{escolhaPlayer{player},player},1};
                        ENDIF
                        direcaoJogada:=FALSE;
                    ENDIF
                ELSE
                    IF pecasJogo{pecasJogadores{escolhaPlayer{player},player},1}=pecaD THEN
                        pecaD:=pecasJogo{pecasJogadores{escolhaPlayer{player},player},2};
                    ELSE
                        pecaD:=pecasJogo{pecasJogadores{escolhaPlayer{player},player},1};
                    ENDIF

                    direcaoJogada:=TRUE;
                ENDIF
            ELSEIF pecasJogo{pecasJogadores{escolhaPlayer{player},player},1}=pecaE OR pecasJogo{pecasJogadores{escolhaPlayer{player},player},2}=pecaE THEN

                IF pecasJogo{pecasJogadores{escolhaPlayer{player},player},1}=pecaE THEN
                    pecaE:=pecasJogo{pecasJogadores{escolhaPlayer{player},player},2};
                ELSE
                    pecaE:=pecasJogo{pecasJogadores{escolhaPlayer{player},player},1};
                ENDIF
                direcaoJogada:=FALSE;

            ELSE
                IF player=1 THEN
                    IF podeEscolher THEN
                        TPReadFK vaiEscolherNovamente,"Pe�a inv�lida, escolha novamente ou compre uma pe�a","Escolher novamente",stEmpty,stEmpty,stEmpty,stEmpty; 
                    ELSE
                        TPWrite "N�o Possui Pe�as, Ser� realizado a compra autom�tica.";
                        WaitTime 1.0;
                        vaiComprar:=TRUE;
                    ENDIF  
                ELSE
                     vaiComprar:=TRUE;
                ENDIF
                
                IF vaiEscolherNovamente=1 AND player=1 THEN
                    escolhaPlayer{player}:=100;
                ELSE
                    ! CRIAR C�DIGO PARA COMPRAR PE�A 
                    TPWrite "Vai Comprar";
                    WaitTime tempoDelay;
                    
                    rand:=Random();

                    WHILE pecasCompra{rand,1}=-1 OR pecasCompra{rand,1}=-2 DO
                        rand:=Random();
                    ENDWHILE

                    qtdPecasPlayer{player}:=qtdPecasPlayer{player}+1;
                    pecasJogadores{qtdPecasPlayer{player},player}:=rand;
                    pecasCompradas := pecasCompradas + 1;
                    IF player = 1 THEN
                        TPWrite "Pe�a comprada: "+NumToStr(pecasJogo{rand,1},0)+"-"+NumToStr(pecasJogo{rand,2},0);
                        WaitTime tempoDelay;
                    ENDIF    
                ENDIF
            ENDIF
        ENDWHILE

        WaitTime tempoDelay;

        !SE N�O COMPRAR PE�A
        IF vaiComprar<>TRUE THEN
            IF direcaoJogada THEN
                IF pecasJogo{pecasJogadores{escolhaPlayer{player},player},1}=pecaD THEN
                    %"desenhaPeca"% pecasJogo{pecasJogadores{escolhaPlayer{player},player},1},pecasJogo{pecasJogadores{escolhaPlayer{player},player},2},direcaoJogada;
                ELSE
                    %"desenhaPeca"% pecasJogo{pecasJogadores{escolhaPlayer{player},player},2},pecasJogo{pecasJogadores{escolhaPlayer{player},player},1},direcaoJogada;
                ENDIF
            ELSE
                IF pecasJogo{pecasJogadores{escolhaPlayer{player},player},2}=pecaE THEN
                    %"desenhaPeca"% pecasJogo{pecasJogadores{escolhaPlayer{player},player},1},pecasJogo{pecasJogadores{escolhaPlayer{player},player},2},direcaoJogada;
                ELSE
                    %"desenhaPeca"% pecasJogo{pecasJogadores{escolhaPlayer{player},player},2},pecasJogo{pecasJogadores{escolhaPlayer{player},player},1},direcaoJogada;
                ENDIF
            ENDIF
            pecasCompra{pecasJogadores{escolhaPlayer{player},player},1}:=-2;
            pecasCompra{pecasJogadores{escolhaPlayer{player},player},2}:=-2;
        ENDIF
        !qtdPecasPlayer{player}:=qtdPecasPlayer{player}-1;

        escolhaPlayer{player}:=100;
        vaiEscolherNovamente := 0; 
        vaiComprar:=FALSE;
 
    ENDPROC

    PROC setarTela()

        VAR num partida:=0;
        VAR num j:=0;
        VAR bool quemJogaPrimeiro;

        pecasNaMao:=[7,7];
        pontosNaMao:=[0,0];

        ! Define a vari�vel para verificar que joga primeiro, ou seja, o jogador que tem a maior pe�a
        escolhaPlayer:=[100,100];
        qtdPecasPlayer:=[7,7];

        ! Seta o vetor de pecas
        setarPecas;

        ! Mostra na tela
        TPWrite "======================================";
        WaitTime 0.25;
        TPWrite "======================================";
        WaitTime 0.25;
        TPWrite "=============== DOMIN� ===============";
        WaitTime 0.25;
        TPWrite "======================================";
        WaitTime 0.25;
        TPWrite "======================================";
        WaitTime 0.25;
        TPWrite " ";

        ! Sorteia as pe�as dos Jogadores
        TPWrite "Sorteando as pe�as dos jogadores";
        WaitTime tempoDelay;

        quemJogaPrimeiro:=sortearPecas();

        FOR i FROM 1 TO qtdPecas DO
            pecasJogadores{i,1}:=pecasJogador1{i};
            pecasJogadores{i,2}:=pecasJogador2{i};
        ENDFOR

        ! Imprime as pe�as do jogador 1 e 2
        imprimePecas 1,qtdPecasPlayer{1},tempoDelay;
        !imprimePecas 2,qtdPecasPlayer{2},tempoDelay;

        ! Verifica quem possui a maior pe�a
        TPWrite " ";
        TPWrite "Verificando quem possui a pe�a maior (6/6 - 5/6 - 5/5 - 4/6 - ...)";
        !<- ARRUMAR ISSO DEPOIS
        TPWrite " ";
        WaitTime tempoDelay;

        ! Mostra o jogador com a maior pe�a
        IF quemJogaPrimeiro THEN
            TPWrite "Voc� baixou a pe�a";
            !qtdPecasPlayer{1}:=qtdPecasPlayer{1}-1;
        ELSE
            TPWrite "Computador baixou a pe�a";
            !qtdPecasPlayer{2}:=qtdPecasPlayer{2}-1;
        ENDIF

        pecasCompra{maior,1}:=-2;
        pecasCompra{maior,2}:=-2;

        quemJogaPrimeiro:=quemJogaPrimeiro XOR TRUE;

        pecaD:=pecasJogo{maior,1};
        pecaE:=pecasJogo{maior,2};

        %"desenhaPeca"% pecaD,pecaE,TRUE;

        !Loop de jogo at� o fim da partida
        ! Se o jogador que baixou a primeira pe�a for o computador, quemJogaPrimeiro ser� TRUE e ent�o ser� a vez do player 1
        ! Se o jogador que baixou a primeira pe�a for o player, quemJogaPrimeiro ser� FALSE e ent�o ser� a vez do computador
        FOR jogador FROM 1 TO 2 DO
            FOR i FROM 1 TO qtdPecasPlayer{jogador} DO
                IF pecasCompra{pecasJogadores{i,jogador},1}=-2 THEN
                    j:=j+1;
                ENDIF
            ENDFOR
            pecasNaMao{jogador}:=qtdPecasPlayer{jogador}-j;
            j:=0;
        ENDFOR
        
        WHILE ((pecasNaMao{1}>0) AND (pecasNaMao{2}>0)) AND (not empate) DO
            TPErase;
            TPWrite ""; 
            TPWrite "====================================";
            TPWrite "============== PLACAR ==============";
            TPWrite "===== P1: "+NumToStr(pecasNaMao{1},0)+" ============ C2: "+NumToStr(pecasNaMao{2},0)+" =====";
            TPWrite "====================================";
            TPWrite "Pe�as Em Jogo: "+NumToStr(pecasCompradas,0);
            TPWrite "";

            IF quemJogaPrimeiro THEN
                player:=1;
            ELSE
                player:=2;
            ENDIF

            defineJogada player;

            !Troca o jogador
            quemJogaPrimeiro:=quemJogaPrimeiro XOR TRUE;

            !SE TODAS AS MINHAS PE�AS FOREM COMPRADAS, ENT�O O O SISTEMA ...
            !SE AINDA HOUVER PE�AS PARA COMPRAR ENT�O � ANALISADO QUANTAS PE�AS EXISTEM NA M�O DE CADA JOGADOR;
            IF pecasCompradas = 28 THEN
                TPWrite "TODAS AS PE�AS COMPRADAS. �ltimo jogador a comprar: "+NumToStr(player,0);
                TPWrite "Contando pontos na m�o de cada jogador...";
                WaitTime 2.5;
                FOR jogadores FROM 1 TO 2 DO
                    FOR i FROM 1 TO qtdPecasPlayer{jogadores} DO
                        IF pecasCompra{pecasJogadores{i,jogadores},1}<>-2 THEN
                            pontosNaMao{jogadores} := pontosNaMao{jogadores} + pecasJogo{pecasJogadores{i,jogadores},1} + pecasJogo{pecasJogadores{i,jogadores},2};
                        ENDIF
                    ENDFOR
                ENDFOR

                IF pontosNaMao{1} > pontosNaMao{2} THEN
                    pecasNaMao{2} :=0;
                ELSEIF pontosNaMao{1} < pontosNaMao{2} THEN
                    pecasNaMao{1} :=0;
                ELSE
                    empate := TRUE;
                ENDIF
                
            ELSE    
                FOR i FROM 1 TO qtdPecasPlayer{player} DO
                    IF pecasCompra{pecasJogadores{i,player},1}=-2 THEN
                        j:=j+1;
                    ENDIF
                ENDFOR
                pecasNaMao{player}:=qtdPecasPlayer{player}-j;
                j:=0;
            ENDIF
            
        ENDWHILE

        !UnLoad diskhome\File:="DESENHAR.MOD";

        WaitTime tempoDelay;

        IF pecasNaMao{1}=0 THEN
            TPWrite "Parab�ns! Voc� � o vencedor!";
            vencedor :=1;
        ELSEIF pecasNaMao{2}=0 THEN
            TPWrite "YOU LOSE! FATALITY! Computador ganhou!";
            vencedor :=2;
        ELSEIF empate THEN
            TPWrite "EMPATE!";
        ENDIF

        WaitTime 2.0;
        

    ENDPROC
ENDMODULE