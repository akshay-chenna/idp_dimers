# 15-July 2022, This script finds rg and contacts

module load apps/gromacs/2021.4/gnu

cd $PBS_O_WORKDIR
cd ..

while read -r l
do
        cd $l

	echo 1 | gmx_mpi gyrate -f md_corrected_${l}.xtc -s mdframe_${l}.pdb -o rg  
	echo 18 19 | gmx_mpi mindist -f md_corrected_${l}.xtc -s mdframe_${l}.pdb -on contacts -n index.ndx 

	cd ..

done < pending_rg.txt
