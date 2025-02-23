/home/akshay/PED9AAC/voronota/voronota_1.22.3149/voronota get-balls-from-atoms-file --annotated < $1 > ${1}.balls
/home/akshay/PED9AAC/voronota/voronota_1.22.3149/voronota calculate-contacts --annotated < ${1}.balls > ${1}.contacts.txt
cat ${1}.contacts.txt | /home/akshay/PED9AAC/voronota/voronota_1.22.3149/voronota expand-descriptors | column -t > ${1}.expanded_contacts.txt
awk '{ print $2, $9, $15}' ${1}.expanded_contacts.txt > ${1}.atom_contact_areas.txt
mv ${1}.atom_contact_areas.txt ${1}.expanded_contacts.txt ${1}.contacts.txt ${1}.balls outputs/.
