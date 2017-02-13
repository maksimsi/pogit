
#include "inkey.ch"
#include "dbedit.ch"
#include "net.ch"

LOCAL nsavwnd := WSelect(),;
      csavclr := SetColor(),;
      nwnd1

aPolja := { "KONTO", "OPIS" }
aNasl  := { "KONTO", "OPIS" }
CLS

NetUSE("Konto", lEXC); SI_POKonto()

nwnd1 = WOpen3D(1,2,24,77,, "w+/gr+", "³Kontni plan³")
@ MaxRow(),4 say"<ESC-izhod><ENTER-sprememba><Del-brisi>"
set color to
DBEdit(0,0,MaxRow()-1,MaxCol(),aPolja,"DBEPOKonto","@",aNasl,CHR(205),chr(179),chr(205))

CLOSE Konto

WClose(nwnd1)

WSelect(nsavwnd)
SetColor(csavclr)

RETURN

FUNCTION DBEPOKonto(status, ipolje)
LOCAL nKey,kljuc,vrednost,polje
nKey=LastKey()
DO CASE
   CASE status=DE_IDLE
        RETURN DE_CONT
   CASE status=DE_HITTOP
        do ton
        RETURN DE_CONT
   CASE status=DE_HITBOTTOM
        do ton
        RETURN DE_CONT
   CASE status=DE_EMPTY
        RETURN DE_ABORT
   CASE status=DE_EXCEPT
        DO CASE
           CASE nKey > ASC(" ")
                *KEYBOARD Chr(K_RETURN)+Chr(nKey)
           CASE nKey = K_RETURN
                kljuc=INDEXKEY(0)
                vrednost=&kljuc
                polje= Upper(aPolja[ipolje])    &&FIELD(ipolje)

                IF TYPE(polje)="M"
                   return DE_CONT
                ENDIF
                if !RecLock()
                   return DE_CONT
                endif
                @ row(),col() GET &polje
                CursOn()
                READ
                CursOf()
                UNLOCK
                spremenil = .T.
                IF lastkey()=K_ESC
                   return DE_CONT
                endif
                IF vrednost<>&kljuc
                   RETURN DE_REFRESH
                ENDIF
           CASE nKey=K_DEL
                if vprasaj(22,10, "Brisem konto <"+KONTO->konto+">")
                   if RecLock()
                      DELETE
                      UNLOCK
                      PACK
                      Message("Konto brisan...")
                   endif
                endif
                RETURN DE_CONT
           CASE nKey=K_ESC
                RETURN DE_ABORT
        ENDCASE
ENDCASE
RETURN DE_CONT
