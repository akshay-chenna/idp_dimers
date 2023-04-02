for i in {1..15}
do
	x=`sed "${i}q;d" list.txt`
	mkdir $i
	cp $x $i/.
	cp *.mdp simulation.sh $i/.
	cp -r charmm36-feb2021.ff $i/.
	cd $i
	cp *.pdb a.pdb
	qsub -P goelg.p2.352 -N IDP$i -lselect=1:ngpus=1:ncpus=4:centos=skylake -lwalltime=06:00:00 simulation.sh 
	cd ..
done	 
