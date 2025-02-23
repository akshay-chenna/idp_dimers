# This script will tell us all those residues that are part of clusters having a score greater than 600 ang^2.
# "cat outputs/..." line is needed since some clusters have multilined members

for i in {1..576}
do
	cat outputs/PED9AAC-${i}.pdb.A.clusters | tr "\n" " " | tr "]" "\n" | tr -d "[" > outputs/${i}.cluster_trimmed
	paste outputs/PED9AAC-${i}.pdb.A.cluster_sasa.txt outputs/${i}.cluster_trimmed | awk '{ if ( $1 > 600 ) {$1=""; print $0}}' >> 600area_clusters.txt
	paste outputs/PED9AAC-${i}.pdb.A.cluster_sasa.txt outputs/${i}.cluster_trimmed | awk '{ if ( $1 > 1100 ) {$1=""; print $0}}' >> 1100area_clusters.txt
	paste outputs/PED9AAC-${i}.pdb.A.cluster_sasa.txt outputs/${i}.cluster_trimmed | awk '{ if ( $1 > 1600 ) {$1=""; print $0}}' >> 1600area_clusters.txt
done
cat 600area_clusters.txt | tr " " "\n" | sed  '/^$/d' > temp.txt
mv temp.txt 600area_clusters.txt
cat 1100area_clusters.txt | tr " " "\n" | sed  '/^$/d' > temp.txt
mv temp.txt 1100area_clusters.txt
cat 1600area_clusters.txt | tr " " "\n" | sed  '/^$/d' > temp.txt
mv temp.txt 1600area_clusters.txt

cat outputs/*cluster_trimmed | tr " " "\n" | sed  '/^$/d' > temp.txt
mv temp.txt all_clusters.txt
