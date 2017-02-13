

#include "Net.ch"

do while .t.
CLS
SET COLOR TO GR+/R
@ 9,8 TO 11,56
@ 10,9 say" KRONOLO[KI IZPIS KNJIGE PRIHODKOV in ODHODKOV "
set color to

USE prih_odh INDEX idatum  && d_dokum
n=1
go top
do while .not. eof()
   replace nr with n
   n=int(n+1)
   skip
enddo

go top
oddat=ctod("01.01."+right(dtoc(d_dokum),2) )
go bottom
dodat=ctod("31.12."+right(dtoc(d_dokum),2) )
CLOSE prih_odh

@ 13,10 say "Od datuma:" get oddat valid !empty(oddat)
@ 14,10 say "Do datuma:" get dodat valid dodat>=oddat
READ

if lastkey()=27
   return
endif


select 3
use konto index konto

select 2
USE fir ALIAS Firma

if firma->ma="2"
   stopa=33
else
   stopa=61
endif

select 1
USE prih_odh
index on nr to i_nr

Vklopialternate(cprnFILE)
public vpri,vodh,stopa
vpri=0
vodh=0
sumVstDDV=0
sumObrDDV=0
sumVredZDDV=0
nStran=0
nVrsta=0

SELECT Prih_odh

go top
do while d_dokum<oddat .and. !eof()
   akonto=val(konto)
   if akonto<11
      vpri=vpri+cifra
   else
      vodh=vodh+cifra
   endif
   sumVstDDV=sumVstDDV + vstddv
   sumObrDDV=sumObrDDV + obrddv
   sumVredZDDV=sumVredZDDV + vred_z_ddv
   skip
enddo
set relation to PRIH_ODH->konto into KONTO
do while d_dokum <= dodat .and. .not. eof()
   if nVrsta % stopa = 0
      glava()
   endif
   ? transform(PRIH_ODH->nr,"9999")+chr(13)
   if val(PRIH_ODH->konto)<=30
      ?? space(6) +dtoc(PRIH_ODH->d_knji)+" "+PRIH_ODH->opis+" "+PRIH_ODH->dok+" "+dtoc(PRIH_ODH->d_dokum)+" "+dtoc(PRIH_ODH->d_plac)+chr(13)
      ?? space(67) +KONTO->konto+"-"+Left(KONTO->opis,13)+chr(13)
      if val(PRIH_ODH->konto) < 11
         r=84
         vpri=vpri+PRIH_ODH->cifra
      else
         r=89
         vodh=vodh+PRIH_ODH->cifra
      endif
      ?? space(r) +transform(PRIH_ODH->cifra,"@E 99,999,999.99")+chr(13)
      ?? space(103) +transform(PRIH_ODH->vred_z_ddv,"@E 99,999,999.99")+chr(13)+chr(13)
      ?? space(117) +transform(PRIH_ODH->vstddv+PRIH_ODH->obrddv,"@E 99,999,999.99") && ali ali
      sumVstDDV=sumVstDDV + vstddv
      sumObrDDV=sumObrDDV + obrddv
      sumVredZDDV=sumVredZDDV + vred_z_ddv
   endif
   nVrsta=nVrsta+1
   if nVrsta % stopa = 0
      podplat()
      if stopa=33
         do while prow()<=47
            ?
         enddo
      else
         EJECT
      endif
      setprc(0,0)
   endif
   skip
enddo
? replicate("-",132)
? "SKUPNO:                            PRIHODEK"+;
       " " +transform(vpri,"@E 999,999,999.99") +;
       " " +transform(sumObrDDV,"@E 999,999,999.99")

? "                                    ODHODEK"+;
       " " +transform(vodh,"@E 999,999,999.99")+;
       " " +transform(sumVredZDDV,"@E 999,999,999.99")+;
       " " +transform(sumVstDDV,"@E 999,999,999.99") +kmali
if stopa=33
   do while prow()<=47
   ?
   enddo
else
   EJECT
endif
setprc(0,0)

IzklopiAlternate()
UsmeriIzpis(cPRNFILE, "")

exit
enddo
CLOSE Databases

PROCEDURE Glava
   nStran=nStran+1
   setprc(0,0)
   ?
   ? Trim(FIRMA->dorg)+", "+FIRMA->imefir
   ? FIRMA->mesto
   ? zac+PadC("KNJIGA PRIHODKOV in ODHODKOV",40)+konc
   ? padc("Obdobje:"+dtoc(oddat)+" - "+dtoc(dodat),80)
   ? space(68) +"Stran: "+ltrim(str(nStran,3))
   ? mali
   ? replicate("-",132)
   ? "Zap. Datum                         [t.knjig.   Datum    Datum                                 Prihodek                       "
   ? "[t.  knji`.    Opis knji`enja      listine     izstav.  pla~ila    Kolona/Konto                   Odhodek   Rn z DDV      DDV"

   ? replicate("-",132)
   ? if(nStran=1,"DONOS do dne "+dtoc(oddat)+" :", "PRENOS:") +chr(13)
   ?? space(84) +transform(vpri,"@E 999,999,999.99")
   ? space(89) +transform(vodh,"@E 999,999,999.99")
   ? replicate("-",132)    && 12
   nVrsta=prow()+1
RETURN

procedure podplat
? replicate("-",132)
? "Prenos na naslednjo stran:" +chr(13)
?? space(84) +transform(vpri,"@E 999,999,999.99")
? space(89) +transform(vpri,"@E 999,999,999.99") +chr(13)
?? space(pcol()) +kmali
return
