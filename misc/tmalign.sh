cd ~/scratch/peptides/

for i in {5..7} 
do

mkdir scores$i

e=`wc -l namescpp.txt | awk '{print $1}'`

for ((j=1; j<=$((e));  j++))
do

l=`sed "${j}q;d" namescpp.txt`

./TMalign cpp/$l'.pdb' central$i.pdb > scores$i/$l'.txt'

a=`grep TM-score 'scores'$i/$l'.txt' | head -2 | awk '{print $2}' | sort -r | head -1`

if (( $(echo "$a >= 0.5" |bc -l) ))
then
	echo $l >> similar$i'.txt'
else
	continue
fi

done
done


