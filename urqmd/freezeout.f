c $Id: freezeout.f 5115 2016-01-04 19:07:31Z darko $
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c freezeout common block for uQMD
c
c     Revision : 1.0 
c
c

      real*8 frr0(nmax), frrx(nmax), frry(nmax), frrz(nmax),
     +     frp0(nmax), frpx(nmax), frpy(nmax), frpz(nmax)

      common /frcoor/ frr0, frrx, frry, frrz, frp0, frpx, frpy, frpz 
