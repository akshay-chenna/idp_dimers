a=35
mkdir cut_$a

while read -r line
do

while read -r next
do
cat pairwise/$line'_'$next'.txt' >> cut_$a'/'$line'.txt'

done < ../selected_$a'.txt'
done < ../selected_$a'.txt'
