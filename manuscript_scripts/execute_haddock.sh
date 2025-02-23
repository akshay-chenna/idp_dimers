while read -r line
do

cd ~/scratch/ensemble_dock/master/
mkdir ../docked_ensemble

i=`echo ${line} | awk '{ print $1 }'`
j=`echo ${line} | awk '{ print $2 }'`

mkdir ../conf${i}_${j}

cp ../active_passive/active-passive_${i}.txt ../conf${i}_${j}
cp ../active_passive/active-passive_${j}.txt ../conf${i}_${j}

echo "AMBIG_TBL=./ambig.tbl" >> ../conf${i}_${j}/run.param 
echo "HADDOCK_DIR=/home/chemical/phd/chz198152/apps/haddock2.4-2021-05" >> ../conf${i}_${j}/run.param
echo "N_COMP=2" >> ../conf${i}_${j}/run.param
echo "PDB_FILE1=./PED9AAC-${i}.pdb" >> ../conf${i}_${j}/run.param
echo "PDB_FILE2=./PED9AAC-${j}.pdb" >> ../conf${i}_${j}/run.param
echo "PROJECT_DIR=./" >> ../conf${i}_${j}/run.param
echo "RUN_NUMBER=1" >> ../conf${i}_${j}/run.param

cd ../conf${i}_${j}

/home/apps/anaconda3/5.2.0/gnu/bin/python ~/apps/haddock-tools/active-passive-to-ambig.py active-passive_${i}.txt active-passive_${j}.txt | sed s/segid/name\ CA\ and\ segid/g | sed s/2.0/3.0/g > ambig.tbl

cp ../master/generate_run.sh .
cp ../monomer_ensemble/PED9AAC-${i}.pdb .
cp ../monomer_ensemble/PED9AAC-${j}.pdb .
./generate_run.sh	

cd run1
sed -i 's/noecv=true/noecv=false/g' run.cns
sed -i 's/structures_0=1000/structures_0=250/g' run.cns
sed -i 's/structures_1=200/structures_1=0/g' run.cns
sed -i 's/anastruc_1=200/anastruc_1=0/g' run.cns
sed -i 's/firstwater="yes"/firstwater="no"/g' run.cns
sed -i 's/fcc_ignc=false/fcc_ignc=true/g' run.cns
sed -i 's/cpunumber_1=1/cpunumber_1=2/g' run.cns
random=`shuf -i 100-999 -n1`
seed=`grep iniseed run.cns | cut -d = -f 5 | cut -d ';' -f 1 | head -1`
sed -i "s/iniseed=${seed}/iniseed=${random}/g" run.cns

cp ../generate_run.sh .
./generate_run.sh >> run.out	

cp ../../master/run_analysis.sh ./structures/it0/.
cd structures/it0/
./run_analysis.sh
awk '{ print $1 "\t" $2 "\t" $3 "\t" 1.9*$8 -0.8*$NF -0.02*$((NF-2))}' structures_ene-sorted.stat | sort -nk 3 | column -t > ene-weighted-sorted.stat
awk '{ print $1 "\t" $2 "\t" 1.9*$8 -0.8*$NF -0.02*$((NF-2))}' structures_ene-sorted.stat | column -t >> ../../../../ene-reweighted.txt

cd ../../../../
tar cvf conf${i}_${j}.tar.xz --use-compress-program='xz' conf${i}_${j}
mv conf${i}_${j}.tar.xz docked_ensemble/.
rm -rf conf${i}_${j}
rm master/execute_haddock-${i}_${j}.sh
done < /home/chemical/phd/chz198152/scratch/ensemble_dock/master/lists/x.in
