MODULE Module1
     
    ! ================== INTEGRANTES ==================
    ! Nomes:
    ! Ana Laura Belotto Claudio - R.A: 11035315
    ! Gilmar Correia Jeronimo - R.A: 11014515
    ! Lucas Barboza Moreira Pinheiro - R.A: 11017015
    ! =================================================
     
    PERS robtarget pHome:=[[807.94,22.13,849.61],[2.82776E-8,-0.236102,-0.971728,7.69646E-9],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    
    VAR num novamente := 1;
    VAR num vencedor:=0;
    VAR num vitoriasPlayer1:=0;
    VAR num vitoriasPlayer2:=0;
    
    VAR num pecasJogo{qtdPecas,2};
    VAR num pecasCompra{qtdPecas,2};
    VAR num pecasCompradas:=14;
    VAR num maior:=-1;
    VAR bool empate := FALSE;    
    
    VAR pos centroD;
    VAR pos centroE;
    PERS bool primVezD:=FALSE;
    PERS bool primVezE:=TRUE;
    PERS bool prevDobreD := FALSE;
    PERS bool prevDobreE := FALSE;
    
    
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


