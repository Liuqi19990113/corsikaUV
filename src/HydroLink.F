      SUBROUTINE HydroLink

C-----------------------------------------------------------------------
C  link with hydro
C  only treat nucleus and hardron
C  THIS SUBROUTINE IS CALLED FROM SDPM.
C-----------------------------------------------------------------------

      IMPLICIT NONE
#define __PAMINC__
#define __PARPARINC__
#define __PARPAEINC__
#define __RANDPAINC__
#define __RESTINC__
#define __RUNPARINC__
#if __INTTEST__
#define __TSTINTINC__
#endif
#include "corsika.h"
      double precision mass0
      integer NPROT,NNEUT
      integer mmry,mxptl
      parameter (mmry=1)
      integer nptl,idptl
      real pptl,tivptl,xorptl
      common/Hydro/nptl,pptl(5,mxptl),idptl(mxptl)

c     judge if the particle is the particle hydro support  
      if(.not.(itype >= 200 .or. (itype>=7 .and. itype<=9) .or. 
     & (itype>=14 .and. itype<=15))) then
        CALL NEXLNK
        RETURN
      if(itype<200) then
        mass0=PAMA(itype)
      else 
        NPROT = MOD(ITYPE,100)
        NNEUT = ITYPE/100 - NPROT
        mass0 = PAMA(14)*NPROT + PAMA(13)*NNEUT
      endif
      CALL HydroRun(itype,tar,curpar(1),mass0,curpar(2),
     & curpar(3),curpar(4),nptl,idptl,pptl)

      RETURN
      END