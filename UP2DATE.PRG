
#include "net.ch"

DefNastav("DOSPRIDIR","","Imenik kjer ~ita DOSPRINTER.EXE")

USE prih_odh
if FieldPos("VRED_Z_DDV")=0
   CopyTemp()
   USE Temp.$$$


   InsNewField("D_DOG","D",8,0,"D_KNJI")

   InsNewField("D_ZAPAD","D",8,0,"D_PLAC")
   InsNewField("N_PLAC","C",1,0,"D_ZAPAD")

   InsNewField("VRED_Z_DDV","N",10,2,"CIFRA")
   InsNewField("VSTDDV","N",10,2,"VRED_Z_DDV")
   InsNewField("OBRDDV","N",10,2,"VSTDDV")

   CREATE prih_odh FROM temp.$$$
   APPEND FROM temp

   USE knjizi
   COPY TO temp
   USE

   CREATE knjizi FROM temp.$$$
   APPEND FROM temp

endif
USE

if NetUSE("fir",lSHA)
   if Len(dorg) < 30
      CopyTemp()
      USE temp.$$$
      LOCATE FOR field_name="DORG "
      REPLACE field_len WITH 30
      LOCATE FOR field_name="IMEFIR "
      REPLACE field_len WITH 30
      LOCATE FOR field_name="ULICA "
      REPLACE field_len WITH 30
      LOCATE FOR field_name="MESTO "
      REPLACE field_len WITH 30
      if NetUSE("fir",lEXC)
         CREATE fir FROM temp.$$$
         APPEND FROM temp
      endif
   endif

   CLOSE fir
endif

if NetUSE("Prih_odh",lEXC)
   REPLACE konto WITH strzero(val(konto),2) ALL
   CLOSE Prih_odh
endif
if NetUSE("Knjizi",lEXC)
   REPLACE konto WITH strzero(val(konto),2) ALL
   CLOSE Knjizi
endif
if NetUSE("Konto",lEXC)
   REPLACE konto WITH strzero(val(konto),2) ALL
   CLOSE Konto
endif
