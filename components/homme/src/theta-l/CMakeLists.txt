# macro for building theta primitive equations executable

macro(thetal_setup)

SET (KOKKOS_TARGET FALSE)

SET(TARGET_DIR        ${HOMME_SOURCE_DIR}/src/theta-l)
SET(UTILS_SHARE_DIR   ${HOMME_SOURCE_DIR}/utils/csm_share)
SET(SRC_DIR           ${HOMME_SOURCE_DIR}/src)
SET(SRC_SHARE_DIR     ${HOMME_SOURCE_DIR}/src/share)
SET(TEST_SRC_DIR      ${HOMME_SOURCE_DIR}/src/test_src)
SET(UTILS_TIMING_DIR  ${HOMME_BINARY_DIR}/utils/cime/src/share/timing)
SET(ARKODE_DIR        ${HOMME_SOURCE_DIR}/src/arkode)

# Make INCLUDE_DIRS global so the tests can access it
SET (EXEC_INCLUDE_DIRS ${PIO_INCLUDE_DIRS} ${UTILS_TIMING_DIR} )

# Find F90 files in share and test directories
FILE(GLOB TARGET_F90 ${TARGET_DIR}/share/*.F90 ${TARGET_DIR}/*.F90 ${SRC_SHARE_DIR}/*.F90 ${TEST_SRC_DIR}/*.F90)

IF (HOMME_USE_ARKODE)
  SET(TARGET_F90
    ${TARGET_F90}
    ${ARKODE_DIR}/arkode_tables.F90
    ${ARKODE_DIR}/homme_sunlinsol.F90
    ${ARKODE_DIR}/theta-l/arkode_interface.F90
    ${ARKODE_DIR}/theta-l/arkode_mod.F90
    ${ARKODE_DIR}/theta-l/homme_nvector.F90
  )
ENDIF ()

SET(THETAL_SRCS_F90
  ${TARGET_F90}
  ${SRC_DIR}/checksum_mod.F90 
  ${SRC_DIR}/common_io_mod.F90
  ${SRC_DIR}/common_movie_mod.F90
  ${SRC_DIR}/interpolate_driver_mod.F90
  ${SRC_DIR}/interp_movie_mod.F90
  ${SRC_DIR}/netcdf_io_mod.F90
  ${SRC_DIR}/pio_io_mod.F90
  ${SRC_DIR}/prim_main.F90 
  ${SRC_DIR}/prim_movie_mod.F90
  ${SRC_DIR}/theta_restart_mod.F90
  ${SRC_DIR}/repro_sum_mod.F90
  ${SRC_DIR}/restart_io_mod.F90
  ${SRC_DIR}/surfaces_mod.F90
  ${SRC_DIR}/test_mod.F90
  ${UTILS_SHARE_DIR}/shr_kind_mod.F90
  ${UTILS_SHARE_DIR}/shr_mpi_mod.F90 
  ${UTILS_SHARE_DIR}/shr_sys_mod.F90 
  ${UTILS_SHARE_DIR}/shr_file_mod.F90 
  ${UTILS_SHARE_DIR}/shr_vmath_mod.F90 
  ${UTILS_SHARE_DIR}/shr_const_mod.F90 
  ${UTILS_SHARE_DIR}/shr_spfn_mod.F90
)

IF (HOMME_USE_ARKODE)
  SET(THETAL_SRCS_C
    ${ARKODE_DIR}/nvector_external.h
    ${ARKODE_DIR}/nvector_external.c
    ${ARKODE_DIR}/column_linsol.h
    ${ARKODE_DIR}/column_linsol.c
  )
ENDIF ()

IF (HOMMEXX_BFB_TESTING)
  # We need a couple more files/includes to correctly hook-up C routines
  SET(THETAL_SRCS_F90
      ${THETAL_SRCS_F90}
      ${SRC_SHARE_DIR}/cxx/utilities/bfb_mod.F90
  )

  SET(THETAL_SRCS_C
      ${THETAL_SRCS_C}
      ${SRC_SHARE_DIR}/cxx/utilities/BfbUtils.cpp
      ${SRC_SHARE_DIR}/cxx/ExecSpaceDefs.cpp
  )

  SET (EXEC_INCLUDE_DIRS
      ${EXEC_INCLUDE_DIRS}
      ${SRC_SHARE_DIR}/cxx
      ${HOMME_BINARY_DIR}/src/share/cxx/
  )
ENDIF()

# If the user specified a file for custom compiler options use those
IF (DEFINED THETA_CUSTOM_FLAGS_FILE)
  setCustomCompilerFlags(THETA_CUSTOM_FLAGS_FILE THETAL_SRCS_F90)
ENDIF ()

# Make SRCS global so the tests can access it
SET(EXEC_SOURCES ${THETAL_SRCS} ${THETAL_SRCS_C} ${THETAL_SRCS_F90} )

# Set up defaults
IF (NOT PREQX_NP)
  SET (PREQX_NP 4) 
ENDIF ()
IF (NOT PREQX_PLEV)
  SET (PREQX_PLEV 20) 
ENDIF ()
IF (NOT PREQX_USE_PIO)
  SET (PREQX_USE_PIO FALSE) 
ENDIF ()
IF (NOT PREQX_USE_ENERGY)
  SET (PREQX_USE_ENERGY FALSE) 
ENDIF ()
IF (NOT PREQX_NC)
  SET (PREQX_NC 0)
ENDIF ()
IF (NOT QSIZE_D)
  SET (QSIZE_D 4)
ENDIF ()
# for some of matt's old scripts which use preqx_qsize_d
IF (PREQX_QSIZE_D)      
  SET (QSIZE_D ${PREQX_QSIZE_D})
ENDIF ()

SET(USE_OPENACC FALSE)
IF (${ENABLE_HORIZ_OPENMP} AND ${ENABLE_COLUMN_OPENMP})
  SET(NESTED_OPENMP TRUE CACHE BOOL "Both horizontal and column threading")
ENDIF ()

endmacro(thetal_setup)

thetal_setup()
############################################################################
# createTestExec(exec_name exec_type NP PLEV USE_PIO USE_ENERGY)
############################################################################
createTestExec(theta-l theta-l ${PREQX_NP} ${PREQX_NC} ${PREQX_PLEV} ${PREQX_USE_PIO}  ${PREQX_USE_ENERGY} ${QSIZE_D})

