# This script clusters the docked poses based on contacts.
# Uses haddock, also see bonvin's github: https://github.com/haddocking/fcc
# 21-April-2022

cd $PBS_O_WORKDIR
#0
export HADDOCKTOOLS="/home/chemical/phd/chz198152/apps/haddock2.4-2021-05/tools"

for j in {1..20}
do

#mkdir haddock${j}
#for i in {1..5000} ; do $HADDOCKTOOLS/pdb_chain-to-segid outputs/m${j}-${i}_0001.pdb > haddock${j}/m${j}-${i}.pdb ; done

#1 Generate contacts
#ls haddock${j}/*.pdb | sort -t - -nk 2 > list${j}.txt   # a list containing file names
#$HADDOCKTOOLS/make_contacts.py -f list${j}.txt # 5 Ang cutoff for contacts

#sed 's/.pdb/.contacts/g' list${j}.txt | sed '/^$/d' | sort -t - -nk2 > clist${j}.txt

#2 Make contact matrix
#$HADDOCKTOOLS/calc_fcc_matrix.py -f clist${j}.txt -o haddock${j}/fcc_matrix${j}.mat

#3 Cluster
$HADDOCKTOOLS/cluster_fcc.py data/fcc_matrix${j}.mat 0.75 -o data/cluster${j}_075.out -c 1 # Clusters with a minimum of one complex
#rm *list${j}.txt 

done
