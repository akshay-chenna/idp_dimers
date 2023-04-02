awk '{print $1}' hbond_mhp-p.log | grep MHP | cut -b 4-6 >> mhpres.txt
awk '{print $3}' hbond_mhp-p.log | grep MHP | cut -b 4-6 >> mhpres.txt
sort mhpres.txt | uniq | awk '{print ($1 - 443 + 1329) }' >> mhpt.txt
rm mhpres.txt
awk '{print $1}' hbond_d-mhp.log | grep MHP | cut -b 4-6 >> mhpres.txt
awk '{print $3}' hbond_d-mhp.log | grep MHP | cut -b 4-6 >> mhpres.txt
sort mhpres.txt | uniq | awk '{print ($1 - 443 + 1329) }' >> mhpt.txt
rm mhpres.txt
uniq -D mhpt.txt >> common_mhp.txt
