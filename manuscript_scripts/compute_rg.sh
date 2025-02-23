cd $PBS_O_WORKDIR
source ~/apps/scripts/source_conda.sh 
conda activate py310
module load apps/gromacs/2022.1/gnu

while read -r l
do

cd $l
pwd
gmx_mpi gyrate -f md_corrected_${l}.xtc -s ../mdframe_1.pdb -o rg_${l} -dt 200 -xvg none << EOF
1
EOF

cat rg_${l}.xvg >> ../rg_500ns.txt

cd ..
	
done < list.txt
