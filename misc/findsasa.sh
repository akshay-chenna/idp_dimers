cd ~/scratch/covid/DESRES-Trajectory_sarscov2-10917618-no-water-zinc-glueCA/sarscov2-10917618-no-water-zinc-glueCA
module load apps/gromacs/2019.4/intel
gmx_mpi sasa -f out.trr -s mae.pdb -or res0_1.xvg -o tot0_1.xvg -surface 0 -output 14 -ndots 2000 -n ind.ndx &
gmx_mpi sasa -f out.trr -s mae.pdb -or res1_1.xvg -o tot1_1.xvg -surface 14 -output 14 -ndots 2000 -n ind.ndx &
gmx_mpi sasa -f out.trr -s mae.pdb -or res0_3.xvg -o tot0_3.xvg -surface 0 -output 16 -ndots 2000 -n ind.ndx &
gmx_mpi sasa -f out.trr -s mae.pdb -or res3_3.xvg -o tot3_3.xvg -surface 16 -output 16 -ndots 2000 -n ind.ndx 
wait

