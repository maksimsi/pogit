


procedure okno
parameters y, x, y1, x1, tip
private enojni, dvojni
  dvojni = CHR(201)+CHR(205)+CHR(187)+;
           CHR(186)+CHR(188)+CHR(205)+;
           CHR(200)+CHR(186)

  enojni = chr(218)+chr(196)+chr(191)+;
           chr(179)+chr(217)+chr(196)+;
           chr(192)+chr(179)

  @ y, x clear to y1, x1
  if pcount()>4
     if tip = 2
        @ y, x, y1, x1 box dvojni
        return
     endif
     if tip = 1
        @ y, x, y1, x1 box enojni
     endif
  else
           @ y, x, y1, x1 box enojni  && ~e ni tipa potem je enojni
  endif

return