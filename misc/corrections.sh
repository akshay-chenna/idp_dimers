#Trajectory corrections
echo 1 0 | gmx_mpi trjconv -f em1.gro -s em1.tpr -o frame_cluster.gro -pbc cluster
gmx_mpi grompp -f md.mdp -c frame_cluster.gro -o frame_cluster.tpr
echo 1 | gmx_mpi trjconv -f md.xtc -o md_corrected.xtc -s frame_cluster.tpr -pbc nojump
echo 1 | gmx_mpi trjconv -f md_corrected.xtc -o mdframe.pdb -b 10000 -s frame_cluster.tpr
