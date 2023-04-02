cd ~/scratch/vs_4res/cyclic2

i=1
while read -r line
do
	echo "cd ~/scratch/vs_4res/cyclic2" >> conf$i.sh
	echo "source ~/.bashrc" >> conf$i.sh
	echo "loadalignit" >> conf$i.sh
	name=$line
	echo "mpirun -np 1 ~/scratch/apps/alignit/bin/align-it -r ../db/s1_4res/${name}.phar --refType PHAR -d ../db/cyclicm.phar --dbType PHAR -p ${name}_match90.phar -o ${name}_aligned90.pdb -s ${name}_score90.txt -e 0.90" >> conf${i}.sh

i=$((i+1))
done < names4res.list


for i in {0..4}
do
	j=$((i*10))
	echo "cd ~/scratch/vs_4res/cyclic2" >> master$i.sh
	echo "bash conf$((j+1)).sh &" >> master$i.sh
	echo "bash conf$((j+2)).sh &" >> master$i.sh
	echo "bash conf$((j+3)).sh &" >> master$i.sh
	echo "bash conf$((j+4)).sh &" >> master$i.sh
	echo "bash conf$((j+5)).sh &" >> master$i.sh
	echo "bash conf$((j+6)).sh &" >> master$i.sh
	echo "bash conf$((j+7)).sh &" >> master$i.sh
	echo "bash conf$((j+8)).sh &" >> master$i.sh
	echo "bash conf$((j+9)).sh &" >> master$i.sh
	echo "bash conf$((j+10)).sh &" >> master$i.sh
	echo "wait" >> master$i.sh
	
	qsub -P chemical -q low -N cyclic4_$i -l select=1:ncpus=10 -l walltime=40:00:00 master$i.sh
done
