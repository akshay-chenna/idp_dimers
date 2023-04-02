for j in {1..12}
do
cp energymin.sh $j'energymin.sh'
k=$(((j-1)*6000+1))
l=$((j*6000))
sed -n ${k},${l}p names.txt > names${j}.txt
sed -i "4ij=${j}" ${j}energymin.sh
qsub -P goelg.p2.216 -q standard -N ${j}Kalata -l select=1:ngpus=1:ncpus=10 -l walltime=20:00:00 ${j}energymin.sh
done

