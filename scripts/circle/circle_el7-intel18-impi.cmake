# Client maintainer: chuck.atkins@kitware.com
set(CTEST_SITE "CircleCI")
set(CTEST_BUILD_CONFIGURATION Debug)
set(CTEST_CMAKE_GENERATOR "Unix Makefiles")
set(CTEST_BUILD_FLAGS "-k -j4")
set(CTEST_TEST_ARGS PARALLEL_LEVEL 1)

set(dashboard_model Experimental)
set(dashboard_binary_name "build_$ENV{CIRCLE_JOB}")
set(dashboard_track "Continuous Integration")

set(CTEST_GIT_COMMAND "/usr/bin/git")
set(CTEST_UPDATE_VERSION_ONLY TRUE)
set(CTEST_SOURCE_DIRECTORY "$ENV{CIRCLE_WORKING_DIRECTORY}/source")
set(CTEST_DASHBOARD_ROOT "$ENV{HOME}")

include(${CMAKE_CURRENT_LIST_DIR}/EnvironmentModules.cmake)
module(purge)
module(load intel)
module(load py2-numpy)
module(load impi)
module(load py2-mpi4py)
module(load phdf5)
module(load adios)

set(ENV{CC}  icc)
set(ENV{CXX} icpc)
set(ENV{FC}  ifort)
set(ENV{CFLAGS} -Werror)
set(ENV{CXXFLAGS} -Werror)
set(ENV{FFLAGS} "-warn errors")
find_program(MPI_C_COMPILER mpiicc)
find_program(MPI_CXX_COMPILER mpiicpc)
find_program(MPI_Fortran_COMPILER mpiifort)

# Allow oversubscription for IntelMPI to prevent timeouts on circleci
set(ENV{I_MPI_WAIT_MODE} "enable")

set(dashboard_cache "
ADIOS2_USE_ADIOS1:STRING=ON
ADIOS2_USE_BZip2:STRING=ON
ADIOS2_USE_DataMan:STRING=ON
ADIOS2_USE_Fortran:STRING=ON
ADIOS2_USE_HDF5:STRING=ON
ADIOS2_USE_MPI:STRING=ON
ADIOS2_USE_Python:STRING=ON
#ADIOS2_USE_ZFP:STRING=ON
ADIOS2_USE_ZeroMQ:STRING=ON
#ZFP_ROOT:PATH=/opt/zfp/install

MPI_C_COMPILER:FILEPATH=${MPI_C_COMPILER}
MPI_CXX_COMPILER:FILEPATH=${MPI_CXX_COMPILER}
MPI_Fortran_COMPILER:FILEPATH=${MPI_Fortran_COMPILER}
MPIEXEC_MAX_NUMPROCS:STRING=16
")

include(${CMAKE_CURRENT_LIST_DIR}/../dashboard/adios_common.cmake)
