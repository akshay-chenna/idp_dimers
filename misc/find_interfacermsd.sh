for i in {1..15}
do
	cd $i
	python ../traj_interface_rmsd.py ../random_frame.pdb md_corrected.xtc 7.5
	mv *.jpg rmsd_${i}.jpg
	cd ..
done
