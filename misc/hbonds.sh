# 18-July 2022, This script finds main chain hydrogen bonds needed between the chain.

module load apps/gromacs/2021.4/gnu

cd $PBS_O_WORKDIR
cd ..

while read -r l
do
        cd $l

#gmx_mpi make_ndx -n index.ndx -o index.ndx << EOF
#18 & 7
#19 & 7
#q
#EOF	

gmx_mpi hbond -f md_corrected_${l}.xtc -s md.tpr -n index.ndx -num inter_mainchain_hb.xvg << EOF
20
21
EOF
	cd ..

done < directories.txt
