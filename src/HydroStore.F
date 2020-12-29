      SUBROUTINE HydroStore( ELABN )

C-----------------------------------------------------------------------
C
C  STORES hydro OUTPUT PARTICLES INTO CORSIKA STACK.
C  THIS SUBROUTINE IS CALLED FROM NEXLNK.
C  ARGUMENT:
C   ELABN  = ENERGY/NUCLEON OF PROJECTILE (GEV)
C-----------------------------------------------------------------------

      IMPLICIT NONE
#define __DPMFLGINC__
#define __ELADPMINC__
#define __ELASTYINC__
#define __ISTAINC__
#define __LONGIINC__
#define __MULTINC__
#define __PAMINC__
#define __PARPARINC__
#define __PARPAEINC__
#define __RANDPAINC__
#define __RESTINC__
#define __RUNPARINC__
#define __SIGMINC__
#if __AUGERHIST__ || __EHISTORY__
#define __GENERINC__
#endif
#if __AUGERHIST__ || __COASTUSERLIB__
#define __OBSPARINC__
#endif
#if __INTTEST__
#define __TSTINTINC__
#endif
#include "corsika.h"

      integer NPROT,NNEUT,maproj,KODCRD
      integer mmry,mxptl
      parameter (mmry=1)
      parameter (mxptl=200000/mmry)
      integer nptl,nspec,idptl
      double precision pptl,tivptl,xorptl
      common/Hydro/NPROT,NNEUT,nptl,nspec,pptl(5,mxptl),idptl(mxptl)
C-----------------------------------------------------------------------
      DOUBLE PRECISION EA,ELABN,ELASTI,EMAX,COSTET,PL2,PT2,PTM
CC    DOUBLE PRECISION GAMMAX
      DOUBLE PRECISION PFRX(60),PFRY(60),PTOT,CPHIV,SPHIV
      DOUBLE PRECISION FAC1,FAC2
      REAL             ETOT,GNU
      INTEGER          ITYP(60),IREST,INEW,NZNEW,NNNEW,I,
     *                 KODNEX,KODCRS,JFIN,KNEW,J,MEL,MEN,LL
#if __EHISTORY__
      INTEGER          IK
#endif
      SAVE
#if __AUGERHIST__
      DOUBLE PRECISION EDEP,THICKLOC,THICK
      INTEGER          II
      EXTERNAL         THICK
#endif
#if __COASTUSERLIB__
c  definition of the COAST crs::CInteraction class
      COMMON/coastInteraction/coastX, coastY, coastZ,
     &     coastE, coastCX, coastEl, coastProjId, coastTargId,
     &     coastT
      double precision coastX, coastY, coastZ
      double precision coastE, coastCX, coastEl
      double precision coastT
      integer coastProjId, coastTargId
#endif
C-----------------------------------------------------------------------

      IF ( DEBUG ) WRITE(MDEBUG,*) 'HydroStore:'

C  NUMBER OF SPECTATORS OF REMAINING NUCLEUS IS NREST
      IREST = ITYPE
      INEW   = 0
      ETOT   = 0.
      ELASTI = 0.
      NZNEW  = 0
      NNNEW  = 0
      KNEW   = 0
      maproj=NPROT+NNEUT

c  event variables:
c     nrevt.......... event number
c     nptevt ........ number of (stored!) particles per event
c     bimevt ........ absolute value of impact parameter
c     phievt ........ angle of impact parameter
c     kolevt ........ number of collisions
c     pmxevt ........ reference momentum
c     egyevt ........ pp cm energy (hadron) or string energy (lepton)
c     npjevt ........ number of primary projectile participants
c     ntgevt ........ number of primary target participants

      GNU  = 1
      EMAX = 0.D0
CC    GAMMAX = 0.D0
#if __EHISTORY__
C  COPY PARTICLE INFORMATION, LATER TO BECOME GRANDMOTHER PARTICLE
      DO  IK = 0, 6
        SECPAR(28+IK) = CURPAR(IK)
      ENDDO
C  STORE GENERATION COUNTER OF MOTHER
      SECPAR(35) = GEN
C  STORE MASS PENETRATION BEFORE INTERACTION
      SECPAR(36) = CURPAR(9)
#if __THIN__
      SECPAR(37) = CURPAR(13)
#endif
#endif

C  PARTICLE LOOP
      DO  5  I = 1, nptl

c  particle variables:
c     i ............. particle number
c     idptl(i) ...... particle id
c     pptl(1,i) ..... x-component of particle momentum
c     pptl(2,i) ..... y-component of particle momentum
c     pptl(3,i) ..... z-component of particle momentum
c     pptl(4,i) ..... particle energy
c     pptl(5,i) ..... particle mass

#if !__INTTEST__
C  ELIMINATE TARGET SPECTATORS
        IF ( PPTL(3,I) .LT. 0.1D0 ) GOTO 5

C  ELIMINATE BACKWARD GOING PARTICLES
        IF ( .NOT. LLONGI  .AND.  PPTL(3,I) .LT. 0. ) GOTO 5
#endif
C  CONVERT PARTICLE CODE  NEX(US) ---> C(O)RS(IKA)
C  MOST FREQUENT PARTICLES COME FIRST
        KODNEX = idptl(I)

        IF ( ABS(KODNEX).GT.100 .AND. ABS(KODNEX).LT.340 ) THEN
C  MESONS, ALSO WITH STRANGENESS
C  MESONS
          IF     ( KODNEX .EQ.   111 ) THEN    ! PI(0)
            KODCRS =  7
          ELSEIF ( KODNEX .EQ.   211 ) THEN    ! PI(+)
            KODCRS =  8
          ELSEIF ( KODNEX .EQ.  -211 ) THEN    ! PI(-)
            KODCRS =  9
          ELSEIF ( KODNEX .EQ.   221 ) THEN    ! ETA
            KODCRS = 17
C  STRANGE MESONS
          ELSEIF ( KODNEX .EQ.   130 ) THEN    ! K0L
            KODCRS = 10
          ELSEIF ( KODNEX .EQ.   321 ) THEN    ! K(+)
            KODCRS = 11
          ELSEIF ( KODNEX .EQ.  -321 ) THEN    ! K(-)
            KODCRS = 12
          ELSEIF ( KODNEX .EQ.   310 ) THEN    ! K0S
            KODCRS = 16
          ELSEIF ( KODNEX .EQ.   311  .OR.     ! K(0)
     *             KODNEX .EQ.  -311 ) THEN    ! ANTI-K(0)
            CALL RMMARD( RD,1,1 )
            IF ( RD(1) .GE. 0.5D0 ) THEN
              KODCRS = 10                        ! K0L
            ELSE
              KODCRS = 16                        ! K0S
            ENDIF
          ENDIF

        ELSEIF ( ABS(KODNEX).GT.1000 .AND. ABS(KODNEX).LT.3400 )THEN
C  BARYONS, ALSO WITH STRANGENESS
C  NUCLEAONS
          IF     ( KODNEX .EQ.  2112 ) THEN    ! N
            KODCRS = 13
          ELSEIF ( KODNEX .EQ.  2212 ) THEN    ! P
            KODCRS = 14
          ELSEIF ( KODNEX .EQ. -2212 ) THEN    ! ANTI-P
            KODCRS = 15
          ELSEIF ( KODNEX .EQ. -2112 ) THEN    ! ANTI-N
            KODCRS = 25
C  STRANGE BARYONS
          ELSEIF ( KODNEX .EQ.  3122 ) THEN    ! LAMBDA
            KODCRS = 18
          ELSEIF ( KODNEX .EQ.  3222 ) THEN    ! SIGMA(+)
            KODCRS = 19
          ELSEIF ( KODNEX .EQ.  3212 ) THEN    ! SIGMA(0)
            KODCRS = 20
          ELSEIF ( KODNEX .EQ.  3112 ) THEN    ! SIGMA(-)
            KODCRS = 21
          ELSEIF ( KODNEX .EQ.  3322 ) THEN    ! XI(0)
            KODCRS = 22
          ELSEIF ( KODNEX .EQ.  3312 ) THEN    ! XI(-)
            KODCRS = 23
          ELSEIF ( KODNEX .EQ.  3334 ) THEN    ! OMEGA(-)
            KODCRS = 24
          ELSEIF ( KODNEX .EQ. -3122 ) THEN    ! ANTI_LAMBDA
            KODCRS = 26
          ELSEIF ( KODNEX .EQ. -3222 ) THEN    ! ANTI-SIGMA(-)
            KODCRS = 27
          ELSEIF ( KODNEX .EQ. -3212 ) THEN    ! ANTI-SIGMA(0)
            KODCRS = 28
          ELSEIF ( KODNEX .EQ. -3112 ) THEN    ! ANTI-SIGMA(+)
            KODCRS = 29
          ELSEIF ( KODNEX .EQ. -3322 ) THEN    ! ANTI-XI(0)
            KODCRS = 30
          ELSEIF ( KODNEX .EQ. -3312 ) THEN    ! ANTI-XI(+)
            KODCRS = 31
          ELSEIF ( KODNEX .EQ. -3334 ) THEN    ! ANTI-OMEGA(+)
            KODCRS = 32
          ENDIF

        ELSEIF ( ABS(KODNEX) .LE. 22 )THEN
C  GAMMAS, LEPTONS AND NEUTRINOS
          IF     ( KODNEX .EQ.    22 ) THEN    ! GAMMA
            KODCRS =  1
C  LEPTONS
          ELSEIF ( KODNEX .EQ.   -11 ) THEN    ! E(+)
            KODCRS =  2
          ELSEIF ( KODNEX .EQ.    11 ) THEN    ! E(-)
            KODCRS =  3
          ELSEIF ( KODNEX .EQ.   -13 ) THEN    ! MU(+)
            KODCRS =  5
          ELSEIF ( KODNEX .EQ.    13 ) THEN    ! MU(-)
            KODCRS =  6
#if __CHARM__ || __TAULEP__
C  TAU LEPTONS
          ELSEIF ( KODNEX .EQ.   -15 ) THEN    ! TAU(+)
            KODCRS = 131
          ELSEIF ( KODNEX .EQ.    15 ) THEN    ! TAU(-)
            KODCRS = 132
#else
C  TAU LEPTONS CANNOT BE TREATED, TAKE INSTEAD MUONS
          ELSEIF ( KODNEX .EQ.   -15 ) THEN    ! TAU(+)
            KODCRS = 5                           ! BECOMES MU(+)
          ELSEIF ( KODNEX .EQ.    15 ) THEN    ! TAU(-)
            KODCRS = 6                           ! BECOMES MU(-)
#endif
#if __NEUTRINO__
C  NEUTRINOS
          ELSEIF ( KODNEX .EQ.    12 ) THEN    ! NU_E
            KODCRS = 66
          ELSEIF ( KODNEX .EQ.   -12 ) THEN    ! ANTI-NU_E
            KODCRS = 67
          ELSEIF ( KODNEX .EQ.    14 ) THEN    ! NU_MU
            KODCRS = 68
          ELSEIF ( KODNEX .EQ.   -14 ) THEN    ! ANTI-NU_MU
            KODCRS = 69
C  TAU NEUTRINOS
#if __CHARM__ || __TAULEP__
          ELSEIF ( KODNEX .EQ.    16 ) THEN    ! NU_TAU
            KODCRS = 133
          ELSEIF ( KODNEX .EQ.   -16 ) THEN    ! ANTI-NU_TAU
            KODCRS = 134
#else
          ELSEIF ( KODNEX .EQ.    16 ) THEN    ! NU_TAU
            KODCRS = 68                          ! BECOMES NU_MU
          ELSEIF ( KODNEX .EQ.   -16 ) THEN    ! ANTI-NU_TAU
            KODCRS = 69                          ! BECOMES ANTI-NU_MU
#endif
#else
C  NEUTRINOS ARE SKIPPED
          ELSEIF ( KODNEX .EQ.    12 ) THEN    ! NU_E
            GOTO 55
          ELSEIF ( KODNEX .EQ.   -12 ) THEN    ! ANTI-NU_E
            GOTO 55
          ELSEIF ( KODNEX .EQ.    14 ) THEN    ! NU_MU
            GOTO 55
          ELSEIF ( KODNEX .EQ.   -14 ) THEN    ! ANTI-NU_MU
            GOTO 55
C  TAU NEUTRINOS
          ELSEIF ( KODNEX .EQ.    16 ) THEN    ! NU_TAU
            GOTO 55
          ELSEIF ( KODNEX .EQ.   -16 ) THEN    ! ANTI-NU_TAU
            GOTO 55
#endif
          ENDIF

        ELSEIF ( ABS(KODNEX).GT.400 .AND. ABS(KODNEX).LT.450 ) THEN
C  CHARMED MESONS
#if __CHARM__
          IF     ( KODNEX .EQ.   421 ) THEN    ! D(0)
            KODCRS = 116
          ELSEIF ( KODNEX .EQ.   411 ) THEN    ! D(+)
            KODCRS = 117
          ELSEIF ( KODNEX .EQ.  -411 ) THEN    ! D(-)
            KODCRS = 118
          ELSEIF ( KODNEX .EQ.  -421 ) THEN    ! ANTI-D(0)
            KODCRS = 119
C  CHARMED MESONS WITH STRANGENESS
          ELSEIF ( KODNEX .EQ.   431 ) THEN    ! D_S(+)
            KODCRS = 120
          ELSEIF ( KODNEX .EQ.  -431 ) THEN    ! D_S(-)
            KODCRS = 121
C  CHARMED ETA MESON
          ELSEIF ( KODNEX .EQ.   441  .OR.     ! ETA_C
     *             KODNEX .EQ.  -441 ) THEN
            KODCRS = 122
C  EXCITED CHARMED MESONS
          ELSEIF ( KODNEX .EQ.   423 ) THEN    ! D*(0)
            KODCRS = 123
          ELSEIF ( KODNEX .EQ.   413 ) THEN    ! D*(+)
            KODCRS = 124
          ELSEIF ( KODNEX .EQ.  -413 ) THEN    ! D*(-)
            KODCRS = 125
          ELSEIF ( KODNEX .EQ.  -423 ) THEN    ! ANTI-D*(0)
            KODCRS = 126
          ELSEIF ( KODNEX .EQ.   433 ) THEN    ! D_S*(+)
            KODCRS = 127
          ELSEIF ( KODNEX .EQ.  -433 ) THEN    ! D_S*(-)
            KODCRS = 128
          ELSEIF ( KODNEX .EQ.   443   .OR.    ! J/PSI
     *             KODNEX .EQ.  -443 ) THEN
            KODCRS = 130
#else
C  CHARMED MESONS CANNOT BE TREATED, TAKE INSTEAD STRANGE MESONS
          IF     ( KODNEX .EQ.   421 ) THEN    ! D(0)
            KODCRS = 11                          ! BECOMES K(+)
          ELSEIF ( KODNEX .EQ.   411  .OR.     ! D(+)
     *             KODNEX .EQ.  -411 ) THEN    ! D(-)
            CALL RMMARD( RD,1,1 )
            IF ( RD(1) .GE. 0.5D0 ) THEN
              KODCRS = 10                        ! BECOMES K0L
            ELSE
              KODCRD = 16                        ! BECOMES KOS
            ENDIF
          ELSEIF ( KODNEX .EQ.  -421 ) THEN    ! ANTI-D(0)
            KODCRS = 12                          ! BECOMES K(-)
C  CHARMED MESONS WITH STRANGENESS
          ELSEIF ( KODNEX .EQ.   431  .OR.     ! D_S((+)
     *             KODNEX .EQ.  -431 ) THEN    ! ANTI-D_S(-)
            CALL RMMARD( RD,1,1 )
            IF ( RD(1) .GE. 0.5D0 ) THEN
              KODCRS = 10                        ! BECOMES K0L
            ELSE
              KODCRD = 16                        ! BECOMES KOS
            ENDIF
C  CHARMED ETA MESON
          ELSEIF ( KODNEX .EQ.   441  .OR.     ! ETA_C
     *             KODNEX .EQ.  -441 ) THEN
            KODCRS = 17                          ! BECOMES ETA
C  EXCITED CHARMED MESONS
          ELSEIF ( KODNEX .EQ.   423 ) THEN    ! D*(0)
            KODCRS = 11                          ! BECOMES K(+)
          ELSEIF ( KODNEX .EQ.   413   .OR.    ! D*(+)
     *             KODNEX .EQ.  -413   .OR.    ! ANTI-D*(-)
     *             KODNEX .EQ.   433   .OR.    ! D_S*(+)
     *             KODNEX .EQ.  -433 ) THEN    ! ANTI D_S*(-)
            CALL RMMARD( RD,1,1 )
            IF ( RD(1) .GE. 0.5D0 ) THEN
              KODCRS = 10                        ! BECOMES K0L
            ELSE
              KODCRD = 16                        ! BECOMES K0S
            ENDIF
          ELSEIF ( KODNEX .EQ.  -423 ) THEN    ! ANTI-D*(0)
            KODCRS = 12                          ! BECOMES K(-)
          ELSEIF ( KODNEX .EQ.   443   .OR.    ! J/PSI
     *             KODNEX .EQ.  -443 ) THEN
            KODCRS = 17                          ! BECOMES ETA
#endif
          ENDIF

        ELSEIF ( ABS(KODNEX).GT.4000 .AND. ABS(KODNEX).LT.4500 )THEN
C  BARYONS WITH CHARM
#if __CHARM__
          IF     ( KODNEX .EQ.  4122 ) THEN    ! LAMBDA_C(+)
            KODCRS = 137
          ELSEIF ( KODNEX .EQ.  4232 ) THEN    ! XI_C(+)
            KODCRS = 138
          ELSEIF ( KODNEX .EQ.  4132 ) THEN    ! XI_C(0)
            KODCRS = 139
          ELSEIF ( KODNEX .EQ.  4222 ) THEN    ! SIGMA_C(++)
            KODCRS = 140
          ELSEIF ( KODNEX .EQ.  4212 ) THEN    ! SIGMA_C(+)
            KODCRS = 141
          ELSEIF ( KODNEX .EQ.  4112 ) THEN    ! SIGMA_C(0)
            KODCRS = 142
          ELSEIF ( KODNEX .EQ.  4322 ) THEN    ! XI_C'(+)            '
            KODCRS = 143
          ELSEIF ( KODNEX .EQ.  4312 ) THEN    ! XI_C'(0)            '
            KODCRS = 144
          ELSEIF ( KODNEX .EQ.  4332 ) THEN    ! OMEGA_C(0)
            KODCRS = 145
          ELSEIF ( KODNEX .EQ. -4122 ) THEN    ! ANTI-LAMBDA_C(-)
            KODCRS = 149
          ELSEIF ( KODNEX .EQ. -4232 ) THEN    ! ANTI-XI_C(-)
            KODCRS = 150
          ELSEIF ( KODNEX .EQ. -4132 ) THEN    ! ANTI-XI-C(0)
            KODCRS = 151
          ELSEIF ( KODNEX .EQ. -4222 ) THEN    ! ANTI-SIGMA_C(--)
            KODCRS = 152
          ELSEIF ( KODNEX .EQ. -4212 ) THEN    ! ANTI-SIGMA_C(-)
            KODCRS = 153
          ELSEIF ( KODNEX .EQ. -4112 ) THEN    ! ANTI-SIGMA_C(0)
            KODCRS = 154
          ELSEIF ( KODNEX .EQ. -4322 ) THEN    ! ANTI-XI_C'(-)       '
            KODCRS = 155
          ELSEIF ( KODNEX .EQ. -4312 ) THEN    ! ANTI-XI_C'(0)       '
            KODCRS = 156
          ELSEIF ( KODNEX .EQ. -4332 ) THEN    ! ANTI-OMEGA_C(0)
            KODCRS = 157
C  EXCITED CHARMED BARYONS
          ELSEIF ( KODNEX .EQ.  4224 ) THEN    ! SIGMA_C*(++)
            KODCRS = 161
          ELSEIF ( KODNEX .EQ.  4214 ) THEN    ! SIGMA_C*(+)
            KODCRS = 162
          ELSEIF ( KODNEX .EQ.  4114 ) THEN    ! SIGMA_C*(0)
            KODCRS = 163
          ELSEIF ( KODNEX .EQ. -4224 ) THEN    ! ANTI-SIGMA_C*(--)
            KODCRS = 171
          ELSEIF ( KODNEX .EQ. -4214 ) THEN    ! ANTI-SIGMA_C*(-)
            KODCRS = 172
          ELSEIF ( KODNEX .EQ. -4114 ) THEN    ! ANTI-SIGMA_C*(0)
            KODCRS = 173
C  DOUBLE CHARMED BARYONS CANNOT BE TREATED, TAKE CHARMED STRANGE BARYS
          ELSEIF ( KODNEX .EQ.  4422 ) THEN    ! XI_CC(++)
            KODCRS = 143                         ! BECOMES XI_C'(+)    '
          ELSEIF ( KODNEX .EQ.  4412 ) THEN    ! XI_CC(+)
            KODCRS = 144                         ! BECOMES XI_C'(0)    '
          ELSEIF ( KODNEX .EQ.  4432 ) THEN    ! OMEGA_CC(+)
            KODCRS = 145                         ! BECOMES OMEGA_C(0)
          ELSEIF ( KODNEX .EQ. -4422 ) THEN    ! ANTI-XI_CC(--)
            KODCRS = 150                         ! BECOMES ANTI-XI_C(-)
          ELSEIF ( KODNEX .EQ. -4412 ) THEN    ! ANTI-XI_CC(-)
            KODCRS = 156                       ! BECOMES ANTI-XI_C'(0) '
          ELSEIF ( KODNEX .EQ. -4432 ) THEN    ! ANTI-OMEGA_CC(-)
            KODCRS = 157                       ! BECOMES ANTI-OMEGA_C(0)
C  TRIPLE CHARMED BARYONS CANNOT BE TREATED, TAKE CHARMED STRANGE BARYS
          ELSEIF ( KODNEX .EQ.  4444 ) THEN    ! OMEGA_CCC(++)
            KODCRS = 145                         ! BECOMES OMEGA_C(0)
          ELSEIF ( KODNEX .EQ. -4444 ) THEN    ! ANTI-OMEGA_CCC(--)
            KODCRS = 157                       ! BECOMES ANTI-OMEGA_C(0)
#else
C  CHARMED BARYONS CANNOT BE TREATED, TAKE INSTEAD STRANGE BARYONS
          IF     ( KODNEX .EQ.  4122 ) THEN    ! LAMBDA_C(+)
            KODCRS = 18                          ! BECOMES LAMBDA
          ELSEIF ( KODNEX .EQ.  4232 ) THEN    ! XI_C(+)
            KODCRS = 22                          ! BECOMES XI(0)
          ELSEIF ( KODNEX .EQ.  4132 ) THEN    ! XI_C(0)
            KODCRS = 23                          ! BECOMES XI(-)
          ELSEIF ( KODNEX .EQ.  4222 ) THEN    ! SIGMA_C(++)
            KODCRS = 19                          ! BECOMES SIGMA(+)
          ELSEIF ( KODNEX .EQ.  4212 ) THEN    ! SIGMA_C(+)
            KODCRS = 20                          ! BECOMES SIGMA(0)
          ELSEIF ( KODNEX .EQ.  4112 ) THEN    ! SIGMA_C(0)
            KODCRS = 21                          ! BECOMES SIGMA(-)
          ELSEIF ( KODNEX .EQ.  4322 ) THEN    ! XI_C'(+)            '
            KODCRS = 22                          ! BECOMES XI(0)
          ELSEIF ( KODNEX .EQ.  4312 ) THEN    ! XI_C'(0)            '
            KODCRS = 23                          ! BECOMES XI(-)
          ELSEIF ( KODNEX .EQ.  4332 ) THEN    ! OMEGA_C(0)
            KODCRS = 24                          ! BECOMES OMEGA(-)
          ELSEIF ( KODNEX .EQ. -4122 ) THEN    ! ANTI-LAMBDA_C(-)
            KODCRS = 26                          ! BECOMES ANTI-LAMBDA
          ELSEIF ( KODNEX .EQ. -4232 ) THEN    ! ANTI-XI_C(-)
            KODCRS = 30                          ! BECOMES ANTI-XI(0)
          ELSEIF ( KODNEX .EQ. -4132 ) THEN    ! ANTI-XI-C(0)
            KODCRS = 31                          ! BECOMES ANTI-XI(+)
          ELSEIF ( KODNEX .EQ. -4222 ) THEN    ! ANTI-SIGMA_C(--)
            KODCRS = 27                          ! BECOMES ANTI-SIGMA(-)
          ELSEIF ( KODNEX .EQ. -4212 ) THEN    ! ANTI-SIGMA_C(-)
            KODCRS = 28                          ! BECOMES ANTI-SIGMA(0)
          ELSEIF ( KODNEX .EQ. -4112 ) THEN    ! ANTI-SIGMA_C(0)
            KODCRS = 29                          ! BECOMES ANTI-SIGMA(+)
          ELSEIF ( KODNEX .EQ. -4322 ) THEN    ! ANTI-XI_C'(-)       '
            KODCRS = 30                          ! BECOMES ANTI-XI(0)
          ELSEIF ( KODNEX .EQ. -4312 ) THEN    ! ANTI-XI_C'(0)       '
            KODCRS = 31                          ! BECOMES ANTI-XI(+)
          ELSEIF ( KODNEX .EQ. -4332 ) THEN    ! ANTI-OMEGA_C(0)
            KODCRS = 32                          ! BECOMES ANTI-OMEGA(+)
C  EXCITED CHARMED BARYONS CANNOT BE TREATED, TAKE STRANGE BARYONS
          ELSEIF ( KODNEX .EQ.  4224 ) THEN    ! SIGMA_C*(++)
            KODCRS = 19                          ! BECOMES SIGMA(+)
          ELSEIF ( KODNEX .EQ.  4214 ) THEN    ! SIGMA_C*(+)
            KODCRS = 20                          ! BECOMES SIGMA(0)
          ELSEIF ( KODNEX .EQ.  4114 ) THEN    ! SIGMA_C*(0)
            KODCRS = 21                          ! BECOMES SIGMA(-)
          ELSEIF ( KODNEX .EQ. -4224 ) THEN    ! ANTI-SIGMA_C*(--)
            KODCRS = 27                          ! BECOMES ANTI-SIGMA(-)
          ELSEIF ( KODNEX .EQ. -4214 ) THEN    ! ANTI-SIGMA_C*(-)
            KODCRS = 28                          ! BECOMES ANTI-SIGMA(0)
          ELSEIF ( KODNEX .EQ. -4114 ) THEN    ! ANTI-SIGMA_C*(0)
            KODCRS = 29                          ! BECOMES ANTI-SIGMA(+)
C  DOUBLE CHARMED BARYONS CANNOT BE TREATED, TAKE STRANGE BARYS
          ELSEIF ( KODNEX .EQ.  4422 ) THEN    ! XI_CC(++)
            KODCRS = 22                          ! BECOMES XI(0)
          ELSEIF ( KODNEX .EQ.  4412 ) THEN    ! XI_CC(+)
            KODCRS = 23                          ! BECOMES XI(-)
          ELSEIF ( KODNEX .EQ.  4432 ) THEN    ! OMEGA_CC(+)
            KODCRS = 24                          ! BECOMES OMEGA(-)
          ELSEIF ( KODNEX .EQ. -4422 ) THEN    ! ANTI-XI_CC(--)
            KODCRS = 30                          ! BECOMES ANTI-XI(0)
          ELSEIF ( KODNEX .EQ. -4412 ) THEN    ! ANTI-XI_CC(-)
            KODCRS = 31                          ! BECOMES ANTI-XI(+)
          ELSEIF ( KODNEX .EQ. -4432 ) THEN    ! ANTI-OMEGA_CC(-)
            KODCRS = 32                          ! BECOMES ANTI-OMEGA(+)
C  TRIPLE CHARMED BARYONS CANNOT BE TREATED, TAKE STRANGE BARYS
          ELSEIF ( KODNEX .EQ.  4444 ) THEN    ! OMEGA_CCC*(++)
            KODCRS = 24                          ! BECOMES OMEGA(-)
          ELSEIF ( KODNEX .EQ. -4444 ) THEN    ! ANTI-OMEGA_CCC*(--)
            KODCRS = 32                          ! BECOMES ANTI-OMEGA(+)
#endif
          ENDIF
C  PROJECTILE FRAGMENT NUCLEUS
        ! ELSEIF ( KODNEX .EQ. 80000 ) THEN
        !   KODCRS = IDRES(J) * 100 + IDXRES(J)

        ELSE
          WRITE(MONIOU,*) 'HydroStore: UNKNOWN PARTICLE CODE=',KODNEX
          STOP
        ENDIF          
        SECPAR(0) = KODCRS

C  ELIMINATE BACKWARD GOING PARTICLES
        IF ( LLONGI  .AND.  PPTL(3,I) .LT. 0. ) GOTO 56

        IF ( ( KODCRS .NE. 1  .AND.  KODCRS .LE. 65 ) 
     *       .OR. KODCRS .GE. 100 ) THEN
C  ORDINARY SECONDARY PARTICLES
          SECPAR(1) = PPTL(4,I)/PAMA(KODCRS)
C  LOOK FOR SPECTATOR NUCLEONS
          IF ( KODCRS .EQ. 13  .OR.  KODCRS .EQ. 14 .AND. nspec .gt. 0
     &      ) THEN

C  COMPOSE PROJECTILE SPECTATORS TO REMAINING NUCLEUS
                nspec=nspec-1
                IF     ( KODCRS .EQ. 14 ) THEN
                  INEW  = INEW + 101
                  IREST = IREST - 101
                ELSEIF ( KODCRS .EQ. 13 ) THEN
                  INEW  = INEW + 100
                  IREST = IREST - 100
                ENDIF
#if !__INTTEST__
                GOTO 5
#endif
C  DISREGARD PROJECTILE SPECTATORS FOR ELASTICITY
                GOTO 7
            ! ENDIF
          ENDIF

CC        IF ( SECPAR(1) .GT. GAMMAX ) THEN
CC          GAMMAX = SECPAR(1)
C  CALCULATE ELASTICITY FROM ENERGY OF FASTEST PARTICLE (LEADER)
CC          ELASTI = GAMMAX * PAMA(KODCRS) / ELABN
CC        ENDIF
          IF ( PPTL(4,I) .GT. EMAX ) THEN
            EMAX = PPTL(4,I)
C  CALCULATE ELASTICITY FROM MOST ENERGETIC PARTICLE (LEADER)
C  REGARD: ELABN IS ENERGY/NUCLEON
cdh         ELASTI = EMAX * maproj / ELABN
            ELASTI = EMAX / ELABN
          ENDIF
        ELSE
C  GAMMAS AND NEUTRINOS
          SECPAR(1) = PPTL(4,I)
        ENDIF

C  COUNTER FOR ENERGY-MULTIPLICITY MATRIX
        MSMM = MSMM + 1

C  DETERMINE ANGLES FROM LONGITUDINAL AND TRANSVERSAL MOMENTA
 7      CONTINUE
        PT2 = DBLE(PPTL(1,I))**2 + DBLE(PPTL(2,I))**2
        PL2 = DBLE(PPTL(3,I))**2
        IF ( PL2+PT2 .LE. 0.D0 ) THEN
          PTOT   = 0.D0
          COSTET = 0.D0
          CPHIV  = 1.D0
          SPHIV  = 0.D0
        ELSE
          PTOT   = SQRT( PL2 + PT2 )
          COSTET = DBLE(PPTL(3,I)) / PTOT
          COSTET = MAX( MIN(COSTET, 1.D0), -1.D0 )
          CPHIV  = DBLE(PPTL(1,I)) / PTOT
          SPHIV  = DBLE(PPTL(2,I)) / PTOT
        ENDIF

#if __INTTEST__
C       IF ( COSTET .EQ. 0.D0 ) COSTET = 1.D-4
        SECPAR(17) = SQRT( PPTL(1,I)**2 + PPTL(2,I)**2 )

#endif
C  COUNTERS FOR FIRST INTERACTION
        IF ( FIRSTI ) THEN
          IF     ( SECPAR(0) .EQ.  7.D0  .OR. SECPAR(0) .EQ.  8.D0
     *       .OR.  SECPAR(0) .EQ.  9.D0                           ) THEN
            IFINPI = IFINPI + 1
          ELSEIF ( SECPAR(0) .EQ. 13.D0  .OR. SECPAR(0) .EQ. 14.D0
     *       .OR.  SECPAR(0) .EQ. 15.D0  .OR. SECPAR(0) .EQ. 25.D0) THEN
            IFINNU = IFINNU + 1
          ELSEIF ( SECPAR(0) .EQ. 10.D0  .OR. SECPAR(0) .EQ. 11.D0
     *       .OR.  SECPAR(0) .EQ. 12.D0  .OR. SECPAR(0) .EQ. 16.D0) THEN
            IFINKA = IFINKA + 1
          ELSEIF ( SECPAR(0) .EQ. 17.D0                           ) THEN
            IFINET = IFINET + 1
          ELSEIF ((SECPAR(0) .GE. 18.D0 .AND. SECPAR(0) .LE. 24.D0)
     *       .OR. (SECPAR(0) .GE. 26.D0 .AND. SECPAR(0) .LE. 32.D0))THEN
            IFINHY = IFINHY + 1
          ELSEIF ( SECPAR(0) .GE. 51.D0 .AND. SECPAR(0) .LE. 53.D0) THEN
            IFINRHO = IFINRHO + 1
#if __CHARM__
          ELSEIF ((SECPAR(0).GE.116.D0  .AND. SECPAR(0).LE.130.D0)  .OR.
     *            (SECPAR(0).GE.137.D0  .AND. SECPAR(0).LE.173.D0)) THEN
            IFINCM = IFINCM + 1
#endif
          ELSE
            IFINOT = IFINOT + 1
          ENDIF
        ENDIF

        ETOT = ETOT + PPTL(4,I)
        CALL ADDANG4( COSTHE,PHIX,PHIY, COSTET,CPHIV,SPHIV,
     *                                 SECPAR(2),SECPAR(3),SECPAR(4) )
#if __UPWARD__
        IF ( SECPAR(2) .GE. C(29) ) THEN
#else
        IF ( SECPAR(2) .GT. C(29) ) THEN
#endif
#if __EHISTORY__
C  COPY PARTICLE INFORMATION, LATER TO BECOME MOTHER PARTICLE
          DO  IK = 0, 8
            SECPAR(IK+17) = SECPAR(IK)
          ENDDO
#if __THIN__
          SECPAR(26) = SECPAR(13)
#endif
#endif
          CALL TSTACK
          GOTO 5
        ELSE
          GOTO 56
        ENDIF

#if !__NEUTRINO__
 55     IF ( LLONGI ) THEN
C  ADD NEUTRINO ENERGY TO LONGITUDINAL ENERGY DEPOSIT
#if __THIN__
          DLONG(LHEIGH,8) = DLONG(LHEIGH,8) + PPTL(4,I) * WEIGHT
#else
          DLONG(LHEIGH,8) = DLONG(LHEIGH,8) + PPTL(4,I)
#endif
        ENDIF
        GOTO 5

#endif
 56     IF ( LLONGI ) THEN
C  ADD ENERGY TO LONGITUDINAL ENERGY DEPOSIT
          IF     ( KODCRS .LE.  3                        ) THEN
#if __THIN__
            DLONG(LHEIGH,13) = DLONG(LHEIGH,13)
     *                       + (PPTL(4,I) - RESTMS(KODCRS) ) * WEIGHT
          ELSEIF ( KODCRS .EQ.  5  .OR.   KODCRS .EQ.  6 ) THEN
            DLONG(LHEIGH,15) = DLONG(LHEIGH,15) + PPTL(4,I) * WEIGHT
#if __NEUTRINO__
          ELSEIF ( ( KODCRS .GE. 66  .AND.  KODCRS .LE. 69 )
#if __CHARM__ || __TAULEP__
     *        .OR.  KODCRS .EQ. 133  .OR.  KODCRS .EQ. 134
#endif
     *                                                     ) THEN
            DLONG(LHEIGH,18) = DLONG(LHEIGH,18) + PPTL(4,I) * WEIGHT
#endif
          ELSE
            IF     ( KODCRS .EQ.  8  .OR.  KODCRS .EQ.  9  .OR.
     *               KODCRS .EQ. 11  .OR.  KODCRS .EQ. 12 ) THEN
              FAC1 = 0.25D0
              FAC2 = 0.75D0
            ELSEIF ( KODCRS .EQ. 10  .OR.  KODCRS .EQ. 16 ) THEN
              FAC1 = 0.5D0
              FAC2 = 0.5D0
            ELSE
              FAC1 = 1.D0
              FAC2 = 0.D0
            ENDIF
C  ADD TO THE HADRON ENERGY DEPOSIT
            DLONG(LHEIGH,17) = DLONG(LHEIGH,17)
     *                   + (PPTL(4,I)-RESTMS(KODCRS) )*WEIGHT*FAC1
C  ADD TO THE NEUTRINO DEPOSIT
            DLONG(LHEIGH,18) = DLONG(LHEIGH,18)
     *                   + (PPTL(4,I)-RESTMS(KODCRS) )*WEIGHT*FAC2
#else
            DLONG(LHEIGH,13) = DLONG(LHEIGH,13) + PPTL(4,I)
     *                                          - RESTMS(KODCRS)
          ELSEIF ( KODCRS .EQ.  5  .OR.   KODCRS .EQ.  6 ) THEN
            DLONG(LHEIGH,15) = DLONG(LHEIGH,15) + PPTL(4,I)
#if __NEUTRINO__
          ELSEIF ( ( KODCRS .GE. 66  .AND.  KODCRS .LE. 69 )
#if __CHARM__ || __TAULEP__
     *        .OR.  KODCRS .EQ. 133  .OR.  KODCRS .EQ. 134
#endif
     *                                                     ) THEN
            DLONG(LHEIGH,18) = DLONG(LHEIGH,18) + PPTL(4,I)
#endif
          ELSE
            IF     ( KODCRS .EQ.  8  .OR.  KODCRS .EQ.  9  .OR.
     *               KODCRS .EQ. 11  .OR.  KODCRS .EQ. 12 ) THEN
              FAC1 = 0.25D0
              FAC2 = 0.75D0
            ELSEIF ( KODCRS .EQ. 10  .OR.  KODCRS .EQ. 16 ) THEN
              FAC1 = 0.5D0
              FAC2 = 0.5D0
            ELSE
              FAC1 = 1.D0
              FAC2 = 0.D0
            ENDIF
C  ADD TO THE HADRON ENERGY DEPOSIT
            DLONG(LHEIGH,17) = DLONG(LHEIGH,17)
     *                         + (PPTL(4,I)-RESTMS(KODCRS) )*FAC1
C  ADD TO THE NEUTRINO DEPOSIT
            DLONG(LHEIGH,18) = DLONG(LHEIGH,18)
     *                         + (PPTL(4,I)-RESTMS(KODCRS) )*FAC2
#endif
          ENDIF
        ENDIF
#if __AUGERHIST__
        THICKLOC = THICK( H )
        DO  LL = 1, NOBSLV
          IF     ( THICKLOC .GE. THCKOB(LL)  .AND.
     *             THICKLOC .LT. THCKOB(LL)+SAMPTH ) THEN
C  THICKH IS WITHIN 1 G/CM^2 BELOW OBSLEV(LL)
C  BRING THE ENERGY BELOW ANGULAR CUT TO THE HISTO OF LEVEL LL
            OUTPAR(0) = KODCRS
            IF     ( KODCRS .EQ. 1 ) THEN
              OUTPAR(1) = PPTL(4,I)
              EDEP = OUTPAR(1) * WEIGHT
            ELSEIF ( KODCRS .EQ. 2   .OR.  KODCRS .EQ. 3 ) THEN
              OUTPAR(1) = PPTL(4,I)
              EDEP = ( PPTL(4,I) - RESTMS(KODCRS) ) * WEIGHT
            ELSE
              OUTPAR(1) = PPTL(4,I) / PAMA(KODCRS)
              EDEP = ( PPTL(4,I) - RESTMS(KODCRS) ) * WEIGHT
            ENDIF
            DO  II = 2, 8
              OUTPAR(II) = SECPAR(II)
            ENDDO
            OUTPAR( 9) = GEN
            OUTPAR(10) = ALEVEL
            OUTPAR(13) = WEIGHT
C  WE HAVE ANGULAR CUT
            CALL AUGERDEPFIL( EDEP,LL,1 )
          ELSEIF ( THICKLOC .LT. THCKOB(LL) ) THEN
            GOTO 111
          ENDIF
        ENDDO
 111    CONTINUE

#endif
 5    CONTINUE

      IF ( DEBUG ) WRITE(MDEBUG,*) 'HydroStore:,ETOT =',ETOT

      IF ( NFRAGM .NE. 0  .AND.  INEW .GT. 0 ) THEN
C  TREAT REMAINING NUCLEUS
        IF ( DEBUG ) WRITE(MDEBUG,150) INEW,(CURPAR(I),I=1,8)
 150    FORMAT(' HydroStore: REMNNT=',1P,I10,8E10.3)
        SECPAR(1)  = CURPAR(1)
        SECPAR(2)  = CURPAR(2)
        SECPAR(3)  = CURPAR(3)
        SECPAR(4)  = CURPAR(4)
#if __INTTEST__
        SECPAR(17) = CURPAR(17)
#endif

        IF     ( INEW .EQ. 100 ) THEN
C  REMAINING NUCLEUS IS SINGLE NEUTRON
          SECPAR(0) = 13.D0
#if __EHISTORY__
C  COPY PARTICLE INFORMATION, LATER TO BECOME MOTHER PARTICLE
          DO  IK = 0, 8
            SECPAR(IK+17) = SECPAR(IK)
          ENDDO
#if __THIN__
          SECPAR(26) = SECPAR(13)
#endif
#endif
          CALL TSTACK
          ETOT = ETOT + SECPAR(1) * PAMA(13)
          GOTO 140

        ELSEIF ( INEW .EQ. 101 ) THEN
C  REMAINING NUCLEUS IS SINGLE PROTON
          SECPAR(0) = 14.D0
#if __EHISTORY__
C  COPY PARTICLE INFORMATION, LATER TO BECOME MOTHER PARTICLE
          DO  IK = 0, 8
            SECPAR(IK+17) = SECPAR(IK)
          ENDDO
#if __THIN__
          SECPAR(26) = SECPAR(13)
#endif
#endif
          CALL TSTACK
          ETOT = ETOT + SECPAR(1) * PAMA(14)
          GOTO 140

        ELSEIF ( NFRAGM .GE. 2 ) THEN
C  REMAINING NUCLEUS IS EVAPORATING NUCLEONS AND ALPHA PARTICLES
          NZNEW = MOD(INEW,100)
          NNNEW = INEW/100 - NZNEW
          JFIN  = 0
          CALL VAPOR( MAPROJ,INEW,JFIN,ITYP,PFRX,PFRY )
          IF ( JFIN .EQ. 0 ) GOTO 139
C  LOOP TO TREAT THE REMANENTS OF THE DESINTEGRATED FRAGMENT
          KNEW = 0
          DO  135  J = 1, JFIN
            EA = GAMMA * PAMA(ITYP(J))
            IF (DEBUG) WRITE(MDEBUG,*) 'HydroStore: J,ITYP,EA=',
     *                                       J,ITYP(J),EA
C  MOMENTA SQUARED
            PTM = ( EA - PAMA(ITYP(J)) ) * ( EA + PAMA(ITYP(J)) )
            PT2 = PFRX(J)**2 + PFRY(J)**2
            IF ( PT2 .GE. PTM ) THEN
              IF (DEBUG) WRITE(MDEBUG,*)
     &          'HydroStore: PT REJECT PARTICLE',J
              GOTO 135
            ENDIF
            IF ( PTM .GT. 0.D0 ) THEN
              PTOT   = SQRT( PTM )
              COSTET = SQRT( 1.D0 - PT2/PTM )
              CPHIV  = PFRX(J) / PTOT
              SPHIV  = PFRY(J) / PTOT
            ELSE
              PTOT   = 0.D0
              COSTET = 0.D0
              CPHIV  = 1.D0
              SPHIV  = 0.D0
            ENDIF
            CALL ADDANG4( COSTHE,PHIX,PHIY, COSTET,CPHIV,SPHIV,
     *                                SECPAR(2),SECPAR(3),SECPAR(4) )
#if __UPWARD__
            IF ( SECPAR(2) .GE. C(29) ) THEN
#else
            IF ( SECPAR(2) .GT. C(29) ) THEN
#endif
              IF ( J .LT. JFIN ) THEN
                SECPAR(0)  = ITYP(J)
#if __INTTEST__
                SECPAR(17) = SQRT( PT2 )
#endif
#if __EHISTORY__
C  COPY PARTICLE INFORMATION, LATER TO BECOME MOTHER PARTICLE
                DO  IK = 0, 8
                  SECPAR(IK+17) = SECPAR(IK)
                ENDDO
#if __THIN__
                SECPAR(26) = SECPAR(13)
#endif
#endif
                CALL TSTACK
              ELSE
                KNEW = ITYP(JFIN)
              ENDIF
            ELSE
              IF ( DEBUG ) WRITE(MDEBUG,*)
     *                 'HydroStore: ANGLE REJECT PARTICLE',J
              IF ( LLONGI ) THEN
C  ADD ENERGY TO LONGITUDINAL ENERGY DEPOSIT
#if __THIN__
                DLONG(LHEIGH,17) = DLONG(LHEIGH,17) + ( EA
     *                                     - RESTMS(ITYP(J)) )* WEIGHT
#else
                DLONG(LHEIGH,17) = DLONG(LHEIGH,17) +EA-RESTMS(ITYP(J))
#endif
              ENDIF
#if __AUGERHIST__
              THICKLOC = THICK( H )
              DO  LL = 1, NOBSLV
                IF     ( THICKLOC .GE. THCKOB(LL)  .AND.
     *                   THICKLOC .LT. THCKOB(LL)+SAMPTH ) THEN
C  THICKH IS WITHIN 1 G/CM^2 BELOW OBSLEV(LL)
C  BRING THE ENERGY BELOW ANGULAR CUT TO THE HISTO OF LEVEL LL
                  OUTPAR(0) = ITYP(J)
                  DO  II = 1, 8
                    OUTPAR(II) = SECPAR(II)
                  ENDDO
                  OUTPAR( 9) = GEN
                  OUTPAR(10) = ALEVEL
                  OUTPAR(13) = WEIGHT
                  EDEP = ( OUTPAR(1) * PAMA(ITYP(J))
     *                             - RESTMS(ITYP(J)) ) * WEIGHT
C  WE HAVE ANGULAR CUT
                  CALL AUGERDEPFIL( EDEP,LL,1 )
                ELSEIF ( THICKLOC .LT. THCKOB(LL) ) THEN
                  GOTO 112
                ENDIF
              ENDDO
 112          CONTINUE
#endif
            ENDIF
 135      CONTINUE

        ELSEIF ( NFRAGM .EQ. 1 ) THEN
C  REMAINING NUCLEUS IS ONE FRAGMENT
          NZNEW = MOD(INEW,100)
          NNNEW = INEW/100 - NZNEW
          KNEW  = INEW
        ENDIF

        IF     ( KNEW/100 .EQ. 5 ) THEN
C  REMAINING NUCLEUS: MASS 5 CANNOT BE TREATED IN BOX2
          IF ( MOD(KNEW,100) .GE. 3 ) THEN
C  MASS 5: SPLIT OFF ONE PROTON
            SECPAR(0) = 14.D0
#if __EHISTORY__
C  COPY PARTICLE INFORMATION, LATER TO BECOME MOTHER PARTICLE
            DO  IK = 0, 8
              SECPAR(IK+17) = SECPAR(IK)
            ENDDO
#if __THIN__
            SECPAR(26) = SECPAR(13)
#endif
#endif
            CALL TSTACK
            KNEW = KNEW - 101
          ELSE
C  MASS 5: SPLIT OFF ONE NEUTRON
            SECPAR(0) = 13.D0
#if __EHISTORY__
C  COPY PARTICLE INFORMATION, LATER TO BECOME MOTHER PARTICLE
            DO  IK = 0, 8
              SECPAR(IK+17) = SECPAR(IK)
            ENDDO
#if __THIN__
            SECPAR(26) = SECPAR(13)
#endif
#endif
            CALL TSTACK
            KNEW = KNEW - 100
          ENDIF
        ELSEIF ( KNEW/100 .EQ. 8 ) THEN
C  REMAINING NUCLEUS: MASS 8 CANNOT BE TREATED IN BOX2
          IF     ( MOD(KNEW,100) .GE. 5 ) THEN
C  MASS 8: SPLIT OFF ONE PROTON
            SECPAR(0) = 14.D0
#if __EHISTORY__
C  COPY PARTICLE INFORMATION, LATER TO BECOME MOTHER PARTICLE
            DO  IK = 0, 8
              SECPAR(IK+17) = SECPAR(IK)
            ENDDO
#if __THIN__
            SECPAR(26) = SECPAR(13)
#endif
#endif
            CALL TSTACK
            KNEW = KNEW - 101
          ELSEIF ( MOD(KNEW,100) .LE. 3 ) THEN
C  MASS 8: SPLIT OFF ONE NEUTRON
            SECPAR(0) = 13.D0
#if __EHISTORY__
C  COPY PARTICLE INFORMATION, LATER TO BECOME MOTHER PARTICLE
            DO  IK = 0, 8
              SECPAR(IK+17) = SECPAR(IK)
            ENDDO
#if __THIN__
            SECPAR(26) = SECPAR(13)
#endif
#endif
            CALL TSTACK
            KNEW = KNEW - 100
          ELSE
C  MASS 8: SPLIT OFF ONE ALPHA PARTICLE
            SECPAR(0) = 402.D0
#if __EHISTORY__
C  COPY PARTICLE INFORMATION, LATER TO BECOME MOTHER PARTICLE
            DO  IK = 0, 8
              SECPAR(IK+17) = SECPAR(IK)
            ENDDO
#if __THIN__
            SECPAR(26) = SECPAR(13)
#endif
#endif
            CALL TSTACK
            KNEW = KNEW - 402
          ENDIF
        ENDIF

        SECPAR(0) = KNEW
#if __EHISTORY__
C  COPY PARTICLE INFORMATION, LATER TO BECOME MOTHER PARTICLE
        DO  IK = 0, 8
          SECPAR(IK+17) = SECPAR(IK)
        ENDDO
#if __THIN__
        SECPAR(26) = SECPAR(13)
#endif
#endif
        CALL TSTACK
      ENDIF

 139  ETOT = ETOT + SECPAR(1)*(PAMA(13)*NNNEW + PAMA(14)*NZNEW)
 140  CONTINUE
      IF ( DEBUG ) WRITE(MDEBUG,1401) ELASTI,ETOT,ELABN,ETOT/ELABN
 1401 FORMAT(1H ,'HydroStore: ELASTI,ETOT,ELABN,MISMATCH=',
     *                 F8.5,1X,2(F15.2,1X),F8.5)

C  FILL ELASTICITY IN MATRICES
      MEL = MIN ( 1.D0+10.D0*      MAX( 0.D0, ELASTI ) , 11.D0 )
      MEN = MIN ( 4.D0+ 3.D0*LOG10(MAX( .1D0, EKINL  )), 40.D0 )
#if __THIN__
      IELDPM(MEN,MEL) = IELDPM(MEN,MEL) + NINT( WEIGHT )
      IELDPA(MEN,MEL) = IELDPA(MEN,MEL) + NINT( WEIGHT )
      IF ( ELASTI .LT. 1.D0 ) THEN
        ELMEAN(MEN) = ELMEAN(MEN) + ELASTI * WEIGHT
        ELMEAA(MEN) = ELMEAA(MEN) + ELASTI * WEIGHT
#else
      IELDPM(MEN,MEL) = IELDPM(MEN,MEL) + 1
      IELDPA(MEN,MEL) = IELDPA(MEN,MEL) + 1
      IF ( ELASTI .LT. 1.D0 ) THEN
        ELMEAN(MEN) = ELMEAN(MEN) + ELASTI
        ELMEAA(MEN) = ELMEAA(MEN) + ELASTI
#endif
      ENDIF

#if __COASTUSERLIB__
C  for epos/nexus
      coastProjId = nint(curpar(0))
      coastTargId = nint(tar)
      coastX = curpar(7)
      coastY = curpar(8)
#if __CURVED__
      coastZ = curpar(14)
#else
      coastX = coastX - XOFF(NOBSLV)
      coastY = coastY - YOFF(NOBSLV)
      coastZ = curpar(5)
#endif
      coastT = curpar(6)
      coastE = pama(coastProjId)*curpar(1)
      coastCX = sigair
      coastEl = elasti
      call interaction(coastX)
#endif

      IF ( FIRSTI ) THEN
        TARG1I = TAR
        SIG1I  = SIGAIR
        ELAST  = ELASTI
C  RANDOM GENERATOR STATUS (SEQUENCE L=1) AT END OF EVENT
        LL   = 1
        CALL RMMAQD( ISEED(1,LL),LL,'R' )
C  SEED
        ISEED1I(1) = ISEED(1,LL)
C  NUMBER OF CALLS
        ISEED1I(2) = ISEED(2,LL)
C  NUMBER OF BILLIONS
        ISEED1I(3) = ISEED(3,LL)
        FIRSTI = .FALSE.
      ENDIF

      RETURN
      END SUBROUTINE HydroStore


