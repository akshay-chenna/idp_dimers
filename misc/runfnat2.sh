# to calculate the fraction of contacts
cd /home/chemical/phd/chz198152/scratch/rosetta_1

readarray a < top3k.names
readarray b <top3kfrom50k.names

#export OMP_NUM_THREADS=4

for i in {0..3000}; do
for ((j=0; j<=3000; j++));do

<< 'END'
if [ $j -lt $i ]

then
fnat=99
echo -e "${a[$i]} \t ${b[$j]} \t $fnat" >> fnatt-10k.txt

else
END

fnat=`~/scratch/dockq/./fnat lowrespdbs/${a[$i]} lowrespdbs/${b[$j]} 5 | grep Fnat | awk '{print $NF}'`
echo -e "${a[$i]}${b[$j]}$fnat" >> fnatt-50k.txt

#fi
done &
wait
done

