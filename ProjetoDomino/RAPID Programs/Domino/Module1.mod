MODULE Module1
    
    !CONST robtarget pHome:=[[807.94,22.13,849.61],[2.82776E-8,-0.236102,-0.971728,7.69646E-9],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    
    LOCAL VAR loadsession load1;
    
    PROC main()
        StartLoad diskhome \File:="TELA.MOD", load1;
        WaitLoad load1;
        %"setarTela"%;
        UnLoad diskhome \File:="TELA.MOD";
           
    ENDPROC
     
ENDMODULE
