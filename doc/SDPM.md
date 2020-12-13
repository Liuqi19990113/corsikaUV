##### VAPOR

```fortran
SUBROUTINE VAPOR( MAPROJ,INEW,JFIN,ITYP,PFRX,PFRY )

c-----------------------------------------------------------------------
c  (e)vapor(ation of nucleons and alpha particles from fragment)
c
c  treates the remaining unfragmented nucleus
c  evaporation following campi approximation.
c  see: x. campi and j. huefner, phys.rev. c24 (1981) 2199
c  and  j.j. gaimard, these universite paris 7, (1990)
c  this subroutine is called from sdpm, dpmjst, nstore, and vstore.
c  arguments input:
c   maproj       = number of nucleons of projectile
c   inew         = particle type of spectator fragment
c  arguments output:
c   jfin         = number of fragments
c   ityp(1:jfin) = nature (particle code) of fragments (geant)
c   pfrx(1:jfin) = transverse momentum of fragments in x-direction (gev)
c   pfry(1:jfin) = transverse momentum of fragments in y-direction (gev)
c-----------------------------------------------------------------------
```

##### PIGEN

```fortran
SUBROUTINE PIGEN( FNKGS )

c-----------------------------------------------------------------------
c  pi(on) gen(eration)
c
c  this subroutine steers the photonuclear reaction:
c   for production of 1 pion, pigen1 is called.
c   for production of 2 pions, pigen2 is called.
c   at higher energies sdpm is called for production of more particles
c          or rhogen is called for production of rho or omega meson.
c  this subroutine is called from munucl and photon.
c  argument:
c   fnkgs  = flag indicating that nkg might be subtracted
c-----------------------------------------------------------------------
```

##### FLULNK

```fortran
SUBROUTINE FLULNK

C-----------------------------------------------------------------------
C  FLU(KA) L(I)NK ROUTINE
C
C  LINKING SUBROUTINE TO FLUKA 2011.2
C  THIS SUBROUTINE IS CALLED FROM SDPM.
C-----------------------------------------------------------------------
```

##### URQLNK

```FORTRAN
SUBROUTINE URQLNK

C-----------------------------------------------------------------------
C  URQ(MD) L(I)NK (WITH CORSIKA)
C
C  LINKS URQMD MODEL TO CORSIKA TO PERFORM COLLISIONS.
C  THIS SUBROUTINE IS CALLED FROM NUCINT AND SDPM.
C-----------------------------------------------------------------------
```

##### DPMJLK

```FORTRAN
SUBROUTINE DPMJLK

C-----------------------------------------------------------------------
C  DPMJ(ET) L(IN)K
C
C  LINKING SUBROUT. TO DPMJET-III (VERS. 2017.1)
C  THIS SUBROUTINE IS CALLED FROM SDPM
C-----------------------------------------------------------------------
```

##### HDPM

```FORTRAN
SUBROUTINE HDPM

C-----------------------------------------------------------------------
C  H(ADRONIC) D(UAL) P(ARTON) M(ODEL)
C
C  GENERATOR OF HADRONIC COLLISION INSPIRED BY DUAL PARTON MODEL.
C  THIS SUBROUTINE IS CALLED FROM SDPM.
C-----------------------------------------------------------------------
```

##### HERLNK

```FORTRAN
SUBROUTINE HERLNK

C-----------------------------------------------------------------------
C  HER(WIG) L(I)NK(ING ROUTINE)
C
C  LINKS HERWIG MODEL TO CORSIKA.
C  THIS SUBROUTINE IS CALLED FROM SDPM.
C-----------------------------------------------------------------------
```

##### NEXLNK

```FORTRAN
SUBROUTINE NEXLNK

C-----------------------------------------------------------------------
C  (EPOS/)NEX(US) L(I)NK (TO CORSIKA)
C
C  LINKS EPOS/NEXUS PACKAGE TO CORSIKA, NEEDS FIRST CALL OF NEXINI.
C  THIS SUBROUTINE IS CALLED FROM SDPM.
C-----------------------------------------------------------------------
```

##### QGSLNK

```FORTRAN
SUBROUTINE QGSLNK

C-----------------------------------------------------------------------
C  Q(UARK) G(LUON) S(TRING JET MODEL) L(I)NK (TO CORSIKA)
C
C  LINKS QGSJET MODEL TO CORSIKA.
C  THIS SUBROUTINE IS CALLED FROM SDPM.
C-----------------------------------------------------------------------
```

##### SIBLNK

```FORTRAN
SUBROUTINE SIBLNK

C-----------------------------------------------------------------------
C  SIB(YLL) L(I)NK (TO CORSIKA)
C
C  LINKS SIBYLL PROGRAM PACKAGE TO CORSIKA, NEEDS FIRST CALL OF
C  SIBINI.
C  UPDATED FOR SIBYLL-2.3  Sept. 2015 by D. Heck
C  THIS SUBROUTINE IS CALLED FROM SDPM.
C-----------------------------------------------------------------------
```

##### VENLNK

```FORTRAN
SUBROUTINE VENLNK

C-----------------------------------------------------------------------
C  VEN(US) L(I)NK (TO CORSIKA)
C
C  LINKS VENUS PACKAGE TO CORSIKA, NEEDS FIRST CALL OF VENINI.
C  THIS SUBROUTINE IS CALLED FROM SDPM.
C-----------------------------------------------------------------------
```
