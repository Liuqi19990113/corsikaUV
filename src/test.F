      program main
      implicit none
      double precision m_pro,ELABN,tar,itype,m_tar
      integer NPROT,NNEUT
      integer mmry,mxptl
      parameter (mmry=1)
      parameter (mxptl=200000/mmry)
      integer nptl,nspec,idptl,spec_judge,seedh
      double precision pptl,tivptl,xorptl,gamma
      common/Hydro/NPROT,NNEUT,nptl,nspec,pptl(5,mxptl),idptl(mxptl),
     & spec_judge(mxptl)
      ! test variable
      double precision::p_sum(4)=0
      integer i,j
      logical DEBUG
      
      DEBUG=.true.

      itype=201.
      tar=40
      gamma=1e8
      m_pro=0.938272013+0.939565346
      m_tar=m_pro*20
      seedh=101
      ELABN=m_pro*gamma
      write(*,*) "seedh = "
      read(*,*) seedh

      CALL HydroRun(int(itype),int(tar),gamma,m_pro
     & ,nptl,nspec,idptl,pptl,spec_judge,seedh)


      ! CALL HydroStore(ELABN)
      ! test process
      do i=1,nptl
        do j=1,4
          p_sum(j)=pptl(j,i)+p_sum(j)
          pptl(j,i)=0
        enddo
      enddo
      IF(DEBUG) then
        write(*,*) "HydroLink: p_sum",p_sum
        write(*,*)"HydroLink: ELABN Eptl ELABN/Eptl : ",ELABN,p_sum(4),
     &  ELABN/p_sum(4)
        write(*,*)"HydroLink: nptl npsec : ",nptl,nspec
      ENDIF
      nptl=0
      nspec=0



      end program