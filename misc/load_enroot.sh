module load apps/enroot/3.2.0
enroot create -n gmx /home/apps/skeleton/nvidia_bootcamp/containers/hpc+gromacs+2021.3.sqsh 
enroot list
enroot start gmx
cd ~/scratch/benchmarks/syn_dimer/
