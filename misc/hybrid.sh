# Script generates topology, energy minimizes, finds sasa and mmpbsa.
# Saves mmpbsa scores, residue-wise contributions, sasas, energy minimized structure/tpr/ndx files
# 06-March-2022, IIT Delhi

cd $PBS_O_WORKDIR

# With topology generation, therefore use 2021 for handling cyclic backbones (of kb1)
module load apps/gromacs/2021.4/gnu

mkdir emposes
mkdir contrib
mkdir areas

hybrid() {
	for i in {1..8} # Number of serial runs on each core
		do
		line=`sed "${i}q;d" lists/x$1`
		mkdir em$line
		cd em$line
		#Always ensure that the cyclotide is before NSP7. This is necessary for recognizing that the protein is a cyclic by pdb2gmx
		cp ../outputs/${line}.pdb .
		cp -r ../essentials/* .
		# Keeping the indices ready for sasa and mmpbsa calculations. CAREFUL! HETATOMS are not considered part of "protein", therefore use "chain" and keep only the "system" group to make chain A as index 1 and chain B as index 2. 
gmx_mpi make_ndx -f ${line}.pdb -o ind.ndx << EOF
keep 0
chain A
chain B
q
EOF

		# Make changes (From rosetta nomenclature) in the residue names so that charmm can recogize them. Also add the residue entires in merged.hdb (copy paste the L version and rename it to D. eg take ALA entry and duplicate it and rename it to DALA)
		sed -i "s/HETATM/ATOM  /g" ${line}.pdb
		sed -i 's/DAS /DASP/g' ${line}.pdb
		sed -i 's/DGN /DGLN/g' ${line}.pdb
		sed -i 's/DAR /DARG/g' ${line}.pdb
		sed -i 's/DAL /DALA/g' ${line}.pdb
		sed -i 's/DGU /DGLU/g' ${line}.pdb
		sed -i 's/DAN /DASN/g' ${line}.pdb
		sed -i 's/DTH /DTHR/g' ${line}.pdb
		sed -i 's/DIL /DILE/g' ${line}.pdb
		sed -i 's/DME /DMET/g' ${line}.pdb
		sed -i 's/DPH /DPHE/g' ${line}.pdb
		sed -i 's/DTY /DTYR/g' ${line}.pdb
		sed -i 's/DTR /DTRP/g' ${line}.pdb
		sed -i 's/DLY /DLYS/g' ${line}.pdb
		sed -i 's/DVA /DVAL/g' ${line}.pdb
		sed -i 's/DLE /DLEU/g' ${line}.pdb
		sed -i 's/DSE /DSER/g' ${line}.pdb
		sed -i 's/DPR /DPRO/g' ${line}.pdb
		sed -i 's/DHI /DHSE/g' ${line}.pdb

#Remove all chain labels. Else it will throw some errors.
echo 0 | gmx_mpi trjconv -f ${line}.pdb -s ${line}.pdb -o a.pdb

#But include TER.
lx=`grep -n "N   LYS     1    " a.pdb | cut -d : -f 1`
sed -i "$((lx))iTER" a.pdb

# THIS CHARMMff IS MODIFIED FOR DEALING WITH D AMINO ACIDS
##added D amino acids to residuetypes.dat
##replicated l variant of merged.hdb to d variants
## add: "DILE CD1 CD" to mergerd.arn
/home/apps/centos7/gromacs/2021.4/gcc-9.1-mpich-3.3.1/bin/gmx_mpi pdb2gmx -f a.pdb -ignh << EOF
1
1
EOF

		# Solvate the molecule
		gmx_mpi editconf -f conf.gro -o dock${line}_n.gro -bt dodec -d 1 -c
		gmx_mpi solvate -cp dock$line'_'n.gro -cs spc216.gro -p topol.top -o dock$line'_'s.gro
		gmx_mpi grompp -f ions.mdp -c dock$line'_'s.gro -p topol.top -o ions$line.tpr -maxwarn 1
gmx_mpi make_ndx -f dock${line}_s.gro -o indw.ndx << EOF
keep 0
r SOL
q
EOF
 	
		echo 1 | gmx_mpi genion -s ions$line.tpr -o dock$line'_'i.gro -n indw.ndx -p topol.top -neutral -conc 0.15 
		gmx_mpi grompp -f em.mdp -c dock$line'_'i.gro -p topol.top -o em.tpr

		# Energy minimize (Fmax < 100 kJ/nm)
		export OMP_NUM_THREADS=1
		mpirun -np 1 -host `sed "$2q;d" $PBS_NODEFILE` /home/apps/centos7/gromacs/2021.4/gcc-9.1-mpich-3.3.1/bin/gmx_mpi mdrun -v -s em.tpr -o em.trr -g em$line.log -c em$line.gro -ntomp 1

		# Calculate SASA for dot products
		echo 0 0 | gmx_mpi trjconv -f em${line}.gro -s em${line}.gro -o p${line}.gro -n ind.ndx -center
		gmx_mpi sasa -f p${line}.gro -s p${line}.gro -or ../areas/complex_r${line} -oa ../areas/complex_a${line} -o ../areas/complex_t${line} -surface 0 -output 0 -ndots 200 -n ind.ndx &
		gmx_mpi sasa -f p${line}.gro -s p${line}.gro -or ../areas/nsp7_r${line} -oa ../areas/nsp7_a${line} -o ../areas/nsp7_t${line} -surface 2 -output 2 -ndots 200 -n ind.ndx &
		gmx_mpi sasa -f p${line}.gro -s p${line}.gro -or ../areas/kb1_r${line} -oa ../areas/kb1_a${line} -o ../areas/kb1_t${line} -surface 1 -output 1 -ndots 200 -n ind.ndx &	

		# MMPBSA
		module load apps/gromacs/5.1.4/intel
		/home/apps/GROMACS/5.1.4/intel/bin/gmx_mpi grompp -f em.mdp -c dock$line'_'i.gro -p topol.top -o em$line.tpr
		timeout 7m echo 1 2 | mpirun -np 1 -host `sed "$2q;d" $PBS_NODEFILE` ./g_mmpbsa -f em${line}.gro -s em${line}.tpr -n ind.ndx -i mmpbsa.mdp -pdie 4 -mme -mm mm.xvg -pbsa -pol pol.xvg -apol apol.xvg -decomp -mmcon contrib_mm_${line}.dat -pcon contrib_pol_${line}.dat -apcon contrib_apol_${line}.dat 

		vdw=`tail -n 1 mm.xvg | awk '{print $6}' `
		elec=`tail -n 1 mm.xvg | awk '{print $7}' `
		pol=`tail -n 1 pol.xvg | awk '{print $4-($3+$2)}'`
		apol=`tail -n 1 apol.xvg | awk '{print $4-($3+$2)}'`

		echo -e "${line}\t${vdw}\t${elec}\t${pol}\t${apol}" >> ../mmpbsa.txt
		
		cp contrib_mm_${line}.dat ../contrib/.
		cp contrib_pol_${line}.dat ../contrib/.
		cp contrib_apol_${line}.dat ../contrib/.
		cp em${line}.gro ../emposes/.
		cp em${line}.tpr ../emposes/.
		mv ind.ndx ${line}.ndx 
		cp ${line}.ndx ../emposes/.

		cd ..
#		rm -rf em$line 

	done
}

node=1
for task in $( eval echo {$(((j-1)*81+1))..$((j*81))}) # Number of parallel runs
do
	node=$((node+1))
	hybrid $task $node &
done
wait
