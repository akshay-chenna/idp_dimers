for i in {1..576}
do
	paste outputs/PED9AAC-${i}.pdb.A.cluster_sasa.txt outputs/${i}.cluster_trimmed | awk '{ if ( $1 > 600 ) {$1=""; print $0}}' | tr "[\n]" "[ ]" >> outputs/active-passive_${i}.txt
	echo -e "\n" >> outputs/active-passive_${i}.txt
done
