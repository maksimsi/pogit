USE FIRME
if lastrec()>1
  lVecFirm=.T.
  GO TOP
  DECLARE ARRAJ[9]
  FOR I=1 TO LASTREC()
     ARRAJ[I]=STR(FST,1)+" - "+DORG
     SKIP
  NEXT
  F=0
  @ 5,27 TO 7,53
  set color to w+
  @ 6,28 SAY " OBDELAVA ZA FIRMO       "
  set color to
  DO WHILE F=0
     F=VRNI(8,27,ARRAJ)
  ENDDO
  KAM="CD F"+STR(F,1)
  RUN &KAM
endif
USE