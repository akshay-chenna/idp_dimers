for j in {1..1}
do
cp initial.sh $j'initial.sh'
sed -i "13ij=${j}" $j'initial.sh'
qsub -P goelg.p2.451 -q standard -N $j'initial' -l select=1:ncpus=1 -l walltime=00:30:00 $j'initial.sh'
done
