

TCLB=master # This can be any folder with TCLB

RT=$TCLB/tools/RT
LG=$TCLB/CLB/d3q27_PSM_NEBB/lammps

# $RT -f frac_my.Rt
#$RT -f pack.lammps.Rt -o data/pack.lammps
#$LG data/pack.lammps
#R -f pack_copy.R
$RT -f flow.xml.Rt
$RT -f flow.lammps.Rt
