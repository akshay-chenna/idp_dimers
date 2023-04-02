echo 1 | gmx_mpi gyrate -f md_corrected.xtc -s mdframe.pdb -o rg -xvg none &
echo 18 19 | gmx_mpi mindist -f md_corrected.xtc -s mdframe.pdb -on contacts -n index.ndx -xvg none &
