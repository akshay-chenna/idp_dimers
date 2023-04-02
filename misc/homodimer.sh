# Purpose:
# Created: AKSHAY CHENNA on 9th DEC 2020

cd /home/chemical/phd/chz198152/scratch/rosetta/homodimer_app
module load apps/Rosetta/2020.03/intel2019

$ROSETTA_BIN/exposed_strand_finder.mpi.linuxiccrelease -database $ROSETTA_DB -l list.txt  @finder_options > exposed_strands-4-4.txt

