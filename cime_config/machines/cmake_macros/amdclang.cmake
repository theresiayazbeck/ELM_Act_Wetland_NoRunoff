if (compile_threaded)
  string(APPEND FFLAGS " -fopenmp")
  string(APPEND CFLAGS " -fopenmp")
  string(APPEND CXXFLAGS " -fopenmp")
  string(APPEND LDFLAGS " -fopenmp")
endif()
string(APPEND CPPDEFS " -DNO_R16 -DCPRAMD -DFORTRANUNDERSCORE")
