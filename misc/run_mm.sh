for j in {1..3}
do

k=$(((j-1)*22200+1))
l=$((j*22200))
sed -n $k,$l'p' names.txt > names$j.txt

cp mmpbsa.sh ${j}mmpbsa.sh
sed -i "4ij=${j}" ${j}mmpbsa.sh

qsub -P goelg.p2.216 -q standard -N $j'mmpbsa' -l select=100:ncpus=1 -l walltime=30:00:00 ${j}mmpbsa.sh

done

