gmx mdrun -v -s md.tpr -o md.trr -x md.xtc -cpo md.cpt -e md.edr -g md.log -c md.gro -ntomp 5 -ntmpi 4 -nsteps 50000 -nb gpu -bonded gpu -pme gpu -nstlist 400 -npme 1
