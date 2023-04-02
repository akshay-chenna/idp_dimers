cd /home/chemical/phd/chz198152/scratch/akshay/bispidine/pack/bis_mix/
module load apps/gromacs/5.1.4/intel


gmx_mpi trjconv -f md1.xtc -o mdf1.xtc -s md1.tpr -pbc whole << EOF
0
0
EOF

gmx_mpi trjconv -f mdf1.xtc -o mdfull_whole1.xtc -s md1.tpr -pbc nojump << EOF
0
0
EOF

rm mdf1.xtc
gmx_mpi trjconv -f mdfull_whole1.xtc -s md1.tpr -b 10000 -n ind.ndx -o mdpept1.pdb << EOF
0
EOF

gmx_mpi trjconv -f md2.xtc -o mdf2.xtc -s md2.tpr -pbc whole << EOF
0
0
EOF

gmx_mpi trjconv -f mdf2.xtc -o mdfull_whole2.xtc -s md2.tpr -pbc nojump << EOF
0
0
EOF

rm mdf2.xtc

gmx_mpi trjconv -f mdfull_whole2.xtc -s md2.tpr -b 90000 -n ind.ndx -o mdpept2.pdb << EOF
0
EOF

bash jcpl.sh

<< 'END'

gmx_mpi clustsize -f nmdfull_whole.xtc -s nmd.tpr -n ind.ndx -cut 0.35 << EOF
17
EOF

gmx_mpi angle -f nmdfull_whole.xtc -n ind.ndx -type dihedral -od nlpv2dist -ov nlpv2avg << EOF
19
EOF
tail -n 5000 nlpv2avg.xvg | awk '{ total += $2 } END { print total/NR }' >> avg.txt

gmx_mpi angle -f nmdfull_whole.xtc -n ind.ndx -type dihedral -od nlpi2dist -ov nlpi2avg << EOF
21
EOF
tail -n 5000 nlpi2avg.xvg | awk '{ total += $2 } END { print total/NR }' >> avg.txt

gmx_mpi angle -f nmdfull_whole.xtc -n ind.ndx -type dihedral -od nlpv3dist -ov nlpv3avg << EOF
24
EOF
tail -n 5000 nlpv3avg.xvg | awk '{ total += $2 } END { print total/NR }' >> avg.txt

gmx_mpi angle -f nmdfull_whole.xtc -n ind.ndx -type dihedral -od nlpi3dist -ov nlpi3avg << EOF
25
EOF
tail -n 5000 nlpi3avg.xvg | awk '{ total += $2 } END { print total/NR }' >> avg.txt


gmx_mpi angle -f nmdfull_whole.xtc -n ind.ndx -type dihedral -od nrpv2dist -ov nrpv2avg << EOF
26
EOF
tail -n 5000 nrpv2avg.xvg | awk '{ total += $2 } END { print total/NR }' >> avg.txt

gmx_mpi angle -f nmdfull_whole.xtc -n ind.ndx -type dihedral -od nrpi2dist -ov nrpi2avg << EOF
27
EOF
tail -n 5000 nrpi2avg.xvg | awk '{ total += $2 } END { print total/NR }' >> avg.txt

gmx_mpi angle -f nmdfull_whole.xtc -n ind.ndx -type dihedral -od nrpv3dist -ov nrpv3avg << EOF
28
EOF
tail -n 5000 nrpv3avg.xvg | awk '{ total += $2 } END { print total/NR }' >> avg.txt

gmx_mpi angle -f nmdfull_whole.xtc -n ind.ndx -type dihedral -od nrpi3dist -ov nrpi3avg << EOF
29
EOF
tail -n 5000 nrpi3avg.xvg | awk '{ total += $2 } END { print total/NR }' >> avg.txt
