# Scaling test for TCLB

## Installing different versions of TCLB

You can use the `./install.sh` script to install different versions and configurations of TCLB. The arguments are `./install.sh [codename] [fork] [branch] [other args]`, where `[codename]` is just the folder name, `[fork]` is the GitHub user/org name and [branch] is the git branch to clone. For example:
```bash
./install.sh master CFD-GO master LAMMPS=/group/director2188/sprint/LIGGGHTS-PUBLIC/
./install.sh fastdem llaniewski feature/fastdem LAMMPS=/group/director2188/sprint/LIGGGHTS-PUBLIC/
```
The script will clone `TCLB` and compile using [`TCLB_cluster`](https://github/CFD-GO/TCLB_cluster.git)

## Generating data

The testcase data can be generated with the `./gen.sh` script. To do it, a copy of TCLB has to be installed in the `master` folder.

## Running cases

Cases are run in the folders corresponding to the versions of TCLB installed. For now the case scripts are in folders with names corresponding to the cluster names. For example, to run the single GPU tests for the master branch on topaz:
```
cd master
sbatch ../topaz/test.sh
```

