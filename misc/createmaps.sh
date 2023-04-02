cd /home/chemical/phd/chz198152/scratch/covid/nsp12-7-8/proteinonly/contactmaps
module load apps/gromacs/5.1.4/intel
while read -r line 
do
gmx_mpi mdmat -f ../structures/o$line.pdb -s ../structures/o$line.pdb -frames mdmat$line -n ../ind.ndx << EOF
14
EOF

sed -i '6d' contactmap.py
sed -i "6ic=\"mdmat$line.xpm\"" contactmap.py
sed -i '7d' contactmap.py
sed -i "7id=\"mdmat$line.txt\"" contactmap.py
python contactmap.py

cat mdmat$line'.txt' >> mdmatclust30.txt
rm \#*
rm dm*
done < central30bb.txt

mkdir clust30
mv mdmat* clust30/.
