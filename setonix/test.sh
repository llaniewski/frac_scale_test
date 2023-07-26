#!/bin/bash --login

#SBATCH --account=director2188-gpu
#SBATCH --partition=gpu
#SBATCH --ntasks=5
#SBATCH --ntasks-per-node=5
#SBATCH --cpus-per-task=1
#SBATCH --gpus=1
#SBATCH --time=1:00:00

module load rocm/5.4.3

CLB/d3q27_PSM_NEBB/main data/pureflow_1_1.xml


for i in flow_3000_1_1 flow_6000_1_1 flow_9000_1_1 flow_12000_1_1 flow_15000_1_1 flow_18000_1_1 flow_21000_1_1 flow_24000_1_1 flow_27000_1_1
do

echo >map
for j in 0
do
	echo "$j CLB/d3q27_PSM_NEBB/main data/$i.xml" >>map
done
for j in 1 2 3 4
do
	echo "$j CLB/d3q27_PSM_NEBB/lammps data/$i.lammps" >>map
done

# export HCC_SERIALIZE_KERNEL=3
# export HCC_SERIALIZE_COPY=3
# export HIP_TRACE_API=2
# export HIP_DB=api+copy+mem
# export AMD_LOG_LEVEL=4

srun --multi-prog map
done

