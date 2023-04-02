# 17-July 2022, This script runs a python script to compute the beta content

source ~/apps/source_conda.sh
conda activate py310

cd $PBS_O_WORKDIR
cd ..

while read -r l
do
	cd $l

	ln -s ../analysis_scripts/calc_betacontent.py .
	python calc_betacontent.py md_corrected_${l}.xtc mdframe_${l}.pdb

	rm -rf \#*
	cd ..

done < directories.txt
