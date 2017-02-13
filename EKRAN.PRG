
DO WHILE .T.
    @ 6,38 clear to 21,58
    @ 6,38 to 21,58

    @ 7,39 SAY"2 PRIHOD-ODHOD"
    @ 8,39 SAY"  EKRAN"
    @ 10,40 PROMPT " CELA KNJIGA  "
    @ 11,40 PROMPT " PO KONTU     "
    @ 12,40 PROMPT " KRONOLO[KO   "
    @ 13,40 PROMPT " IZHOD        "
    MENU TO najdi
    save screen to e2
    DO CASE
    CASE (najdi %4)=0
         EXIT
    CASE najdi=1
         do while .t.
         CLS
         oddatuma=ctod("  .  .    ")
         dodatuma=ctod("  .  .    ")
         @ 5,0 SAY "od datuma:" GET oddatuma
         @ 6,0 SAY "do datuma:" GET dodatuma
         READ
         if Lastkey()=27
            exit
         endif
         CLS
         select 2
         use konto index konto
         select 1
         use prih_odh index p_konto
         set filter to d_dokum>=oddatuma .AND. d_dokum<=dodatuma
         n=1
         vr=3
         set color to i
         @ 0,0 say" KNJIGA PRIHODKOV in ODHODKOV "+dtoc(oddatuma)+" - "+dtoc(dodatuma)
         set color to
         @ 2,0 to 23,79
         aaa=0
         bbb=0
         SELECT Konto
         lsumprih=.T.
         do while !eof()
            ckonto=konto
            if ckonto > "10" .AND. lSumPrih
               @ vr,2 say replicate(chr(196),74)
               vr=vr+1
               set color to i
               @ vr,3 say" SKUPAJ PRIHODKI: "
               set color to
               @ vr,62 say aaa picture"999,999,999.99"
               vr=vr+2
               lSumPrih:=.F.
            endif

            SELECT prih_odh
            DBSeek(cKonto,.T.)
            if konto==ckonto
               SUM A->cifra to aa while Prih_odh->konto==cKonto
               @ vr,2 say ckonto+" "+Konto->opis
               SELECT Prih_odh
               @ vr,62 say aa picture"999,999,999.99"
               if cKonto <= "10"
                  aaa=aaa+aa
               elseif cKonto>="11"
                  bbb=bbb+aa
               endif
               vr=vr+1
            endif
            if vr>22
               do ton
               @ 24,60 say"Enter ..."
               inkey(0)
               vr=3
               @ 2,0 clear to 24,79
               @ 2,0 to 23,79
            endif
            SELECT Konto
            SKIP
         enddo
         if vr>21
            do ton
            @ 24,60 say"Enter ..."
            inkey(0)
            vr=3
            @ 2,0 clear to 24,79
            @ 2,0 to 23,79
         endif
         @ vr,2 say replicate(chr(196),74)
         vr=vr+1
         set color to i
         @ vr,3 say" SKUPAJ ODHODKI: "
         set color to
         @ vr,62 say bbb picture"999,999,999.99"
         vr=vr+2
         SET COLOR TO I
         @ vr,3 say" SALDO: "
         SET COLOR TO
         ccc=aaa-bbb
         @ vr,12 say ccc picture"999,999,999.99"
         inkey(0)
         clear
         exit
         enddo
         close databases
    CASE najdi=2
         do while .t.
         select 2
         use konto index konto
         select 1
         use prih_odh index p_konto
         clear
         od=space(2)
         do=space(2)
         @ 10,10 say"Za konto: "get od picture"99"
         *@ 12,10 say"Do konta: "get do picture"99"
         READ
         do=od
         clear
         set color to i
         @ 0,2 say" IZPIS ANALITIKE PRIHODKOV in ODHODKOV "
         @ 0,65 SAY" ZBIR "
         set color to
@ 4,3 say"OPIS                   DAN/knj   DOKUMENT  DAN/dokum          ZNESEK"
                     do while val(od)<=val(do)
                     daj=od
                     select 1
                     seek daj
                     if found()
                     @ 5,0 clear to 24,79
                     @ 5,0 to 23,79
                     vr=6
                     select 2
                     seek daj
                     @ 2,2 clear to 2,79
                     set color to r*
                     @ 2,2 say daj
                     set color to g
                     @ 2,6 say B->opis
                     set color to
                     select 1
                     seek daj
                     sum A->cifra to aaa while A->konto=daj
                     @ 2,57 say aaa picture"999,999,999.99"
                     seek daj
                     do while A->konto=daj .and. .not. eof()
                        @ vr,3 say A->opis+"   "+dtoc(A->d_knji)+"  "+A->dok+"   "+dtoc(A->d_dokum)
                        @ vr,59 say A->cifra picture"9,999,999.99"
                        skip
                        vr=vr+1
                        if vr>22
                           vr=6
                           @ 24,60 say"Enter ..."
                           inkey(0)
                           if lastkey()=27
                              exit
                           endif
                           @ 6,1 clear to 22,78
                        endif
                     enddo
                     inkey(0)
                     endif
                     od=str(val(od)+1,2)
                     enddo
                     clear
                     exit
                     enddo
close databases
CASE najdi=3
     do ekrpo
ENDCASE
rest screen from e2
ENDDO