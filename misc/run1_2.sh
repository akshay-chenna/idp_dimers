i=1

cd $PBS_O_WORKDIR

source ~/apps/source_conda.sh

conda activate markov

cd $i
python manual_msm2.py 
