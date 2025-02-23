mkdir lists
cd lists
for i in {1..576}; do for ((j=$((i+1)); j<=576; j++)); do echo -e "${i} \t ${j}" >> list.txt ; done; done
split --numeric-suffixes=1 -l 6 -a 5 list.txt 
for i in {1..9}; do mv x0000$i x$i; done
for i in {10..99}; do mv x000$i x$i; done
for i in {100..999}; do mv x00$i x$i; done
