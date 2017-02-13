clear
do while .t.
za="  "
@ 10,10 say"Za kateri konto?"get za
read
if za="  "
loop
endif
exit
enddo
SELECT 2
USE konto index konto
SELECT 1
USE prih_odh index p_konto,p_opis,idatum
set filter to A->konto=za
set order to 1
SET RELATION to konto into B
go top

DECLARE citaj[13]
citaj[1]="opis"
citaj[2]="konto"
citaj[3]="d_knji"
citaj[4]="d_dog"
citaj[5]="dok"
citaj[6]="d_dokum"
citaj[7]="d_plac"
citaj[8]="d_zapad"
citaj[9]="n_plac"
citaj[10]="cifra"
citaj[11]="vred_z_ddv"
citaj[12]="vstddv"
citaj[13]="obrddv"

DECLARE nasl[13]
nasl[1]="OPIS KNJI@ENJA"
nasl[2]="KONTO"
nasl[3]="DAT KNJI."
nasl[4]="DAT DOGO."
nasl[5]="DOKUMENT"
nasl[6]="DAT DOK."
nasl[7]="DAT PLA^"
nasl[8]="VALUTA"
nasl[9]="N.P."
nasl[10]="ZNESEK"
nasl[11]="Vr.Z DDV"
nasl[12]="Vst.DDV"
nasl[13]="Obr.DDV"

clear screen
set color to gr+
@ 1,0 to 24,79 double
SET COLOR TO g
@ 0,1 say" ^e ZBRI[E[ KONTO, se pri izhodu (ESC)POSTAVKA zbri{e! "
@ 23,4 say"Uporabljaj pu{~ice;  ESC - izhod;  ENTER - sprememba"
set color to
dbedit(3,1,22,78,citaj,"bosi","@",nasl,CHR(205),chr(179),chr(205))
close databases

FUNCTION bosi
PARAMETERS status,ipolje
PRIVATE tipka,kljuc,vrednost,polje
tipka=lastkey()
DO CASE
   CASE status=0
   set color to r
   @ 2,5 say B->opis
   set color to
        RETURN 1
   CASE status=1
        do ton
        RETURN 1
   CASE status=2
        do ton
        RETURN 1
   CASE status=3
        RETURN 0
   CASE status=4
        IF lastkey()>ASC(" ") .or. lastkey()=13
           kljuc=INDEXKEY(0)
           vrednost=&kljuc
           polje=FIELD(ipolje)
           SET CURSOR ON
             IF TYPE(polje)<>"M"
                IF lastkey()<>13
                  KEYBOARD CHR(tipka)
                ENDIF
              @ row(),col() GET &polje
              READ
              ENDIF
          SET CURSOR OFF
           IF lastkey()=27
              RETURN 0
           ELSE
             IF vrednost<>&kljuc
                 RETURN 2
             ELSE
                 RETURN 1
             ENDIF
           ENDIF
           ELSE
              clear screen
              set filter to
              adav=space(2)
              seek adav
              if found()
                 set color to R*
                 @ 23,60 say"Po~akaj!"
                 set color to
                 do ton
                 delete while konto=adav
                 pack
              endif
              set filter to
             RETURN 0
           ENDIF
ENDCASE
RETURN 1