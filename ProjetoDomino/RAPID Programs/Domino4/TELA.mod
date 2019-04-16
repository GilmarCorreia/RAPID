MODULE TELA
 
    CONST num qtdPecas:=28;
    VAR num pecasJogadores{qtdPecas,2};
    VAR num pecasJogador1{qtdPecas};
    VAR num pecasJogador2{qtdPecas};
    VAR num pecasJogo{qtdPecas,2};
    VAR num pecasCompra{qtdPecas,2};
    VAR num pecasBaixadas:=1;
    VAR num maior:=-1;

    VAR bool quemJogaPrimeiro;
    VAR num escolhaPlayer{2};
    VAR num qtdPecasPlayer{2};
    VAR num pecasNaMao{2};
    VAR num player;
    VAR num vaiComprar;
    VAR bool direcaoJogada;
    !Se for true, jogou na direita, se for false, jogou na esquerda.

    VAR num tempoDelay:=0.5;

    VAR num pecaD;
    VAR num pecaE;

    LOCAL VAR loadsession load2;
    !! =======================================================================================================================
    !!                                              FUNÇÃO DE RANDOM - TIRADO DO SITE ()
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

    ! Essa função sorteia as peças para ambos os jogadores no começo da partida
    FUNC bool sortearPecas()

        ! Seta as variáveis
        VAR num rand;
        VAR bool quemPossuiMaiorPeca;

        ! Esse for sorteia 7 peças e as coloca para o jogador 1. Sorteia mais 7 e coloca para o jogador 2,
        ! Nesta função já se define quem começa com a maior peça, controlado pela variável maior e quemPossuiMaiorPeca;
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

        WaitTime delay;
        TPWrite " ";

        FOR i FROM 1 TO qtdPecasPlayer DO
            IF pecasCompra{pecasJogadores{i,jogador},1}<>-2 THEN
                TPWrite "Peça "+NumToStr(i,0)+"- J"+NumToStr(jogador,0)+" = "+NumToStr(pecasJogo{pecasJogadores{i,jogador},1},0)+"-"+NumToStr(pecasJogo{pecasJogadores{i,jogador},2},0);
            ENDIF
        ENDFOR

        TPWrite " ";
        WaitTime delay;

    ENDPROC

    PROC defineJogada(num player)

        VAR NUM rand;
        VAR NUM escolhaLado;

        WHILE escolhaPlayer{player}>qtdPecasPlayer{player} DO
            IF (player=1) THEN
                WHILE escolhaPlayer{player}>qtdPecasPlayer{player} DO
                    ! CÓDIGO PARA A PESSOA
                    TPWrite "Sua vez";
                    imprimePecas player,qtdPecasPlayer{player},1.5;

                    TPReadNum escolhaPlayer{player},"Selecione a Peça para Jogar";
                    IF escolhaPlayer{player}>qtdPecasPlayer{player} OR pecasCompra{pecasJogadores{escolhaPlayer{player},player},1}=-2 THEN
                        TPWrite "Número inválido, escolha novamente";
                        escolhaPlayer{player}:=100;
                    ENDIF
                ENDWHILE
            ELSE
                ! CÓDIGO PARA O COMPUTADOR
                TPWrite "Vez do Computador";
                !imprimePecas 2,qtdPecasPlayer{2},1.0;
                WaitTime 0.5;


                FOR peca FROM 1 TO qtdPecasPlayer{player} DO
                    IF ((pecasJogo{pecasJogadores{peca,player},1}=pecaD OR pecasJogo{pecasJogadores{peca,player},2}=pecaD) OR (pecasJogo{pecasJogadores{peca,player},1}=pecaE OR pecasJogo{pecasJogadores{peca,player},2}=pecaE)) AND pecasCompra{pecasJogadores{peca,player},1}<>-2 THEN
                        escolhaPlayer{player}:=peca;
                    ENDIF
                ENDFOR

                IF escolhaPlayer{player}>qtdPecasPlayer{player} OR pecasCompra{pecasJogadores{escolhaPlayer{player},player},1}=-2 THEN
                    FOR peca FROM 1 TO qtdPecasPlayer{player} DO
                        IF pecasCompra{pecasJogadores{peca,player},1}<>-2 THEN
                            escolhaPlayer{player}:=peca;
                        ENDIF
                    ENDFOR
                ENDIF

            ENDIF

            ! VERIFICA SE É POSSÍVEL JOGAR A PEÇA DESEJADA, SE NÃO REALIZA A COMPRA DE PEÇAS
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
                    TPReadFK vaiComprar,"Peça inválida, escolha novamente ou compre uma peça","Escolher novamente","Comprar peca",stEmpty,stEmpty,stEmpty;
                ELSE
                    vaiComprar:=2;
                ENDIF

                IF vaiComprar=1 AND player=1 THEN
                    escolhaPlayer{player}:=100;
                ELSE
                    ! CRIAR CÓDIGO PARA COMPRAR PEÇA 
                    TPWrite "Vai Comprar";

                    rand:=Random();

                    WHILE pecasCompra{rand,1}=-1 OR pecasCompra{rand,1}=-2 DO
                        rand:=Random();
                    ENDWHILE

                    qtdPecasPlayer{player}:=qtdPecasPlayer{player}+1;
                    pecasJogadores{qtdPecasPlayer{player},player}:=rand;

                ENDIF
            ENDIF
        ENDWHILE

        WaitTime tempoDelay;

        !SE NÃO COMPRAR PEÇA
        IF vaiComprar<>2 THEN
            IF direcaoJogada THEN
                IF pecasJogo{pecasJogadores{escolhaPlayer{player},player},1}=pecaD THEN
                    %"desenhaPeca"%pecasJogo{pecasJogadores{escolhaPlayer{player},player},1},pecasJogo{pecasJogadores{escolhaPlayer{player},player},2},direcaoJogada;
                ELSE
                    %"desenhaPeca"%pecasJogo{pecasJogadores{escolhaPlayer{player},player},2},pecasJogo{pecasJogadores{escolhaPlayer{player},player},1},direcaoJogada;
                ENDIF
            ELSE
                IF pecasJogo{pecasJogadores{escolhaPlayer{player},player},2}=pecaE THEN
                    %"desenhaPeca"%pecasJogo{pecasJogadores{escolhaPlayer{player},player},1},pecasJogo{pecasJogadores{escolhaPlayer{player},player},2},direcaoJogada;
                ELSE
                    %"desenhaPeca"%pecasJogo{pecasJogadores{escolhaPlayer{player},player},2},pecasJogo{pecasJogadores{escolhaPlayer{player},player},1},direcaoJogada;
                ENDIF
            ENDIF
            pecasCompra{pecasJogadores{escolhaPlayer{player},player},1}:=-2;
            pecasCompra{pecasJogadores{escolhaPlayer{player},player},2}:=-2;
        ENDIF
        !qtdPecasPlayer{player}:=qtdPecasPlayer{player}-1;

        escolhaPlayer{player}:=100;
        vaiComprar:=1;
    ENDPROC

    PROC setarTela()

        VAR num partida:=0;
        VAR num j:=0;

        pecasNaMao:=[7,7];

        ! Define a variável para verificar que joga primeiro, ou seja, o jogador que tem a maior peça
        escolhaPlayer:=[100,100];
        qtdPecasPlayer:=[7,7];

        ! Seta o vetor de pecas
        setarPecas;

        ! Mostra na tela
        TPWrite "======================================";
        WaitTime 0.25;
        TPWrite "======================================";
        WaitTime 0.25;
        TPWrite "=============== DOMINÓ ===============";
        WaitTime 0.25;
        TPWrite "======================================";
        WaitTime 0.25;
        TPWrite "======================================";
        WaitTime 0.25;
        TPWrite " ";

        ! Sorteia as peças dos Jogadores
        TPWrite "Sorteando as peças dos jogadores";
        WaitTime tempoDelay;

        quemJogaPrimeiro:=sortearPecas();

        FOR i FROM 1 TO qtdPecas DO
            pecasJogadores{i,1}:=pecasJogador1{i};
            pecasJogadores{i,2}:=pecasJogador2{i};
        ENDFOR

        ! Imprime as peças do jogador 1 e 2
        imprimePecas 1,qtdPecasPlayer{1},tempoDelay;
        !imprimePecas 2,qtdPecasPlayer{2},tempoDelay;

        ! Verifica quem possui a maior peça
        TPWrite " ";
        TPWrite "Verificando quem possui a peça maior (6/6 - 5/6 - 5/5 - 4/6 - ...)";
        !<- ARRUMAR ISSO DEPOIS
        TPWrite " ";
        WaitTime tempoDelay;

        ! Mostra o jogador com a maior peça
        IF quemJogaPrimeiro THEN
            TPWrite "Você baixou a peça";
            !qtdPecasPlayer{1}:=qtdPecasPlayer{1}-1;
        ELSE
            TPWrite "Computador baixou a peça";
            !qtdPecasPlayer{2}:=qtdPecasPlayer{2}-1;
        ENDIF

        pecasCompra{maior,1}:=-2;
        pecasCompra{maior,2}:=-2;

        quemJogaPrimeiro:=quemJogaPrimeiro XOR TRUE;

        !Carrega classe de desenho
        !StartLoad\Dynamic,diskhome\File:="DESENHAR.MOD",load2;
        !WaitLoad load2;

        pecaD:=pecasJogo{maior,1};
        pecaE:=pecasJogo{maior,2};

        %"desenhaPeca"%pecaD,pecaE,TRUE;

        !Loop de jogo até o fim da partida
        ! Se o jogador que baixou a primeira peça for o computador, quemJogaPrimeiro será TRUE e então será a vez do player 1
        ! Se o jogador que baixou a primeira peça for o player, quemJogaPrimeiro será FALSE e então será a vez do computador
        FOR jogador FROM 1 TO 2 DO
            FOR i FROM 1 TO qtdPecasPlayer{jogador} DO
                IF pecasCompra{pecasJogadores{i,jogador},1}=-2 THEN
                    j:=j+1;
                ENDIF
            ENDFOR
            pecasNaMao{jogador}:=qtdPecasPlayer{jogador}-j;
            j:=0;
        ENDFOR

        WHILE ((pecasNaMao{1}>0) AND (pecasNaMao{2}>0)) DO
            TPWrite "";
            TPWrite "====================================";
            TPWrite "============== PLACAR ==============";
            TPWrite "===== P1: "+NumToStr(pecasNaMao{1},0)+" ============ C2: "+NumToStr(pecasNaMao{2},0)+" =====";
            TPWrite "====================================";
            TPWrite "";

            IF quemJogaPrimeiro THEN
                player:=1;
            ELSE
                player:=2;
            ENDIF

            defineJogada player;

            !Troca o jogador
            quemJogaPrimeiro:=quemJogaPrimeiro XOR TRUE;


            FOR i FROM 1 TO qtdPecasPlayer{player} DO
                IF pecasCompra{pecasJogadores{i,player},1}=-2 THEN
                    j:=j+1;
                ENDIF
            ENDFOR
            pecasNaMao{player}:=qtdPecasPlayer{player}-j;
            j:=0;

        ENDWHILE

        !UnLoad diskhome\File:="DESENHAR.MOD";

        WaitTime tempoDelay;

        IF pecasNaMao{1}=0 THEN
            TPWrite "Parabéns! Você é o vencedor!";
        ELSE
            TPWrite "YOU LOSE! FATALITY! Computador ganhou!";
        ENDIF

        WaitTime 5.0;

    ENDPROC
ENDMODULE