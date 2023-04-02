cd /home/chemical/phd/chz198152/scratch/covid/pep-nsp7
module load apps/gromacs/5.1.4/intel/

mkdir selected_poses

for i in {1..5}
do

while read -r line
do

rm\#*
l=`sed "${line}q;d" names${i}.txt`
gmx_mpi trjconv -f emposes/em$l.gro -o selected_poses/em$l.pdb -s emposes/em$l.tpr << EOF
1
EOF
gmx_mpi editconf -f selected_poses/em$l.pdb -o selected_poses/em$l.pdb -label A
a=`grep -n OT2 selected_poses/em$l.pdb | head -1 | cut -d : -f 1`
n=$((a+1))
sed -i "${n}iTER" selected_poses/em$l.pdb
sed -i "${n},$ s/ A / B /" selected_poses/em$l.pdb
done < complex$i.txt

rm selected_poses/\#*
done
