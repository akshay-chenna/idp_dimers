cd $PBS_O_WORKDIR
for k in {1..1}; do
for i in {1..2} ; do
	cp run.sh run${i}.sh
	sed -i "1ii=${i}" run${i}.sh
	ssh  `sed "${i}q;d" $PBS_NODEFILE` 'bash -s' < run${i}.sh &
done
wait 
done
