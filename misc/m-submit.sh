#mkdir err_outs
#mkdir scripts
#mkdir trajectories

for run in {1710..1719}
do
	cp m-par_run.sh m-par_run${run}.sh
	sed -i "2iz=${run}" m-par_run${run}.sh
	#qsub -P chemical -q standard -N dimer${run} -l select=1:ngpus=1:ncpus=4:centos=skylake -l walltime=96:00:00 m-par_run${run}.sh
	#qsub -P chemical -q low -N dimer${run} -l select=1:ngpus=1:ncpus=4:centos=skylake -l walltime=96:00:00 m-par_run${run}.sh
	#qsub -P chemical -q test -N dimer${run} -l select=1:ngpus=1:ncpus=4:centos=icelake -l walltime=24:00:00 m-par_run${run}.sh
	qsub -P chemical -q scai_lowq -N dimer${run} -l select=1:ngpus=1:ncpus=4:centos=amdepyc -l walltime=24:00:00 m-par_run${run}.sh
done
