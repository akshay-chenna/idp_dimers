cd $PBS_O_WORKDIR
source ~/apps/scripts/source_conda.sh 
conda activate py310
module load apps/gromacs/2022.1/gnu

while read -r l
do

cd $l
pwd

echo 18 19 | gmx_mpi mindist -f md_corrected_${l}.xtc -s ../mdframe_1.pdb -on contacts_${l} -n index.ndx  -dt 200 -xvg none

cat contacts_${l}.xvg >> ../contacts_500ns.txt

cd ..
	
done < list.txt
