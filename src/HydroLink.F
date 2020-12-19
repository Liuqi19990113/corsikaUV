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
      double precision mass0,ELABN
      integer NPROT,NNEUT
      integer mmry,mxptl
      parameter (mmry=1)
      parameter (mxptl=200000/mmry)
      integer nptl,nspec,idptl
      real pptl,tivptl,xorptl
      common/Hydro/NPROT,NNEUT,nptl,nspec,pptl(5,mxptl),idptl(mxptl)
      
      nptl=0
      nspec=0
      NPROT=0
      NNEUT=0
c     judge if the particle is the particle hydro support  
      if(.not.(itype >= 200 .or. (itype>=7 .and. itype<=9) .or. 
     & (itype>=14 .and. itype<=15))) then
        CALL NEXLNK
        RETURN
      endif
      if(.true.) goto 5
5     write(*,*)5 
      if(itype<200) then
        mass0=PAMA(itype)
        ELABN=mass0*curpar(1)
      else 
        NPROT = MOD(ITYPE,100)
        NNEUT = ITYPE/100 - NPROT
        mass0 = PAMA(14)*NPROT + PAMA(13)*NNEUT
        !ELABN=mass0*curpar(1)/(NPROT+NNEUT)?
        ELABN=mass0*curpar(1)
      endif
      CALL HydroRun(itype,tar,curpar(1),mass0,curpar(2),
     & curpar(3),curpar(4),nptl,nspec,idptl,pptl)

      CALL HydroStore(ELABN)
      RETURN
      END SUBROUTINE HydroLink