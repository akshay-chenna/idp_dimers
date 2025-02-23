# Requires voronota.sh transition_prob.in sa.in
run_markov(){
while read -r line
do
	ipython markov_hotspots.py ${line} >> run.out
done < $1
}

for i in x{00..15}
do
	run_markov $i &
done
wait
rm *pdb
mv *.out outputs/
