
#include "inkey.ch"
#include "net.ch"

PRIVATE nCount

DO WHILE .T.
   if !NetUSE("knjizi",lSHA)
      Exit
   endif
   nCount=RecCount()
   CLOSE Knjizi
   if nCount=0
      do ton
      Message("Ni kaj za knji`iti: Tabela knji`enja je prazna!")
      exit
   endif
   if Vprasaj(20,2,"@eli{ sknji`iti zajete podatke v knjigo PO?")
      CLOSE ALL
      if NetUSE("Knjizi",lEXC)  && ziher varianta
         Message("Knji`im v knjigo PO","w+/b","",.F.)
         COPY TO Knjizi.tmp
         NetUSE("prih_odh",lSHA,,lNEW); SI_POprihodh("p_konto")
         APPEND FROM Knjizi.tmp FOR cifra<>0

         SELECT Knjizi
         ZAP
         INDEX ON konto TO knjizi

         CLOSE ALL

         CLS
         do ton
         Message("Dogodki so prene{eni v knjigo PO!")
      else
         Message("Napaka pri prenosu! Poskusi znova.","w+/r")
      endif
   endif
   exit
ENDDO