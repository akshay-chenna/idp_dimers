j=1
sed '/^#/d' mm${j}.xvg > mm${j}.txt
sed -i '/^@/d' mm${j}.txt
sed '/^#/d' pol${j}.xvg > pol${j}.txt
sed -i '/^@/d' pol${j}.txt
sed '/^#/d' apol${j}.xvg > apol${j}.txt
sed -i '/^@/d' apol${j}.txt
paste mm${j}.txt pol${j}.txt | paste - apol${j}.txt | awk '{ print $1, $6,$7,($12-$11-$10),($16-$15-$14), $8+$12-$11-$10+$16-$15-$14 }' > mmpbsa${j}.txt
