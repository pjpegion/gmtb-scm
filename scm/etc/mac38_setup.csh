#!/bin/bash

echo "Setting environment variables for SCM-CCPP on MACOSX with clang/gfortran"

setenv CC /opt/local/bin/mpicc
setenv CXX /opt/local/bin/mpicxx
setenv F77 /opt/local/bin/mpif77
setenv F90 /opt/local/bin/mpif90
setenv FC /opt/local/bin/mpif90
setenv CPP "/opt/local/bin/mpif90 -E -x f95-cpp-input"

setenv LDFLAGS "-L/opt/local/libexec/llvm-7.0//lib"
setenv CPPFLAGS "-I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/ -I/opt/local/libexec/llvm-7.0/include"
setenv CXXFLAGS "-I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/ -I/opt/local/libexec/llvm-7.0/include"
setenv CFLAGS "-I /Volumes/Cluster/opt/local/include/"
setenv FFLAGS "-fmax-stack-var-size=30000 -fbounds-check -fcheck=all -gdwarf-4 -fvar-tracking-assignments -fbacktrace -fcheck=bounds -fdec"

if (! $?PATH) then
  setenv PATH " /opt/local/libexec/llvm-7.0/bin"
else
  setenv PATH " /opt/local/libexec/llvm-7.0/bin:$PATH"
endif
if (! $?LD_LIBRARY_PATH) then
  #setenv LD_LIBRARY_PATH "/usr/local/opt/zlib/lib:/opt/local/libexec/llvm-7.0//usr/local/opt/llvm/lib"
  setenv LD_LIBRARY_PATH "/opt/local/libexec/llvm-7.0/lib"
else
  #setenv LD_LIBRARY_PATH "/usr/local/opt/zlib/lib:/opt/local/libexec/llvm-7.0//usr/local/opt/llvm/lib:$LD_LIBRARY_PATH"
  setenv LD_LIBRARY_PATH "/opt/local/libexec/llvm-7.0/lib:$LD_LIBRARY_PATH"
endif
setenv NETCDF /Volumes/Cluster/opt/local
set NCEPLIBS_DIR = "/Users/ppegion/ncep_libs.2"
setenv NCEPLIBS_DIR $NCEPLIBS_DIR
