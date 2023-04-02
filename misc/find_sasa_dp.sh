# Calculates the sasa and dot product
# 18-Oct-2022

cd $PBS_O_WORKDIR
k=1
while read -r i
do
	cd $i
	cp ../*.py .
	echo "cd /home/chemical/phd/chz198152/scratch/covid/design_kb1/cpp_md10ns/$i" > execute_python.sh
	echo "source ~/apps/scripts/source_conda.sh ; conda activate hamsm_env2 ; python calc_sasa.py ; python calc_dp.py" >> execute_python.sh
	ssh  `sed "${k}q;d" $PBS_NODEFILE` 'bash -s' < execute_python.sh &
	cd ..
	k=$((k+1))
done < mmlist.txt
wait
