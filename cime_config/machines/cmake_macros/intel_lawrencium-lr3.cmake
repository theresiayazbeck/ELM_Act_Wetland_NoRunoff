if (COMP_NAME STREQUAL gptl)
  string(APPEND CPPDEFS " -DHAVE_VPRINTF -DHAVE_GETTIMEOFDAY")
endif()
set(LAPACK_LIBDIR "/global/software/sl-6.x86_64/modules/intel/2016.1.150/lapack/3.6.0-intel/lib")
set(NETCDF_PATH "$ENV{NETCDF_DIR}")
string(APPEND SLIBS " -lnetcdff -lnetcdf -mkl")
