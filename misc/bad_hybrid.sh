cd $PBS_O_WORKDIR
module load apps/gromacs/5.1.4/intel

mkdir emposes
mkdir contrib

hybrid() {
	for i in {1..1}
		do
		line=`sed "$1q;d" bad_contacts.txt`
		mkdir em$line
		cd em$line
		cp ../../gro/${line}.gro .
		cp -r ../essentials/* .
		cp -r ../top_d2kb1/* .
		#a=`grep inf ../bad/em${line}/em${line}.log | grep atom | head -1 | awk '{ print $NF }'`
		a=225
		b=`sed -n $((a+2))p ${line}.gro | awk '{print $4}'`
		c=`sed -n $((a+2))p ${line}.gro | awk '{print $5}'`
		d=`sed -n $((a+2))p ${line}.gro | awk '{print $6}'`
		e=`echo $b+0.2 | bc -l`
		f=`echo $c-0.2 | bc -l`
		g=`echo $d+0.3 | bc -l`
		sed -i "$((a+2))s/$b/$e/" ${line}.gro 
		sed -i "$((a+2))s/$c/$f/" ${line}.gro 
		sed -i "$((a+2))s/$d/$g/" ${line}.gro

		gmx_mpi editconf -f ${line}.gro -o dock${line}_n.gro -bt dodec -d 1 -c
		gmx_mpi solvate -cp dock$line'_'n.gro -cs spc216.gro -p topol.top -o dock$line'_'s.gro
		gmx_mpi grompp -f ions.mdp -c dock$line'_'s.gro -p topol.top -o ions$line.tpr -maxwarn 1
		echo 15 | gmx_mpi genion -s ions$line.tpr -o dock$line'_'i.gro -p topol.top -neutral -conc 0.15 
		gmx_mpi grompp -f em.mdp -c dock$line'_'i.gro -p topol.top -o em$line.tpr
gmx_mpi make_ndx -f dock$line'_'i.gro -o dock${line}.ndx << EOF
a 1-383
a 384-1499
q
EOF
		export OMP_NUM_THREADS=1
		mpirun -np 1 -host `sed "$1q;d" $PBS_NODEFILE` gmx_mpi mdrun -v -s em$line.tpr -o em.trr -g em$line.log -c em$line.gro -ntomp 1 -nsteps 10000
		
		timeout 7m echo 24 25 | mpirun -np 1 -host `sed "$1q;d" $PBS_NODEFILE` ./g_mmpbsa -f em${line}.gro -s em${line}.tpr -n dock${line}.ndx -i mmpbsa.mdp -pdie 4 -mme -mm mm.xvg -pbsa -pol pol.xvg -apol apol.xvg -decomp -mmcon contrib_mm_${line}.dat -pcon contrib_pol_${line}.dat -apcon contrib_apol_${line}.dat 

		vdw=`tail -n 1 mm.xvg | awk '{print $6}' `
		elec=`tail -n 1 mm.xvg | awk '{print $7}' `
		pol=`tail -n 1 pol.xvg | awk '{print $4-($3+$2)}'`
		apol=`tail -n 1 apol.xvg | awk '{print $4-($3+$2)}'`

		echo -e "${line}\t${vdw}\t${elec}\t${pol}\t${apol}" >> ../bad_mmpbsa.txt
		
		cp contrib_mm_${line}.dat ../contrib/.
		cp contrib_pol_${line}.dat ../contrib/.
		cp contrib_apol_${line}.dat ../contrib/.
		cp em${line}.gro ../emposes/.

		cd ..

	done
}

for task in {1..1}
do
	hybrid $task &
done
wait
