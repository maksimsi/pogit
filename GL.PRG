
#include "barve.ch"
#include "net.ch"

IF !lVecFirm
   NetUSE("fir",lSHA)
   FirNaslov()
   FirNastav()
   CLOSE Fir
ELSE
   DAJ=1
   DO WHILE daj%4<>0
      set color to
      POmenu_okno(6,27, "GLAVA",;
                       { " A@URIRANJE FIRME      ",;
                         " NASTAVITEV PRENOSOV   ",;
                         " IZBIRA  FIRME         ",;
                         " IZHOD                 " })
      MENU TO DAJ
      save screen to e2
      DO CASE
         CASE daj = 1
              SELECT 1
              NetUSE("FIR",lSHA)
              FirNaslov()
              cPOT = DiskName()+":"+DirName()
              DirChange( cROOTDIR )

              SELECT 2
              USE FIRME
              INDEX ON FST TO FIRME
              AH=VAL(RIGHT(cPOT,1))
              SEEK AH
              IF FOUND()
                 REPLACE FST WITH VAL(RIGHT(cPOT,1)), DORG WITH A->DORG, IMEFIR WITH A->IMEFIR,;
                         ULICA WITH A->ULICA, MESTO WITH A->MESTO, RACUN WITH A->RACUN,;
                         OBCINA WITH A->OBCINA
                 COMMIT
              ENDIF
              CLOSE ALL
              DirChange( cPOT )
         CASE daj = 2
              NetUSE("FIR",lSHA)
              FirNastav()
              CLOSE Fir
         CASE daj = 3
              cPOT = DiskName()+":"+DirName()
              DirChange( cROOTDIR )
              USE FIRME INDEX FIRME
              GO TOP
              DECLARE ARRAJ[9]
              FOR I=1 TO LASTREC()
                 ARRAJ[I]=STR(FST,1)+" - "+DORG
                 SKIP
              NEXT
              F=0
              F=VRNI(8,50,ARRAJ)
              IF F<>0
                 KAM="F"+STR(F,1)
              ENDIF
              if DirChange(KAM)<>0
                 Message( "Mapa " + KAM + " ne obstaja!" )
              endif
      ENDCASE
      restore screen from e2
      USE FIR
      @ 0,30 clear to 0,79
      @ 0,30 SAY ALLTRIM(DORG)+", "+ALLTRIM(ULICA)+" "+ALLTRIM(MESTO)
      USE
   ENDDO
ENDIF

RETURN

PROCEDURE FirNaslov
  IF LASTREC()=0
     AddRec()
  ENDIF
  cls
  set color to

  if !RecLock()
     return
  endif

  SAVE SCREEN

  Win3D(5,10, 18,72, 1, crna_bela, "³Firma³")
  Barva(crna_bela+","+bela_modra, crna_bela+","+bela_crna)

  @ 7,      12 SAY "Naziv________:" GET dorg
  @ Row()+1,12 SAY "              " GET imefir
  @ Row()+2,12 SAY "ULICA _______:" GET ulica
  @ Row()+1,12 SAY "KRAJ_________:" GET mesto
  *@ row()+1,12 SAY "Dav~na [t____:" GET davcna_st
  @ Row()+1,12 SAY "`iro ra~un___:" GET racun
  *@ Row()+1,12 SAY "sklic        :" GET racun2
  READ
  UNLOCK

  set color to
restore screen
RETURN


PROCEDURE FirNastav
  if !RecLock()
     return
  endif
  DO WHILE .T.
     CLS
     set color to r
     @ 9,8 TO 20,60
     set color to
     @ 10,10 say"KNJI@ENJE V PRIHODKE ODHODKE   (D/N): " GET V1 VALID V1 $ "DN"
     @ 12,10 say"PROMET BALGA - obrazec TDr (D/N) ___: " GET V2 VALID V2 $ "DN"
     @ 14,10 say"SALDAKONTI DOBAVITELJEV        (D/N): " GET V4 VALID V4 $ "DN"
     @ 16,10 say"Papir za Tdr in prevzemni list (1/2): " get ma valid ma $ "12"
     @ 17,10 say"380 x 12, A3 format = 1"
     @ 18,10 say"321 x 8 , A4 le`e~i = 2"
     READ
     if v1="D" .AND. !File("knjizi.dbf")
        do ton
        Message("Nima{ nastavljene baze za PRIH.-ODHODKE!","w+/r")
        loop
     endif
     if v2="D" .AND. .not. File("blago.dbf")
        Message("Nima{ nastavljene  KNJIGE O PROM.BLAGA!(TDr)","w+/r")
        loop
     endif
     if v4="D" .AND. .not. File("saldo.dbf")
        Message("Nima{ nastavljenih SALDAKONTOV!","w+/r")
        LOOP
     endif
     EXIT
  ENDDO
  UNLOCK
RETURN

FUNCTION VRNI
PARAMETERS Y,X,ARRA
 Y1=Y+LEN(ARRA)+1
 X1=X+LEN(ARRA[1])+2
 @ Y,X clear to Y1,X1
 @ Y,X to Y1,X1
 REZ=ACHOICE(Y+1,X+1,Y1-1,X1-1,ARRA)
RETURN REZ

FUNCTION WOHIN
NEK=1
DO WHILE !EMPTY(A->DORG)
   NEK=NEK+1
   SKIP
ENDDO
RETURN NEK