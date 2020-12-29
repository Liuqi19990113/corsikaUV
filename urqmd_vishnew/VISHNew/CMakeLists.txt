ENABLE_LANGUAGE(Fortran)
message("Looking for HDF5 ...")
find_package(HDF5)
if(${HDF5_FOUND})
    include_directories(${HDF5_INCLUDE_DIRS})
    set(_hdf5_libs ${HDF5_LIBRARIES} ${HDF5_CXX_LIBRARIES} ${HDF5_HL_LIBRARIES})
endif(${HDF5_FOUND})

# FFLAGS depend on the compiler
if (${HDF5_FOUND})
  set (CMAKE_Fortran_COMPILER "h5fc")
endif (${HDF5_FOUND})
get_filename_component (Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)

if (Fortran_COMPILER_NAME MATCHES "gfortran.*")
  # gfortran
  set (CMAKE_Fortran_FLAGS_RELEASE "-O3 -cpp -fno-align-commons")
  set (CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g -cpp")
elseif (Fortran_COMPILER_NAME MATCHES "ifort.*")
  # ifort (untested)
  set (CMAKE_Fortran_FLAGS_RELEASE "-O3 -cpp -heap-arrays")
  set (CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g -cpp -heap-arrays")
elseif (Fortran_COMPILER_NAME MATCHES "h5fc")
  set (CMAKE_Fortran_FLAGS_RELEASE "-O3 -cpp -lm -lz -fno-align-commons")
  set (CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g -cpp")
else (Fortran_COMPILER_NAME MATCHES "gfortran.*")
  message ("CMAKE_Fortran_COMPILER full path: " ${CMAKE_Fortran_COMPILER})
  set (CMAKE_Fortran_FLAGS_RELEASE "-O3 -cpp -fno-align-commons")
  set (CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g -cpp")
endif (Fortran_COMPILER_NAME MATCHES "gfortran.*")
set (LIBSRC Jetoutputh5.F)
add_library (hdf5 ${LIBSRC})
add_executable(VISHNew
  VISH2p1V1.10.0.F
  PhyBdary-1.10.F
  InputEOS-1.3.F 
  OSCARoutput.F 
  Arsenal-0.8.F 
  Initialization-1.03.F
  InputFun-1.29RC6.F 
  cornelius2.f90
  )
target_link_libraries (VISHNew hdf5)
set_target_properties (VISHNew PROPERTIES COMPILE_FLAGS "-DUSE_HDF5")
INSTALL(TARGETS VISHNew DESTINATION urqmd_vishnew/VISHNew)
INSTALL(FILES extraParas.inp Vishydro.inp DESTINATION urqmd_vishnew/VISHNew)
INSTALL(DIRECTORY EOS DESTINATION urqmd_vishnew/VISHNew)