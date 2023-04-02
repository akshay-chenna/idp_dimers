cd ~/scratch/covid/pep-nsp7/simulations/5/
module load apps/gromacs/2019.4/intel

gmx_mpi cluster -f md_cluster.xtc -s mdcluster.tpr -n ind.ndx -g clusterpep10bb -dist rmspepdist10bb -sz sizepep10bb -clid clidpep10bb -clndx clndxpep10bb -cl clusterpep10bb -method gromos -cutoff 0.10 << EOF
24
24
EOF	
