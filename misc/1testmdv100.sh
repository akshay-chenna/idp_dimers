cd /scratch/chemical/phd/chz198152/asyntest/
module load apps/gromacs/5.1.4/intel
a=20
b=1
d=89
export OMP_NUM_THREADS=$b
mpirun -np $a gmx_mpi mdrun -v -s md.tpr -deffnm md$d -ntomp $b -pin on
#mpirun -np $a gmx_mpi mdrun -v -s md.tpr -o md.trr -x md.xtc -cpo md.cpt -e md.edr -g 1v100md_$d.log -c md.gro -ntomp $b 
c=`grep Performance md$d.log | awk '{print $2}'`
echo -e "$d \t 1 \t 20 \t $a \t $b \t $c" >> 1benchv100.txt
rm \#*
