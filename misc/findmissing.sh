cd /home/chemical/phd/chz198152/scratch/covid/pep-nsp7/.

#Run to find the missing areas

for i in {1..5}
do

e=`wc -l names$i.txt | awk '{print $1}'`
for ((j=1; j<=$((e));  j++))
do

l=`sed "${j}q;d" names${i}.txt`

if [ -e areas/complex_a$l.xvg ]
then
echo $l
else
echo $l >> missedareas.txt
fi

done
done
