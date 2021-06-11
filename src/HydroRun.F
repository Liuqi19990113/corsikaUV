#ifndef _HYDRORUN_F_
#define _HYDRORUN_F_

      subroutine HydroRun(proj_id,tar,gamma,m_pro,nptl,nspec,idptl
     &   ,pptl,spec_judge,seedh)

      IMPLICIT NONE
      integer mmry,mxptl
      parameter (mmry=1)
      parameter (mxptl=200000/mmry)
      integer nptl,nspec,idptl(mxptl),spec_judge(mxptl),tar,proj_id
      double precision pptl(5,mxptl)
      double precision m_p,m_n,E_pro,gamma,ene,m_pro,m_tar,
     &  gamma0,beta0,beta(4),momentum
      integer nucleus_judge,pro_A,pro_Z,pro_pid,pro_iso3,tar_A,tar_Z,
     &  i,seedh

      ! initial the particle information
      ! mass of proton and neutron
      m_p=0.938272013
      m_n=0.939565346
      E_pro=gamma*m_pro
      ene=E_pro
      ! projectile information
      ! if =1 , is nucleus
      if(proj_id .ge. 200) then
        nucleus_judge=1
        pro_A=proj_id/100
        pro_Z=proj_id-pro_A*100
        ene=ene/pro_A
      else
        nucleus_judge=0
        if(proj_id.eq.14) then
          ! p+
          pro_pid=1
          pro_iso3=1
        elseif(proj_id.eq.13) then
          ! n
          pro_pid=1
          pro_iso3=-1
        elseif(proj_id.eq.15) then
          ! p-
          pro_pid=-1
          pro_iso3=-1
        elseif(proj_id.eq.7) then
          ! pi0
          pro_pid=101
          pro_iso3=0
        elseif(proj_id.eq.8) then
          ! pi+
          pro_pid=101
          pro_iso3=2
        elseif(proj_id.eq.9) then
          ! pi-
          pro_pid=101
          pro_iso3=-2
        endif
      endif

      ! target information
      if(tar .eq. 14) then
        ! N
        tar_A=14
        tar_Z=7
      elseif (tar .eq. 16) then
        ! O
        tar_A=16
        tar_Z=8
      else if (tar .eq. 40) then
        ! Ar
        tar_A=40
        tar_Z=18
      else
        ! unknown target 
        tar_A=tar
        tar_Z=tar/2
        if(tar .le. 0 .or. tar .gt. 208) then
          write(*,*) "HydroRun: wrong tar = ",tar
          STOP
        endif
      endif
      m_tar=tar_Z*m_p+(tar_A-tar_Z)*m_n

      ! run python script
      if(nucleus_judge .eq. 1) then
        call HydroPython(ene,nucleus_judge,pro_A,pro_Z
     &   ,tar_A,tar_Z,seedh)
      else
        call HydroPython(ene,nucleus_judge,pro_pid,pro_iso3
     &   ,tar_A,tar_Z,seedh)
      endif

      ! beta
      momentum=(gamma**2-1)**0.5*m_pro
      beta0=momentum/(E_pro+m_tar)
      gamma0=(1-beta0**2)**(-0.5)
      beta(4)=gamma0
      beta(3)=-beta0
      beta(1)=0
      beta(2)=0
      call ReadHydro(beta,nptl,nspec,idptl,pptl,spec_judge)
      RETURN


      end subroutine HydroRun



      subroutine ReadHydro(beta,nptl,nspec,idptl,pptl,spec_judge)
      
      IMPLICIT NONE
      integer mmry,mxptl
      parameter (mmry=1)
      parameter (mxptl=200000/mmry)
      double precision beta(4),pptl(5,mxptl)
      integer nptl,nspec,idptl(mxptl),spec_judge(mxptl)
      character(len=100):: input_file_QGP
     &  ="./urqmd_vishnew/urqmd/urqmd_QGP_19.txt",
     & input_file_spec
     &  ="./urqmd_vishnew/urqmd/urqmd_spec_19.txt"
      double precision ::p_spec,E_spec,beta_spec(4),p_QGP,E_QGP,
     &  beta_QGP(4),beta_NN(4),E_NN,p_NN
      double precision p(4),mass,x(4)
      integer pdg,counter
      integer QGP_status,spec_status,access
      integer :: spec_unit=110,QGP_unit=111
      integer i,j

      ! initialize 
      nptl=0
      nspec=0
      p_spec=0
      E_spec=0
      p_QGP=0
      E_QGP=0
      beta_spec=0
      beta_QGP=0
      beta_NN=0
      p_NN=0
      E_NN=0
      ! 0 means exist, others means not exist
      ! whether or not have QGP
      QGP_status=access(input_file_QGP,"r")
      spec_status=access(input_file_spec,"r")

      if(spec_status.eq.0) then
        open(unit=spec_unit,file=input_file_spec)
        ! remove header
        do i=1,4
          read(spec_unit,*)
        enddo
        do while(.true.)
          ! read data line
          read(unit=spec_unit,fmt=*,end=100)counter,pdg,p(1),p(2)
     &     ,p(3),p(4),mass,x(1),x(2),x(3),x(4)
          ! if use QGP ,only spectator, if not use QGP , all particle
          ! p_spec=p_spec+p(3)
          ! E_spec=E_spec+p(4)
          p_NN=p_NN+p(3)
          E_NN=E_NN+p(4)
          ! if exits QGP, only record spectator, or record all
          if(((QGP_status.eq. 0).and.x(4).eq. 0 .and. p(3).gt.0)
     &     .or. (.not. (QGP_status.eq. 0))) then
            nptl=nptl+1
            idptl(nptl)=pdg
            spec_judge(nptl)=0
            do i=1,4
              pptl(i,nptl)=p(i)
            enddo
            pptl(5,nptl)=mass
            if(x(4).eq.0 .and. ABS(p(4)/mass/beta(4)-1)<0.1)then
              nspec=nspec+1
              spec_judge(nptl)=1
            endif
          endif
        end do
100     close(spec_unit)   
        ! beta_spec(3)=p_spec/E_spec
        ! beta_spec(4)=(1-beta_spec(3)**2)**(-0.5)
        ! do i=1,nptl
        !   do j=1,4
        !     p(j)=pptl(j,i)
        !   enddo
        !   E_QGP=E_QGP+p(4)
        !   p_QGP=p_QGP+p(3)
        !   ! to cms
        !   call LorentzTransform(beta_spec,p)
        !   ! to lab
        !   call LorentzTransform(beta,p)
        !   do j=1,4
        !     pptl(j,i)=p(j)
        !   enddo
        ! enddo

      endif
      !begin QGP
      ! p_QGP=0
      ! E_QGP=0
      if(QGP_status.eq.0)then
        write(*,*)"HydroRun: Generated QGP"
        open(unit=QGP_unit,file=input_file_QGP)
        ! remove header
        do i=1,4
          read(QGP_unit,*)
        enddo
        do while(.true.)
          ! read data line
          read(unit=QGP_unit,fmt=*,end=101)counter,pdg,p(1),p(2)
     &     ,p(3),p(4),mass,x(1),x(2),x(3),x(4)
          p_QGP=p_QGP+p(3)
          E_QGP=E_QGP+p(4)
          ! p_NN=p_NN+p(3)
          ! E_NN=E_NN+p(4)
          nptl=nptl+1
          do i=1,4
            pptl(i,nptl)=p(i)
          enddo
          pptl(5,nptl)=mass
          spec_judge(nptl)=0
        enddo
101     close(QGP_unit)

      else
        write(*,*)"HydroRun: Not Generated QGP"

      endif
        write(*,*)"HydroRun: E_NN,p_NN=",E_NN,p_NN
        write(*,*)"HydroRun: E_QGP_NN,p_QGP_NN=",E_QGP,p_QGP
        beta_NN(3)=p_NN/E_NN
        beta_NN(4)=(1-beta_NN(3)**2)**(-0.5)
        do i=1,nptl
          do j=1,4
            p(j)=pptl(j,i)
          enddo
          ! to cms
          call LorentzTransform(beta_NN,p)
          ! to lab
          call LorentzTransform(beta,p)
          do j=1,4
            pptl(j,i)=p(j)
          enddo
        enddo
      RETURN
      end subroutine ReadHydro





      subroutine HydroPython(ene,nucleus_judge,pro_para_1,pro_para_2,
     &   tar_para_1,tar_para_2,seedh)

        IMPLICIT NONE
        double precision ene
        integer nucleus_judge,pro_para_1,pro_para_2,tar_para_1,
     & tar_para_2,seedh
        character(len=400) command

        write(command,*)"python ./urqmd_vishnew/run.py",ene,
     & nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2,seedh
        call system(command)
        RETURN
      end subroutine HydroPython



      subroutine LorentzTransform(beta,p)
        IMPLICIT NONE
        double precision beta(4),p(4)
        double precision E,pz
        
        E=0
        pz=0
        pz=beta(4)*(p(3)-beta(3)*p(4))
        E=beta(4)*(p(4)-beta(3)*p(3))
        p(3)=pz
        p(4)=E
        RETURN
      end subroutine LorentzTransform


#endif



