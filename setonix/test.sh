#!/bin/bash --login

#SBATCH --account=director2188-gpu
#SBATCH --partition=gpu
#SBATCH --ntasks=5
#SBATCH --ntasks-per-node=5
#SBATCH --cpus-per-task=1
#SBATCH --gpus=1
#SBATCH --time=0:10:00

module load rocm/5.4.3
echo >map
for i in 0
do
	echo "$i CLB/d3q27_PSM_NEBB/main data/flow_3000_1_1.xml" >>map
done
for i in 1 2 3 4
do
	echo "$i CLB/d3q27_PSM_NEBB/lammps data/flow_3000_1_1.lammps" >>map
done

export HCC_SERIALIZE_KERNEL=3
export HCC_SERIALIZE_COPY=3
export HIP_TRACE_API=2
export HIP_DB=api+copy+mem
export AMD_LOG_LEVEL=4

srun --multi-prog map


