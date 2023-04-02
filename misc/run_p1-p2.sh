# 17-July 2022, This script runs a python script to compute the beta content

source ~/apps/source_conda.sh
conda activate py310

cd $PBS_O_WORKDIR
cd ..

while read -r l
do
	cd $l

	ln -s ../analysis_scripts/calc_p1-p2.py .
	python calc_p1-p2.py mdframe_${l}.pdb md_corrected_${l}.xtc

	rm -rf \#*
	echo $l
	cd ..

done < directories.txt
