cd /home/chemical/phd/chz198152/scratch/covid/kb1-chC1/sasa
module load apps/gromacs/5.1.4/intel

#Run to extract the areas

while read -r l
do

sed -n 25,53p areas/complex_r${l}.xvg > temp.txt
tail -n +25 areas/kb1_r${l}.xvg | paste temp.txt - | awk '{print $7  - $2 }' >> delkb1sasa.txt

done < best_names.txt
