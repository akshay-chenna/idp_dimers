# To calculate the fraction of contacts 

cd /home/chemical/phd/chz198152/scratch/rosetta_1

readarray a < top3k.names
fnat=()
for i in {0..2999}; do
for ((j=0; j<=2999; j++));do

if [ $j -lt $i ]

then
fnat+=(99)

else
fnat+=(`~/scratch/dockq/./fnat lowrespdbs/${a[$i]} lowrespdbs/${a[$j]} 5 | grep Fnat | awk '{print $NF}'`)

fi

done 
done

echo ${fnat[*]} > fnattop3k.txt
