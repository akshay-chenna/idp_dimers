for j in {20..20}
do
cp getcontactspy.sh $j'getcontactspy.sh'
sed -i "41ij=${j}" $j'getcontactspy.sh'
qsub -P chemical -q standard -N ${j}contacts -l select=1:ncpus=1 -l walltime=06:00:00 $j'getcontactspy.sh'
done
