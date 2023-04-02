cd /home/chemical/phd/chz198152/scratch/covid/pep-nsp7/.

#Run to extract the areas and mmpbsa energies peptide wise

#rm *name*.txt totalsasa* deltargetsasa*
#rm totalsasa* deltargetsasa* delatom*
rm delatom*
for i in {1..5}
do

#cd dockedposes/
#ls -v $i* | cut -d . -f1 >> ../names$i.txt
#cd ..

e=`wc -l names$i.txt | awk '{print $1}'`
for ((j=1; j<=$((e));  j++))
do

l=`sed "${j}q;d" names${i}.txt`
#paste areas/complex_r$l.xvg areas/nsp7_r$l.xvg | sed -n 25,94p | awk '{print $7  - $2 }' >> deltargetsasa$i.txt &

sed -i '1141,$d' areas/nsp7_a$l.xvg
tail -n +25 areas/pep_a$l.xvg >> areas/nsp7_a$l.xvg 
paste areas/complex_a$l.xvg areas/nsp7_a$l.xvg | tail -n +25 | awk '{ print $2 - $7 }' >> delatomsasa$i.txt 

#tail -1 areas/complex_t$l.xvg | awk '{print $2}' >> totalsasa$i.txt 

#grep -w $l  nmmpbsa_cum.txt >> mmpbsa$i.txt &

done
#wait
done
