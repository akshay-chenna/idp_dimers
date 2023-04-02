cd $PBS_O_WORKDIR
#module load apps/gromacs/5.1.4/intel

#Run to extract the areas

while read -r l
do

sed -n 25,94p areas/complex_r${l}.xvg > temp.txt
tail -n +25 areas/nsp7_r${l}.xvg | paste temp.txt - | awk '{print $7  - $2 }' >> deltargetsasa1.txt

tail -1 areas/complex_t${l}.xvg | awk '{print $2}' >> totalsasa1.txt 

done < x1.txt
