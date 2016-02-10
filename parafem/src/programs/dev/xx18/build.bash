#!/bin/bash

if [[ $# == 1 && $1 == 'xx18' ]]; then
    export build=xx18 log=build-xx18.log
elif [[ $# == 1 && $1 == 'modules' ]]; then
    export build=modules log=build-modules.log
else
    echo 'Usage:
build.bash xx18 to build xx18 only
build.bash modules to re-build the ParaFEM modules and p12meshgen'
    exit 2 # incorrect usage
fi

# The following two commands are needed until the new modules are set
# to be the defaults on 24 February 2016.
source $EPCC_PE_RELEASE/nov2015
# This is needed because cray-tpsl is used by cray-petsc without
# actually loading the module.
module load cray-tpsl

# Split in two because /work was slow.  Seems OK on /home to compile modules and xx18 all at once.

module load cray-petsc

(
    export PARAFEM_HOME=$(readlink --canonicalize $PWD/../../../..)
    if [[ $build == 'xx18' ]]; then
	sleep 1 # TDS and /home are sleepy
	./make-parafem-xx18 MACHINE=xc30 -debug --no-libs --no-tools -mpi -xx > $log 2>&1
	sleep 1 # TDS and /home are sleepy
    elif [[ $build == 'modules' ]]; then
	./make-parafem-xx18 MACHINE=xc30 clean execlean &> clean.log
	sleep 1 # TDS and /home are sleepy
	./make-parafem-xx18 MACHINE=xc30 -debug --no-libs --no-tools -mpi --only-modules > $log 2>&1
	sleep 1 # TDS and /home are sleepy
	./make-parafem-xx18 MACHINE=xc30 -debug --no-libs -mpi --only-tools -preproc >> $log 2>&1
	sleep 1 # TDS and /home are sleepy
    fi
)
