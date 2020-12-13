# 1. corsika.F

由于corsika.F的内容过多，我在这个markdown文件中记录了我在查找需要的函数过程中所见到的所有函数中corsika给出的简介，并对部分我需要着重考虑的函数附上了其使用的变量声明。为了方便显示toc目录，最好在chorme浏览器安装markdown viewer后打开观看。本文的标号来自vscode插件的自动生成，有一些赘余项，但是不影响阅读。同时为了方便阅读，注释部分的内容我全部修改为了小写，所以注释中的变量大小写往往和其他部分不太符合。

<!-- TOC -->

- [1. corsika.F](#1-corsikaf)
  - [1.1. CORSIKA/AAMAIN](#11-corsikaaamain)
    - [1.1.1. CORSIKAMAIN](#111-corsikamain)
      - [1.1.1.1. RUNSHOWER](#1111-runshower)
      - [1.1.1.2. FINISHSHOWER](#1112-finishshower)
      - [1.1.1.3. FINISHRUN](#1113-finishrun)
    - [1.1.2. AUGERCORES](#112-augercores)
    - [1.1.3. UPDATE](#113-update)
    - [1.1.4. BLOCK1](#114-block1)
    - [1.1.5. COORIN](#115-coorin)
    - [1.1.6. FSTACKO](#116-fstacko)
    - [1.1.7. FSTACKJO](#117-fstackjo)
    - [1.1.8. HEIGH](#118-heigh)
    - [1.1.9. INPRM](#119-inprm)
    - [1.1.10. LBIN](#1110-lbin)
    - [1.1.11. NRANGC](#1111-nrangc)
    - [1.1.12. OUTPT1](#1112-outpt1)
    - [1.1.13. PRTIME](#1113-prtime)
    - [1.1.14. STAEND](#1114-staend)
    - [1.1.15. TSTEND](#1115-tstend)
    - [1.1.16. TOBUF](#1116-tobuf)
    - [1.1.17. TOBUFS](#1117-tobufs)
    - [1.1.18. UPDATC](#1118-updatc)
    - [1.1.19. TOBUFC](#1119-tobufc)
    - [1.1.20. AUGCUT](#1120-augcut)
    - [1.1.21. AUGERDEPFIL](#1121-augerdepfil)
    - [1.1.22. SHOWERFRONT](#1122-showerfront)
    - [1.1.23. BOX2](#1123-box2)
    - [1.1.24. BOX3](#1124-box3)
    - [1.1.25. COOINC](#1125-cooinc)
    - [1.1.26. FINDTH](#1126-findth)
    - [1.1.27. FSTACK](#1127-fstack)
    - [1.1.28. INPRM](#1128-inprm)
    - [1.1.29. ISTACK](#1129-istack)
    - [1.1.30. JSTACK](#1130-jstack)
    - [1.1.31. LONGFT](#1131-longft)
    - [1.1.32. NUCINT](#1132-nucint)
      - [1.1.32.1. CHRMDC](#11321-chrmdc)
      - [1.1.32.2. ETADEC](#11322-etadec)
      - [1.1.32.3. HEPARIN](#11323-heparin)
      - [1.1.32.4. KDECAY](#11324-kdecay)
      - [1.1.32.5. LBIN](#11325-lbin)
      - [1.1.32.6. PI0DEC](#11326-pi0dec)
      - [1.1.32.7. SDPM](#11327-sdpm)
        - [1.1.32.7.1. VAPOR](#113271-vapor)
        - [1.1.32.7.2. PIGEN](#113272-pigen)
        - [1.1.32.7.3. FLULNK](#113273-flulnk)
        - [1.1.32.7.4. URQLNK](#113274-urqlnk)
        - [1.1.32.7.5. DPMJLK](#113275-dpmjlk)
        - [1.1.32.7.6. HDPM](#113276-hdpm)
        - [1.1.32.7.7. HERLNK](#113277-herlnk)
        - [1.1.32.7.8. NEXLNK](#113278-nexlnk)
          - [1.1.32.7.8.1. NSTORE](#1132781-nstore)
        - [1.1.32.7.9. QGSLNK](#113279-qgslnk)
        - [1.1.32.7.10. SIBLNK](#1132710-siblnk)
        - [1.1.32.7.11. VENLNK](#1132711-venlnk)
          - [1.1.32.7.11.1. VSTORE](#11327111-vstore)
        - [1.1.32.7.12. RMMARD](#1132712-rmmard)
      - [1.1.32.8. STRDEC](#11328-strdec)
      - [1.1.32.9. THICK](#11329-thick)
      - [1.1.32.10. CGHEI](#113210-cghei)
      - [1.1.32.11. URQLNK](#113211-urqlnk)
      - [1.1.32.12. PYTDCSET](#113212-pytdcset)
      - [1.1.32.13. ADDANG](#113213-addang)
    - [1.1.33. OUTEND](#1133-outend)
    - [1.1.34. PRESHO](#1134-presho)
    - [1.1.35. SOURCEPATH](#1135-sourcepath)
    - [1.1.36. START](#1136-start)
    - [1.1.37. STCKIN](#1137-stckin)
    - [1.1.38. THICKC](#1138-thickc)
    - [1.1.39. TRAJCHECK](#1139-trajcheck)
    - [1.1.40. AVAGE](#1140-avage)
    - [1.1.41. ININKG](#1141-ininkg)
    - [1.1.42. MITAGE](#1142-mitage)
    - [1.1.43. STANKG](#1143-stankg)
    - [1.1.44. CONEXINI](#1144-conexini)
    - [1.1.45. CONEXLNK](#1145-conexlnk)
    - [1.1.46. GETBUS](#1146-getbus)
    - [1.1.47. OUTND2](#1147-outnd2)
    - [1.1.48. AHISTOUT](#1148-ahistout)
    - [1.1.49. AUGERHISTNORM](#1149-augerhistnorm)
    - [1.1.50. LNGHSTINI](#1150-lnghstini)
    - [1.1.51. LONGIHIST](#1151-longihist)
    - [1.1.52. MUONHISTFIL](#1152-muonhistfil)
    - [1.1.53. HISFIL](#1153-hisfil)
    - [1.1.54. HISOUT](#1154-hisout)
    - [1.1.55. HISPRP](#1155-hisprp)
    - [1.1.56. HISRES](#1156-hisres)
    - [1.1.57. HISTRA](#1157-histra)
    - [1.1.58. TSTACK](#1158-tstack)
    - [1.1.59. VAPOR](#1159-vapor)
    - [1.1.60. ADDANG4](#1160-addang4)
    - [1.1.61. AUGERDEPFIL](#1161-augerdepfil)
    - [1.1.62. RMMAQD](#1162-rmmaqd)

<!-- /TOC -->
## 1.1. CORSIKA/AAMAIN

```fortran
#if __PARALLELIB__
      SUBROUTINE CORSIKA(LPRIM,DECTCUT,DECTMAX
     &               ,I1CUTPART,I2CUTPART,CFILINPU,CFILOUTP,CFILSTEE
     &               ,IDMPI)

C-----------------------------------------------------------------------
C  MAIN SUBROUTINE
C
C  CORSIKA CALLED FROM EXTERNAL PROGRAM WITH INPUT PARAMETERS.
C  ARGUMENTS:
C     LPRIM    (LOG) : PRIMARY INTERACTION (T) OR NOT (F)
C     DECTCUT  (DBL) : THRESHOLD ENERGY FOR SUBSHOWERS (GEV).
C                      ALL PARTICLES WITH ENERGY ABOVE ECTCUT WILL HAVE
C                      A SEED FROM THE 6TH SEQUENCE OF RANDOM NUMBERS
C                      ECTCUT IS IRRELEVANT FOR EM SHOWERS
C     DECTMAX  (DBL) : MAXIMUM ENERGY (GEV) FOR A COMPLETE SUBSHOWER
C     I1CUTPART(INT) : FIRST INDICE OF PARTICULE TO READ FROM CFILINP
C     I2CUTPART(INT) : LAST INDICE OF PARTICULE TO READ FROM CFILINP
C     CFILINPU (CHA) : CUTFILE NAME TO READ TO FILL 2ND STACK
C     CFILOUTP (CHA) : SCREEN OUTFILE FILE NAME
C     CFILSTEE (CHA) : STEERING FILE NAME TO READ INPUT PARAMETERS
C     IDMPI    (INT) : ID OF THE MPI TASK
#else
      PROGRAM AAMAIN

C-----------------------------------------------------------------------
C  MAIN PROGRAM
#endif

#if __CONEX__
C  TO ALLOW TO RUN CORSIKA SHOWER DEVELOPMENT AND CONEX SHOWER DEVELOPMENT
C  IN PARALLEL, WE CALL A SUBROUTINE WITH NAME OF THE DIFFERENT SUB PARTS
C  AS ARGUMENT (TRICK FOR RECURSIVE CALL OF SUBROUTINE)
C
C-----------------------------------------------------------------------
```

### 1.1.1. CORSIKAMAIN

由于上述的AAMAIN的全过程只执行了这一个subroutine，所以说后面提到的有AAMAIN调用的subroutine和function实际上是由这个CORSIKAMAIN来调用的

```fortran
SUBROUTINE CORSIKAMAIN(DUMRUNSHOWER,DUMFINISHSHOWER,DUMFINISHRUN
#if __PARALLELIB__
     *                ,LPRIM,I1CUTPART,I2CUTPART,CFILINPU,CFILOUTP
     *                ,CFILSTEE,IDMPI
#endif
     *                )

C-----------------------------------------------------------------------
C  MAIN SUBROUTINE
#if __PARALLELIB__
C
C  CORSIKA CALLED FROM EXTERNAL PROGRAM WITH INPUT PARAMETERS.
C  ARGUMENTS:
C     LPRIM    (LOG) : PRIMARY INTERACTION (T) OR NOT (F)
C     I1CUTPART(INT) : FIRST INDICE OF PARTICULE TO READ FROM CFILINP
C     I2CUTPART(INT) : LAST INDICE OF PARTICULE TO READ FROM CFILINP
C     CFILINPU (CHA) : CUTFILE NAME TO READ TO FILL 2ND STACK
C     CFILOUTP (CHA) : SCREEN OUTFILE FILE NAME
C     CFILSTEE (CHA) : STEERING FILE NAME TO READ INPUT PARAMETERS
C     IDMPI    (INT) : ID OF THE MPI TASK
#endif
#endif
C
C
C  SIMULATION OF EXTENSIVE AIR SHOWERS
C  PREPARES INITIALIZATIONS
C  GENERATES SHOWERS IN THE SHOWER LOOP
C  TREATES PARTICLES IN THE PARTICLE LOOP
C  PERFORMS PRINTING OF TABLES AT END OF SHOWER AND AT END OF RUN
C-----------------------------------------------------------------------
```

#### 1.1.1.1. RUNSHOWER

```FORTRAN
ENTRY RUNSHOWER

C-----------------------------------------------------------------------
C
C  SUBPART OF AAMAIN FOR SHOWER DEVELOPMENT
C  THIS SUBROUTINE IS CALLED FROM FROMCNX AND CORSIKAMAIN VIA EXTERNAL
C  NAME
C
C-----------------------------------------------------------------------
```

#### 1.1.1.2. FINISHSHOWER

```FORTRAN
ENTRY FINISHSHOWER

C-----------------------------------------------------------------------
C
C  SUBPART OF AAMAIN AT THE END OF THE SHOWER (EVENT STATISTICS AND PLOTS)
C  THIS SUBROUTINE IS CALLED FROM CORSIKAMAIN VIA AN EXTERNAL NAME
C
C-----------------------------------------------------------------------
```

#### 1.1.1.3. FINISHRUN

```FORTRAN
ENTRY FINISHRUN

C-----------------------------------------------------------------------
C
C  SUBPART OF AAMAIN AT THE END OF THE RUN (STATISTICS AND MEAN PLOTS)
C  THIS SUBROUTINE IS CALLED FROM CORSIKAMAIN VIA AN EXTERNAL NAME
C
C-----------------------------------------------------------------------
```

### 1.1.2. AUGERCORES

```fortran
SUBROUTINE AUGERCORES

c-----------------------------------------------------------------------
c  (determine) auger core (position)s
c  core positions are in x: half detector distance (= 750 m)
c                     in y: half detector row distance
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------  
```

### 1.1.3. UPDATE

```fortran
SUBROUTINE UPDATE( HNEW,THCKHN,IPAS )

c-----------------------------------------------------------------------
c  update(s particle parameters)
c
c  updates particle parameters to observation level with number ipas
c                           or to point of interaction or decay (ipas=0)
c  for charged particles the energy loss is computed for the whole step,
c  subdivided by the boundaries of the atmospheric layers.
c  the particle is flying the 1st half (chi/2) with initial energy
c  and angle and the 2nd half with final energy and angle.
c  the time calculation follows this simplification.
c  charged particles are deflected in the earth magnetic field.
c  the angle of deflection by multiple scattering is computed only
c  for muons/taus and only once for the whole step at half thickness.
c  if particles come to rest by stopping, their path to the stopping
c  point is calculated.
#if __cerenkov__
c  cherenkov radiation is calculated only for lowest observation level
#endif
c  this subroutine is called from aamain, box3, mutrac, and updatc.
c  arguments:
c   hnew   = altitude of particle after update (cm)
c   thckhn = thickness of hnew (g/cm**2)
c   ipas   = 0  transport to end of range of particle
c       .ne. 0  transport to passage of observation level ipas
c-----------------------------------------------------------------------
```

### 1.1.4. BLOCK1

```fortran
BLOCK DATA BLOCK1

c-----------------------------------------------------------------------
c  initializes data
c  this routine is called from aamain
c-----------------------------------------------------------------------
```

### 1.1.5. COORIN

```fortran
SUBROUTINE COORIN( HEIGHT )

c-----------------------------------------------------------------------
c  coor(dinate) in(itialization)
c
c  initializes coordinate correction for each observation level
c  routine should be called after height of first interaction is
c  determined. x,y coordinates of 1. ineraction are assumed to be 0,0.
c  this subroutine is called from aamain, electr, and photon.
c  argument:
c   height = height of 1. interaction (cm)
c-----------------------------------------------------------------------
```

### 1.1.6. FSTACKO

```fortran
SUBROUTINE FSTACKO(IOPT)

c-----------------------------------------------------------------------
c  f(ile) stack o(pen)
c
c  scratch disk management.
c  this subroutine is called from tstout and aamain.
c  argument:
c   iopt : option to open file (1) or to close it (0)
c-----------------------------------------------------------------------
```

### 1.1.7. FSTACKJO

```fortran
SUBROUTINE FSTACKJO(IOPT)

c-----------------------------------------------------------------------
c  f(ile) stack o(pen)
c
c  2d scratch disk management.
c  this subroutine is called from tstout, cutread, datac and aamain.
c  argument:
c   iopt : option to open file (1) or to close it (0)
C-----------------------------------------------------------------------
```

### 1.1.8. HEIGH

```fortran
DOUBLE PRECISION FUNCTION HEIGH( ARG )

c-----------------------------------------------------------------------
c  heigh(t as function of thickness)
c
c  calculates height depending on thickness of atmosphere
c  this function is called from aamain, box2, box3, cooinc, inprm,
c  mutrac, prangc, staend, thickc, updatc, update, egsin1, and ininkg
c  argument:
c   arg    = mass overlay (g/cm**2)
c-----------------------------------------------------------------------
```

### 1.1.9. INPRM

```fortran
SUBROUTINE INPRM

c-----------------------------------------------------------------------
c  in(put) pr(i)m(ary)
c
c  takes input primary energy from specified spectrum
c  checks input variables for consistency and limitations
c  writes data base file
c  initializes cherenkov, if cerenkov option selected.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.10. LBIN

```fortran
integer function lbin( xx,yy,hh,istart )

c-----------------------------------------------------------------------
c  l(ongitudinal) bin
c
c  determines the longitudinal bin of slant depth distribution for a
#if __curved__
c  particle with coordinates xx, yy and apparent height hh in
c  curved coordinate system
#else
c  particle with cartesian coordinates  xx, yy, hh.
#endif
c  this function is called from aamain, box3, em, mubrem, mudecy,
c  munucl, muprpr, mutrac, nucint, update, cerlde.
c  arguments:
c   xx    = x coordinate of particle (cm)
c   yy    = y coordinate of particle (cm)
#if __curved__
c   hh    = happ apparent height of particle in det. system (cm)
#else
c   hh    = h altitude   of particle (cm)
#endif
c   istart = starting bin for forward search
c-----------------------------------------------------------------------
```

### 1.1.11. NRANGC

```fortran
SUBROUTINE NRANGC( ARG )

c-----------------------------------------------------------------------
c  n(eutral particle) range c(urved atmosphere)
c
c  determines penetrated matter chi for neutral particles
c  taking into account a curved atmosphere.
c  this subroutine is called from aamain and box2.
c  argument:
c   arg    = geometric length of particle track (cm)
C-----------------------------------------------------------------------
```

### 1.1.12. OUTPT1

```fortran
SUBROUTINE OUTPT1

c-----------------------------------------------------------------------
c  (write particle) outp(u)t  1
c
c  writes 39 particle records per physical record
c  tabulates parameters of all high energy particles with
c  lorentz factor larger than ectmap.
c  this subroutine is called from aamain, box3, mutrac, updatc,
c  and ausgab.
c-----------------------------------------------------------------------
```

### 1.1.13. PRTIME

```fortran
SUBROUTINE PRTIME( TTIME )

c-----------------------------------------------------------------------
c  pr(int) time
c
c  prints present date and time and gives it in a format suited for the
c  runheader and eventheader.
c  this subroutine is called from aamain and start.
c  argument:
c   ttime  = time (yymmdd)
c
c  if our date routine does not fit to your computer, please replace
c  it by a suitable routine of your system
c-----------------------------------------------------------------------
```

### 1.1.14. STAEND

```fortran
SUBROUTINE STAEND

c-----------------------------------------------------------------------
c  sta(rt) end
c
c  subroutine for getting the control printout of the constant arrays
c  print control output.
c  this subroutine is called from aamain and start.
C-----------------------------------------------------------------------
```

### 1.1.15. TSTEND

```fortran
SUBROUTINE TSTEND

c-----------------------------------------------------------------------
c  t(o) st(ack) end (of reaction)
c
c  move intermediate reaction stack to the real stack
c  and perform thinning, if selected.
c  this subroutine is called from aamain, box3, and pigen.
c-----------------------------------------------------------------------
```

### 1.1.16. TOBUF

```fortran
SUBROUTINE TOBUF( A,IFL )

c-----------------------------------------------------------------------
c  (write) to buf(fer)
c
c  writes up to nsubbl data blocks to output buffer and puts the full
c  buffer to file.
c  this subroutine is called from aamain, electr, inprm, outend,
c  outpt1, outpt2, and photon.
c  arguments:
c   a      = array to be written to file
c   ifl    = starting of final output
c          = 0  normal block
c          = 1  normal block with end of output
c          = 2  only end of output
c-----------------------------------------------------------------------
```

### 1.1.17. TOBUFS

```fortran
SUBROUTINE TOBUFS( A,N )

c-----------------------------------------------------------------------
c  (write) to buf(fer) s(hort)
c
c  writes data a with length n to buffer.
c  this subroutine is called from aamain, electr, inprm, outend,
c  outpt1, and photon.
c  arguments:
c   a      = array to be written to file
c   n      = length of data block
c-----------------------------------------------------------------------
```

### 1.1.18. UPDATC

```fortran
SUBROUTINE UPDATC( IPASC,FLAGMU )

c-----------------------------------------------------------------------
c  updat(es particle parameters in a) c(urved atmosphere)
c
c  in the case the horizontal component of the track is to long (> 20km)
c  the particle track is chopped in several shorter tracks.
c  for each of these chopped tracks subr. update is called.
c  this subroutine is called from aamain, box3, and mutrac.
c  arguments:
c   ipasc  = 0  transport leads to end of range of particle
c            1  transport leads to observation level
c   flagmu = flag indicating the tracking of muons
c-----------------------------------------------------------------------
```

### 1.1.19. TOBUFC

```fortran
SUBROUTINE TOBUFC( A,IFL,ICERBUF )

c-----------------------------------------------------------------------
c  (write) to buf(fer) c(herenkov data)
c
c  copy to buffer cherenkov data.
c  this subroutine is called from aamain, inprm, electr, photon, outnd2,
c  and outpt2.
c  arguments:
c   a      = array to be written to file
c   ifl    = starting of final output
c          = 0  normal block
c          = 1  normal block with end of output
c          = 2  only end of output
c  icerbuf = number of telescope output file
c-----------------------------------------------------------------------
```

### 1.1.20. AUGCUT

```fortran
SUBROUTINE AUGCUT( LL )

c-----------------------------------------------------------------------
c  aug(er) cut(ted energy particles at observation level slice)
c
c  traces hadrons and muons to cutting point and stores their
c  coordinates in outpar.
c  this subroutine is called from aamain, box3, mutrac, and update.
c  argument:
c   ll     = number of observation level
c-----------------------------------------------------------------------
```

### 1.1.21. AUGERDEPFIL

```fortran
SUBROUTINE AUGERDEPFIL( EDEP,LL,ICUT )

c-----------------------------------------------------------------------
c  auger dep(osit histogram) fil(ling)
c
c  to be used if particle is stopped or goes below energy threshold
c  in the layer below the observation level.
c  filling of the histogramming to follow the longitudinal
c  evolution of showers for the auger experiment.
c  at level ll the energy edep is deposited. the coordinates of the
c  stopped particle are available in outpar.
c  this subroutine is called from aamain, em, mubrem, muprpr, tstack,
c  augact, augcut, and augect.
c  arguments:
c   edep   = deposited energy (gev) (already corrected by weight)
c   ll     = number of observation level
c   icut   = 0 for energy cut, 1 for angular cut
c-----------------------------------------------------------------------
```

### 1.1.22. SHOWERFRONT

```fortran
SUBROUTINE SHOWERFRONT

c-----------------------------------------------------------------------
c  showerfront
c
c  showerfront calculates various variables to be used for
c  the arrival of the spherical shower front at observation level
c  this subroutine is called from aamain, electr, photon.
c  design   : j. knapp   univ. of leeds
c-----------------------------------------------------------------------
```

### 1.1.23. BOX2

```fortran
SUBROUTINE BOX2

c-----------------------------------------------------------------------
c  determines point of interaction or decay for any particle
c  heavy primaries and strange baryons included
c  annihilation cross-section included
c  precise mean free path for decaying particles
c  has interaction length statistics included
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.24. BOX3

```fortran
SUBROUTINE BOX3

c-----------------------------------------------------------------------
c  checks passage through observation level(s)
c  iret1=1 kills particle
c  iret2=1 particle has been cutted in update
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.25. COOINC

```fortran
SUBROUTINE COOINC

c-----------------------------------------------------------------------
c  coo(rdinate) in(itialization for a) c(urved atmosphere)
c
c  initializes all important coordinates for one observation level
c  routine determines starting parameters at height given by thick0 for
c  a coordinate system which is fixed in (x,y) at the assumed detector
c  position and in z at detector level.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.26. FINDTH

```fortran
DOUBLE PRECISION FUNCTION FINDTH( X )

c-----------------------------------------------------------------------
c  find th(eta)
c
c  function to find theta of primary with correction to geometry
c  for vertical cylinder with long axis as used for underwater neutrino
c  detectors.
c  to randomize xy coordinates of shower cores one needs to project the
c  detector cylinder along the primary''s track onto the surface. such
c  projection has area (pi*r^2*cos(th)+l*2r*sin(th))/cos(th) and
c  consists of two half-circles and a rectangle.
c  this routine is called from aamain.
c  argument:
c   x      = random number
c-----------------
```

### 1.1.27. FSTACK

```fortran
c-----------------------------------------------------------------------
c  f(rom) stack
c
c  gets particle from stack and reads from disk if necessary.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.28. INPRM

```fortran
c-----------------------------------------------------------------------
c  in(put) pr(i)m(ary)
c
c  takes input primary energy from specified spectrum
c  checks input variables for consistency and limitations
c  writes data base file
c  initializes cherenkov, if cerenkov option selected.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.29. ISTACK

```fortran
c-----------------------------------------------------------------------
c  i(nitialize) stack
c
c  prepares stack and external disk file.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.30. JSTACK

```fortran
SUBROUTINE JSTACK

c-----------------------------------------------------------------------
c  (initialize) stack j
c
c  prepares stack and external disk file.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.31. LONGFT

```fortran
SUBROUTINE LONGFT( FPARAM,CHI2 )

c-----------------------------------------------------------------------
c  long(itudinal) f(i)t
c
c  this routine performs a fit to the longitudinal distribution of an
c  air shower. due to the large particle numbers in an air shower the
c  statistical errors on the particle number at a given level are
c  minute. this leads to rather large chi**2/dof for the fits even if
c  the fitted function matches the points better than say 1%.
c  keep in mind that fitting is a difficult task and the results do not
c  necessarily represent the abolute minimum or even a good
c  approximation.
c
c  in a first step a 4 parameter fit is tried based on m. hillas'' curve
c  with width parameter lambda :
c   n(t) = nmax * ((t-t0)/(tmax-t0))**((tmax-t0)/p) * exp((tmax-t)/p)
c  with:
c   nmax = particle number at tmax
c   t    = depth in g/cm**2
c   t0   = starting depth of shower
c   tmax = depth of shower maximum
c   p    = width parameter lambda
c
c  in a second step we refine the fit with the start values from the 4
c  parameter fit and use a 6 parameter fit based on m. hillas'' curve
c  replacing his width parameter lambda by a polynomial of 3. degree.
c   n(t) = nmax * ((t-t0)/(tmax-t0))**((tmax-t0)/(p1+p2*t+p3*t**2))
c               * exp((tmax-t)/(p1+p2*t+p3*t**2))
c  with:
c   nmax = particle number at tmax
c   t    = depth in g/cm**2
c   t0   = starting depth of shower
c   tmax = depth of shower maximum
c   p1 .. p3 = parameters of a polynomial describing the width
c
c  this subroutine is called from aamain.
c  arguments:
c   fparam = array with the final fitted parameters (6 parameters)
c   chi2   = chi squared
c-----------------------------------------------------------------------
```

### 1.1.32. NUCINT

```fortran
SUBROUTINE NUCINT

c-----------------------------------------------------------------------
c  nuc(lear) int(eraction)
c
c  selects type of interaction process according to ecm
c  heavy primaries and strange baryons included.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
 IMPLICIT NONE
#define __AIRINC__
#define __CONSTAINC__
#define __GENERINC__
#define __IRETINC__
#define __KAONSINC__
#define __LONGIINC__
#define __MULTINC__
#define __PAMINC__
#define __PARPARINC__
#define __PARPAEINC__
#define __POLARINC__
#define __RANDPAINC__
#define __RUNPARINC__
#define __SIGMINC__
#define __STATIINC__
#define __VKININC__
#if __AUGERHIST__
#define __OBSPARINC__
#endif
#if __INTTEST__
#define __TSTINTINC__
#endif
#include "corsika.h"

      DOUBLE PRECISION BETA3,COSMU,COSTCM,COSTH3,ETOT,GAMMA3,
     *                 PHI,PHIMU,PHI3,SINMU,THICK,WORK1,WORK2
      INTEGER          I,IGO,KJ
      LOGICAL          FIRSTINT
#if !__STACKIN__ && !__CONEX__
      DOUBLE PRECISION ENERGY,EN,PZ,PX,PY,HEI0
      INTEGER          NNN,NN,NTYP
c     INTEGER          N,IRET,IBL
#endif
#if __URQMD__
      INTEGER          IA
#endif
#if __NEUTRINO__
      DOUBLE PRECISION COSTH4
#endif
#if __SLANT__
      INTEGER          LBIN
      EXTERNAL         LBIN
#endif
#if __AUGERHIST__
      DOUBLE PRECISION EDEP,THICKLOC
      INTEGER          II,LL
#endif
      SAVE
      EXTERNAL         THICK
C-----------------------------------------------------------------------
```

#### 1.1.32.1. CHRMDC

```fortran
SUBROUTINE CHRMDC

c-----------------------------------------------------------------------
c  ch(a)rm(ed particle) d(e)c(ay)
c
c  routine treates decay of charmed particles and tau leptons.
c  decay is treated by pythia.
c  this subroutine is called from mutrac and nucint.
c-----------------------------------------------------------------------
```

#### 1.1.32.2. ETADEC

```fortran
SUBROUTINE ETADEC

c-----------------------------------------------------------------------
c  eta dec(ay)
c
c  routine treates decay of eta
c  decay with full kinematic, energy and momenta conserved
c  this subroutine is called from nucint.
c  updated including rare decay eta ---> mu(+) + mu(-) + gamma
c  updated including rare decay eta ---> mu(+) + mu(-)
c-----------------------------------------------------------------------
```

#### 1.1.32.3. HEPARIN

```fortran
SUBROUTINE HEPARIN( CHAE )

c-----------------------------------------------------------------------
c  he(avy) par(ticle) in(teraction)
c  heavy particle interaction based on m.masip and j.illana model
c  performs interaction on proton and retrieve secondary particles.
c  this subroutine is called from nucint.
c  argument:
c   chae = particle (total) lab. energy (in gev)
C-----------------------------------------------------------------------
```

#### 1.1.32.4. KDECAY

```fortran
SUBROUTINE KDECAY( IGO )

c-----------------------------------------------------------------------
c  k(aon) decay
c
c  kaon decays with full kinematic, energy and momenta conserved
c  all secondary particles are written to stack.
c  this subroutine is called from nucint.
c  argument:         (to characterize the decaying kaon)
c   igo    = 1  k+
c          = 2  k-
c          = 3  k0s
c          = 4  k0l
c-----------------------------------------------------------------------
```

#### 1.1.32.5. LBIN

```fortran
INTEGER FUNCTION LBIN( XX,YY,HH,ISTART )

c-----------------------------------------------------------------------
c  l(ongitudinal) bin
c
c  determines the longitudinal bin of slant depth distribution for a
#if __curved__
c  particle with coordinates xx, yy and apparent height hh in
c  curved coordinate system
#else
c  particle with cartesian coordinates  xx, yy, hh.
#endif
c  this function is called from aamain, box3, em, mubrem, mudecy,
c  munucl, muprpr, mutrac, nucint, update, cerlde.
c  arguments:
c   xx    = x coordinate of particle (cm)
c   yy    = y coordinate of particle (cm)
#if __curved__
c   hh    = happ apparent height of particle in det. system (cm)
#else
c   hh    = h altitude   of particle (cm)
#endif
c   istart = starting bin for forward search
c-----------------------------------------------------------------------
```

#### 1.1.32.6. PI0DEC

```fortran
SUBROUTINE PI0DEC

c-----------------------------------------------------------------------
c  pi 0 dec(ay)
c
c  decay of pi0 into 2 gammas or into e(+) + e(-) + gamma
c  this subroutine is called from nucint.
c-----------------------------------------------------------------------
```

#### 1.1.32.7. SDPM

```fortran
SUBROUTINE SDPM( LTA )

c-----------------------------------------------------------------------
c  s(tarting) d(ual) p(arton) m(odel)
c
c  this routine determines the target nucleus.
c  it calls also the various interaction models.
c  for hdpm, this routine looks, how many nucleons interact and which
c  residual fragment of the projectile nucleus remains.
c  this subroutine is called from nucint and pigen.
c  argument:
c   lta    = target: 1=14n, 2=16o, 3=40ar, 0=random
c-----------------------------------------------------------------------
IMPLICIT NONE
#define __AIRINC__
#define __CONSTAINC__
#define __DPMFLGINC__
#define __GENERINC__
#define __INTERINC__
#define __ISTAINC__
#define __LONGIINC__
#define __MULTINC__
#define __NCSNCSINC__
#define __PAMINC__
#define __PARPARINC__
#define __PARPAEINC__
#define __RANDPAINC__
#define __RESTINC__
#define __RUNPARINC__
#define __SIGMINC__
#define __VKININC__
#if __AUGERHIST__
#define __OBSPARINC__
#endif
#if __DPMJET__
#define __DPMJETINC__
#endif
#if __EPOS__ || __NEXUS__
#define __NEXUSINC__
#endif
#if __QGSJET__
#define __QGSCINC__
#endif
#if __SIBYLL__
#define __SIBYLCINC__
#endif
#if __VENUS__
#define __VENUSINC__
#endif
#if __INTTEST__
#define __TSTINTINC__
#endif
#include "corsika.h"

      DOUBLE PRECISION PFRX(60),PFRY(60)
      DOUBLE PRECISION COSTET,CPHIV,EA,P,PTM,PT2,PTOT,SPHIV,
     *                 SIGMAA,SIGMAN,SIGMAO,SIG45,S45SQ,S4530
      DOUBLE PRECISION CGHSIG
      INTEGER          ITYP(60),I,IA,IANEW,INACTA,INACTZ,INDEX,INEUTR,
     *                 IZ,IZNEW,J,JFIN,KNEW,L,LL,LTA,NPRPRO,NNEPRO
#if __GHEISHAD__
      DOUBLE PRECISION EKIN
#endif
#if __AUGERHIST__
      DOUBLE PRECISION EDEP,THICKLOC,THICK
      INTEGER          II
      EXTERNAL         THICK
#endif
      SAVE
      EXTERNAL         CGHSIG
C-----------------------------------------------------------------------
```

##### 1.1.32.7.1. VAPOR

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

##### 1.1.32.7.2. PIGEN

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

##### 1.1.32.7.3. FLULNK

```fortran
SUBROUTINE FLULNK

C-----------------------------------------------------------------------
C  FLU(KA) L(I)NK ROUTINE
C
C  LINKING SUBROUTINE TO FLUKA 2011.2
C  THIS SUBROUTINE IS CALLED FROM SDPM.
C-----------------------------------------------------------------------
```

##### 1.1.32.7.4. URQLNK

```FORTRAN
SUBROUTINE URQLNK

C-----------------------------------------------------------------------
C  URQ(MD) L(I)NK (WITH CORSIKA)
C
C  LINKS URQMD MODEL TO CORSIKA TO PERFORM COLLISIONS.
C  THIS SUBROUTINE IS CALLED FROM NUCINT AND SDPM.
C-----------------------------------------------------------------------
```

##### 1.1.32.7.5. DPMJLK

```FORTRAN
SUBROUTINE DPMJLK

C-----------------------------------------------------------------------
C  DPMJ(ET) L(IN)K
C
C  LINKING SUBROUT. TO DPMJET-III (VERS. 2017.1)
C  THIS SUBROUTINE IS CALLED FROM SDPM
C-----------------------------------------------------------------------
```

##### 1.1.32.7.6. HDPM

```FORTRAN
SUBROUTINE HDPM

C-----------------------------------------------------------------------
C  H(ADRONIC) D(UAL) P(ARTON) M(ODEL)
C
C  GENERATOR OF HADRONIC COLLISION INSPIRED BY DUAL PARTON MODEL.
C  THIS SUBROUTINE IS CALLED FROM SDPM.
C-----------------------------------------------------------------------
```

##### 1.1.32.7.7. HERLNK

```FORTRAN
SUBROUTINE HERLNK

C-----------------------------------------------------------------------
C  HER(WIG) L(I)NK(ING ROUTINE)
C
C  LINKS HERWIG MODEL TO CORSIKA.
C  THIS SUBROUTINE IS CALLED FROM SDPM.
C-----------------------------------------------------------------------
```

##### 1.1.32.7.8. NEXLNK

```FORTRAN
SUBROUTINE NEXLNK

C-----------------------------------------------------------------------
C  (EPOS/)NEX(US) L(I)NK (TO CORSIKA)
C
C  LINKS EPOS/NEXUS PACKAGE TO CORSIKA, NEEDS FIRST CALL OF NEXINI.
C  THIS SUBROUTINE IS CALLED FROM SDPM.
C-----------------------------------------------------------------------
IMPLICIT NONE
#define __NEXLININC__
#define __NEXPARINC__
#define __NEXUSINC__
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

#if __EPOS__
C--------------------------- EPOS COMMON ------------------------------
      real pnll,ptq,exmass,cutmss,wproj,wtarg
      common/hadr1/pnll,ptq,exmass,cutmss,wproj,wtarg
      integer nevt,kolevt,npjevt,minfra,maxfra,nglevt,koievt,kohevt
     *,ntgevt,npnevt,nppevt,ntnevt,ntpevt,jpnevt,jppevt,jtnevt,jtpevt
      real phievt,bimevt,pmxevt,egyevt,xbjevt,qsqevt,zppevt,zptevt
      common/cevt/phievt,nevt,bimevt,kolevt,koievt,pmxevt,egyevt,npjevt
     *,ntgevt,npnevt,nppevt,ntnevt,ntpevt,jpnevt,jppevt,jtnevt,jtpevt
     *,xbjevt,qsqevt,nglevt,zppevt,zptevt,minfra,maxfra,kohevt
      integer idprojin,idtargin,irdmpr
     &             ,isoproj,isotarg
      real rexdifi,rexndii
      common/hadr25/idprojin,idtargin,rexdifi(4),rexndii(4),irdmpr
     &             ,isoproj,isotarg
      double precision seedi,seedj,seedj2,seedc
      integer iseqini,iseqsim
      common/cseed/seedi,seedj,seedj2,seedc,iseqini,iseqsim
#elif __NEXUS__
C--------------------------- NEXUS COMMON ------------------------------
      real pnll,ptq,exmass,cutmss,rstras,wproj,wtarg
      common/hadr1/pnll,ptq,exmass,cutmss,rstras,wproj,wtarg
      integer nevt,kolevt,npjevt
     *,ntgevt,npnevt,nppevt,ntnevt,ntpevt,jpnevt,jppevt,jtnevt,jtpevt
      real phievt,bimevt,pmxevt,egyevt,xbjevt,qsqevt
      common/cevt/phievt,nevt,bimevt,kolevt,pmxevt,egyevt,npjevt
     *,ntgevt,npnevt,nppevt,ntnevt,ntpevt,jpnevt,jppevt,jtnevt,jtpevt
     *,xbjevt,qsqevt
      double precision seedi,seedj,seedc
      common/cseed/seedi,seedj,seedc
#endif
      integer iprmpt,ish,ishsub,irandm,irewch,iecho,modsho,idensi
      common/prnt1/iprmpt,ish,ishsub,irandm,irewch,iecho,modsho,idensi
      integer iomodl,idproj,idtarg,laproj,maproj,latarg,matarg
      real wexcit,core,fctrmx
      common/hadr2/iomodl,idproj,idtarg,wexcit
      common/nucl1/laproj,maproj,latarg,matarg,core,fctrmx
      integer icinpu
      real engy,elepti,elepto,angmue
      common/lept1/engy,elepti,elepto,angmue,icinpu
      real egymin,egymax,elab,ecms,ekin
      common/enrgy/egymin,egymax,elab,ecms,ekin
C-----------------------------------------------------------------------
      DOUBLE PRECISION ELABN
      INTEGER J,NNEUT,NPROT
      SAVE
C-----------------------------------------------------------------------
```

###### 1.1.32.7.8.1. NSTORE

```fortran
SUBROUTINE NSTORE( ELABN )

C-----------------------------------------------------------------------
#if __EPOS__
C  EPOS PARTICLES STORE (INTO CORSIKA STACK)
#elif __NEXUS__
C  N(EXUS PARTICLES) STORE (INTO CORSIKA STACK)
#endif
C
C  STORES EPOS/NEXUS OUTPUT PARTICLES INTO CORSIKA STACK.
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

      integer mmry,mxptl
      parameter (mmry=1)   !memory saving factor
#if __EPOS__
C--------------------------- EPOS COMMON ------------------------------
      integer nevt,kolevt,npjevt,minfra,maxfra,nglevt,koievt,kohevt
     *,ntgevt,npnevt,nppevt,ntnevt,ntpevt,jpnevt,jppevt,jtnevt,jtpevt
      real phievt,bimevt,pmxevt,egyevt,xbjevt,qsqevt,zppevt,zptevt
      common/cevt/phievt,nevt,bimevt,kolevt,koievt,pmxevt,egyevt,npjevt
     *,ntgevt,npnevt,nppevt,ntnevt,ntpevt,jpnevt,jppevt,jtnevt,jtpevt
     *,xbjevt,qsqevt,nglevt,zppevt,zptevt,minfra,maxfra,kohevt
      parameter (mxptl=200000/mmry) !max nr of particles in nexus particle list
      integer      infragm,ibreit
      common/nucl6/infragm,ibreit
#elif __NEXUS__
C--------------------------- NEXUS COMMON ------------------------------
      integer nevt,kolevt,npjevt
     *,ntgevt,npnevt,nppevt,ntnevt,ntpevt,jpnevt,jppevt,jtnevt,jtpevt
      real phievt,bimevt,pmxevt,egyevt,xbjevt,qsqevt
      common/cevt/phievt,nevt,bimevt,kolevt,pmxevt,egyevt,npjevt
     *,ntgevt,npnevt,nppevt,ntnevt,ntpevt,jpnevt,jppevt,jtnevt,jtpevt
     *,xbjevt,qsqevt
      parameter (mxptl=50000/mmry) !max nr of particles in nexus particle list
#endif
      integer nptl,iorptl,idptl,ifrptl,jorptl,istptl,ibptl,ityptl
      real pptl,tivptl,xorptl
      common/cptl/nptl,pptl(5,mxptl),iorptl(mxptl),idptl(mxptl)
     *,istptl(mxptl),tivptl(2,mxptl),ifrptl(2,mxptl),jorptl(mxptl)
     *,xorptl(4,mxptl),ibptl(4,mxptl),ityptl(mxptl)
      integer laproj,maproj,latarg,matarg
      real core,fctrmx
      common/nucl1/laproj,maproj,latarg,matarg,core,fctrmx
C-----------------------------------------------------------------------
      DOUBLE PRECISION EA,ELABN,ELASTI,EMAX,COSTET,PL2,PT2,PTM
CC    DOUBLE PRECISION GAMMAX
      DOUBLE PRECISION PFRX(60),PFRY(60),PTOT,CPHIV,SPHIV
      DOUBLE PRECISION FAC1,FAC2
      REAL             ETOT,GNU
      INTEGER          ITYP(60),NREST,IREST,NNEW,INEW,NZNEW,NNNEW,I,
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

c  particle variables:
c     i ............. particle number
c     idptl(i) ...... particle id
c     pptl(1,i) ..... x-component of particle momentum
c     pptl(2,i) ..... y-component of particle momentum
c     pptl(3,i) ..... z-component of particle momentum
c     pptl(4,i) ..... particle energy
c     pptl(5,i) ..... particle mass
c     iorptl(i) ..... particle number of father
c     jorptl(i) ..... particle number of mother
c     ifrptl(1,i) ... particle number of first child
c     ifrptl(2,i) ... particle number of last child
c     istptl(i) ..... generation flag: last gen.(0) or not(1) or ghost(2)
c     xorptl(1,i) ... x-component of formation point
c     xorptl(2,i) ... y-component of formation point
c     xorptl(3,i) ... z-component of formation point
c     xorptl(4,i) ... formation time
c     tivptl(1,i) ... formation time (always in the pp-cms!)
c     tivptl(2,i) ... destruction time (always in the pp-cms!)
c     ityptl(i)  .....from target (10-19), soft (20-29), hard (30-39),
c                     projectile (40-49) string, droplet (50)
c     idiptl(i) ..... id of father (999 if no father)
c     idjptl(i) ..... id of mother (999 if no mother)
```

##### 1.1.32.7.9. QGSLNK

```FORTRAN
SUBROUTINE QGSLNK

C-----------------------------------------------------------------------
C  Q(UARK) G(LUON) S(TRING JET MODEL) L(I)NK (TO CORSIKA)
C
C  LINKS QGSJET MODEL TO CORSIKA.
C  THIS SUBROUTINE IS CALLED FROM SDPM.
C-----------------------------------------------------------------------
```

##### 1.1.32.7.10. SIBLNK

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

##### 1.1.32.7.11. VENLNK

```FORTRAN
SUBROUTINE VENLNK

C-----------------------------------------------------------------------
C  VEN(US) L(I)NK (TO CORSIKA)
C
C  LINKS VENUS PACKAGE TO CORSIKA, NEEDS FIRST CALL OF VENINI.
C  THIS SUBROUTINE IS CALLED FROM SDPM.
C-----------------------------------------------------------------------
```

###### 1.1.32.7.11.1. VSTORE

```fortran
SUBROUTINE VSTORE

c-----------------------------------------------------------------------
c  v(enus particles) store (into corsika stack)
c
c  stores venus output particles into corsika stack.
c  this subroutine is called from venlnk.
c-----------------------------------------------------------------------

#define __CONSTAINC__
#define __DPMFLGINC__
#define __ELADPMINC__
#define __ELASTYINC__
#define __INTERINC__
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

      PARAMETER (KOLLMX=2500)
      PARAMETER (MXPTL=70000)
      PARAMETER (MXSTR=3000)
      PARAMETER (NDEP=129)
      PARAMETER (NDET=129)
      COMMON /ACCUM/   AMSAC,ILAMAS,IMSG,INOIAC,IPAGE,JERR,NAEVT,NREVT
     *                ,NRPTL,NRSTR,NTEVT
      COMMON /CEVT/    BIMEVT,COLEVT,EGYEVT,PHIEVT,PMXEVT
     *                ,KOLEVT,NEVT,NPJEVT,NTGEVT
      COMMON /COL/     BIMP,BMAX,COORD(4,KOLLMX),DISTCE(KOLLMX)
     *                ,QDEP(NDEP),QDET14(NDET),QDET16(NDET),QDET40(NDET)
     *                ,QDET99(NDET),RMPROJ,RMTARG(4),XDEP(NDEP)
     *                ,XDET14(NDET),XDET16(NDET),XDET40(NDET)
     *                ,XDET99(NDET)
     *                ,KOLL,LTARG,NORD(KOLLMX),NPROJ,NRPROJ(KOLLMX)
     *                ,NRTARG(KOLLMX),NTARG
      COMMON /CPTL/    PPTL(5,MXPTL),TIVPTL(2,MXPTL),XORPTL(4,MXPTL)
     *                ,IBPTL(4,MXPTL),ICLPTL(MXPTL),IDPTL(MXPTL)
     *                ,IFRPTL(2,MXPTL),IORPTL(MXPTL),ISTPTL(MXPTL)
     *                ,JORPTL(MXPTL),NPTL,NQJPTL(MXPTL)
      COMMON /CSTR/    PSTR(5,MXSTR),ROTSTR(3,MXSTR),XORSTR(4,MXSTR)
     *                ,ICSTR(4,MXSTR),IORSTR(MXSTR),IRLSTR(MXSTR),NSTR
      COMMON /FILES/   IFCH,IFDT,IFHI,IFMT,IFOP
      COMMON /PARO2/   AMPROJ,AMTARG,ANGMUE,ELEPTI,ELEPTO,ENGY
     *                ,PNLL,PNLLX,PROB(99),PROSEA,RHOPHI,TAUREA
     *                ,YHAHA,YMXIMI,YPJTL
     *                ,ICBAC(99,2),ICFOR(99,2),ICHOIC,ICLHIS,IDPM
     *                ,IDPROJ,IDTARG,IENTRO,IJPHIS,IMIHIS,IPAGI,ISH
     *                ,ISHEVT,ISHSUB,ISPALL,ISPHIS,ISTMAX,ISUP,IVI
     *                ,JPSI,JPSIFI,KUTDIQ,LAPROJ,LATARG,MAPROJ,MATARG
     *                ,MODSHO,NDECAX,NDECAY,NEVENT
      COMMON /PARO3/   ASUHAX(7),ASUHAY(7),OMEGA,SIGPPD,SIGPPE,UENTRO
     *                ,IWZZZZ

      DOUBLE PRECISION EA,ELASTI,EMAX,COSTET,PL2,PTOT,PT2,PTM
      DOUBLE PRECISION FAC1,FAC2
CC    DOUBLE PRECISION GAMMAX
      DOUBLE PRECISION PFRX(60),PFRY(60),CPHIV,SPHIV
      INTEGER          ITYP(60),NRPTLA(MXPTL),LL
#if __EHISTORY__
      INTEGER          IK
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
      SAVE
#if __AUGERHIST__
      DOUBLE PRECISION EDEP,THICKLOC,THICK
      INTEGER          II
      EXTERNAL         THICK
#endif
C-----------------------------------------------------------------------
C  EVENT VARIABLES:
C     LEVT................... RECORD LABEL (LEVT=1)
C     NREVT.................. EVENT NUMBER
C     NPTLS ................. NUMBER OF (STORED!) PARTICLES PER EVENT
C     BIMEVT ................ IMPACT PARAMETER
C     KOLEVT,COLEVT ......... REAL/EFFECTIVE # OF COLLISIONS
C     PMXEVT ................ REFERENCE MOMENTUM
C     EGYEVT ................ PP CM ENERGY (HAD) OR STRING ENERGY (STR)
C     NPJEVT,NTGEVT ......... # OF PROJ/TARG PARTICIPANTS
C----------------------------------------------------------------------
C  PARTICLE VARIABLES:
C     LPTL ......... RECORD LABEL (LPTL=3)
C     NREVT ........ EVENT NUMBER
C     NRPTL ........ PARTICLE NUMBER
C     I ............ ORIGINAL PTL NUMBER
C     IDPTL ........ PARTICLE ID
C     PPTL ......... 5-MOMENTUM (PX,PY,PZ,EN,MASS) IN LAB
C     IOPTL ........ ORIGIN (-999:PARENT NOT STORED, -1,0:NO PARENT)
C     JOPTL ........ ORIGIN (SECOND PARENT)
C     ISTPTL ....... STABLE (=0) OR NOT (=1)
C     XORPTL ....... SPACE-TIME POINT (X,Y,Z,T) ON PTL TRACK (PP-CM)
C     TIVPTL ....... TIME INTERVAL OF EXISTENCE
C     NQJPTL ....... QUARK NUMBERS OF JETS
```

##### 1.1.32.7.12. RMMARD

```fortran
SUBROUTINE RMMARD( RVEC,LENV,ISEQ )

c-----------------------------------------------------------------------
c  r(ando)m (number generator of) mar(saglia type) d(ouble precision)
c
c  these routines (rmmard,rmmaqd) are modified versions of routines
c  from the cern libraries. description of algorithm see:
c   http://wwwasdoc.web.cern.ch/wwwasdoc/cernlib.html (v113)
c  it has been checked that results are bit-identical with cern
c  double precision random number generator rmm48, described in
c   http://wwwasdoc.web.cern.ch/wwwasdoc/cernlib.html (v116)
c  arguments:
c   rvec   = double prec. vector field to be filled with random numbers
c   lenv   = length of vector (# of randnumbers to be generated)
c   iseq   = # of random sequence
c
c  version of d. heck for double precision random numbers.
C-----------------------------------------------------------------------
```

#### 1.1.32.8. STRDEC

```fortran
SUBROUTINE STRDEC

c-----------------------------------------------------------------------
c  str(ange baryon) dec(ay)
c
c  routine treates decay of strange baryons (lambda, sigma, xi, omega)
c  decay with full kinematic, energy and momenta conserved.
c  this subroutine is called from nucint.
c-----------------------------------------------------------------------
```

#### 1.1.32.9. THICK

```fortran
DOUBLE PRECISION FUNCTION THICK( ARG )

c-----------------------------------------------------------------------
c  thick(ness of atmosphere)
c
c  calculates thickness (g/cm**2) of atmosphere depending on height (cm)
c  this function is called from aamain, box2, box3, em, inprm, mubrem,
c  mudecy, muprpr, mutrac, nrangc, nucint, prangc, start, updatc,
c  update, egs4, electr, howfar, photon, ininkg, nkg, and cerenk.
c  argument:
c   arg    = height (cm)
c-----------------------------------------------------------------------
```

#### 1.1.32.10. CGHEI

```fortran
SUBROUTINE CGHEI

c-----------------------------------------------------------------------
c  c(orsika) ghe(isha) i(nterface)
c
c  main steering subrout. for hadron package gheisha ***
c  this subroutine is called from nucint.
c
c  origin  : f.carminati, h.fesefeldt (subrout. ghesig)
c  redesign: p. gabriel ik1  fzk karlsruhe
c-----------------------------------------------------------------------
```

#### 1.1.32.11. URQLNK

```fortran
SUBROUTINE URQLNK

c-----------------------------------------------------------------------
c  urq(md) l(i)nk (with corsika)
c
c  links urqmd model to corsika to perform collisions.
c  this subroutine is called from nucint and sdpm.
c-----------------------------------------------------------------------
```

#### 1.1.32.12. PYTDCSET

```fortran
SUBROUTINE PYTDCSET

c-----------------------------------------------------------------------
c  pyt(hia) d(e)c(ay) set
c
c  pytdcset declares charmed (and bottom) particles stable
c  this subroutine is called from heparin, nucint, and pytini.
c-----------------------------------------------------------------------
```

#### 1.1.32.13. ADDANG

```FORTRAN
SUBROUTINE ADDANG( COST0,PHI0, COST,PHI, COST1,PHI1 )

C-----------------------------------------------------------------------
C  ADD(ITION OF) ANG(LES)
C
C  ADDITION OF ANGLES IS DONE BY SEQUENTIAL ROTATIONS :
C    1. ROTATE VECTOR AROUND Z AXIS BY -PHI0
C    2. ROTATE VECTOR AROUND Y AXIS BY -THETA0  NOW VECTOR IS (0,0,1)
C
C    3. ROTATE VECTOR AROUND Y AXIS BY  THETA ANGLES TO BE ADDED
C    4. ROTATE VECTOR AROUND Z AXIS BY  PHI
C
C    5. ROTATE VECTOR AROUND Y AXIS BY  THETA0
C    6. ROTATE VECTOR AROUND Z AXIS BY -PHI0
C              NOW VECTOR IS (X,Y,Z) WITH COST1     = Z
C                                     AND TAN(PHI1) = Y/X
C  THIS SUBROUTINE IS CALLED FROM MANY ROUTINES.
C  ARGUMENTS:
C   COST0  = COSINE THETA OF PARTICLE BEFORE
C   PHI0   = PHI          OF PARTICLE BEFORE
C   COST   = COSINE THETA OF ANGLE TO ADD
C   PHI    = PHI          OF ANGLE TO ADD
C   COST1  = COSINE THETA OF PARTICLE AFTER ADDITION OF ANGLES
C   PHI1   = PHI    THETA OF PARTICLE AFTER ADDITION OF ANGLES
C-----------------------------------------------------------------------
```

### 1.1.33. OUTEND

```fortran
SUBROUTINE OUTEND

c-----------------------------------------------------------------------
c  out(put at) end (of shower)
c
c  write rest of particles to output buffer.
c  prints interaction lengths statistics.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.34. PRESHO

```FORTRAN
SUBROUTINE PRESHO( PRESTART,PREHEIGH )

c-----------------------------------------------------------------------
c  presho(wer linking routine)
c
c  this subroutine makes the link with the preshower c-routines
c  of  p. homola (krakow) to simulate the interactions of an eev gamma
c  in the earth''s magnetic field far above the atmosphere.
c  this subroutine is called from aamain.
c  arguments:
c   prestart =  starting altitude of gamma preshower (cm)
c   preheigh =  first interaction in earth magnetic field (cm)
c-----------------------------------------------------------------------
```

### 1.1.35. SOURCEPATH

```FORTRAN
SUBROUTINE SOURCEPATH( TSTEPS,THETAP,PHIP )

c-----------------------------------------------------------------------
c  calculates the source path in angles thetap and phip
c  for consecutive steps tsteps.
c  this subroutine is called from aamain.
c  arguments:
c   tsteps  = maximum number of step (events to be simulated) (in)
c   thetap  = zenith angle  (in rad)(out)
c   phip    = azimuth angle (in rad)(out)
c-----------------------------------------------------------------------
```

### 1.1.36. START

```FORTRAN
SUBROUTINE START

c-----------------------------------------------------------------------
c  start
c
c  prints header and all selected options
c  performs initializations and checks at the beginning of run.
c  calls datac to read in data cards.
c  initializes atmospheric models
c  checks and initializes selected hadronic interaction model.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.37. STCKIN

```FORTRAN
 SUBROUTINE STCKIN

c-----------------------------------------------------------------------
c  st(a)ck in(put)
c
c  this subroutine reads in the list of secondaries of an exotic
c  interaction and stores the secondary particles onto stack to
c  treat them as one single shower.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.38. THICKC

```FORTRAN
DOUBLE PRECISION FUNCTION THICKC( ARG )

c-----------------------------------------------------------------------
c  thick(ness in case of) c(urved atmosphere)
c
c  calculates the atmospheric thickness at interaction point in curved
c  coordinate system after transporting the particle by chi g/cm**2.
c  this function is called from aamain.
c  argument:
c   arg    = penetrated matter thickness in curved atmosphere (g/cm**2)
c
c  redesign: d. heck      ik   fzk karlsruhe
c-----------------------------------------------------------------------
```

### 1.1.39. TRAJCHECK

```FORTRAN
SUBROUTINE TRAJCHECK

c-----------------------------------------------------------------------
c  traj(ectory input) check
c  checks the input parameters of the trajectory key words.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.40. AVAGE

```FORTRAN
SUBROUTINE AVAGE

c-----------------------------------------------------------------------
c  ave(erage) age
c
c  calculates average age as a function of radius.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.41. ININKG

```FORTRAN
SUBROUTINE ININKG

c-----------------------------------------------------------------------
c  ini(tialize) nkg
c
c  initializes arrays for nkg calculating variables.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.42. MITAGE

```FORTRAN
SUBROUTINE MITAGE

c-----------------------------------------------------------------------
c  mit(telwert) age   (average age)
c
c  calculates average distribution for nkg function over all showers.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.43. STANKG

```FORTRAN
SUBROUTINE STANKG

c-----------------------------------------------------------------------
c  sta(rt) nkg
c
c  initializes arrays for single showers nkg calculated variables.
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.44. CONEXINI

```FORTRAN
SUBROUTINE CONEXINI

c-----------------------------------------------------------------------
c  conex ini(tialization)
c
c  this subroutine transfer to conex all parameters which can be taken
c  from corsika and common to all events.
c  conex is only compatible with the curved option (for geometry
c  compatibility)
c  this subroutine is called from aamain.
c  arguments:
c-----------------------------------------------------------------------
```

### 1.1.45. CONEXLNK

```FORTRAN
SUBROUTINE CONEXLNK( THICK1,CHISUM,CHISM2 )

c-----------------------------------------------------------------------
c  conex l(i)nk
c
c  this subroutine calls conex to simulate the shower from the first
c  interaction until the end of cascade equations and stores the secondary
c  particles onto stack to treat them as one single shower.
c  this subroutine is called from aamain.
c  arguments:
c   thick1 = thickness of first interaction (g/cm**2)
c   chisum = sum of thickness of first interaction (g/cm**2)
c   chism2 = square of chisum
c-----------------------------------------------------------------------
```

### 1.1.46. GETBUS

```FORTRAN
SUBROUTINE GETBUS( IPARTI,ENERGYP,THETAP,CERSZE )

c-----------------------------------------------------------------------
c  get bu(nch) s(ize)
c
c  calculates optimal bunch size for cherenkov photons. cherenkov photons
c  are grouped in bunches in order to accelerate computing time.
c  however, we set a maximal value for the grouping of cherenkov photons
c  so that we get at least 100 bunches/m**2 at a cherenkov flux of 3000
c  photons/m**2. this is the minimum cherenkov flux which can be
c  distinguished from the night sky light background in the hegra
c  experiment at the island la palma. so the parameterization of the
c  cherenkov bunch as calculated in this subroutine is valid for
c  observation levels similar to that of the hegra experiment.
c     for a given primary particle, incident energy and angle, an
c  optimal bunch size is calculated by interpolation in a table,
c  where we have chosen an energy range up to 1000 tev, incident
c  angles 0 and 40 degrees, and 4 types of primaris: gammas,
c  protons, nitrogen, and iron.
c  this subroutine is called from aamain.
c  arguments:
c   iparti = type of primary particle
c   energyp= particles energy (gev)
c   thetap = angle (rad)
c   cersze = size of cherenkov bunch
c-----------------------------------------------------------------------
```

### 1.1.47. OUTND2

```FORTRAN
SUBROUTINE OUTND2

c-----------------------------------------------------------------------
c  out(put at e)nd (of shower)
c
c  write rest of particles to output buffer
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.48. AHISTOUT

```FORTRAN
SUBROUTINE AHISTOUT

c-----------------------------------------------------------------------
#if __anahist__
c  a(nalyse) hist(ogram) out
c
c  writes out histogramming of shower analysis
#endif
#if __augerhist__
c  a(uger) hist(ogram) out
c
c  writes out histogramming to follow the evolution of showers
c  for the auger experiment.
#endif
#if __muonhist__
c  
c  writes out histogramming of muons in the shower development
#endif
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.49. AUGERHISTNORM

```FORTRAN
SUBROUTINE AUGERHISTNORM( JJSHOW )

c-----------------------------------------------------------------------
c  auger hist(ogram) norm(alization)
c
c  this subroutine is called from aamain.
c  argument:
c   jjshow = number of showers
c-----------------------------------------------------------------------
```

### 1.1.50. LNGHSTINI

```FORTRAN
SUBROUTINE LNGHSTINI

c-----------------------------------------------------------------------
c  l(o)ng(itudinal) h(i)st(ogram) ini(tialization)
c
c  opens longitudinal histograms
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.51. LONGIHIST

```FORTRAN
SUBROUTINE LONGIHIST

c-----------------------------------------------------------------------
c  longi(tudinal) hist(ogram)
c
c  fills longitudinal histograms
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.52. MUONHISTFIL

```FORTRAN
SUBROUTINE MUONHISTFIL

c-----------------------------------------------------------------------
c  muon hist(ogram) fil(ling)
c
c  fills histograms for muonhist option.
c  see : l. cazon et al., astropart. phys. 36(2012)211
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.53. HISFIL

```FORTRAN
SUBROUTINE HISFIL

c-----------------------------------------------------------------------
c  his(togram) fil(ling)
c
c  fill the histograms
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.54. HISOUT

```FORTRAN
SUBROUTINE HISOUT

c-----------------------------------------------------------------------
c  his(togram) out(put)
c
c  output of the histograms on disk
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.55. HISPRP

```FORTRAN
SUBROUTINE HISPRP

c-----------------------------------------------------------------------
c  his(togram) pr(e)p(aration)
c  gathers particles of one collision
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.56. HISRES

```FORTRAN
SUBROUTINE HISRES

c-----------------------------------------------------------------------
c  his(togram) res(et)
c
c  reset histogramming for one event
c  this subroutine is called from aamain.
c-----------------------------------------------------------------------
```

### 1.1.57. HISTRA

```FORTRAN
SUBROUTINE HISTRA( FLAG )

c-----------------------------------------------------------------------
c  his(togram) tra(nsformation)
c
c  lorentz transform quantities from lab into the desired system
c  (transformation along the vertical direction)
c  this subroutine is called from aamain.
c  argument :
c   fkag  = indicating if transformation was successful
c-----------------------------------------------------------------------
```

### 1.1.58. TSTACK

```fortran
SUBROUTINE TSTACK

C-----------------------------------------------------------------------
C  T(O) STACK
C
C  ADDS PARTICLE TO INTERMEDIATE STACK UNTIL REACTION IS FINISHED.
C  ONLY PARTICLES ABOVE ENERGY CUT ARE TAKEN TO STACK.
C  THIS SUBROUTINE IS CALLED FROM MANY ROUTINES  ALL OVER THE PROGRAM.
C-----------------------------------------------------------------------
```

### 1.1.59. VAPOR

```fortran
SUBROUTINE VAPOR( MAPROJ,INEW,JFIN,ITYP,PFRX,PFRY )

C-----------------------------------------------------------------------
C  (E)VAPOR(ATION OF NUCLEONS AND ALPHA PARTICLES FROM FRAGMENT)
C
C  TREATES THE REMAINING UNFRAGMENTED NUCLEUS
C  EVAPORATION FOLLOWING CAMPI APPROXIMATION.
C  SEE: X. CAMPI AND J. HUEFNER, PHYS.REV. C24 (1981) 2199
C  AND  J.J. GAIMARD, THESE UNIVERSITE PARIS 7, (1990)
C  THIS SUBROUTINE IS CALLED FROM SDPM, DPMJST, NSTORE, AND VSTORE.
C  ARGUMENTS INPUT:
C   MAPROJ       = NUMBER OF NUCLEONS OF PROJECTILE
C   INEW         = PARTICLE TYPE OF SPECTATOR FRAGMENT
C  ARGUMENTS OUTPUT:
C   JFIN         = NUMBER OF FRAGMENTS
C   ITYP(1:JFIN) = NATURE (PARTICLE CODE) OF FRAGMENTS (GEANT)
C   PFRX(1:JFIN) = TRANSVERSE MOMENTUM OF FRAGMENTS IN X-DIRECTION (GEV)
C   PFRY(1:JFIN) = TRANSVERSE MOMENTUM OF FRAGMENTS IN Y-DIRECTION (GEV)
C-----------------------------------------------------------------------
```

### 1.1.60. ADDANG4

```fortran
SUBROUTINE ADDANG4( COST0,CPHI0,SPHI0, COST,CPHI,SPHI,
     *                                            COST1,CPHI1,SPHI1 )

C-----------------------------------------------------------------------
C  ADD(ITION OF) ANG(LES)
C
C  THIS SUBROUTINE IS CALLED FROM MANY ROUTINES.
C  ARGUMENTS:
C   COST0  =  COSINE THETA       OF PARTICLE BEFORE
C   CPHI0  =  DIRECTION COS IN X OF PARTICLE BEFORE
C   SPHI0  = -DIRECTION COS IN Y OF PARTICLE BEFORE
C   COST   =  DIRECTION COSINE THETA    OF ANGLE TO ADD
C   CPHI   =  DIRECTION COSINE PHI      OF ANGLE TO ADD
C   SPHI   =  DIRECTION COSINE PHI      OF ANGLE TO ADD
C   COST1  =  COSINE THETA       OF PARTICLE AFTER ADDITION OF ANGLES
C   CPHI1  =  DIRECTION COS IN X OF PARTICLE AFTER ADDITION OF ANGLES
C   SPHI1  = -DIRECTION COS IN Y OF PARTICLE AFTER ADDITION OF ANGLES
C-----------------------------------------------------------------------
```

### 1.1.61. AUGERDEPFIL

```fortran
SUBROUTINE AUGERDEPFIL( EDEP,LL,ICUT )

C-----------------------------------------------------------------------
C  AUGER DEP(OSIT HISTOGRAM) FIL(LING)
C
C  TO BE USED IF PARTICLE IS STOPPED OR GOES BELOW ENERGY THRESHOLD
C  IN THE LAYER BELOW THE OBSERVATION LEVEL.
C  FILLING OF THE HISTOGRAMMING TO FOLLOW THE LONGITUDINAL
C  EVOLUTION OF SHOWERS FOR THE AUGER EXPERIMENT.
C  AT LEVEL LL THE ENERGY EDEP IS DEPOSITED. THE COORDINATES OF THE
C  STOPPED PARTICLE ARE AVAILABLE IN OUTPAR.
C  THIS SUBROUTINE IS CALLED FROM AAMAIN, EM, MUBREM, MUPRPR, TSTACK,
C  AUGACT, AUGCUT, AND AUGECT.
C  ARGUMENTS:
C   EDEP   = DEPOSITED ENERGY (GEV) (ALREADY CORRECTED BY WEIGHT)
C   LL     = NUMBER OF OBSERVATION LEVEL
C   ICUT   = 0 FOR ENERGY CUT, 1 FOR ANGULAR CUT
C-----------------------------------------------------------------------
```

### 1.1.62. RMMAQD

```fortran
SUBROUTINE RMMAQD( ISEED,ISEQ,CHOPT )

C-----------------------------------------------------------------------
C  SUBROUTINE FOR INITIALIZATION OF RMMARD
C  THESE ROUTINE RMMAQD IS A MODIFIED VERSION OF ROUTINE RMMAQ FROM
C  THE CERN LIBRARIES. DESCRIPTION OF ALGORITHM SEE:
C   http://wwwasdoc.web.cern.ch/wwwasdoc/cernlib.html (v113)
C  FURTHER DETAILS SEE SUBR. RMMARD
C  ARGUMENTS:
C   ISEED  = SEED TO INITIALIZE A SEQUENCE (3 INTEGERS)
C   ISEQ   = # OF RANDOM SEQUENCE
C   CHOPT  = CHARACTER TO STEER INITIALIZE OPTIONS
C            ' '  SEQUENCE 1 IS INITIALIZED WITH DEFAULT SEED
C            'R'  GET STATUS OF GENERATOR BY 3 SEEDS
C            'RV' COMPLETE STATUS OF GENERATOR IS DUMPED (103 WORDS)
C            'S'  SET RANDOM GENERATOR BY 3 SEEDS
C            'SV' SET RANDOM GENERATOR BY ARRAY WITH 103 WORDS
C            'V'  VECTOR OPTION SET/GET STATUS USING 103 WORDS
C-----------------------------------------------------------------------
```
