cd /scratch/chemical/phd/chz198152/mab_sim/mab_3/
module load apps/gromacs/5.1.4/intel

export OMP_NUM_THREADS=4


gmx_mpi hbond -f mdfull_whole.xtc -s md.tpr -n ind.ndx -num hbond_i-i -g hbond_i-i -hbn hbond_i-i -tu ns  << EOF
29
29
EOF

<< END
bash common_mhp.sh

gmx_mpi hbond -f mdfull_whole.xtc -s md.tpr -n ind.ndx -num hbond_d-dhp -g hbond_d-dhp -hbn hbond_d-dhp -tu ns  << EOF
22
24
EOF

bash common_dhp.sh

END
