module load apps/gromacs/2020.6/intel

for i in {1..15}
do
	cd $i
	echo 1 | gmx_mpi trjconv -f md.xtc -s md.tpr -o mdf.xtc -n index.ndx -pbc whole
	mkdir md_frames
	#echo 1 | gmx_mpi trjconv -f mdf.xtc -s md.tpr -o md_frames/frame.pdb -sep -pbc nojump
	echo 1 | gmx_mpi trjconv -f mdf.xtc -s md.tpr -o md_corrected.xtc -n index.ndx -pbc nojump
	rm mdf.xtc
	cd ..
done
