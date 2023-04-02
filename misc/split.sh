mkdir lists
cd lists
for i in {1..576};  do echo -e "${i} \t ${i}" >> list.txt ; done
split --numeric-suffixes=1 -l 20 -a 2 list.txt 
for i in {1..9}; do mv x0$i x$i; done
