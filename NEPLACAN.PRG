
DO WHILE .T.
   @ 7,48 clear to 14,68
   @ 7,48 to 14,68

   @ 8,49 SAY"3 NEPLA^ANI RA^UNI"
   @ 10,50 PROMPT " KUPCI        "
   @ 11,50 PROMPT " DOBAVITELJI  "
   @ 13,50 PROMPT " IZHOD        "
   MENU TO nasel
   save screen to e3
   DO CASE
      CASE (nasel %3)=0
           EXIT
      CASE nasel=1
           akonto="06"
           sez_racuni("K")
      CASE nasel=2
           akonto="12"
           sez_racuni("D")
   ENDCASE
   rest screen from e3
enddo

close databases
return

procedure sez_racuni(cKupDob)
           CLS
           nadan=date()
           @ 14,10 say"Datum izpisa: "get nadan
           @ 15,10 say"Konto_______: "get akonto
           read
           if lastkey()=27
              return
           endif
           select 2
           use fir
           select 1
           USE prih_odh INDEX idatum

           VklopiAlternate(cprnFILE)
           nstran=1
           gl_kupcev()
           ncifra=0
           do while !eof()
              if konto<>akonto .or. !empty(d_plac)
                 skip
                 loop
              endif
              pisi=.f.
              if cKupDob="K"
                 pisi=if(at("/RA",dok)>0 ,.t.,.f.)
              elseif cKupDob="D"
                 pisi=if(at("/BL",dok)=0 ,.t.,.f.)
              endif
              if pisi
                 ? opis,d_dokum,dok,transform(cifra,"@E 99,999,999.99")
                 ncifra=ncifra+cifra
              endif
              if prow()>55
                 ? replicate("-",80)
                 eject
                 nstran=nstran+1
                 gl_kupcev()
              endif
              skip
           enddo
           ? replicate("-",80)
           ? pad("SKUPAJ:",40),transform(ncifra,"@E 99,999,999.99")
           ? replicate("-",80)
           eject
           *SET PRINT OFF
           *SET CONSOLE ON
           IzklopiAlternate()
           UsmeriIzpis(cPRNFILE, "")

           close databases
return

procedure gl_kupcev
naslov=if(cKupDob="K", "SEZNAM TERJATEV DO KUPCEV","SEZNAM OBVEZNOSTI DO DOBAVITELJEV")
?
?
? fir->dorg
? fir->imefir
? fir->ulica
? empha+padc(naslov,80)+de_empha
? padc("Datum izpisa: "+dtoc(nadan),80)
? space(70)+"Stran:"+str(nstran,3)
? padc("OPIS",20),padc("DATUM",8),padc("DOKUMENT",10),padc("ZNESEK",13)
? replicate("-",80)
return