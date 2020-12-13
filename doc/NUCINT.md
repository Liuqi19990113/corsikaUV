#### CHRMDC

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

#### ETADEC

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

#### HEPARIN

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

#### KDECAY

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

#### LBIN

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

#### PI0DEC

```fortran
SUBROUTINE PI0DEC

c-----------------------------------------------------------------------
c  pi 0 dec(ay)
c
c  decay of pi0 into 2 gammas or into e(+) + e(-) + gamma
c  this subroutine is called from nucint.
c-----------------------------------------------------------------------
```

#### SDPM

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
```

#### STRDEC

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

#### THICK

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

#### CGHEI

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

#### URQLNK

```fortran
SUBROUTINE URQLNK

c-----------------------------------------------------------------------
c  urq(md) l(i)nk (with corsika)
c
c  links urqmd model to corsika to perform collisions.
c  this subroutine is called from nucint and sdpm.
c-----------------------------------------------------------------------
```

#### PYTDCSET

```fortran
SUBROUTINE PYTDCSET

c-----------------------------------------------------------------------
c  pyt(hia) d(e)c(ay) set
c
c  pytdcset declares charmed (and bottom) particles stable
c  this subroutine is called from heparin, nucint, and pytini.
c-----------------------------------------------------------------------
```
