cd $PBS_O_WORKDIR

#Run to extract the areas
for l in {1..5000}
do
sed -n 55,124p areas/complex_r${l}.xvg > temp.txt
tail -n +26 areas/nsp7_r${l}.xvg | paste temp.txt - | awk '{print $7  - $2 }' >> deltargetsasa1.txt

#tail -n +25 areas/nsp7_a${l}.xvg >> areas/kb1_a${l}.xvg
#paste areas/complex_a${l}.xvg areas/kb1_a${l}.xvg | tail -n +25 | awk '{ print $2 - $7 }' >> delatomsasa.txt

tail -1 areas/complex_t${l}.xvg | awk '{print $2}' >> totalsasa1.txt

done
