cd $PBS_O_WORKDIR

module load apps/gromacs/2021.4/gnu

cat list.txt | while read -r l
do
cd $l
echo 1 0 | gmx_mpi trjconv -f em1.gro -s em1.tpr -o frame_cluster.gro -pbc cluster
gmx_mpi grompp -f md.mdp -c frame_cluster.gro -o frame_cluster.tpr
echo 1 | gmx_mpi trjconv -f md.xtc -o md_corrected.xtc -s frame_cluster.tpr -pbc nojump
mv md_corrected.xtc md_corrected_${l}.xtc
cd ..
done
#echo 1 | gmx_mpi trjconv -f md_corrected.xtc -o mdframe.pdb -e 1 -s frame_cluster.tpr
