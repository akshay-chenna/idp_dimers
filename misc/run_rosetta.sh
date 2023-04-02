for j in {2..11}
do
cp relax.sh ${j}relax.sh
sed -i "5ij=${j}" ${j}relax.sh
qsub -P goelg.p2.451 -q standard -N ${j}Relax -l select=75:ncpus=1:mpiprocs=1 -l walltime=18:00:00 ${j}relax.sh
done
