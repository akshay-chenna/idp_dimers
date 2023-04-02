
cd $PBS_O_WORKDIR

source ~/apps/scripts/source_conda.sh

conda activate hamsm_env

python hamsm_westpa.py
#python hamsm_westpa_load.py
