#!/bin/bash

if ! test -z "$1"
then
	ARG="LAMMPS=$1"
fi
./install.sh singlekernel llaniewski feature/singlekernel $ARG
./install.sh interior llaniewski feature/interior $ARG
./install.sh fastdem llaniewski feature/fastdem $ARG
./install.sh develop CFD-GO develop $ARG
