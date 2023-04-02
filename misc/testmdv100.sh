cd /scratch/chemical/phd/chz198152/asyntest/
module load apps/gromacs/5.1.4/intel
a=2
b=10
d=9
export OMP_NUM_THREADS=$b
mpirun -np $a gmx_mpi mdrun -v -s md.tpr -deffnm md$d -ntomp $b &
mpirun -np $a gmx_mpi mdrun -v -s md.tpr -o md.trr -x md.xtc -cpo md.cpt -e md.edr -g v100md_$d.log -c md.gro -ntomp $b 
c=`grep Performance md_$d.log | awk '{print $2}'`
echo -e "$d \t 2 \t 40 \t $a \t $b \t $c" >> benchv100.txt
rm \#*
