
for i in {1..576}; do for ((j=$((i+1)); j<=576; j++ )); do echo conf${i}_${j} >> all.txt ; done; done
cat all.txt done.txt | sort  | uniq -u > missed.txt
