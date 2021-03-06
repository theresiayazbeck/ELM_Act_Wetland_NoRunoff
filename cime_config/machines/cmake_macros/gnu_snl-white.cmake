set(SCXX "$ENV{E3SM_SRCROOT}/externals/kokkos/bin/nvcc_wrapper")
set(MPICXX "$ENV{E3SM_SRCROOT}/externals/kokkos/bin/nvcc_wrapper")
set(KOKKOS_OPTIONS "--arch=Pascal60 --with-cuda=$ENV{CUDA_ROOT} --with-cuda-options=enable_lambda")
string(APPEND CXXFLAGS " -expt-extended-lambda -DCUDA_BUILD")
set(NETCDF_PATH "$ENV{NETCDF_FORTRAN_PATH}")
execute_process(COMMAND ${NETCDF_PATH}/bin/nf-config --flibs OUTPUT_VARIABLE SHELL_CMD_OUTPUT_BUILD_INTERNAL_IGNORE0 OUTPUT_STRIP_TRAILING_WHITESPACE)
string(APPEND SLIBS " ${SHELL_CMD_OUTPUT_BUILD_INTERNAL_IGNORE0} -lblas -llapack -lcudart -lstdc++")
