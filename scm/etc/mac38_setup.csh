#!/bin/tcsh

echo "Setting environment variables for SCM-CCPP on Theia with icc/ifort"


echo "Setting CC/CXX/FC environment variables"
setenv CC gcc
setenv CXX c++ 
setenv FC ifort
setenv NETCDF /Volumes/Cluster/usr/local/ifort
#setenv NETCDF /Volumes/User/ppegion/ifort/ 

echo "Setting NCEPLIBS_DIR environment variable"
set NCEPLIBS_DIR = "/Users/ppegion/ncep_libs"
setenv NCEPLIBS_DIR $NCEPLIBS_DIR
