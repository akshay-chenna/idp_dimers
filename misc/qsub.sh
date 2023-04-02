qsub -P goelg.p2.451 -N 8GPU-mult -lselect=8:ngpus=1:ncpus=4:centos=skylake -lplace=scatter -lwalltime=00:30:00 par_sim.sh
