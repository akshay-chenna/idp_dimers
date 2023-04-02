cd $PBS_O_WORKDIR
i=1000
while [ "$i" -le 1500 ] 
do 
	a=$(qstat -u $USER | grep test | wc -l)
	if [ "$a" -lt 10 ]
	then
		sed -i "s/run=${i}/run=$((i+1))/g" mtest_submit.sh
		bash mtest_submit.sh
		i=$((i+1))
	fi 
	sleep 60
done
