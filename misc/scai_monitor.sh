cd $PBS_O_WORKDIR
i=500
while [ "$i" -le 1000 ] 
do 
	a=$(qstat -u $USER | grep scai | wc -l)
	if [ "$a" -lt 10 ]
	then
		sed -i "s/run=${i}/run=$((i+1))/g" scai_submit.sh
		bash scai_submit.sh
		i=$((i+1))
	fi 
	sleep 60
done
