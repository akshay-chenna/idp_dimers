cd $PBS_O_WORKDIR
k=0

for ((i=$(((z-1)*200+1)); i<=$((z*200)); i++))
do
		k=$((k+1))
		cp execute_haddock.sh execute_haddock${i}.sh
        	sed -i "s/x.in/x${i}/g" execute_haddock${i}.sh
        	ssh  `sed "${k}q;d" $PBS_NODEFILE` 'bash -s' < execute_haddock${i}.sh &
done
wait

for ((i=$(((z-1)*200+1)); i<=$((z*200)); i++))
do
		mv execute_haddock${i}.sh scripts/
done

mv par_sim${z}.sh scripts/.
