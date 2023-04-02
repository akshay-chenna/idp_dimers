cd /scratch/chemical/phd/chz198152/asyntest/
module load apps/gromacs/5.1.4/intel
a=4
b=16
d=3
export OMP_NUM_THREADS=$b
mpirun -np $a gmx_mpi mdrun -v -s md.tpr -o md.trr -x md.xtc -cpo md.cpt -e md.edr -g k40md_$d.log -c md.gro -ntomp $b
c=`grep Performance md_$d.log | awk '{print $2}'`
echo -e "$d \t 4 \t 64 \t $a \t $b \t $c" >> benchk40.txt
rm \#*
