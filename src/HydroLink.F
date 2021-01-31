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

#define __THNVARINC__

#if __INTTEST__
#define __TSTINTINC__
#endif
#include "corsika.h"
      double precision m_pro,ELABN
      integer NPROT,NNEUT
      integer mmry,mxptl
      parameter (mmry=1)
      parameter (mxptl=200000/mmry)
      integer nptl,nspec,idptl,spec_judge
      double precision pptl,tivptl,xorptl
      common/Hydro/NPROT,NNEUT,nptl,nspec,pptl(5,mxptl),idptl(mxptl),
     & spec_judge(mxptl)
      ! test variable
      double precision::p_sum(4)=0
      integer i,j
      

      nptl=0
      nspec=0
      NPROT=0
      NNEUT=0
c     judge if the particle is the particle hydro support  
      if(.not.(itype >= 200 .or. (itype>=7 .and. itype<=9) .or. 
     & (itype>=13 .and. itype<=15))) then
        CALL NEXLNK
        RETURN
      endif

      if(itype<200) then
        m_pro=PAMA(itype)
        ELABN=m_pro*curpar(1)
      else 
        NPROT = MOD(ITYPE,100)
        NNEUT = ITYPE/100 - NPROT
        m_pro = PAMA(14)*NPROT + PAMA(13)*NNEUT
        !ELABN=m_pro*curpar(1)/(NPROT+NNEUT)?
        ELABN=m_pro*curpar(1)
      endif
c     judge if it reach LHC energy 
      if(ELABN < 1e7) then
        CALL NEXLNK
        RETURN
      endif

      IF(DEBUG) write(*,*)"HydroLink: itype=",itype," tar=",tar
      
      CALL hydro_run(int(itype),int(tar),curpar(1),m_pro
     & ,nptl,nspec,idptl,pptl,spec_judge)


      
      ! test process
      do i=1,nptl
        do j=1,4
          p_sum(j)=pptl(j,i)+p_sum(j)
        enddo
      enddo
      IF(DEBUG) then
        write(*,*)"HydroLink: ELABN Eptl ELABN/Eptl : ",ELABN,p_sum(4),
     &  ELABN/p_sum(4)
        write(*,*)"HydroLink: nptl npsec : ",nptl,nspec
      ENDIF

      CALL HydroStore(ELABN)
  

      RETURN
      END SUBROUTINE HydroLink