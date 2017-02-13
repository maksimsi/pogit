
#include "inkey.ch"
#include "net.ch"

CLS

NetUSE("konto",lSHA); SI_POKonto()
DECLARE tabla [RECCOUNT ()]
FOR i=1 TO RECCOUNT()
   tabla[I] =+KONTO->konto+"  "+KONTO->opis
   SKIP
NEXT

NetUSE("knjizi",lSHA,,lNEW)
If FilLock()
   REPLACE konto WITH StrZero(Val(konto),2) ALL
   UNLOCK
EndIf

kkk=reccount()
INDEX ON konto TO knjizi

DatumK=date()
DatumD=date()

lInit=.T.

do while .t.

   SELECT Knjizi
   clear screen
   @ 2,2 say"OPIS                KONTO  DAN/knj  DOKUMENT  DAN/dokum       ZNESEK"
   @ 3,2 SAY replicate(chr(196),68)
   @ 1,0 to 17,79
   set color to i
                      @ 0,1 say " ZAJEMANJE KNJIGE PRIHODKOV - ODHODKOV "
                      set color to
                      set color to i*
                      @ 0,78 say chr(254)
                      set color to
   DO WHILE .T.
      vr=4
      go top
      do while .not. eof()
         @ vr,3 say KNJIZI->opis+" "+KNJIZI->konto+"   "+dtoc(KNJIZI->d_knji)+" "+KNJIZI->dok+"   "+dtoc(KNJIZI->d_dokum)
         @ vr,58 say KNJIZI->cifra picture"9,999,999.99"
         skip
         vr=vr+1
         if vr>16
            vr=4
         endif
      enddo

   if lInit
      akonto=space(2)
      aopis=space(20)
      atem=space(7)
      Valuta=ctod("  .  .  ")
      acifra=0
      nVredZDDV=0
      nVstDDV=0
      nObrDDV=0

      lInit=.F.
   endif

      @ 22,3 clear to 24,79

      @ 18,12 say "    opis knji`be      dat.knj  dat.dok {tev.d.  Znesek P/O"

      @ 19,1 say"konto:" GET akonto VALID lista_konto(@akonto)
      @ 19,12 get aopis
      @ 19,col()+1 get DatumK
      @ 19,col()+1 get DatumD
      @ 19,col()+1 get atem
      @ 19,col()+1 get acifra picture"9,999,999.99"


      @ 21,20 say " Vred.Z DDV     Vst.DDV     izst.DDV    Valuta "
      @ 22,20 get nVredZDDV picture"9,999,999.99"
      @ 22,col()+1 get nVstDDV picture"9,999,999.99"
      @ 22,col()+1 get nObrDDV picture"9,999,999.99"
      @ 22,col()+1 get Valuta
      READ
      set color to

      IF LastKey() = K_ESC
         CLOSE All
         SET COLOR TO
         do while .t.
         CLS
         @ 15,15 prompt" PREGLED ZAJETEGA   "
         @ 16,15 PROMPT" KNJI@ENJE ZAJETEGA "
         @ 17,15 PROMPT" IZHOD              "
         MENU TO najdi
         DO CASE
            CASE najdi=1
                 do glejzaj
            CASE najdi=2
                 do prenos
            CASE najdi=3
                 close all
                 return
            case lastkey()=27
                 close all
                 return
         ENDCASE
         enddo
      ENDIF

   da="D"
   @ 24,31 say"Dobro? "get da
   read
   IF upper(da)="D"
      if acifra=0
         acifra=nVredZDDV - nVstDDV - nObrDDV
      endif
      SELECT Knjizi
      if AddRec()
         REPLACE opis WITH aopis, konto WITH akonto,;
                 d_knji WITH DatumK, dok WITH atem, d_dokum WITH DatumD,;
                 cifra WITH acifra, d_zapad with Valuta,;
                 vred_z_ddv with nVredZDDV,;
                 vstddv with nVstDDV, obrddv with nObrDDV
         commit
         lInit = .T.
      endif
   ELSE
      do ton
      ja="D"
      @ 24,62 say"Popravi{? (D/N) "get ja
      read
      @ 24,3 clear to 24,79
      if upper(ja)="D"
         loop
      endif
      lInit=.T.
   ENDIF
ENDDO
EXIT
ENDDO


FUNCTION lista_konto
      SELECT Konto
      seek akonto
      if .not. found()
         save screen
         @ 3,42 clear to 22,75
         @ 3,42 TO 22,75
         x = ACHOICE (4,43,21,74,tabla)
         restore screen
         IF x<>0
            STORE tabla [x] TO akonto
            akonto=left(akonto,2)
            keyboard chr(13)
            return .F.
         ENDIF

      endif
      SELECT Konto
      seek akonto
      SET color to i
      @ 17,1 say KONTO->opis
      set color to

return .T.