cp *.pdb a.pdb

gmx_mpi pdb2gmx -f a.pdb -ignh << EOF
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

a=`grep qtot topol_Protein_chain_H.itp | tail -1 | awk '{print $1}'`
b=`grep qtot topol_Protein_chain_L.itp | tail -1 | awk '{print $1}'`

gmx_mpi make_ndx -f conf_i.gro -o index.ndx << EOF
a 1-${a}
a $((a+1))-$((a+b))
name 18 chH
name 19 chL
q
EOF
