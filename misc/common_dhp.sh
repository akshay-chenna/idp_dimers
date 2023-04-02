awk '{print $1}' hbond_dhp-p.log | grep DHP | cut -b 4-6 >> dhpres.txt
awk '{print $3}' hbond_dhp-p.log | grep DHP | cut -b 4-6 >> dhpres.txt
sort dhpres.txt | uniq | awk '{print ($1 - 449 + 1325) }' >> dhpt.txt
rm dhpres.txt
awk '{print $1}' hbond_d-dhp.log | grep DHP | cut -b 4-6 >> dhpres.txt
awk '{print $3}' hbond_d-dhp.log | grep DHP | cut -b 4-6 >> dhpres.txt
sort dhpres.txt | uniq | awk '{print ($1 - 449 + 1325) }' >> dhpt.txt
rm dhpres.txt
sort dhpt.txt | uniq -D | uniq >> common_dhp.txt
