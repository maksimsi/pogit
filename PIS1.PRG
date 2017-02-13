DO WHILE .T.
    OSmenu_okno(6,38, "TISKALNIK",;
                     { " CELA KNJIGA  ",;
                       " PO KONTIH    ",;
                       " KRONOLO[KI I.",;
                       " NEPL. RA^UNI ",;
                       "-",;
                       " IZHOD        " })
    MENU TO najdi
    save screen to e2
    DO CASE
       CASE (najdi %5)=0
            EXIT
       CASE najdi=1
            do while .t.
            CLEAR SCREEN
            nadan=space(8)
            oddat=ctod("01.01."+right(dtoc(date()),2))
            dodat=date()
            @ 14,10 say"Izpis na dan:"get nadan picture"99.99.99"
            @ 16,10 say"Od datuma   :" get oddat
            @ 17,10 say"Do datuma   :" get dodat
            read
            if lastkey()=27
               exit
            endif
            select 3
            use fir
            select 2
            use konto index konto
            select 1
            use prih_odh index p_konto
            n=1
            vr=9

            VklopiAlternate(cprnFILE)
            setprc(0,0)
            ? C->dorg
            ? C->imefir
            ? C->mesto +chr(13)
            nn=2+len(RTRIM(C->mesto))
            ?? space(nn) +", "+C->ulica
            ? "---------------------"  &&3
            ?
            ?
            ? space(10) +"KNJIGA PRIHODKOV in ODHODKOV  na dan:"+ nadan
            ? space(10) +dtoc(oddat)+" - "+dtoc(dodat)
            sumVredZDDV=0
            aaa=0
            bbb=0
            do while n<=99
               *daj=rtrim(str(int(n)))
               *daj=IIF(n < 10, daj+" ", daj)
               daj=strzero(n,2)
               select 1
               daj=right(daj,2)
               seek daj
               if found()
                  sum A->cifra to aa while A->konto=daj for d_dokum>oddat-1 .and. ;
                                                            d_dokum<dodat+1
                  select 2
                  seek daj
                  ?
                  ?  daj+" "+B->opis +chr(13)   && 9
                  select 1
                  ? space(62) +transform(aa,"999,999,999.99")
                  if n<11
                     aaa=aaa+aa
                  else
                     bbb=bbb+aa
                  endif
                  vr=vr+1
               endif
               n=n+1
               if n=11
                  ? space(2) +replicate("-",74)
                  vr=vr+1
                  ? space(3) +"SKUPAJ PRIHODKI: " +chr(13)
                  ?? space(62) +transform(aaa,"999,999,999.99")
                  ?
                  ?
                  vr=vr+3
               endif
            enddo
            ? space(2) +replicate("-",74)
            vr=vr+1
            ? space(3) +"SKUPAJ ODHODKI: " +chr(13)
            ?? space(62) +transform(bbb,"999,999,999.99")
            ?
            ?
            vr=vr+3
            ? space(3) +"PRIHODKI:" +chr(13)
            ?? space(12) +transform(aaa,"999,999,999.99")
            vr=vr+1
            ? space(3) +"ODHODKI:" +chr(13)
            ?? space(12) +transform(bbb,"999,999,999.99")
            ? space(3) +"-----------------------"
            vr=vr+2
            ?
            ? space(3) +"SALDO: " +chr(13)
            ccc=aaa-bbb
            ?? space(12) +EMPHA+transform(ccc,"999,999,999.99")+DE_EMPHA
            ?
            eject

            IzklopiAlternate()
            UsmeriIzpis(cPRNFILE, "")

            exit
            enddo
            close databases
     CASE najdi=2
          do while .t.
          clear
          nadan=space(8)
          oddat=ctod("01.01."+right(dtoc(date()),2))
          dodat=date()
          ckto="  "
          @ 14,10 say"Izpis na dan:"get nadan picture"99.99.99"
          @ 16,10 say"Od datuma   :" get oddat
          @ 17,10 say"Do datuma   :" get dodat
          @ 19,10 say"Za konto    :" get ckto
          @ 19,30 say"prazno je vsi konti"
          READ
          if lastkey()=27
             exit
          endif
          select 3
          USE FIR alias fir
          select 2
          use konto index konto alias konto
          select 1
          use prih_odh index p_konto alias prih_odh
          if .not. Empty(ckto)
             SET FILTER TO konto= ckto
             GO TOP
          endif
          CLS

          VklopiAlternate(cprnFILE)
          ran=1
          setprc(0,0)
          ? C->dorg
          ? C->imefir
          ? C->mesto +chr(13)
          nn=2+len(RTRIM(C->mesto))
          ?? space(nn) +", "+C->ulica
          ? "---------------------"
          ?
          ?
          ? space(10) +EMPHA+"KNJIGA PRIHODKOV in ODHODKOV"+DE_EMPHA +chr(13)
          ?? space(40) +"na dan: "+nadan +chr(13)
          ?? space(62) +"Stran: "+ltrim(str(ran))
          ? space(10) +dtoc(oddat)+" - "+dtoc(dodat) && 7
          vr=9
          od=1
          do=99
          do while od<=do
             daj=strzero(od,2)
             select 1
             seek daj
             if found()
                ?
                ? "OPIS                  DAN/knj DOKUMENT  DAN/dokum      ZNESEK      Zne.Z DDV"
                ? replicate("-",78)
                vr=vr+2
                ?
                select 1
                seek daj
                do while A->konto=daj .and. .not. eof()
                   if ! (d_dokum>oddat-1 .and. d_dokum<dodat+1)
                      skip
                      loop
                   endif
                   ? A->opis+" "+dtoc(A->d_knji)+" "+A->dok+" "+dtoc(A->d_dokum)+;
                     transform(A->cifra,"@E 999,999,999.99")+" "+transform(A->vred_z_ddv,"@E 999,999,999.99")
                   skip
                   vr=vr+1
                   if vr>60
                      ?
                      vr=vr+2
                      ran=int(ran+1)
                      ? "NADALJEVANJE na strani: "+ltrim(str(ran))
                      eject
                      setprc(0,0)
                      ? C->dorg
                      ? C->imefir
                      ? C->mesto +chr(13)
                      nn=2+len(RTRIM(C->mesto))
                      ?? space(nn) +", "+C->ulica
                      ? "---------------------"
                      ?
                      ?
                      ? space(10) +EMPHA+"KNJIGA PRIHODKOV in ODHODKOV"+DE_EMPHA +chr(13)
                      ?? space(40) +"na dan: "+nadan +chr(13)
                      ?? space(62) +"Stran: "+ltrim(str(ran))
                      ? space(10) +dtoc(oddat)+" - "+dtoc(dodat)
                      ?
                      ? "OPIS                  DAN/knj DOKUMENT  DAN/dokum      ZNESEK      Zne.Z DDV"
                      ? replicate("-",78)
                      vr=11
                   endif
                enddo
                select 2
                ?  replicate("-",78)
                vr=vr+1
                seek daj
                ? daj+" "+left(B->opis,40)+chr(13)
                select 1
                seek daj
                sum A->cifra, A->vred_z_ddv to aaa,ddd while A->konto=daj for d_dokum>oddat-1 .and.;
                                                                              d_dokum<dodat+1
                ?? space(49) +transform(aaa, "@E 999,999,999.99")+" "+;
                            transform(ddd, "@E 999,999,999.99")
                ?
                ?
                ?
                vr=vr+4
             endif
             od=od+1
          enddo
          ?
          eject

          IzklopiAlternate()
          UsmeriIzpis(cPRNFILE, "")

          exit
          enddo
          close databases
     CASE najdi=3
          do cela94
     CASE najdi=4
          do neplacan
    ENDCASE
rest screen from e2
ENDDO