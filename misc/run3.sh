i=3

cd ~/scratch/benchmarks/syn_dimer_gmx20/run6/
module load apps/gromacs/2020.6/intel
nvidia-cuda-mps-control -d
export OMP_NUM_THREADS=1
for ((j=$(((i-1)*4+1)); j<=$(((i-1)*4+4)); j++)) ; do
	mkdir ${j}
	cp md.tpr ${j}/.
	cd ${j}
	mpirun -np 1 gmx_mpi mdrun -v -s md.tpr -deffnm md -ntomp 1 -nstlist 150 -nsteps 50000 -pin on -nb gpu -bonded gpu -pme gpu -update gpu &
	cd ..
done
wait
