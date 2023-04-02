awk '{print $6 " " $7}' lowres.sc | cut --complement -d . -f 3 | cut --complement -b 2-5 >> conformers.list 

for i in {1..5} ; do
for ((j=i; j<=5; j++)); do

if [ $i -ne $j ]
then
c=`grep "$i $j" conformers.list | wc -l`
d=`grep "$j $i" conformers.list | wc -l`

echo -e "$i$j \t $(($c+$d))" >> population.txt

else
c=`grep "$i $j" conformers.list | wc -l`
echo -e "$i$j \t $c" >> population.txt
fi

done
done

