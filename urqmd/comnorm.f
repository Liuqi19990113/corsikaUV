c $Id: comnorm.f 5115 2016-01-04 19:07:31Z darko $
      integer n
      parameter (n = 400)
      real*8 x_norm(0:3,1:n),y_norm(0:3,1:n)
      real*8 y2a(0:3,1:n),y2b(0:3,1:n),dx
      common /normsplin/ x_norm,y_norm,y2a,y2b,dx
