# corsika阅读过程中的发现

此文档记录阅读过程中各种比较凌乱但或许有用的发现

## 要点

1. corsika在选择target的过程中只考虑了N,O,Ar :30187-30233
2. 通过__PRESHOWER__中的N1STTR设置固定初始碰撞粒子
3. EPOS会对γ进行处理 :65158
4. CORSIKA最多处理60核子
5. CORSIKA计算核质量是通过pn数目计算
6. CORSIKA的强子过程中似乎并没有直接处理remanent，而是将使用phys中的近似方法
7. corsika能处理的 $\theta_{max}=70^{\circ}$
8. 高能低能强子模型的转变能量是由模型决定的，EPOS对应49GeV

## EPOS参数

```fortran
integer ::latarg = Z of target
integer ::idprojin = type of projectile in EPOS
```

## NSTORE中调用参数

```fortran
c     integer kolevt ........ number of collisions
c     integer npjevt ........ number of primary projectile participants
c     integer ntgevt ........ number of primary target participants
c     integer infragm
c     integer nptl ....... number of secondary particles?
c     integer iorptl(i) ..... particle number of father
c     integer idptl(i) ...... particle id
c     integer istptl(i) ..... generation flag: last gen.(0) or not(1) or ghost(2)
c     integer ityptl(i)  .....from target (10-19), soft (20-29), hard (30-39),
c                     projectile (40-49) string, droplet (50)
c     real pptl(1,i) ..... x-component of particle momentum
c     real pptl(2,i) ..... y-component of particle momentum
c     real pptl(3,i) ..... z-component of particle momentum
c     real pptl(4,i) ..... particle energy
c     real pptl(5,i) ..... particle mass
c     integer maproj ... NUMBER OF NUCLEONS OF PROJECTILE
c     integer matarg
c?    real tivptl(1,i) ... formation time (always in the pp-cms!)
c?    real tivptl(2,i) ... destruction time (always in the pp-cms!)
c?    real xorptl(1,i) ... x-component of formation point
c?    real xorptl(2,i) ... y-component of formation point
c?    real xorptl(3,i) ... z-component of formation point
c?    real xorptl(4,i) ... formation time
c?    real phievt ........ angle of impact parameter
c?    real bimevt ........ absolute value of impact parameter
c?    real pmxevt ........ reference momentum
c?    real egyevt ........ pp cm energy (hadron) or string energy (lepton)
c?    integer ifrptl(1,i) ... particle number of first child
c?    integer ifrptl(2,i) ... particle number of last child
c?    integer jorptl(i) ..... particle number of mother
```
