#module load apps/gromacs/2021.4/gnu
module load apps/gromacs/2022.1/gnu
export OMP_NUM_THREADS=4

cp *.pdb a.pdb
gmx_mpi pdb2gmx -f a.pdb -ignh -his << EOF
1
1
1
1
EOF

gmx_mpi editconf -f conf.gro -o conf_b.gro -bt dodec -d 1

gmx_mpi solvate -cp conf_b.gro -cs spc216.gro -o conf_s.gro -p topol.top

gmx_mpi grompp -f ions.mdp -c conf_s.gro -r conf_s.gro -o ions.tpr -maxwarn 1

gmx_mpi genion -s ions.tpr -o conf_i.gro -p topol.top -conc 0.15 -neutral << EOF
13
EOF

sed -i 's/ NA/SOD/g' conf_i.gro
sed -i 's/ CL/CLA/g' conf_i.gro
sed -i 's/NA /SOD/g' conf_i.gro
sed -i 's/CL /CLA/g' conf_i.gro

sed -i 's/NA/SOD/g' topol.top
sed -i 's/CL/CLA/g' topol.top

gmx_mpi make_ndx -f conf_i.gro -o index.ndx << EOF
a 1-2016
a 2017-4032
name 18 chA
name 19 chB
q
EOF

rm posre_Protein_chain_B.itp topol_Protein_chain_B.itp

gmx_mpi genrestr -f conf_i.gro -o rest_full_protein.itp -n index.ndx << EOF
18
EOF

grep -v Protein_chain_B topol.top  > temp.txt
mv temp.txt topol.top
sed  -i 's/Protein_chain_A     1/Protein_chain_A     2/g' topol.top

echo '#ifdef POSRES_FULL' >> topol_Protein_chain_A.itp
echo '#include "rest_full_protein.itp"' >> topol_Protein_chain_A.itp
echo '#endif' >> topol_Protein_chain_A.itp

gmx_mpi grompp -f em1.mdp -c conf_i.gro -r conf_i.gro -p topol.top -o em1.tpr -po em1out.mdp
mpirun -np 1 gmx_mpi mdrun -v -s em1.tpr -o em1.trr -g em1.log -c em1.gro -ntomp 4

gmx_mpi grompp -f em2.mdp -c em1.gro -r em1.gro -p topol.top -o em2.tpr -po em2out.mdp
mpirun -np 1 gmx_mpi mdrun -v -s em2.tpr -o em2.trr -g em2.log -c em2.gro -ntomp 4

gmx_mpi grompp -f sa.mdp -c em2.gro -r em2.gro -p topol.top -o sa.tpr -po saout.mdp -maxwarn 1
mpirun -np 1 gmx_mpi mdrun -v -s sa.tpr -o sa.trr -x sa.xtc -cpo sa.cpt -e sa.edr -g sa.log -c sa.gro -ntomp 4 -nstlist 150 -nb gpu -bonded gpu -pme gpu -update gpu

gmx_mpi grompp -f nvt.mdp -c sa.gro -r sa.gro -p topol.top -o nvt.tpr -po nvtout.mdp -maxwarn 1
mpirun -np 1 gmx_mpi mdrun -v -s nvt.tpr -o nvt.trr -x nvt.xtc -cpo nvt.cpt -e nvt.edr -g nvt.log -c nvt.gro -ntomp 4 -nstlist 150 -nb gpu -bonded gpu -pme gpu -update gpu

gmx_mpi grompp -f npt.mdp -c nvt.gro -r nvt.gro -p topol.top -o npt.tpr -po nptout.mdp -maxwarn 2
mpirun -np 1 gmx_mpi mdrun -v -s npt.tpr -o npt.trr -x npt.xtc -cpo npt.cpt -e npt.edr -g npt.log -c npt.gro -ntomp 4 -nstlist 150 -nb gpu -bonded gpu -pme gpu -update gpu

gmx_mpi grompp -f md.mdp -c npt.gro -r npt.gro -p topol.top -o md.tpr -po mdout.mdp -maxwarn 2   
mpirun -np 1 gmx_mpi mdrun -v -s md.tpr -o md.trr -x md.xtc -cpo md.cpt -e md.edr -g md.log -c md.gro -ntomp 4 -nstlist 150 -nb gpu -bonded gpu -pme gpu -update gpu
