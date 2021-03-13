ENABLE_LANGUAGE(Fortran)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_SOURCE_DIR})
# By default, optimize for the system's native architecture.  Disable via the
# NATIVE option.  In addition, detect if another architecture flag is already
# set and do not override it.
set(CMAKE_Fortran_FLAGS "-mcmodel=medium")
option(NATIVE "compile for native architecture" ON)
if(NATIVE)
  if(CMAKE_Fortran_COMPILER_ID STREQUAL "Intel")
    # Intel compiler: search for -m, -x, -ax flags; if not found add -xHost.
    if(NOT CMAKE_Fortran_FLAGS MATCHES "(^| )-(m|x|ax)[^ ]+")
      string(APPEND CMAKE_Fortran_FLAGS " -xHost")
    endif()
  else()
    # All other compilers (gcc-like): search for -m flags;
    # if not found add -march=native.
    if(NOT CMAKE_Fortran_FLAGS MATCHES "(^| )-m[^ ]+")
      string(APPEND CMAKE_Fortran_FLAGS " -march=native")
    endif()
  endif()
endif()
# Adapted from the makefiles in the public UrQMD distribution.
if("${CMAKE_Fortran_COMPILER_ID}" STREQUAL "Intel")
  set(SYSTEM_FILES intranf.f erf.f)
else()
  set(SYSTEM_FILES gnuranf.f)
endif()
SET(URQMD_SRC 1fluid.f addpart.f angdis.f anndec.f bessel.f blockres.f boxprg.f cascinit.f CFmax.f90 coload.f cornelius.f90 dectim.f delpart.f detbal.f dwidth.f error.f getmass.f getspin.f hepnam.f hepchg.f hepcmp.f init.f input.f iso.f ityp2pdg.f jdecay2.f make22.f numrec.f output.f paulibl.f proppot.f pythia6409.f quadri.f90 saveinfo.f scatter.f siglookup.f string.f tabinit.f uhmerge.f upmerge.f whichres.f urqmd.f ${SYSTEM_FILES})
ADD_EXECUTABLE(urqmd ${URQMD_SRC})
INSTALL(TARGETS urqmd DESTINATION urqmd_vishnew/urqmd)
INSTALL(FILES tables.dat input_frez DESTINATION urqmd_vishnew/urqmd)
INSTALL(PROGRAMS urqmd_initial.sh urqmd_frez.sh DESTINATION urqmd_vishnew/urqmd)