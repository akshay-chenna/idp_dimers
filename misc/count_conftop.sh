sort -nk2 lowres.sc | head -1000 | awk '{print $6 " " $7}' | cut --complement -d . -f 3 | cut --complement -b 2-5 >> conformers1k.list 

for i in {1..5} ; do
for ((j=i; j<=5; j++)); do

if [ $i -ne $j ]
then
c=`grep "$i $j" conformers1k.list | wc -l`
d=`grep "$j $i" conformers1k.list | wc -l`

echo -e "$i$j \t $(($c+$d))" >> population1k.txt

else
c=`grep "$i $j" conformers1k.list | wc -l`
echo -e "$i$j \t $c" >> population1k.txt
fi

done
done

