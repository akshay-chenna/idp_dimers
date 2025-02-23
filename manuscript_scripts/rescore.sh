
cd $PBS_O_WORKDIR

while read -r line
do
tar -xf docked_ensemble/${line}
a=`echo ${line} | cut -d . -f 1`
awk '{ print $1 "\t" $2 "\t" 1.9*$8 -0.8*$NF -0.02*$((NF-2))}' ${a}/run1/structures/it0/structures_ene-sorted.stat | column -t >> ene-reweighted.txt
rm -rf $a
done < data/x${i}
