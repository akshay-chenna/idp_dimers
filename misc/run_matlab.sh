for i in {11..20}
do

cp independent_contacts.m independent_contacts${i}.m
sed -i "2ii=${i}" independent_contacts${i}.m 

echo 'cd $PBS_O_WORKDIR' >> ${i}submitmatlab.sh
echo "module load apps/Matlab/r2020b/precompiled" >> ${i}submitmatlab.sh
echo "i=$i" >> ${i}submitmatlab.sh
echo 'matlab -nodisplay -nosplash -nodesktop -r "run independent_contacts${i}.m; exit"' >> ${i}submitmatlab.sh

qsub -P chemical -q low -N ${i}matlab -l select=1:ncpus=1 -l walltime=00:10:00 $i'submitmatlab.sh'
done
