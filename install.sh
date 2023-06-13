#!/bin/bash

set -euo pipefail

function usage {
	echo "./install.sh name origin branch [configure options]"
	echo "examples:"
	echo "  ./install.sh dev_float CFD-GO develop --disable-double"
}

if [ $# -lt 3 ]
then
	usage
	exit -1
fi

NAME="$1"
shift
ORIGIN="$1"
shift
BRANCH="$1"
shift

REPO="git@github.com:$ORIGIN/TCLB.git"

if test -d "$NAME"
then
	cd "$NAME"
	git pull
else
	git clone "$REPO" "$NAME"
	cd "$NAME"
	git checkout "$BRANCH"
fi

if test -d "p"
then
	(cd p; git pull)
else
	git clone git@github.com:CFD-GO/TCLB_cluster.git p
fi

if ! test -L data
then
	ln -s ../data/ data
fi

p/config -y "$@"
p/make d3q27_PSM_NEBB

