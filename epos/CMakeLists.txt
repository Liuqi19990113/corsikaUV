INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
SET(CMAKE_Fortran_FLAGS "-O0 -I. -g -std=legacy")
SET(EPOS_CORSIKA_SRC epos-bas-lhc.f epos-con-lhc.f eposm.f epos_j.f epos-dky-lhc.f epos-dro-lhc.f epos-ems-lhc.f epos-fra-lhc.f epos-ico-lhc.f epos-hnb-lhc.f epos-ids-lhc.f epos-int-lhc.f epos-jps-lhc.f epos-omg-lhc.f epos-par-lhc.f epos-sem-lhc.f epos-rsh-lhc.f epos-qsh-lhc.f epos-tim-lhc.f epos-uti-lhc.f epos-xan-lhc.f epos-xpr-lhc.f)
ADD_LIBRARY(EPOS_CORSIKA STATIC ${EPOS_CORSIKA_SRC})