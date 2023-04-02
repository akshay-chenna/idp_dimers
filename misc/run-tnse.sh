module load apps/gromacs/2021.4/gnu
source ~/apps/source_conda.sh
conda activate py310

cd $PBS_O_WORKDIR
nohup python t-sne.py
