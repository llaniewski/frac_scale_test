#!/bin/bash
#SBATCH -A plgclb2023-gpu-a100
#SBATCH -p plgrid-gpu-a100
#SBATCH --cpus-per-task=1
#SBATCH --tasks-per-node 5
#SBATCH --time=01:00:00
#SBATCH --gres=gpu

module load GCC/11.2.0 GCCcore/11.2.0 libtirpc/1.3.2 OpenMPI/4.1.2 CUDA/11.6.0

~/TCLB/CLB/d3q27_PSM_NEBB/main pureflow.xml
for i in flow_3000_1_1 flow_6000_1_1 flow_9000_1_1 flow_12000_1_1 flow_15000_1_1 flow_18000_1_1 flow_21000_1_1 flow_24000_1_1 flow_27000_1_1
do
	mpirun -np 1 ~/TCLB/CLB/d3q27_PSM_NEBB/main $i.xml : -np 4 ~/TCLB/CLB/d3q27_PSM_NEBB/lammps $i.lammps
done
