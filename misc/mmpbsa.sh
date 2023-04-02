# Script to perform mmpbsa cyclotide protein complex
# 12-March-2022, IIT Delhi

cd $PBS_O_WORKDIR
module load apps/gromacs/5.1.4/intel

mmpbsa() {
	for i in {1..1} # Number of serial runs on each core
		do
		line=`sed "$1q;d" mmlist.txt`
		cd ${line}
                export OMP_NUM_THREADS=1
		cp mmpbsa.mdp mmpbsa1.mdp	
		sed -i 's/pdie            = 4/pdie            = 1/g' mmpbsa1.mdp
                #gmx_mpi grompp -f em1.mdp -c conf_i.gro -r conf_i.gro -p topol.top -o mmpbsa.tpr -po noout.mdp
		echo 1 2 | mpirun -np 1 -host `sed "$1q;d" $PBS_NODEFILE` ./g_mmpbsa -f md_corrected.xtc -s mmpbsa.tpr -n ind.ndx -i mmpbsa1.mdp -pdie 1 -mme -mm mm1.xvg -pbsa -pol pol1.xvg -apol apol1.xvg -decomp -mmcon contrib_mm1.dat -pcon contrib_pol1.dat -apcon contrib_apol1.dat -b 5000 -e 10000 -dt 20 
		cd .. 
	done
}

for task in {1..39} # Number of parallel runs
do
	mmpbsa $task &
done
wait
