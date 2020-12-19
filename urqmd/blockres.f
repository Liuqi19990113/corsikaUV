c $Id: blockres.f 5115 2016-01-04 19:07:31Z darko $
      blockdata setres
cc itypes: 100 g,   101 pi, 102 eta, 103 om, 104 rho, 105 f_0(1370)
cc         106 K,   107 eta', 108 K*, 109 phi,
cc 0++     110 k_0*(1430), 111 a_0(980), 112 f_0(1370)
cc 1++     113 k_1(1270), 114 a_1(1260), 115 f_1(1285), 116 f_1(1420),
cc 2++     117 k_2(1430), 118 a_2(1320), 119 f_2(1270), 120 f_2'(1525)
cc 1+-     121 K_1(1400), 122 b_1(1235), 123 h_1(1170), 124 h_1'(1380)
cc 1--     125 K*(1410), 126 rho(1465), 127 om(1419), 128 phi(1680),
cc 1--     129 K*(1680), 130 rho(1700), 131 om(1662), 132 phi?(1900)
cc
cc (see 'Review of Particle Properties' Phys. Rev. D50 (1994)
cc  Phys. Rev. D54 (1996) and Eur. Phys. J. C3 (1998))
cc
      implicit none
      include 'comres.f'
      integer i, j, k

c set a string for the what and ident tools
      data versiontag/'@(#)$UrQMD: Version 1.3b (10035/10002) $'/
c channels, branching ratios, angular momentum of branches,
c etc.
c ALL of the beyond is sensitive to the parameters defined in comres.f

      data massres/0.938,
c Nucleon resonances
     @             1.440,1.515,1.550,1.645,1.675,1.680,
     @             1.730,1.710,1.720,1.850,1.950,2.000, 2.150,
     @             2.220,2.250,
c Delta (and resonances)(Particle Data Group)
c     @             1.232,1.600,1.620,1.700,1.900,1.905,
c     @             1.910,1.920,1.930,1.950,
c Delta (and resonances)
     @             1.232,1.700,1.675,1.750,1.840,1.880,
     @             1.900,1.920,1.970,1.990,
c Lambda (and resonances)
     @             1.116,1.407,1.520,1.600,1.670,1.690,
     @             1.800,1.810,1.820,1.830,1.890,2.100,
     @             2.110,
c Sigma (and resonances)
     @             1.192,1.384,1.660,1.670,1.750,1.775,
     @             1.915,1.940,2.030,
c Xi (and resonances)
     @             1.315,1.532,1.700,1.823,1.950,2.025,
c     @             1.315,1.532,1.690,1.823,1.950,2.025,
c Omega
     @             1.672/

      data widres/ 0.d0,
c Nucleon resonances
     @             0.350,0.120,0.140,0.160,0.140,0.120,
     @             0.120,0.140,0.150,0.500,0.550,0.350,0.500,
     @             0.550,0.470,
c Delta (and resonances)(Particle-Data-Group)
c     @             0.120,0.350,0.150,0.300,0.200,0.350,
c     @             0.250,0.200,0.350,0.300,
c Delta (and resonances)
     @             0.115,0.350,0.160,0.350,0.260,0.350,
     @             0.250,0.200,0.350,0.350,
c Lambda (and resonances)
     @             0.,0.050,0.016,0.150,0.035,0.060,
     @             0.300,0.150,0.080,0.095,0.100,0.200,
     @             0.200,
c Sigma (and resonances)
     @             0.,0.036,0.100,0.060,0.090,0.120,
     @             0.120,0.220,0.180,
c Xi (and resonances)
     @             0.,0.009,0.05,0.024,0.06,0.02,
c Omega
     @             0./

      data massmes/
c         g     pi    eta   omega   rho   f_0(980)  K
     & 0.000, 0.138, 0.547, 0.782, 0.769, 0.990,    0.494,
c                    eta'   K*     phi
     @             0.958, 0.893, 1.019,
c 0++ scalar  k_0*(1430), a_0(980), f_0(1370)
     @        1.429,      .990,     1.370,
c 1++         k_1(1270),a_1(1260),f_1(1285),f_1(1420)
     @        1.273,    1.230,    1.282,    1.426,
c 2++  tensor k_2*(1430),a_2(1320),f_2(1270),f_2'(1525)
     @        1.430,     1.318,    1.275,    1.525,
c 1+-	        K_1(1400) b1     h1      h1'
     @	  1.400,    1.235, 1.170,  1.386,
c 1--    K    rho   omega phi
     &  1.410,1.465,1.419,1.681,
     &  1.680,1.720,1.649,1.910/ 

      data widmes /
c          g    pi  eta   omega   rho   f_0(980)  K
     &    0.0, 0.0, 0.0, 8.43e-3 ,0.151, 0.1,    0.0,
c                    eta'      K*      phi
     @             0.201e-3, 50.e-3, 4.43e-3,
c 0++	scalar  k_0*(1430), a_0(980), f_0(1370)
     @         .287,        .100,       .200,
c 1++	pseudo-vector k_1(1270),a_1(1260),f_1(1285),f_1(1420)
     @             .090,     .400,      .024,       .055,
c 2++	tensor     k_2*(1430),a_2(1320),f_2(1270),f_2'(1525)
     @          .100,       .107,     .185,     .076,
c 1+-	           k1(1400)	b1      h1    h1*
     @           0.174,    0.142,   0.36,   0.09,
c 1--    K    rho   omega phi
     &  0.227, 0.310, 0.174, 0.150,
     &  0.323, 0.240, 0.220, 0.090/

c      Spins of resonances and mesons (multiplied by two):

      data Jres/      1,
     @                1,    3,    1,    1,    5,    5,
     @                3,    1,    3,    3,    7,    3,   7,
     @                9,    9,
     D                3,    3,    1,    3,    1,    5,
     @                1,    3,    5,    7,
     L                1,    1,    3,    1,    1,    3,
     @                1,    1,    5,    5,    3,    7,   5,
     S                1,    3,    1,    3,    1,    5,
     @                5,    3,    7,
     X                1,    3,    3,    3,    3,    5,
     O                3 /

      data Jmes/ 2,0,0,2,2,0,0,0,2,2,0,0,0,2,2,2,2,4,4,4,4,2,2,2,2,
c 1--
     &     2,2,2,2,2,2,2,2/

c      Parities of resonances and mesons:

      data Pares/      1,
     @                1,   -1,   -1,   -1,   -1,    1,
     @               -1,    1,    1,    1,    1,   -1,  -1,
     @                1,   -1,
     D                1,    1,   -1,   -1,   -1,    1,
     @                1,    1,   -1,    1,
     L                1,   -1,   -1,    1,   -1,   -1,
     @               -1,    1,    1,   -1,    1,   -1,   1,
     S                1,    1,    1,   -1,   -1,   -1,
     @                1,   -1,    1,
c some Xi parities are unknown     ?           ?     ?
     X                1,    1,    1,   -1,    1,    1,
     O                1 /

c                 g  pi et om rh si k  et k* ph k0* a0 f0 k1 a1 f1 f1*
      data Pames/ -1,-1,-1,-1,-1, 1,-1,-1,-1,-1, 1, 1, 1, 1, 1, 1,  1,
c                 k2 a2 f2* f2' k1 b1 h1 h1* rh* rh* om* om*
     &             1, 1, 1,  1,  1, 1, 1,  1,
c 1--    (incl. rh* rh* om* om*)
     &  -1,  -1,  -1,  -1,  -1,  -1,  -1,  -1/

c

c       Isospins of resonances and mesons (multiplied by two)

      data Isores/    1,
     @                1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
     d                3,3,3,3,3,3,3,3,3,3,
     l                0,0,0,0,0,0,0,0,0,0,0,0,0,
     s                2,2,2,2,2,2,2,2,2,
     x                1,1,1,1,1,1,
     o                0/
      data Isomes/ 0,2,0,0,2,0,1,0,1,0,1,2,0,1,2,0,0,1,2,0,0,1,2,0,0,
c 1-- 
     &  1,2,0,0,1,2,0,0/
c     &     2,2,0,0/

c strres gives the number of strange quarks for baryons
c        (switch sign for anti-part.)
      data strres/ 26*0,13*1,9*1,6*2,3/
c strmes gives the number of strange quarks for mesons
c        (switch sign for anti-part.)
      data strmes/ 6*0,-1,0,-1,0,-1,0,0,-1,0,0,0,-1,0,0,0,-1,0,0,0,
c 1--
     &  -1,0,0,0,-1,0,0,0/
c     &     0,0,0,0/


c meson id's sorted by multipletts
      data mlt2it/
     &     101, 106, 102, 107,
     &     104, 108, 103, 109,
     &     111, 110, 105, 112,
     &     114, 113, 115, 116,
     &     118, 117, 119, 120,
     &     122, 121, 123, 124,
     &     126, 125, 127, 128,
     &     130, 129, 131, 132/


c      the decay branches have different angular momentum
C     gN,piN,etN,omN,rhN,pipiN,piD,piN*,KL,KS,f0N,a0N
c  now some n*'s
      data lbr/
     &  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
     &  0, 2, 2, 0, 0, 2, 0, 2, 2, 2, 1, 1,
     &  0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1, 1,
     &  0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1, 1,
     &  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3,
     &  1, 3, 3, 1, 1, 3, 1, 3, 3, 3, 2, 2,
     &  0, 2, 2, 0, 0, 2, 0, 2, 2, 2, 1, 1,
     &  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
     &  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
     &  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
     &  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4,
     &  0, 2, 2, 0, 0, 2, 0, 2, 2, 2, 1, 1,
     &  2, 4, 4, 2, 2, 4, 2, 4, 4, 4, 3, 3,
     &  3, 5, 5, 3, 3, 5, 3, 5, 5, 5, 4, 4,
     &  4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5,


c d,d*
     &  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
     &  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
     &  0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1, 1,
     &  0, 2, 2, 0, 0, 2, 0, 2, 2, 2, 1, 1,
     &  0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1, 1,
     &  1, 3, 3, 1, 1, 3, 1, 3, 3, 3, 2, 2,
     &  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
     &  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
     &  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3,
     &  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4/


         data lbs1/
c orbital angular momentum of decays (baryons with s=1)
c       _  _                                                 _
c      NK NK892 Sipi Si*pi gLa  etLa omLa Lapi etSi La*pi DelK
c lambda*'s
     & 0,   0,   0,   2,   0,   0,   0,   0,   0,   1,   2,
     & 2,   0,   2,   0,   0,   2,   0,   2,   2,   1,   0,
     & 1,   1,   1,   1,   1,   1,   1,   1,   1,   2,   1,
     & 0,   0,   0,   2,   0,   0,   0,   0,   0,   1,   2,
     & 2,   0,   2,   0,   0,   2,   0,   2,   2,   1,   0,
     & 0,   0,   0,   2,   0,   0,   0,   0,   0,   1,   2,
     & 1,   1,   1,   1,   1,   1,   1,   1,   1,   2,   1,
     & 3,   1,   3,   1,   1,   3,   1,   3,   3,   2,   1,
     & 2,   2,   2,   2,   2,   2,   2,   2,   2,   1,   2,
     & 1,   1,   1,   1,   1,   1,   1,   1,   1,   0,   1,
     & 4,   2,   4,   2,   2,   4,   2,   4,   4,   3,   2,
     & 3,   1,   3,   1,   1,   3,   1,   3,   3,   2,   1,
c sigma's
     & 1,   1,   1,   1,   1,   1,   1,   1,   1,   2,   1,
     & 1,   1,   1,   1,   1,   1,   1,   1,   1,   0,   1,
     & 1,   1,   1,   1,   1,   1,   1,   1,   1,   2,   1,
     & 2,   0,   2,   0,   0,   2,   0,   2,   2,   1,   0,
     & 0,   0,   0,   2,   0,   0,   0,   0,   0,   1,   2,
     & 2,   2,   2,   2,   2,   2,   2,   2,   2,   1,   2,
     & 3,   1,   3,   1,   1,   3,   1,   3,   3,   2,   1,
     & 2,   0,   2,   0,   0,   2,   0,   2,   2,   1,   0,
     & 3,   3,   3,   3,   3,   3,   3,   3,   3,   2,   3/


        data lbs2/
c orbital angular momentum of decays (baryons with s=2)
     &  1,  1,  1,  1,
     &  1,  1,  1,  1,
     &  2,  0,  2,  2,
     &  1,  1,  1,  1,
     &  3,  1,  3,  3/

        data lbm/
c orbital angular momentum of meson decays
c (9 stands for 'forbidden', branching ratio should be zero!)
C     gg   gpi grho    gome geta gK   2pi pirho pisi pieta sisi
c      0     1    2     3    4    5    6   7    8    9     10
c     rhet etsig 2rho rhom  2eta  KK  KK* Kpi  K*pi  Krho kome K*K ompi
c      11    12   13    14   15   16   17   18   19   20   21 22 23
c
C     gg   gpi  grho    gome geta gK   2pi pirho 3pi pieta 4pi KK* K*K
c      0     1    2     3    4    5    6   7    8    9     10  11  12
c    et2pi etrho rho2pi om2pi 2eta KK  2Kpi Kpi  K*pi Krho kom K*2pi ompi
c      13    14   15    16   17   18   19   20   21   22   23  24  25
c                      8   10  121314  1617  19      23
     & 1,1,1,1,1,1,9,1,9,9,9,1,1,9,1,1,1,9,9,9,9,1,1,1,1,1, !101
     & 1,1,1,1,1,1,9,1,9,9,9,1,1,9,1,1,1,9,9,9,9,1,1,1,1,1, !102
     & 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, !103
     & 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, !104
     & 0,9,0,0,9,9,0,9,0,0,0,9,9,0,9,9,9,0,0,0,0,9,9,9,9,9, !105
     & 1,1,1,1,1,1,9,1,9,9,9,1,1,9,1,1,1,9,9,9,9,1,1,1,1,1, !106
     & 1,1,1,1,1,1,9,1,9,9,9,1,1,9,1,1,1,9,9,9,9,1,1,1,1,1, !107
     & 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, !108
     & 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, !109
c 0++
c                      8   10  121314  1617  19      23
     & 0,9,0,0,9,9,0,9,0,0,0,9,9,0,9,9,9,0,0,0,0,9,9,9,9,9, !110
     & 0,9,0,0,9,9,0,9,0,0,0,9,9,0,9,9,9,0,0,0,0,9,9,9,9,9,
     & 0,9,0,0,9,9,0,9,0,0,0,9,9,0,9,9,9,0,0,0,0,9,9,9,9,9,
c 1++
     & 0,0,0,0,0,0,9,0,9,9,9,0,0,9,0,0,0,9,9,9,9,0,0,0,0,0,
     & 0,0,0,0,0,0,9,0,9,9,9,0,0,9,0,0,0,9,9,9,9,0,0,0,0,0,
     & 0,0,0,0,0,0,9,0,9,9,9,0,0,9,0,0,0,9,9,9,9,0,0,0,0,0,
     & 0,0,0,0,0,0,9,0,9,9,9,0,0,9,0,0,0,9,9,9,9,0,0,0,0,0,
c 2++
     & 0,2,0,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
     & 0,2,0,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
     & 0,2,0,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
     & 0,2,0,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
c 1+-
C     gg   gpi grho    gome geta gK   2pi pirho pisi pieta sisi
c      0     1    2     3    4    5    6   7    8    9     10
c     rhet etsig 2rho rhom  2eta  KK  KK* Kpi  K*pi  Krho kome K*K ompi
c      11    12   13    14   15   16   17   18   19   20   21 22 23
c
C     gg   gpi  grho    gome geta gK   2pi pirho 3pi pieta 4pi KK* K*K
c      0     1    2     3    4    5    6   7    8    9     10  11  12
c    et2pi etrho rho2pi om2pi 2eta KK  2Kpi Kpi  K*pi Krho kom K*2pi ompi
c      13    14   15    16   17   18   19   20   21   22   23  24  25
c                      8   10  121314  1617  19      23
     & 0,0,0,0,0,0,9,0,9,9,9,0,0,9,0,0,0,9,9,9,9,0,0,0,0,0,
     & 0,0,0,0,0,0,9,0,9,9,9,0,0,9,0,0,0,9,9,9,9,0,0,0,0,0,
     & 0,0,0,0,0,0,9,0,9,9,9,0,0,9,0,0,0,9,9,9,9,0,0,0,0,0,
     & 0,0,0,0,0,0,9,0,9,9,9,0,0,9,0,0,0,9,9,9,9,0,0,0,0,0,
c 1--
     & 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
c 1--
     & 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
     & 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1/


        data branres/

Channels: gN   piN  etN  omN  rhN pipiN piD  piN* KL   KS   f0N  a0N  
c n* resonances
     a  4d-4, .65, .00, .00, .00, .10, .25, .00, .00, .00, .00, .00, !1440
     b 45d-4, .60, .00, .00, .15, .05, .20, .00, .00, .00, .00, .00, !1520
     c 45d-4, .60, .30, .00, .00, .05, .00, .05, .00, .00, .00, .00, !1535
     d 1d-3 , .60, .06, .00, .00, .10, .10, .05, .07, .02, .00, .00, !1650
     e 5d-5 , .40, .00, .00, .00, .00, .55, .05, .00, .00, .00, .00, !1675
     f 21d-4, .60, .00, .00, .00, .20, .15, .05, .00, .00, .00, .00, !1680
     g 1d-4 , .05, .15, .00, .05, .30, .40, .05, .00, .00, .00, .00, !1700
     h    0., .16, .15, .00, .05, .26, .20, .10, .05, .03, .00, .00, !1710
     i 1d-4 , .10, .00, .00, .80, .05, .00, .00, .03, .02, .00, .00, !1720
     j    0., .30, .00, .55, .15, .00, .00, .00, .00, .00, .00, .00, !1900
     k    0., .12, .00, .00, .43, .19, .14, .05, .03, .00, .04, .00, !1990
     l    0., .45, .10, .10, .20, .05, .10, .00, .00, .00, .00, .00, !2080 
     m    0., .35, .00, .05, .30, .10, .15, .05, .00, .00, .00, .00, !2190
     n    0., .35, .00, .00, .25, .20, .20, .00, .00, .00, .00, .00, !2220
     o    0., .30, .00, .00, .25, .20, .20, .05, .00, .00, .00, .00, !2250
c delta resonances
     a  6d-3, 1.0, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, !1232
     b    0., .10, .00, .00, .00, .00, .65, .25, .00, .00, .00, .00, !1600
     c  4d-4, .15, .00, .00, .05, .00, .65, .15, .00, .00, .00, .00, !1620
     d  2d-3, .20, .00, .00, .25, .00, .55, .00, .00, .00, .00, .00, !1700
     e    0., .25, .00, .00, .25, .00, .25, .25, .00, .00, .00, .00, !1900
     f  3d-4, .18, .00, .00, .80, .00, .02, .00, .00, .00, .00, .00, !1905
     g    0., .30, .00, .00, .10, .00, .35, .25, .00, .00, .00, .00, !1910
     h    0., .27, .00, .00, .00, .00, .40, .30, .00, .03, .00, .00, !1920
     i    0., .22, .00, .00, .05, .00, .40, .30, .00, .03, .00, .00, !1930
     j 15d-3, .38, .00, .00, .00, .00, .34, .24, .00, .00, .00, .04/ !1950


        data branbs1/
c...the branching ratios for unstable baryons with strangeness -1:
channels:       _  _                                                 _
c      NK NK892 Sipi Si*pi gLa  etLa omLa Lapi etSi La*pi DelK
c lambda*'s
     @ .00, .00,1.00, .00, .00, .00, .00, .00, .00, .00, .00,
     @ .45, .00, .43, .11,.008, .00, .00, .00, .00, .00, .00,
     @ .35, .00, .65, .00, .00, .00, .00, .00, .00, .00, .00,
     @ .20, .00, .50, .00, .00, .30, .00, .00, .00, .00, .00,
     @ .25, .00, .45, .30, .00, .00, .00, .00, .00, .00, .00,
     @ .40, .20, .20, .20, .00, .00, .00, .00, .00, .00, .00,
     @ .35, .45, .15, .05, .00, .00, .00, .00, .00, .00, .00,
     @ .65, .00, .14, .10, .00, .00, .00, .00, .00, .00, .00,
     @ .10, .00, .70, .20, .00, .00, .00, .00, .00, .00, .00,
     @ .35, .20, .10, .30, .00, .00, .00, .00, .00, .00, .00,
     @ .35, .20, .05, .30, .00, .02, .08, .00, .00, .00, .00,
     @ .25, .45, .30, .00, .00, .00, .00, .00, .00, .00, .00,
c sigma's   ! stable particles shoud add to zero!
     @ .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
     @ .00, .00, .12, .00, .00, .00, .00, .88, .00, .00, .00,
     @ .30, .00, .35, .00, .00, .00, .00, .35, .00, .00, .00,
     @ .15, .00, .70, .00, .00, .00, .00, .15, .00, .00, .00,
     @ .40, .00, .05, .00, .00, .00, .00, .00, .55, .00, .00,
     @ .40, .00, .04, .10, .00, .00, .00, .23, .00, .23, .00,
     @ .15, .00, .40, .05, .00, .00, .00, .40, .00, .00, .00,
     @ .10, .15, .15, .15, .00, .00, .00, .15, .00, .15, .15,
     @ .20, .04, .10, .10, .00, .00, .00, .20, .00, .18, .18/

        data branbs2/
c...the branching ratios for unstable baryons with strangeness -2:
channels:                     _      _
c            Xipi  Xigamma  LaK   SigK
c Xi's
     @       .98,    .02,    0.,   0.,
     @       .10,    .00,   .70,   .20,
     @       .15,    .00,   .70,   .15,
     @       .20,    .00,   .40,   .20,
     @       .10,    .00,   .20,   .70/


        data branmes /
C     gg   gpi  grho    gome geta gK   2pi pirho 3pi pieta 4pi KK* K*K
c      0     1    2     3    4    5    6   7    8    9     10  11  12
c    et2pi etrho rho2pi om2pi 2eta KK  2Kpi Kpi  K*pi Krho kom K*2pi ompi
c      13    14   15    16   17   18   19   20   21   22   23  24  25
c pion
     a 1.00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
c eta
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
c omega
     a  .00, .09, .00, .00, .00, .00, .02, .00, .89, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
c rho(770)
     a  .00, .00, .00, .00, .00, .00,1.00, .00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
c f_0(980)
     a  .00, .00, .00, .00, .00, .00, .70, .00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .30, .00, .00, .00, .00, .00, .00, .00,
c kaon
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
c eta'
     a  .02, .00, .30, .03, .00, .00, .00, .00, .00, .00, .00, .00, .00,
     a  .65, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
c K*(892)
     a  .00, .00, .00, .00, .00,.003, .00, .00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00,1.00, .00, .00, .00, .00, .00,
c phi
     a  .00, .00, .00, .00, .01, .00, .00, .13, .02, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .84, .00, .00, .00, .00, .00, .00, .00,
c K_0(1430)
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00,1.00, .00, .00, .00, .00, .00,
c a_0(980)
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .90, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .10, .00, .00, .00, .00, .00, .00, .00,
c f_0(1370)
     a  .00, .00, .00, .00, .00, .00, .10, .00, .00, .00, .70, .00, .00,
     a  .00, .00, .00, .00, .00, .20, .00, .00, .00, .00, .00, .00, .00,
C     gg   gpi  grho    gome geta gK   2pi pirho 3pi pieta 4pi KK* K*K
c      0     1    2     3    4    5    6   7    8    9     10  11  12
c    et2pi etrho rho2pi om2pi 2eta KK  2Kpi Kpi  K*pi Krho kom K*2pi ompi
c      13    14   15    16   17   18   19   20   21   22   23  24  25
c K_1(1270)
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00, .00, .47, .42, .11, .00, .00,
c a_1(1260)
     a  .00, .10, .00, .00, .00, .00, .00, .90, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
c f_1(1285)
     a  .00, .00, .05, .00, .00, .00, .00, .00, .00, .00, .33, .00, .00,
     a  .53, .00, .00, .00, .00, .00, .09, .00, .00, .00, .00, .00, .00,
c f_1(1420)
     a  .00, .00, .00, .00, .00, .00, .00, .00, .04, .00, .00, .48, .48,
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
c k_2(1430)
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00, .50, .25, .09, .03, .13, .00,
c a_2(1320)
     a  .00, .00, .00, .00, .00, .00, .00, .70, .00, .14, .00, .00, .00,
     a  .00, .00, .00, .11, .00, .05, .00, .00, .00, .00, .00, .00, .00,
c f_2(1270)
     a  .00, .00, .00, .00, .00, .00, .50, .00, .00, .00, .30, .00, .00,
     a  .00, .00, .00, .00, .00, .20, .00, .00, .00, .00, .00, .00, .00,
c f_2'(1525)
     a  .00, .00, .00, .00, .00, .00, .01, .00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .10, .89, .00, .00, .00, .00, .00, .00, .00,
C     gg   gpi  grho    gome geta gK   2pi pirho 3pi pieta 4pi KK* K*K
c      0     1    2     3    4    5    6   7    8    9     10  11  12
c    et2pi etrho rho2pi om2pi 2eta KK  2Kpi Kpi  K*pi Krho kom K*2pi ompi
c      13    14   15    16   17   18   19   20   21   22   23  24  25
c 1+-
c K_1(1400)
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00, .00, .96, .03, .01, .00, .00,
c b_1(1235)
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
     a  .00, .10, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .90,
c h_1(1170)
     a  .00, .00, .00, .00, .00, .00, .00, .90, .10, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
c h_1'(1380)
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .50, .50,
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
C     gg   gpi  grho    gome geta gK   2pi pirho 3pi pieta 4pi KK* K*K
c      0     1    2     3    4    5    6   7    8    9     10  11  12
c    et2pi etrho rho2pi om2pi 2eta KK  2Kpi Kpi  K*pi Krho kom K*2pi ompi
c      13    14   15    16   17   18   19   20   21   22   23  24  25
c 1--
c K*(1410)
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00, .30, .65, .05, .00, .00, .00,
c rho(1450)
     a  .00, .00, .00, .00, .00, .00, .50, .00, .00, .00, .50, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
c om(1420)
     a  .00, .00, .00, .00, .00, .00, .00,1.00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
c phi(1680)
     a  .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00, .40, .40,
     a  .00, .00, .00, .00, .00, .10, .10, .00, .00, .00, .00, .00, .00,
C     gg   gpi  grho    gome geta gK   2pi pirho 3pi pieta 4pi KK* K*K
c      0     1    2     3    4    5    6   7    8    9     10  11  12
c    et2pi etrho rho2pi om2pi 2eta KK  2Kpi Kpi  K*pi Krho kom K*2pi ompi
c      13    14   15    16   17   18   19   20   21   22   23  24  25
c 1--
c K*(1680)
     a  .00, .00, .00, .00, .00,.003, .00, .00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .00, .00, .00, .40, .30, .30, .00, .00, .00,
c rho(1700)
     a  .00, .00, .00, .00, .00, .00, .20, .00, .00, .00, .10, .00, .00,
     a  .00, .00, .70, .00, .00, .00, .00, .00, .00, .00, .00, .00, .00,
c om(1600)
     a  .00, .00, .00, .00, .00, .00, .00, .50, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .50, .00, .00, .00, .00, .00, .00, .00, .00, .00,
c phi(1900)	 
     a  .00, .00, .00, .00, .00, .00, .20, .00, .00, .00, .00, .00, .00,
     a  .00, .00, .00, .00, .10, .70, .00, .00, .00, .00, .00, .00, .00
     a   /
C     gg   gpi  grho    gome geta gK   2pi pirho 3pi pieta 4pi KK* K*K
c      0     1    2     3    4    5    6   7    8    9     10  11  12
c    et2pi etrho rho2pi om2pi 2eta KK  2Kpi Kpi  K*pi Krho kom K*2pi ompi
c      13    14   15    16   17   18   19   20   21   22   23  24  25

c minimal masses of mesons
c                    g     pi  eta  om     rh     f0    k
        data mmesmn/0.0,0.138,0.547,0.276,0.276,0.276,0.495,
c            eta', k*, phi,k_0*,    a_0,f_0
     a       0.278,0.636,.414,.636,0.685,0.276,
c            k1     a1      f1  f1   k2*     a2*  f2  f2'
     a       0.774, 0.414, 0.276,1.272,0.636,0.414,0.276,.990,
c     1+-
     &       0.774,0.556,0.417,1.272,
c 1--
     &  0.636, 0.278, 0.414, 0.990,
     &  0.636, 0.278, 0.414, 0.990/

        data bmtype/
c for each branch you have itype1(M),itype2(M),itype3(M),itype4(M)
c in case of resonances in the exit-channel, maximum two are allowed
c which must be listed as the first two entries
c note: if total strangeness .ne.0, the first meson should be strange!
c       g g          g   pi       g  rho      g   om
     @  100,100,0,0, 100,101,0,0, 100,104,0,0, 100,103,0,0, 
c       g eta        k   g        pi pi        pi rho
     @  100,102,0,0, 106,100,0,0, 101,101,0,0, 101,104,0,0, 
c       pi pi pi       pi  et       pi pi pi pi      k kbar*
     @  101,101,101,0, 101,102,0,0, 101,101,101,101, 106,-108,0,0,
c	  kbar k*      et pi pi
     @ -106,108,0,0, 102,101,101,0,
c       rho et        rho pi pi      om pi pi      et et
     @  104,102,0,0, 104,101,101,0, 103,101,101,0, 102,102,0,0, 
c       k kbar        k   kbar pi     k pi         k* pi
     @  106,-106,0,0, 106,-106,101,0, 106,101,0,0, 108,101,0,0,
c       k rho        k om         k* pi pi       om pi
     @  106,104,0,0, 106,103,0,0, 108,101,101,0, 103,101,0,0/

      data brtype/
c non-strange baryon decay branches:
c for each branch you have a maximum of 4 outgoing itypes
c in case of resonances in the exit-channel, maximum two are allowed
c which must be listed as the first two entries
c         N  g        N  pi       N  et      N  om      N rho 
     @    1,100,0,0,  1,101,0,0,  1,102,0,0, 1,103,0,0, 1,104,0,0,
c         N pi pi      Delta pi    N* pi      La k        Sig k
     @    1,101,101,0, 17,101,0,0, 2,101,0,0, 27,106,0,0, 40,106,0,0,
c         N f0          N a0
     @    1,105,0,0, 1,111,0,0/



c strangeness -1 baryon decay branches:
c in case of resonances in the exit-channel, maximum two are allowed
c which must be listed as the first two entries
      data bs1type/
c		  N Kbar      N K*bar     Si pi	  Si*pi
     @        1,-106,0,0, 1,-108,0,0, 40,101,0,0, 41,101,0,0,
c	        La  g       La  et      La om       La pi
     @        27,100,0,0, 27,102,0,0, 27,103,0,0, 27,101,0,0,
c		  Si et       La* pi      Delta kbar
     @        40,102,0,0, 29,101,0,0, 17,-106,0,0/

c strangeness -2 baryon decay branches:
c in case of resonances in the exit-channel, maximum two are allowed
c which must be listed as the first two entries
      data bs2type/
c		  Xi pi       Xi pi	  La Kbar	    Si Kbar
     @        49,101,0,0, 49,100,0,0, 27,-106,0,0,  40,-106,0,0/


c
cccccccccccccccccccc pointer arrays for cross sections cccccccccccccccccc
c general structure:
c     SigmaLn(SigLnXX(ICLTYP),*) contains in its columns
c     EITHER flags for the crossx and make22 subroutines in which
c     the respective parametrizations and exitchannels are stored
c     OR the line-numbers of the
c     sigmainf(LINE,*) and sigmascal(LINE,*) arrays
c     in which information about the cross sections for the processes with
c     particles of ITYPs ITYP1 and ITYP2 in the entry channel are stored.
c     The first entry in the respective LINE of the sigmainf contains
c     the number of possible exit channels for the collision and the
c     second entry points to the total cross section.
c     The ELASTIC cross section MUST always exist and be the FIRST
c     cross section entry after the total cross section!!
c     In case of NEGATIVE LINENUMBERS in sigmaLn(j>2,i), a DETAILED BALANCE
c     calculation will be performed


      data (((sigmaLN(i,j,k),i=1,maxpsig),j=1,2),k=1,maxreac) /
c 1  proton neutron
c     nCH   t  el  ND  pN* ND* DD  DN* DD*
     .  9, 16, 17,  1,  2,  3,  4,  5,  6,  7, 15,  0,
     .  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  0,
c 2  proton proton (and neutron neutron)
c     nCH t   el  ND pN* ND* DD DN* DD*
     .  9, 18, 19,  1,  2,  3,  4,  5,  6,  7, 15,  0,
     .  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  0,
c 3  D N (sigtot=-1 sum over branches for total cross section)
     .  5, -1, 13, 30,  8, 35, 15,  0,  0,  0,  0,  0,
     .  0,  0,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  
c 4  N* N (sigtot=-1 sum over branches for total cross section)
     .  4, 12, 13, -2, 14, 15,  0,  0,  0,  0,  0,  0,
     .  0,  0,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0, 
c 5  D* N(sigtot=-1 sum over branches for total cross section)
     .  4, 12, 13, -3, 14, 15,  0,  0,  0,  0,  0,  0,
     .  0,  0,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0, 
c 6  D D (sigtot=-1 sum over branches for total cross section)
     .  5, -1, 13, 32, 31, 14, 15,  0,  0,  0,  0,  0, 
     .  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
c 7  D N* (sigtot=-1 sum over branches for total cross section)
     .  4, 12, 13, -5, 14, 15,  0,  0,  0,  0,  0,  0, 
     .  0,  0,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0, 
c 8  D D* (sigtot=-1 sum over branches for total cross section)
     .  4, 12, 13, -6, 14, 15,  0,  0,  0,  0,  0,  0, 
     .  0,  0,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0, 
c 9  meson baryon 
     .  5, 25, 26, 10, 27, 28, 36,  0,  0,  0,  0,  0,
     .  0,  0,  1,  0,  1,  1,  0,  0,  0,  0,  0,  0, 
c10  meson meson (are automatically summed)
     .  5, -1, 38, 11, 27, 28,  37,  0,  0,  0,  0,  0, 
     .  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
c11  bbar-b
     .  3, -1, 22, 23, 24,  0,  0,  0,  0,  0,  0,  0,
     .  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
c12  D*D* or D*N* or N*N*
     .  4, 12, 13, -7, 14, 15,  0,  0,  0,  0,  0,  0, 
     .  0,  0,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0, 
c13  BB (for all that are not specified above: YY etc.)
     .  2, 12, 13, 15,  0,  0,  0,  0,  0,  0,  0,  0,
     .  0,  0,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0 /


cccccccccccccccccccc cross sections info  ccccccccccccccccccccccccccccccccccccc
c IMPORTANT:
c In sigmainf(LINE,*)  the following information is stored:
c column 1     : line# number for sigmas(line#,*) array (index(sig))
c column 2     : flag for angular distribution in the out-channel
c                 0 : isotropic scattering
c                 1 : elastic scattering (ident. part.) ang. distrib. exp (-as)
c                 2 : elastic scattering (non ident. part.) ang. distrib.
c                 3 : f-b peaked N N to N Delta
c        3     : number of particles in the out-channel
c                ( 0 for total cross sections)
c                for <0 number of calls to crossx for sub-branches
c        4 - 8 : ITYPs of particles in the out-channel
c        9 - 15: 2*I3 of particles in the out-channel (-9 for isocgk call)
c                DANGER: the entries have to be sorted in a way, that ALL
c                        unknown I3 components (those which are -9) are
c                        at the END of the list !!!
ccccccccccccccc
c IN sigmascal(LINE,*) the following information is stored:
c column 1     : scaling factor for cross section in sigmas(line#,*)
c column 2     : sqrt(s) value corresponding to entry sigmas(line#,1)
c column 3     : Delta(sqrt(s)) between sigmas(line#,n) and sigmas(line#,n+1)
c column 4,5   : undefined (optionally formation time for outgoing channel)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     proton - neutron total cs. index(inf)=1, index(sig)=1
      data (sigmainf(1,i),i=1,20) /
     @  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,
     @  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 /

      data(sigmascal(1,i),i=1,5) /
     @  1.0000000, 1.8964808, 0.0100000, 0.0000000, 0.0000000 /


c     proton - neutron elastic cs. index(inf)=2, index(sig)=2
      data (sigmainf(2,i),i=1,20) /
     @  2,  2,  2,  1,  1,  0,  0,  0, -9, -9,
     @  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 /

      data(sigmascal(2,i),i=1,5) /
     @  1.0000000, 1.8964808, 0.0100000, 0.0000000, 0.0000000 /


c     proton - proton (neutron - neutron) total cs. index(inf)=3, index(sig)=3
c     low energy forward peak is subtracted
      data (sigmainf(3,i),i=1,20) /
     @  3,  0,  0,  0,  0,  0,  0,  0,  0,  0,
     @  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 /

      data(sigmascal(3,i),i=1,5) /
     @  1.0000000, 1.8964808, 0.0100000, 0.0000000, 0.0000000 /


c     proton - proton (neutron-neutron) elastic cs. index(inf)=4, index(sig)=4
      data (sigmainf(4,i),i=1,20) /
     @  4,  1,  2,  1,  1,  0,  0,  0,  -9,  -9,
     @  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 /

      data(sigmascal(4,i),i=1,5) /
     @  1.0000000, 1.8964808, 0.0100000, 0.0000000, 0.0000000 /


cccccccccccccccccccccccc cross sections sigmas() cccccccccccccccccccccccccc
c
c     proton - neutron total cs. index=1
      data (sigmas(1,i),i=1,ITBLSZ) /
     @248.20, 93.38, 55.26, 44.50, 41.33, 38.48, 37.20, 35.98,
     @ 35.02, 34.47, 34.37, 34.67, 35.23, 35.97, 36.75, 37.37,
     @ 37.77, 38.03, 38.40, 38.83, 39.26, 39.67, 40.06, 40.45,
     @ 40.79, 41.06, 41.31, 41.52, 41.70, 41.81, 41.87, 41.98,
     @ 42.12, 42.29, 42.55, 42.82, 43.01, 43.12, 43.16, 43.14,
     @ 43.06, 42.95, 42.81, 42.67, 42.54, 42.45, 42.38, 42.33,
     @ 42.30, 42.29, 42.28, 42.26, 42.24, 42.21, 42.17, 42.14,
     @ 42.10, 42.07, 42.06, 42.05, 42.04, 42.03, 42.02, 42.00,
     @ 41.97, 41.94, 41.89, 41.84, 41.79, 41.73, 41.67, 41.61,
     @ 41.55, 41.49, 41.44, 41.38, 41.34, 41.31, 41.29, 41.28,
     @ 41.27, 41.28, 41.30, 41.33, 41.36, 41.40, 41.44, 41.49,
     @ 41.50, 41.51, 41.51, 41.51, 41.52, 41.51, 41.51, 41.50,
     @ 41.50, 41.49, 41.47, 41.46
     @/

c     proton - neutron elastic cs. index=2
      data (sigmas(2,i),i=1,ITBLSZ) /
     @248.20, 93.38, 55.26, 44.50, 41.33, 38.48, 37.20, 35.98,
     @ 35.02, 34.47, 32.48, 30.76, 29.46, 28.53, 27.84, 27.20,
     @ 26.53, 25.95, 25.59, 25.46, 25.00, 24.49, 24.08, 23.86,
     @ 23.17, 22.70, 21.88, 21.48, 20.22, 19.75, 18.97, 18.39,
     @ 17.98, 17.63, 17.21, 16.72, 16.68, 16.58, 16.42, 16.22,
     @ 15.98, 15.71, 15.42, 15.14, 14.87, 14.65, 14.44, 14.26,
     @ 14.10, 13.95, 13.80, 13.64, 13.47, 13.29, 13.09, 12.89,
     @ 12.68, 12.47, 12.27, 12.06, 11.84, 11.76, 11.69, 11.60,
     @ 11.50, 11.41, 11.29, 11.17, 11.06, 10.93, 10.81, 10.68,
     @ 10.56, 10.44, 10.33, 10.21, 10.12, 10.03,  9.96,  9.89,
     @  9.83,  9.80,  9.77,  9.75,  9.74,  9.74,  9.74,  9.76,
     @  9.73,  9.70,  9.68,  9.65,  9.63,  9.60,  9.57,  9.55,
     @  9.52,  9.49,  9.46,  9.43
     @/


c     proton - proton (neut - neut) total cs. index=3
c     low energy forward peak is subtracted
      data (sigmas(3,i),i=1,ITBLSZ) /
     @ 39.48, 31.76, 26.26, 24.05, 23.94, 23.77, 23.72, 23.98,
     @ 24.48, 24.52, 28.72, 33.21, 37.33, 39.87, 42.14, 44.15,
     @ 46.85, 48.56, 48.65, 48.97, 48.81, 48.43, 48.36, 48.19,
     @ 47.89, 47.53, 47.42, 47.37, 47.17, 46.65, 46.48, 45.94,
     @ 45.63, 45.75, 45.52, 45.24, 45.13, 44.96, 44.55, 44.44,
     @ 44.10, 43.89, 43.77, 43.32, 43.30, 43.07, 42.95, 42.74,
     @ 42.46, 42.28, 42.11, 41.96, 41.86, 41.74, 41.64, 41.54,
     @ 41.44, 41.37, 41.29, 41.22, 41.14, 41.09, 41.01, 40.93,
     @ 40.83, 40.74, 40.66, 40.58, 40.51, 40.47, 40.40, 40.35,
     @ 40.47, 40.44, 40.38, 40.35, 40.32, 40.27, 40.25, 40.23,
     @ 40.19, 40.13, 40.11, 40.09, 40.06, 40.02, 40.00, 39.95,
     @ 39.94, 39.90, 39.87, 39.82, 39.77, 39.72, 39.67, 39.59,
     @ 39.54, 39.48, 39.41, 39.32
     @/

c     proton - proton (neut - neut) elastic cs. index=4
      data (sigmas(4,i),i=1,ITBLSZ) /
     @ 39.48, 31.76, 26.26, 24.05, 23.94, 23.77, 23.72, 23.98,
     @ 24.48, 24.52, 25.00, 25.40, 25.80, 26.00, 24.32, 23.81,
     @ 24.37, 24.36, 23.13, 22.83, 22.50, 22.20, 21.83, 21.50,
     @ 21.55, 21.25, 20.90, 20.55, 20.30, 20.15, 20.05, 19.90,
     @ 19.50, 19.25, 19.00, 18.50, 18.10, 17.60, 17.20, 17.00,
     @ 16.70, 16.50, 16.20, 15.80, 15.57, 15.20, 15.00, 14.60,
     @ 14.20, 14.00, 13.80, 13.60, 13.40, 13.20, 13.00, 12.85,
     @ 12.70, 12.60, 12.50, 12.40, 12.30, 12.20, 12.10, 12.00,
     @ 11.90, 11.80, 11.75, 11.70, 11.64, 11.53, 11.41, 11.31,
     @ 11.22, 11.13, 11.05, 10.97, 10.89, 10.82, 10.75, 10.68,
     @ 10.61, 10.54, 10.48, 10.41, 10.35, 10.28, 10.22, 10.16,
     @ 10.13, 10.10, 10.08, 10.05, 10.02,  9.99,  9.96,  9.93,
     @  9.90,  9.87,  9.84,  9.80
     @/
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      end



C####C##1#########2#########3#########4#########5#########6#########7##
      integer function flbr(i,iir) 
      implicit none
      integer i,iir,ir,l
      include 'comres.f'
      ir=iabs(iir)
      l=0
      if(ir.gt.minnuc.and.ir.le.maxdel)then
        l=lbr(i,ir)
      else if(ir.gt.minlam.and.ir.le.maxsig)then
        l=lbs1(i,ir)
      else if(ir.gt.mincas.and.ir.le.maxcas)then
        l=lbs2(i,ir)
      else if(ir.gt.minmes.and.ir.le.maxmes)then
        l=lbm(i,ir)
      else
        write(6,*)'*** error(flbr) *** i,ir:',i,ir
        stop
      endif
      flbr=l*2 ! angular momentum of decay into ch.i(x2)
      return
      end

C####C##1#########2#########3#########4#########5#########6#########7##
      real*8 function fbran(i,iir) 
      implicit none
      integer i,iir,ir
      real*8 b
      include 'comres.f'
      ir=iabs(iir)
      b=0.d0
      if(ir.gt.minnuc.and.ir.le.maxdel)then
        b=branres(i,ir)
      else if(ir.gt.minlam.and.ir.le.maxsig)then
        b=branbs1(i,ir)
       else if(ir.gt.mincas.and.ir.le.maxcas)then
        b=branbs2(i,ir)
      else if(ir.gt.minmes.and.ir.le.maxmes)then
        b=branmes(i,ir)
      else
        write(6,*)'*** error(fbran) *** i,ir:',i,ir
        stop
      endif
      fbran=b ! branching ratio of decay into ch.i(x2)
      return
      end

C####C##1#########2#########3#########4#########5#########6#########7##
      integer function strit(i) 
      implicit none
      integer i,is,ia
      include 'comres.f'
      if(i.eq.0) then
         strit=0
         return
      endif
      ia=iabs(i)
      if(ia.ge.minmes)then
         is=strmes(ia)
      else
         is=strres(ia)
      endif
      strit=is*iabs(i)/i	! number of strange quarks in part. i
      return
      end

C####C##1#########2#########3#########4#########5#########6#########7##
      integer function fchg(i3,i) 
      integer i,i3,b,s,ia,strit
      include 'comres.f'
      if(i.eq.0) then
         fchg=0
         return
      endif

      s=strit(i)
      ia=iabs(i)
      if(ia.ge.minmes)then
        b=0
      else
        b=ia/i
      endif
      fchg =(i3+b-s)/2 ! i3 is multiplied whith 2 &  s(s)=-1!
      return  ! charge of particle i
      end

C####C##1#########2#########3#########4#########5#########6#########7##
      real*8 function massit(i) 
      integer i,ia
      include 'comres.f'
      ia=iabs(i)
      if(ia.ge.minmes)then
        massit=massmes(ia)
      else
        massit=massres(ia)
      endif
      return  ! mass of particle i
      end

C####C##1#########2#########3#########4#########5#########6#########7##
      real*8 function mminit(i) 
      implicit none
      integer i,ia
      real*8 massit,widit ! functions
      real*8 cut,pcut
      parameter(pcut=1d-3) ! keep pcut*mass for rel.kinetic energy
      include 'comres.f'
      if(i.eq.0) then
         mminit=0.d0
         return
      endif

      ia=iabs(i)
      cut=pcut*massit(ia)
      if(widit(ia).le.pcut)then ! narrow particle condition
        mminit=massit(ia)
      else if(ia.ge.minmes)then
        mminit=mmesmn(ia)+cut
      else if(ia.gt.minnuc.and.ia.le.maxdel)then
        mminit=massit(minnuc)+massit(pimeson)+cut
      else if(ia.gt.minlam.and.ia.le.maxlam)then
        mminit=massit(minsig)+massit(pimeson)+cut
      else if(ia.gt.minsig.and.ia.le.maxsig)then
        mminit=massit(minsig)+massit(pimeson)+cut
      else if(ia.gt.mincas.and.ia.le.maxcas)then
        mminit=massit(mincas)+massit(pimeson)+cut
      else
        mminit=massit(ia)
      endif
      return  ! minimal mass of particle i
      end

C####C##1#########2#########3#########4#########5#########6#########7##
      real*8 function widit(i) 
      implicit none
      integer i,ia
      include 'comres.f'
      if(i.eq.0) then
         widit=0.d0
         return
      endif

      ia=iabs(i)
      if(ia.ge.minmes)then
        widit=widmes(ia)
      else
        widit=widres(ia)
      endif
      return ! width of particle i
      end

C####C##1#########2#########3#########4#########5#########6#########7##
      subroutine brange(i,mm,mp)
      implicit none
      integer mm,mp,ia,i
      include 'comres.f'
      ia=abs(i)
      mm=0
      if(ia.ge.minmes)then
        mp=maxbrm
      else if(ia.gt.minnuc.and.ia.le.maxdel)then
        mp=maxbra
      else if(ia.gt.minlam.and.ia.le.maxsig)then
        mp=maxbrs1
      else if(ia.gt.mincas.and.ia.le.maxcas)then
        mp=maxbrs2
      else
        mp=0
      endif
      return
      end

C####C##1#########2#########3#########4#########5#########6#########7##
      subroutine b3type(i,j,bi,b1,b2,b3,b4)
c i=itype j=number of decay channel bi=branching ratio b1-4 outgoing itypes
      implicit none
      integer ia,i,j,b1,b2,b3,b4
      real*8 bi
      include 'comres.f'
      ia=abs(i)
      if(ia.gt.minmes)then
        bi=branmes(j,ia)
        b1=bmtype(1,j)
        b2=bmtype(2,j)
        b3=bmtype(3,j)
        b4=bmtype(4,j)
      else if(ia.gt.minnuc.and.ia.le.maxdel)then
        bi=branres(j,ia)
        b1=brtype(1,j)
        b2=brtype(2,j)
        b3=brtype(3,j)
        b4=brtype(4,j)
      else if(ia.gt.minlam.and.ia.le.maxsig)then
        bi=branbs1(j,ia)
        b1=bs1type(1,j)
        b2=bs1type(2,j)
        b3=bs1type(3,j)
        b4=bs1type(4,j)
      else if(ia.gt.mincas.and.ia.le.maxcas)then
        bi=branbs2(j,ia)
        b1=bs2type(1,j)
        b2=bs2type(2,j)
        b3=bs2type(3,j)
        b4=bs2type(4,j)
      else
        bi=0d0
      endif
      return
      end


C####C##1#########2#########3#########4#########5#########6#########7##
      integer function isoit(i) 
      implicit none
      integer i,ia
      include 'comres.f'
      if(i.eq.0) then
	 isoit=0
	 return
      endif
      ia=iabs(i)
      if(ia.ge.minmes)then
        isoit=isomes(ia)
      else
        isoit=isores(ia)
      end if
      return ! isospin of particle i
      end

C####C##1#########2#########3#########4#########5#########6#########7##
      integer function jit(i) 
      implicit none
      integer i,ia
      include 'comres.f'

      if(i.eq.0) then
         jit=0
         return
      endif

      ia=iabs(i)
      if(ia.ge.minmes)then
        jit=jmes(ia)
      else
        jit=jres(ia)
      endif
      return ! spin of particle i
      end
