mkdir scripts
for run in {74..77}
do
	cp par_run.sh par_run${run}.sh
	sed -i "3iz=${run}" par_run${run}.sh
	qsub -P chemical -N Run${run} -l select=200:ncpus=1 -l walltime=06:00:00 par_run${run}.sh
done
