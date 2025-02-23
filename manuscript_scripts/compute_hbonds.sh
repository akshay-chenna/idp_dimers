cd $PBS_O_WORKDIR
source ~/apps/scripts/source_conda.sh 
conda activate py310
module load apps/gromacs/2022.1/gnu

while read -r l
do

cd $l
pwd

#gmx_mpi make_ndx -n index.ndx -o index.ndx << EOF
#18 & 7
#19 & 7
#q
#EOF	

gmx_mpi hbond -f md_corrected_${l}.xtc -s md.tpr -n index.ndx -num inter_mainchain_hb_${l}.xvg -dt 200 -xvg none << EOF
20
21
EOF

cat inter_mainchain_hb_${l}.xvg >> ../inter_mainchain_hb_500ns.txt

cd ..
	
done < list.txt
