#!/bin/bash

i=2
seed1=100
seed2=100
seed3=100
rm ./UV_corsika/DAT* 
rm ./UV_corsika/result.txt
./corsika77400Linux_EPOS_urqmd <<EOF >./UV_corsika/result.txt
RUNNR   $i                             run number                                
NSHOW   2                             number of showers to generate
PRMPAR  14                            prim. particle (1=gamma, 14=proton, ...)
ESLOPE  -2.71                         slope of primary energy spectrum
ERANGE  1.01E9  1.01E9                    energy range of primary particle (GeV)
THETAP  0.  0.                        range of zenith angle (degree)
PHIP    0.  0.                   range of azimuth angle (degree)
SEED    $seed1   0   0                     seed for 1. random number sequence
SEED    $seed2   0   0                     seed for 2. random number sequence
SEED    $seed3   0   0                     seed for 3. random number sequence
OBSLEV  4424.E2                            observation level (in cm)
MAGNET  34.618  36.13                 magnetic field centr. Europe
HADFLG  0  0  0  0  0  2              flags hadr.interact.&fragmentation
ECUTS   9E6  9E6  9E6  9E6          energy cuts for particles
MUADDI  T                             additional info for muons
MUMULT  T                             muon multiple scattering angle
ELMFLG  T   F                         em. interaction flags (NKG,EGS)
STEPFC  1.0                           mult. scattering step length fact.
RADNKG  200.E2                        outer radius for NKG lat.dens.distr.
EPOS    T   0                         Open EPOS
EPOPAR input ../epos/epos.param        !initialization input file for epos                                                                              
EPOPAR fname inics ../epos/epos.inics  !initialization input file for epos                                                                              
EPOPAR fname iniev ../epos/epos.iniev  !initialization input file for epos                                                                              
EPOPAR fname initl ../epos/epos.initl  !initialization input file for epos                                                                              
EPOPAR fname inirj ../epos/epos.inirj  !initialization input file for epos                                                                              
EPOPAR fname inihy ../epos/epos.ini1b  !initialization input file for epos                                                                              
EPOPAR fname check none                !dummy output file for epos                                                                                     
EPOPAR fname histo none                !dummy output file for epos                                                                                     
EPOPAR fname data  none                !dummy output file for epos                                                                                     
EPOPAR fname copy  none                !dummy output file for epos   
LONGI   T  3.  F  F                  longit.distr. & step size & fit & outfile
ECTMAP  1.E2                          cut on gamma factor for printout
MAXPRT  10                             max. number of printed events
DIRECT  ./UV_corsika/                              output directory
*OUTFILE ./UV_corsika/inter1st.dat                  secondary particles of first interaction
USER    qinjian                        user 
DEBUG   T  6  F  1000000              debug flag and log.unit for outer
EXIT                                   terminates input
EOF

