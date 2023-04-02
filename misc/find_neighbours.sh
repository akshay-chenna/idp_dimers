python find_neighbours.py
# ch4342.res.tsv contains residue residue contacts of nsp12 with nsp7, generated from get_static_contacts.py, get_contact_frequencies.py
column -t ch4342.res.tsv | awk {print } | cut -d : -f 3 | sort -nu >> nsp7residues_in_contact.txt
#neighbors.txt contains the residues within 0.6nm
while read -r l ; do a=`head -n $l neighbors.txt | tail -1` ; echo "$l, $a" >> dependent_neighbors_in_contact.txt ; done < nsp7residues_in_contact.txt
## edit the above file
