

*** program: prihodki-odhodki - ****
*** avtor  : Error Ljutomer
*** ~as    : 1994

#include "net.ch"
#include "inkey.ch"


SET KEY K_F12 TO test_odprte()

MemoWrit("p.txt","")
DOSIdle()

SET SCOREBOARD OFF
SET DATE GERMAN
*SET CENTURY ON
SET EPOCH TO 1950
SET WRAP ON
SET CURSOR off

SET DELETED ON

*do zascita

CheckNastav()

PUBLIC lVecFirm:=.F., KAM:="", cROOTDIR := DiskName()+":"+DirName()

PUBLIC lUSEError :=.F.,;
       cprnFILE := "prnFILE.txt",;
       cTargetPRN:="",;
       mallmargin:=0,;
       mal_852:=.F.,;
       mal_lf:=Chr(10)+Chr(13)


PUBLIC mali := chr(27)+chr(15) ,;
       kmali:= chr(18),;
       zac:=chr(27)+CHR(87)+CHR(49),;
       konc:=chr(27)+CHR(87)+CHR(48)
       EMPHA:=CHR(27)+CHR(69)
       DE_EMPHA:=CHR(27)+CHR(70)

NetUSE("FIRME",lSHA)
INDEX ON FST TO Firme
CLOSE Firme

DO FIRME

CLEAR screen

set procedure to ..\util\ComUtil
set procedure to ..\util\Okna

set procedure to ..\util\creatdbf
set procedure to ..\util\nastav

set procedure to ..\util\locks

set procedure to ..\util\prnutil
set procedure to ..\util\FBrowse

cVersion = "2017.02-14"

do up2date

*do spica

do bris
set cursor on
set color to
do bl

menu_barva="g"
menu_izbire=""
DO WHILE .T.
   lUSEError=.F.

   NetUSE("FIR",lSHA)
   @ 0,30 clear to 0,79
   @ 0,30 SAY ALLTRIM(DORG)+", "+AllTrim(imefir)+", "+ALLTRIM(ULICA)+" "+ALLTRIM(MESTO)

   Win3d(13,43,19,76,0,"n/bg")
   SetColor("n/bg")
   @ 14,45 say PadR(Fir->dorg,30)
   @ 15,45 say PadR(Fir->imefir,30)
   @ 16,45 say Padr(trim(Fir->ulica)+", "+trim(Fir->mesto),30)
   @ 19,45 say Padr(DiskName()+":"+Dirname(),30)
   set color to

   CLOSE Fir
   @ 0,0 SAY "PRIHODKI/ODHODKI"
   @ 4,65 say " Ver."+cVersion+" " COLOR "g"
   SET COLOR TO I
   @ 24,53 SAY" RIS Smiljan Belcl s.p. "
   SET color to

   POmenu_okno(3,10, "GLAVNI MENU",;
                   { " B   BAZE PODATKOV    ",;
                     " V   VNOS DOKUMENTOV  ",;
                     " E   EKRANSKI PREGLED ",;
                     " T   IZPIS TISKALNIK  ",;
                     "",;
                     " S   SERVIS           ",;
                     " I   INDEX            ",;
                     "",;
                     " X   KONEC PROGRAMA   " } )

   MENU TO izbor
   save screen to e1
   DO CASE
      CASE (izbor % 7)=0
           KonecPO()
      CASE izbor=1
           do while .t.
           USE FIR
           @ 0,30 clear to 0,79
           @ 0,30 SAY ALLTRIM(DORG)+", "+ALLTRIM(ULICA)+" "+ALLTRIM(MESTO)
           USE
           OSmenu_okno(9,35, "BAZNI PODATKI",;
                            { " NASLOV FIRME       ",;
                              " KONTNI PLAN        ",;
                              "",;
                              " IZHOD              " })
           MENU TO isci
           SAVE SCREEN TO E2
           DO CASE
              CASE (isci %3)=0
                   EXIT
              CASE isci=1
                   DO GL
              CASE isci=2
                   DO konto
           ENDCASE
           rest screen from e1
           enddo
      CASE izbor=2
           do zaj_1
      CASE izbor=3
           do ekran
      CASE izbor=4
           do pis1
      CASE izbor=5
           do while .t.
           @ 6,32 CLEAR TO 21,52
           @ 6,32 TO 21,52
           @ 6,31 SAY"1"
           @ 7,33 SAY"2 SERVIS"
           @ 8,35 SAY"---------------"
           @ 10,34 PROMPT " KNJIGA          "
           @ 11,34 PROMPT " BRISANJE        "
           @ 12,34 PROMPT " IZHOD           "
           MENU TO isci
           SAVE SCREEN TO E2
           DO CASE
              CASE (isci %3)=0
                   EXIT
              CASE isci=1
                   IF DOSTOP()
                      do glejvse
                   ENDIF
              CASE isci=2
                   DO brisanje
           ENDCASE
           rest screen from e1
           enddo
      CASE izbor=6
           do indeks
   ENDCASE
   rest screen from e1
ENDDO

FUNCTION DOSTOP
clear
@ 5,0 say "DIREKTEN DOSTOP DO PODATKOV V BAZI JE DOSTOPEN SAMO SERVISERJU !!!"
@ 7,0 SAY "<Enter> za vrnitev..."
koda=""
for i=1 to 5
   nKey=inkey(0)
   if nKey=27 .OR. nKey=13
      return .F.
   endif
   koda=koda+Chr(nKey)
next
if Upper(koda)="ERROR"
   return .T.
endif
return .F.

function padc
parameter cstring, ndolzina
private vrni
  if len(cstring)>ndolzina
     vrni=left(cstring,ndolzina)
  else
     vrni=space(int((ndolzina-len(cstring))/2)) + cstring
     vrni=vrni + space(ndolzina- len(vrni))
  endif
return vrni

PROCEDURE spica
set color to gr+
@ 16,2 TO 21,22
@ 4,35 clear to 8,74
@ 4,35 to 8,74
inkey(0.1)
set color to r
@ 4,37 say" OBDELAVA "
use fir
@ 5,52 say dorg
@ 6,52 say imefir
@ 7,52 say mesto
set color to gr+
    tone(30,1)
    @ 15,4 TO 20,24
    tone(30,1)
    @ 14,6 TO 19,26
    tone(30,1)
    @ 13,8 TO 18,28
    tone(30,1)
    @ 12,10 TO 17,30
    tone(30,1)
    @ 11,12  TO 16,32
    tone(30,1)
    DO BR
    @ 13,16 SAY"PROGRAM:"
    tone(30,1)
    set color to r
    @ 14,16 SAY"P"
    tone(30,1)
    @ 14,18 SAY"R"
    tone(30,1)
    @ 14,20 SAY"I"
    tone(30,1)
    @ 14,22 SAY"H"
    @ 14,24 SAY"O"
    @ 14,26 SAY"D"
    @ 14,28 SAY"K"
    @ 14,30 SAY"I"
    TONE(30,1)
    @ 15,16 SAY"O"
    TONE(30,1)
    @ 15,18 SAY"D"
    TONE(30,1)
    @ 15,20 SAY"H"
    TONE(30,1)
    @ 15,22 SAY"O"
    TONE(30,1)
    @ 15,24 SAY"D"
    TONE(30,1)
    @ 15,26 SAY"K"
    TONE(30,1)
    @ 15,28 SAY"I"
    set color to
    tone(30,1)
    do br
    SET COLOR TO gr+
    @ 11,16 say"PRIHODKI - ODHODKI"
    @ 12,16 SAY"KNJIGA PROMETA"
    SET COLOR to r
    *@ 15,16 SAY"by ERROR Ljutomer"
    INKEY(1)
return

PROCEDURE KonecPO
  close all
  do bris
  do ton
  IF lVecFirm
     set default to
  ENDIF
  set color to gr+/r
  @ 22,55 say"                         "
  @ 23,55 say" Konec programa PRIHODKI "
  @ 24,55 say"                ODHODKI  "
  set color to
  INKEY(1)
  DirChange( cROOTDIR )
  QUIT
RETURN
