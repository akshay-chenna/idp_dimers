# Long runs on standard queue for 168 hours. Single simulation launch per submit.

#mkdir err_outs
#mkdir scripts
#mkdir trajectories

for run in {1042..1050}
do
	cp l-par_run.sh l-par_run${run}.sh
	sed -i "2iz=${run}" l-par_run${run}.sh
	qsub -P goelg.p2.520 -q standard -N IDP${run} -l select=1:ngpus=1:ncpus=4:centos=skylake -l walltime=168:00:00 l-par_run${run}.sh
	#qsub -P ioe.che.goelg.std.1 -q high -N IDP${run} -l select=1:ngpus=1:ncpus=4:centos=skylake -l walltime=168:00:00 l-par_run${run}.sh
	#qsub -P chemical -q low -N IDP${run} -l select=1:ngpus=1:ncpus=4:centos=skylake -l walltime=96:00:00 l-par_run${run}.sh
	#qsub -P chemical -q test -N IDP${run} -l select=1:ngpus=1:ncpus=4:centos=icelake -l walltime=24:00:00 l-par_run${run}.sh
	#qsub -P chemical -q scai_lowq -N IDP${run} -l select=1:ngpus=1:ncpus=4:centos=amdepyc -l walltime=24:00:00 l-par_run${run}.sh
done
