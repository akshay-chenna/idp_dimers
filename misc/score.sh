cd /home/chemical/phd/chz198152/scratch/rosetta_1/
module load apps/Rosetta/2020.03/intel2019

mpirun -np 2 $ROSETTA_BIN/score.mpi.linuxiccrelease -in:file:l top3kcluster.in -out:file:scorefile dock3k.sc -score:weights docking -score:docking_interface_score 1

