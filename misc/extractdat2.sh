cd $PBS_O_WORKDIR
#module load apps/gromacs/5.1.4/intel

#Run to extract the areas

while read -r l
do

sed -n 25,94p areas/complex_r${l}.xvg > temp2.txt
tail -n +25 areas/nsp7_r${l}.xvg | paste temp2.txt - | awk '{print $7  - $2 }' >> deltargetsasa2.txt

tail -1 areas/complex_t${l}.xvg | awk '{print $2}' >> totalsasa2.txt 

done < x2.txt

