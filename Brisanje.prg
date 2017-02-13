
#include "net.ch"

CLS

@ 0,0 SAY "BRISANJE KNJIGE PRIHODKOV in ODHODKOV"
oddatuma=ctod("  .  .    ")
dodatuma=ctod("  .  .    ")
@ 5,0 say "Od datuma:" GET oddatuma
@ 6,0 say "Do datuma:" GET dodatuma
READ
if LastKey()=27
   RETURN
endif
dane=" "
@ 7,0 say "Ali ste prepri~ani?" GET dane PICTURE "!" VALID dane$"DN"
READ
if LastKey()=27
   RETURN
endif

if NetUSE("prih_odh",lEXC)
   DELETE FOR d_dokum>=oddatuma .AND. d_dokum<=dodatuma
   PACK
endif

save screen

do indeks

rest screen

@ 10,0 say "BAZE ZBRISANE!!!   <Enter>"
inkey(0)

