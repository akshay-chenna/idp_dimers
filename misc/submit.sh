mkdir scripts
mkdir err_outs
for run in {1..1}
do
	cp par_run.sh par_run${run}.sh
	sed -i "3iz=${run}" par_run${run}.sh
	qsub -P chemical -N homo${run} -l select=30:ncpus=1 -l walltime=30:00:00 par_run${run}.sh
done
