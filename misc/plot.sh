gnuplot -e "set terminal png size 1600,900; set output 'reu_mmpbsa+ent.jpg'; set xlabel 'REU (kcal/mol)'; set ylabel 'MMPBSA+ENTROPY (kcal/mol)' ; set title 'Binding energies of designs' ; set term pngcairo font 'sans,10' ; set xrange [-50:0]; set yrange [-50:50]; plot [-50:10] x, 'energies.txt' u 1:2"


