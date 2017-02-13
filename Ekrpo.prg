use prih_odh index idatum
clear
SET CURSOR OFF
set color to g+
@ 12,29 TO 14,52
@ 13,31 say "PO^AKAJTE TRENUTEK !"
n=1
go top
do while .not. eof()
   replace nr with n
   n=int(n+1)
   skip
enddo
clear
go top
public zs
zs=0
clear
set color to r+
@ 0,5 say "obr. 5,47"
set color to g+
@ 1,0 SAY"Z.[T.OPIS                 DAT.KNJ. KON. DOKUMENT  DAT.DOK.  DAT.PL. ZNESEK"
set color to
@ 2,0 say replicate(chr(205),80)
@ 23,0 SAY REPLICATE(CHR(196),80)
do while lastkey() <> 27
 if .not. EOF()
  set color to gr+
  if zs < LASTREC()
   @ 3+(zs%20),0 say str(nr,4)+"³"+opis+"³"+dtoc(d_knji)+"³ "+konto+"³"+dok+"³";
      +dtoc(d_dokum)+"³"+dtoc(d_plac)+"³"+transform(cifra,"@E 9,999,999.99")
   skip
   zs=zs+1
  endif
  if (zs%20) = 0 .and. zs <> 0
   set color to w+
   @ 24,0 CLEAR TO 24,79
   @ 24,0 say"Uporabljajte pu{~ice (dol-gor) za naprej-nazaj  ";
             +ltrim(str(zs,4))+"/"+ltrim(str(reccount(),4))+" (";
             +ltrim(str(int((zs/reccount())*100),3))+"%)   Izhod=<ESC>"
   migaj(20)
   @ 3,0 CLEAR TO 22,79
   set color to
  endif
 else
  set color to w+
  @ 24,0 say"Uporabljajte pu{~ice (dol-gor) za naprej-nazaj  ";
  +ltrim(str(zs,4))+"/"+ltrim(str(reccount(),4))+" (100%)   Izhod=<ESC>"
  set color to
  inkey(0)
  @ 24,0 clear to 24,79
  if lastkey()=5 .and. zs <> 0
   if zs%20 <> 0
    skip -((zs%20)+20)
    zs=zs-((zs%20+20))
   else
    skip -40
    zs=zs-20
   endif
  endif
 endif
enddo
set cursor on
set color to
clear
close all
return

FUNCTION MIGAJ
PARAMETERS step
IF zs > LASTREC()
   zs=zs-(2*step)
   SKIP -(2*step)
   RETURN .T.
ENDIF
INKEY(0)
IF LASTKEY() = 24
ELSEIF LASTKEY() = 5
       IF zs > 39
          SKIP -(2*step)
          zs=zs-(2*step)
       ELSE
         SKIP -step
         zs=zs-step
       ENDIF
ELSEIF LASTKEY()=27
   RETURN .T.
ELSE
   migaj(16)
ENDIF
IF zs < 0
   zs=0
ENDIF
RETURN .T.