MODULE DESENHAR
    !CONST robtarget pHome:=[[807.94,22.13,849.61],[2.82776E-8,-0.236102,-0.971728,7.69646E-9],[0,0,0,0],[9E+9,9E+9,9E+9,9E+9,9E+9,9E+9]];
    
    VAR num pecaSize := 25;
    VAR num raio:=2;
    VAR num aproxZ := 25;
    VAR zonedata zone := fine; 
    VAR speeddata vel := v50;
    VAR num desloc := 2;
    
    ! LOUSA 115 cm por 85cm

    VAR pos centroD;
    VAR pos centroE;
    VAR pos centro;
    VAR robtarget PCenter;
    
    PROC centroOficial(bool iguais, bool direcaoJogada)
        IF iguais AND centroD <> centroE THEN
            IF direcaoJogada THEN
                centroD.y := centroD.y + (1/2)*pecaSize;
            ELSE
                centroE.y := centroE.y - (1/2)*pecaSize;
            ENDIF
        ENDIF
        
        IF direcaoJogada THEN
            centro.x := centroD.x;
            centro.y := centroD.y;
            centro.z := centroD.z;
        ELSE
            centro.x := centroE.x;
            centro.y := centroE.y;
            centro.z := centroE.z;
        ENDIF
        
        
    ENDPROC
     
    PROC desenhaRetangulo(bool vertical)
        VAR num matrizRotacao{10,3};
        VAR num i;
        VAR num j;
        
        matrizRotacao:= [[0,-pecaSize/2,aproxZ],[0,-pecaSize/2,0],[0,pecaSize/2,0],[pecaSize,pecaSize/2,0],[pecaSize,-pecaSize/2,0],
                         [-pecaSize,-pecaSize/2,0], [-pecaSize,pecaSize/2,0], [0,pecaSize/2,0], [0,pecaSize/2,aproxZ], [0,0,aproxZ]];
        
        IF vertical THEN
            i := 1;
            j := 2;
        ELSE
            i := 2;
            j := 1;
        ENDIF
            
        FOR k FROM 1 TO 10 DO
            MoveL Offs(Offs(pHome,centro.x,centro.y,centro.z),matrizRotacao{k,i},matrizRotacao{k,j},matrizRotacao{k,3}), vel, zone, tool0;
        ENDFOR
        
    ENDPROC
    
    PROC desenhaPontos(num n, num m, bool direcaoJogada)
        !var bool pintaBolinha{9};
        var bool horizontal;
        horizontal:=(n<>m);

        !Percorre o vetor desenhaBolinha que informa quais bolinhas devem ser desenhadas
        FOR k FROM 1 TO 2 DO
            FOR j FROM 1 TO 3 DO 
                FOR i FROM 1 TO 3 DO 
                    IF escolheBolinha(j+(i-1)*3,n) and k=1 THEN 
                        desenhaBolinha Offs(pHome,centro.x,centro.y,centro.z),raio,horizontal,i,j,k;
                    ELSEIF escolheBolinha(j+(i-1)*3,m) and k=2 THEN
                        desenhaBolinha Offs(pHome,centro.x,centro.y,centro.z),raio,horizontal,i,j,k;
                    ENDIF  
                ENDFOR 
            ENDFOR
        ENDFOR 
    ENDPROC
    
    FUNC bool escolheBolinha(num i,num n)
       !Vetor que indica quais bolinhas devem ser pintadas  
        VAR bool pintaBolinha{9};
        pintaBolinha:=[n=2 or n=3  or n=4 or n=5 or n=6,false,n=4 or n=5 or n=6,n=6,n=1 or n=3 or n=5,n=6,n=4 or n=5 or n=6,false,n=2 or n=3  or n=4 or n=5 or n=6];
        RETURN pintaBolinha{i};
    ENDFUNC 

    PROC desenhaBolinha(robtarget PCenter, num raio,bool horizontal,num i,num j,num k)
         IF horizontal THEN 
             PCenter:=Offs(PCenter,(7.5-3*(j-1)-4.5)*pecaSize/9,(-1.5-3*(i-1)+9-9*(k-1))*pecaSize/9,0);
         ELSE 
             PCenter:=Offs(PCenter,(-16.5+3*(i-1)+9*(k))*pecaSize/9,(-1.5-3*(j-1)+4.5)*pecaSize/9,0);
         ENDIF 
         PCenter := Offs(PCenter,0,raio,0);
         MoveL Offs(PCenter,0,0,aproxZ),vel,zone,tool0;
         MoveL PCenter,vel,zone,tool0;
         MoveC Offs(PCenter,-raio,-raio,0), Offs(PCenter,0,-2*raio,0),vel,zone,tool0;
         MoveC Offs(PCenter,raio,-raio,0), PCenter,vel,zone,tool0;
         MoveL Offs(PCenter, 0,0,aproxZ), vel,zone,tool0;
    ENDPROC 
    
    PROC offsCentro (bool vertical, bool direcaoJogada)

        ! Parte do código que vai atualizar os centros
        IF vertical THEN
            IF centroD.y = centroE.y THEN
                centroD.y := centroD.y -(3/2 * pecaSize) - desloc;
                centroE.y := centroE.y + (3/2 * pecaSize) + desloc;
            ELSE
                IF direcaoJogada THEN
                    centroD.y := centroD.y -(3/2 * pecaSize) - desloc;
                ELSE
                    centroE.y := centroE.y + (3/2 * pecaSize)+ desloc;
                ENDIF
            ENDIF
            
        ELSE
            IF centroD.y = centroE.y THEN
                centroD.y := centroD.y - (2  * pecaSize) - desloc;
                centroE.y := centroE.y + (2  * pecaSize) + desloc;
            ELSE
                IF direcaoJogada THEN
                    centroD.y := centroD.y - (2  * pecaSize) - desloc;
                ELSE
                    centroE.y := centroE.y + (2  * pecaSize) + desloc;
                ENDIF
            ENDIF
        ENDIF
        
        centroD.x := 0; 
        centroD.z := 0;
        centroE.x := 0; 
        centroE.z := 0;
    
    ENDPROC 
    
    PROC desenhaPeca(num n, num m, bool direcaoJogada)
        
        !MoveL Offs(pHome,0,0,aproxZ), vel, zone, tool0;
        centroOficial n=m, direcaoJogada;
        desenhaRetangulo n=m;
        desenhaPontos m,n, direcaoJogada;
        offsCentro n=m, direcaoJogada;
        !MoveL Offs(pHome,0,0,aproxZ), vel, zone, tool0;
    ENDPROC
    
ENDMODULE