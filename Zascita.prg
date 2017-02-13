DO WHILE .T.
clear
set color to r+/w
@ 23,60 say" ERROR doo "
set color to
IF FILE("firma.dbf")
USE firma
ELSE
USE fir
ENDIF
obstaja=.F.
for i=1 to fcount()
    if field(i)="OKNO"
       obstaja=.T.
       exit
    endif
next
if !obstaja
   do ton
   quit
   return
endif
okno=okno
sifra=serijska()
sifra=ltrim(str(asc(right(left(sifra,2),1))+asc(left(sifra,1));
      +asc(right(left(sifra,3),1))+asc(right(left(sifra,4),1));
      +asc(right(left(sifra,5),1))+asc(right(left(sifra,6),1));
      +asc(right(left(sifra,8),1))+asc(right(left(sifra,7),1));
      +asc(right(left(sifra,10),1))))
sifra=ltrim(str(asc(right(left(sifra,9),1))))+sifra
if left(okno,len(sifra))<>sifra
   do ton
   quit
endif
close databases
EXIT
ENDDO
