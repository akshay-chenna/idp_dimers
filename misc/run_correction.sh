module load apps/gromacs/2021.4/gnu
source ~/apps/source_conda.sh
conda activate py310

cd $PBS_O_WORKDIR
while read -r line
do
	cd ${line}
	cp ../correction.sh .
	nohup bash correction.sh
	cd ..	
done < x1
