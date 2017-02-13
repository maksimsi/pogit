
#include "inkey.ch"
#include "dbedit.ch"
#include "net.ch"

SELECT 2
NetUSE("Konto",lSHA); SI_POKonto()

SELECT 1
NetUSE("Knjizi",lSHA)
INDEX ON konto TO knjizi
SET RELATION TO konto INTO Konto

aPolja := { "KONTO", "OPIS", "D_KNJI", "D_DOG", "DOK", "D_DOKUM", "D_PLAC",;
            "D_ZAPAD", "N_PLAC", "CIFRA", "VRED_Z_DDV", "VSTDDV", "OBRDDV" }

aNasl  := { "KTO", "OPIS KNJI@BE", "DAT KNJI.", "DAT DOGO.", "DOKUMENT", "DAT DOK.",;
            "DAT PLA^", "VALUTA", "N.P.", "ZNESEK", "Vr.Z DDV", "Vst.DDV", "Obr.DDV" }

CLS

@ 1,0 to 24,79 double

set color to

@ 23,1 say padr("<ESC-izhod><ENTER-sprememba><Del-brisanje>", 78) COLOR "w/bg"
DBEdit(3,1,22,78, aPolja ,"DBEZajPO","@",aNasl,CHR(205),chr(179),chr(205))

SELECT Knjizi
if DBSeek("  ") && empty PO konto
   CLOSE Knjizi
   if NetUSE("Knjizi",lEXC)
      DELETE FOR Empty(konto)
      PACK
   endif
endif

Close All

RETURN

FUNCTION DBEZajPO(status, ipolje)
LOCAL nKey,kljuc,vrednost,polje
nKey=LastKey()
DO CASE
   CASE status=DE_IDLE
        @ 2,5 say KONTO->opis
        RETURN DE_CONT
   CASE status=DE_HITTOP
        do ton
        RETURN DE_CONT
   CASE status=DE_HITBOTTOM
        do ton
        RETURN DE_CONT
   CASE status=DE_EMPTY
        Message("Tabela vnosa je prazna.")
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
                if Vprasaj(20,20,"Bri{em knjizbo")
                   if RecLock()
                      DELETE
                      UNLOCK
                      Message("Postavka brisana...")
                   endif
                endif
                RETURN DE_CONT
           CASE nKey=K_ESC
                RETURN DE_ABORT
        ENDCASE
ENDCASE
RETURN DE_CONT
