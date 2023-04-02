for j in {10..10}
do
cp md_launch.sh $j'md_launch.sh'
sed -i "5ij=${j}" $j'md_launch.sh'
qsub -P chemical -q standard -N $j'MD' -l select=1:ngpus=1:ncpus=4:centos=skylake -l walltime=02:00:00 $j'md_launch.sh'
done
