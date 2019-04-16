MODULE Module1
    
    ! ================== INTEGRANTES ==================
    ! Nomes:
    ! Ana Laura Belotto Claudio - R.A: 11035315
    ! Gilmar Correia Jeronimo - R.A: 11014515
    ! Lucas Barboza Moreira Pinheiro - R.A: 11017015
    ! =================================================
    
    !CONST robtarget pHome:=[[807.94,22.13,849.61],[2.82776E-8,-0.236102,-0.971728,7.69646E-9],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    PERS robtarget pHome:=[[807.94,22.13,849.61],[2.82776E-8,-0.236102,-0.971728,7.69646E-9],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    LOCAL VAR loadsession load1; 
     
    PROC main()
        MoveL pHome,vel,zone,tool0;
        !StartLoad "" \File:="TELA.MOD", load1;
        !WaitLoad load1;
        %"setarTela"%;
        !UnLoad "" \File:="TELA.MOD";
           
    ENDPROC
     
ENDMODULE
