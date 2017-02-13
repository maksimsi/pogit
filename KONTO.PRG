

#include "inkey.ch"
#include "dbedit.ch"
#include "net.ch"

LOCAL najdi


DO WHILE .T.
   OSmenu_okno(11,45, "KONTNI PLAN",;
                    { " NOVI PODATKI       ",;
                      " SPREMINJANJE       ",;
                      " IZPIS PRINTER      ",;
                      "",;
                      " IZHOD              " })
   MENU TO najdi
   save screen to e3
   DO CASE
       CASE (najdi %4)=0
            EXIT
       CASE najdi=1
            VnosPOKonto()
       CASE najdi=2
            do glejkont
       CASE najdi=3
            CLS
            select 2
            Netuse("fir",lSHA)
            select 1
            Netuse("konto",lSHA); SI_POKonto("konto")

            VklopiAlternate()
            ? fir->dorg
            ? fir->imefir
            ? trim(fir->ulica)+", "+fir->mesto
            ?
            ? "P/O - kontni plan"
            ?
            ? "Ko","Naziv konta"
            ? "--",Replicate("-",50)
            SELECT konto
            do while !eof()
               ? konto, opis
               skip
            enddo
            ?
            ? "--",Replicate("-",50)
            EJECT
            Close Databases
            IzklopiAlternate()
            USmeriIzpis(cprnfile)
   ENDCASE
   rest screen from e2
ENDDO


PROCEDURE VnosPOKonto()
LOCAL ckonto, copis
   NetUSE("konto",lSHA); SI_POKonto()
   CLS
   DO WHILE .T.
      ckonto="  "
      copis=space(50)
      set color to gr+
      @ 10,1 to 23,78 double
      @ 20,2 say replicate(chr(176),76)
      @ 20,77 SAY replicate(chr(176),2)
      @ 21,77 SAY replicate(chr(176),2)
      @ 22,77 say replicate(chr(176),2)
      @ 10,6 say " NASTAVITEV NOVEGA KONTA "
      set color to
      @ 14,3 say"ID KONTO__:" get ckonto picture"99" VALID !Empty(ckonto)
      @ 15,3 say"OPIS KONTA:" get copis
      READ
      if LastKEY()=K_ESC .OR. Empty(ckonto)
         exit
      endif
      if DBSeek(ckonto)
         tone(261.7,1)
         Message("konto: "+konto+" "+opis+" `e obstaja!")
         loop
      endif
      if Vprasaj(17,60,"Dobro",.T.)
         if AddRec()
            REPLACE konto WITH ckonto, opis WITH copis
         endif
      endif
   ENDDO
   CLOSE konto
RETURN
