cd /home/chemical/phd/chz198152/scratch/covid/pep-nsp7/
module load apps/gromacs/5.1.4/intel


while read -r i
do

v=`echo $i | cut -b 1`

gmx_mpi sasa -f emposes/em$i.gro -s emposes/em$i.gro -or areas/complex_r$i -oa areas/complex_a$i -o areas/complex_t$i -surface 1 -output 1 -ndots 2000 -n essentials/ind$v.ndx &
gmx_mpi sasa -f emposes/em$i.gro -s emposes/em$i.gro -or areas/nsp7_r$i -oa areas/nsp7_a$i -o areas/nsp7_t$i -surface 19 -output 19 -ndots 2000 -n essentials/ind$v.ndx &
gmx_mpi sasa -f emposes/em$i.gro -s emposes/em$i.gro -or areas/pep_r$i -oa areas/pep_a$i -o areas/pep_t$i -surface 20 -output 20 -ndots 2000 -n essentials/ind$v.ndx &

rm areas/\#*

done < missedareas.txt

