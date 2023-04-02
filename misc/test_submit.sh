run=137
cp par_run.sh par_run${run}.sh
sed -i "2iz=${run}" par_run${run}.sh
qsub -P chemical -q test -N Fv${run} -l select=1:ngpus=1:ncpus=4:centos=icelake -l walltime=04:00:00 par_run${run}.sh
