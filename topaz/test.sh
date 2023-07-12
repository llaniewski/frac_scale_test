#!/bin/bash
#SBATCH --job-name=TCLB:single_gpu
#SBATCH --partition=gpuq-dev
#SBATCH --account=pawsey0267
#SBATCH --nodes=1
#SBATCH --ntasks=5
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=5
#SBATCH --gres=gpu:1
#SBATCH --mem=16G
#SBATCH --time=1:00:00

ulimit -l unlimited
echo "running on:"
hostname

date

set -e # exit on error
module load cuda/11.4.2
module load r/4.0.2
module load openmpi-ucx-gpu/4.0.2

i=flow_0_1_1
CLB/d3q27_PSM_NEBB/main data/$i.xml


for i in flow_3000_1_1 flow_6000_1_1 flow_9000_1_1 flow_12000_1_1 flow_15000_1_1 flow_18000_1_1 flow_21000_1_1 flow_24000_1_1 flow_27000_1_1
do
	mpirun -np 1 CLB/d3q27_PSM_NEBB/main data/$i.xml : -np 4 CLB/d3q27_PSM_NEBB/lammps data/$i.lammps
done
