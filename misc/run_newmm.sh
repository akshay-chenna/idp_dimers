for j in {1..10}
do
cp new_hybrid.sh $j'new_hybrid.sh'
sed -i "6ij=${j}" $j'new_hybrid.sh'
qsub -P goelg.p2.451 -q standard -N $j'mmpbsa' -l select=81:ncpus=1 -l walltime=22:00:00 $j'new_hybrid.sh'
done
