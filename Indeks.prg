     DO WHILE .T.
     close all
     SET CURSOR OFF
     @ 17,3 clear to 19,30
     @ 17,3 TO 19,30
     SET COLOR TO gr+/r
         @ 18,5 say" Delam index bazo  1 "
         use konto
         index on konto to konto
         close all

         use prih_odh
         @ 18,24 SAY"2"
         index on opis to p_opis
         @ 18,24 SAY"3"
         @ 18,24 SAY"4"
         INDEX on konto+dtos(d_dokum) to p_konto
         @ 18,24 say"5"
         index on dtos(d_dokum) to idatum

         @ 18,24 say"6"
         use knjizi
         index on konto to knjizi
         close all

         SET CURSOR ON
         set color to
         EXIT
         ENDDO

PROCEDURE SI_POKonto(cIdx)
  if !lUseError
     SET INDEX TO konto
     if PCount()>0
        DBSetOrder(cIdx)
     endif
  endif
RETURN nil

PROCEDURE SI_POPrihOdh(cIdx)
  if !lUseError
     SET INDEX TO p_konto,p_opis, idatum
     if PCount()>0
        DBSetOrder(cIdx)
     endif
  endif
RETURN nil