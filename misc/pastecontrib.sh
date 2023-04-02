mapfile -t a < ../cent_struct.txt

for i in {1..8}; do

tr ' ' '\n' < contrib_mm_${a[$i]}.dat >> temp1.txt
sed -i '/^$/d' temp1.txt
tail -n +4 temp1.txt | head -n -3 >> t1.txt

tr ' ' '\n' < contrib_pol_${a[$i]}.dat >> temp2.txt
sed -i '/^$/d' temp2.txt
tail -n +4 temp2.txt | head -n -3 >> t2.txt

tr ' ' '\n' < contrib_apol_${a[$i]}.dat >> temp3.txt
sed -i '/^$/d' temp3.txt
tail -n +4 temp3.txt | head -n -3 >> t3.txt


paste t1.txt t2.txt t3.txt >> t.txt

awk '{print $1 + $2 + $3 }' t.txt >> res_$i.txt

rm t*.txt

done

paste res_{1..8}.txt >> res.txt

sed -i '890d' res.txt

