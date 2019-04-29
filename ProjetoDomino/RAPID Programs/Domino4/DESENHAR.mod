MODULE DESENHAR

    ! ================== INTEGRANTES ==================
    ! Nomes:
    ! Ana Laura Belotto Claudio - R.A: 11035315
    ! Gilmar Correia Jeronimo - R.A: 11014515
    ! Lucas Barboza Moreira Pinheiro - R.A: 11017015
    ! =================================================
   
    VAR num pecaSize := 25;
    VAR num raio:=2;
    VAR num aproxZ := 25;
    VAR zonedata zone := fine; 
    VAR speeddata vel := v2000;
    VAR num desloc := 2;
    VAR num maxLinha:=250;
    ! LOUSA 115 cm por 85cm

    VAR pos centro;
    VAR robtarget PCenter;
    
    FUNC bool centroOficial(bool dobre,bool direcaoJogada)
        
        IF dobre AND centroD <> centroE THEN 
            IF direcaoJogada THEN 
                IF abs(centroD.y) < maxLinha AND primVezD THEN 
                    centroD.y := centroD.y + (1/2)*pecaSize; 
                ELSE 
                    centroD.x := centroD.x - (1/2)*pecaSize; 
                ENDIF 
            ELSE 
                IF abs(centroE.y) < maxLinha AND primVezE THEN 
                    centroE.y := centroE.y - (1/2)*pecaSize; 
                ELSE 
                    centroE.x := centroE.x - (1/2)*pecaSize;
                ENDIF 
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

        RETURN abs(centro.y) >= maxLinha OR (direcaoJogada AND (not primVezD)) OR ((not direcaoJogada) AND (not primVezE));
    ENDFUNC
    
    FUNC bool naVertical(bool dobre,bool virado)
        return virado XOR dobre;
    ENDFUNC 
    
    PROC offsCentroVira(bool dobre)
        
        IF prevDobreD AND  primVezD THEN
            centro.x := centro.x + (1/2)*pecaSize;
            centroD.x := centroD.x + (1/2)*pecaSize;
        ENDIF
        
        IF prevDobreE AND  primVezE THEN
            centro.x := centro.x + (1/2)*pecaSize;
            centroE.x := centroE.x + (1/2)*pecaSize;
        ENDIF
        
        IF direcaoJogada AND primVezD THEN
            centro.x := centro.x + (3/2)*pecaSize + desloc;
            centro.y := centro.y + (3/2)*pecaSize + desloc;
            centroD.x := centroD.x + (3/2)*pecaSize + desloc;
            centroD.y := centroD.y + (3/2)*pecaSize + desloc;
            primVezD := FALSE;
        ENDIF
        
        IF (not direcaoJogada) AND primVezE THEN
            centro.x := centro.x + (3/2)*pecaSize + desloc;
            centro.y := centro.y - (3/2)*pecaSize - desloc;
            centroE.x := centroE.x + (3/2)*pecaSize + desloc;
            centroE.y := centroE.y - (3/2)*pecaSize - desloc;
            primVezE := FALSE;
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
    
    PROC desenhaPontos(num n, num m, bool direcaoJogada,bool vertical)
        !Percorre o vetor desenhaBolinha que informa quais bolinhas devem ser desenhadas
        FOR k FROM 1 TO 2 DO
            FOR j FROM 1 TO 3 DO 
                FOR i FROM 1 TO 3 DO 
                    IF escolheBolinha(j+(i-1)*3,n) and k=1 THEN 
                        desenhaBolinha Offs(pHome,centro.x,centro.y,centro.z),raio,not vertical,i,j,k;
                    ELSEIF escolheBolinha(j+(i-1)*3,m) and k=2 THEN
                        desenhaBolinha Offs(pHome,centro.x,centro.y,centro.z),raio,not vertical,i,j,k;
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
    
    PROC offsCentro (bool vertical, bool direcaoJogada,bool virado)
        IF (not virado) THEN
            IF vertical THEN 
                 IF centroD.y = centroE.y THEN 
                    centroD.y := centroD.y - (3/2 * pecaSize) - desloc; 
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
        ELSE 
            IF vertical THEN 
                IF direcaoJogada THEN 
                    centroD.x := centroD.x + (2 * pecaSize) + desloc; 
                ELSE 
                    centroE.x := centroE.x + (2 * pecaSize) + desloc; 
                ENDIF     
             ELSE 
                IF direcaoJogada THEN 
                    centroD.x := centroD.x + (3/2  * pecaSize) + desloc; 
                ELSE 
                    centroE.x := centroE.x + (3/2  * pecaSize) + desloc; 
                ENDIF 
             ENDIF
        ENDIF 
          
          
         centroD.z := 0; 
         centroE.z := 0; 
    ENDPROC 
    
    PROC desenhaPeca(num n, num m, bool direcaoJogada)
        VAR bool vertical:=FALSE; 
        VAR bool virado;
        
        virado:=centroOficial(n=m,direcaoJogada);
        vertical:=naVertical(n=m,virado);
        
        IF virado THEN
            offsCentroVira n=m;
        ENDIF
        
        desenhaRetangulo vertical;
        
        IF virado AND (not direcaoJogada) THEN
            desenhaPontos n,m,direcaoJogada,vertical;
        ELSE 
            desenhaPontos m,n,direcaoJogada,vertical;
        ENDIF        
        
        offsCentro vertical, direcaoJogada,virado;
        
        IF direcaoJogada THEN
            prevDobreD:=(n=m);
        ELSE
            prevDobreE:=(n=m);
        ENDIF
    ENDPROC
    
ENDMODULE