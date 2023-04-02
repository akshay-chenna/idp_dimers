cd /home/chemical/phd/chz198152/scratch/benchmarks/syn_dimer

module load apps/gromacs/2020.6/intel

export GMX_GPU_DD_COMMS=true

export GMX_GPU_PME_PP_COMMS=true

export GMX_FORCE_UPDATE_DEFAULT_GPU=true

export OMP_NUM_THREADS=20

mpirun -np 1 gmx_mpi mdrun -v -s md.tpr -o md.trr -x md.xtc -cpo md.cpt -e md.edr -g md.log -c md.gro -ntomp 20 -nsteps 25000 -nb gpu -bonded gpu -pme gpu -nstlist 400
