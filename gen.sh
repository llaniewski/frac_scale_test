#!/bin/bash

TCLB=$PWD/master # This can be any folder with TCLB

RT=$TCLB/tools/RT
LG=$TCLB/CLB/d3q27_PSM_NEBB/lammps

source $TCLB/p/lib

ENGINE="$ENGINE_MAKE"

source_engine $ENGINE
(
	set -e
	q_header $Q_HEADER_SHELL_FLAGS
	q_name "GEN"
	q_queue $MAIN_PARTITION
	q_grant $GRANT
	q_qos $MAIN_QOS
	q_units 1 1 1 0
	q_walltime 0:20:00
	
	env_prepare
	echo $RT -f frac_my.Rt
	echo $RT -f pack.lammps.Rt -o data/pack.lammps
	echo $LG data/pack.lammps
	echo R -f pack_copy.R
	echo $RT -f flow.xml.Rt
	echo $RT -f flow.lammps.Rt
) >tmp.job.scr

q_run "$@" "tmp.job.scr"
