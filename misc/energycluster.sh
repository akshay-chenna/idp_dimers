cd /home/chemical/phd/chz198152/scratch/rosetta_1/
module load apps/Rosetta/2020.03/intel2019

mpirun -np $PBS_NTASKS $ROSETTA_BIN/energy_based_clustering.mpi.linuxiccrelease -database $ROSETTA_DB -in:file:fullatom -in:file:l top3kcluster.in -cluster:energy_based_clustering:cluster_radius 3 -cluster:energy_based_clustering:cluster_by bb_cartesian -cluster:energy_based_clustering:homooligomer_swap 

