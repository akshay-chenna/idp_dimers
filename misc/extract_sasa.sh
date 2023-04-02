cd $PBS_O_WORKDIR
module load apps/gromacs/5.1.4/intel

#Run to extract the areas

while read -r l
do

sed -n 53,122p areas/complex_r${l}.xvg > temp.txt
tail -n +25 areas/nsp7_r${l}.xvg | paste temp.txt - | awk '{print $7  - $2 }' >> deltargetsasa.txt

#tail -n +25 areas/nsp7_a${l}.xvg >> areas/kb1_a${l}.xvg
#paste areas/complex_a${l}.xvg areas/kb1_a${l}.xvg | tail -n +25 | awk '{ print $2 - $7 }' >> delatomsasa.txt

tail -1 areas/complex_t${l}.xvg | awk '{print $2}' >> totalsasa.txt

done < names.txt
