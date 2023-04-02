mkdir top_structures

while read -r line
do
a=`echo ${line} | awk '{print $1}' | cut -d _ -f 1-2`
tar -xf docked_ensemble/${a}.tar.xz
b=`echo ${line} | awk '{ print $1}'`
cp ${a}/run1/structures/it0/${b} top_structures/.
rm -rf ${a}
done < top56.txt
mv top56.txt top_structures/.
