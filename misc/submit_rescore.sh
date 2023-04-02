for run in {1..20}
do
        cp rescore.sh rescore${run}.sh
        sed -i "1ii=${run}" rescore${run}.sh
        qsub -P chemical -q serial -N rescore${run} -l select=1:ncpus=1 -l walltime=24:00:00 rescore${run}.sh
done
