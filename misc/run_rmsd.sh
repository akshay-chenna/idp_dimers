for j in {11..20}
do
cp ligand_interface_rmsd.sh $j'ligand_interface_rmsd.sh'
sed -i "6ii=${j}" $j'ligand_interface_rmsd.sh'
qsub -P chemical -q standard -N $j'rmsd' -l select=1:ncpus=1 -l walltime=01:00:00 $j'ligand_interface_rmsd.sh'
done
